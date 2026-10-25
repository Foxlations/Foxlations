import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Build-host tool (NOT app code). Packs an EXPLODED module directory
 * (java-home/modules/&lt;module&gt;/**.class) into a single `modules` jimage file,
 * so the iOS app bundle ships no loose .class files — whose 0xCAFEBABE magic
 * collides with the Mach-O FAT magic and makes SideStore's CodeSignKit reject the
 * app ("FAT slice bounds exceed file size").
 *
 * Why not `jlink`: the iOS JVM is openjdk/mobile Java 28, built as
 * "28-internal-adhoc.runner.mobile". A stock `jlink` refuses to link those modules
 * ("jlink build ... does not match target java.base build ..."), and that check
 * cannot be disabled. BUT the check lives in the jlink COMMAND (JlinkTask), not in
 * the image writer: {@code ImageFileCreator.recreateJimage(...)} packs a jimage
 * from exploded modules with no version check. The jimage container format is
 * version-independent, so a stock JDK 28's internals pack the mobile-28 classes
 * fine. We reach the internals by reflection (JimagePatcher technique), so this
 * compiles with plain javac and only needs jdk.jlink opened at runtime:
 *
 *   javac -d /tmp PackJimage.java
 *   java --add-modules jdk.jlink \
 *        --add-opens jdk.jlink/jdk.tools.jlink.internal=ALL-UNNAMED \
 *        -cp /tmp PackJimage &lt;modulesDir&gt; &lt;outModulesFile&gt;
 *
 * Run it with a STOCK JDK 28 (its jlink internals must match the module class
 * version, 72). The jimage byte order is the JVM's native order (LE on arm64),
 * which matches the iOS arm64 target.
 */
public final class PackJimage {
    public static void main(String[] args) throws Exception {
        if (args.length < 2) {
            System.err.println("usage: PackJimage <modulesDir> <outModulesFile>");
            System.exit(2);
        }
        Path modulesDir = Paths.get(args[0]).toAbsolutePath();
        Path out = Paths.get(args[1]).toAbsolutePath();

        Class<?> dirArchiveCls =
            Class.forName("jdk.tools.jlink.internal.DirArchive");
        Class<?> pluginsCfgCls =
            Class.forName("jdk.tools.jlink.internal.Jlink$PluginsConfiguration");
        Class<?> imgPluginCfgCls =
            Class.forName("jdk.tools.jlink.internal.ImagePluginConfiguration");
        Class<?> creatorCls =
            Class.forName("jdk.tools.jlink.internal.ImageFileCreator");

        // DirArchive(Path moduleDir, String moduleName) for each exploded module.
        Constructor<?> dirArchiveCtor =
            dirArchiveCls.getDeclaredConstructor(Path.class, String.class);
        dirArchiveCtor.setAccessible(true);
        Set<Object> archives = new LinkedHashSet<>();
        try (DirectoryStream<Path> ds = Files.newDirectoryStream(modulesDir)) {
            for (Path mod : ds) {
                if (!Files.isDirectory(mod)) continue;
                String name = mod.getFileName().toString();
                archives.add(dirArchiveCtor.newInstance(mod, name));
            }
        }
        if (archives.isEmpty()) {
            System.err.println("no module directories under " + modulesDir);
            System.exit(2);
        }
        System.out.println("packing " + archives.size() + " modules -> " + out);

        // CRITICAL: run the "system-modules" jlink plugin. It (re)generates the
        // jdk.internal.module.SystemModules$all / $default classes that encode the
        // full module graph — every java.base package included — for a PACKED
        // image. The source here is an EXPLODED build image (it has
        // ExplodedSystemModules but NOT SystemModules$all), so WITHOUT this plugin
        // the jimage boots into "Error occurred during initialization of VM":
        // NoClassDefFoundError: jdk/internal/module/SystemModules$default on a
        // normal VM, or — on the iOS Zero VM, which loads the FFM ABI very early
        // for libffi — "A non-java.base package was loaded prior to module system
        // initialization: jdk/internal/foreign/abi". Verified locally: empty
        // plugins -> boot fails; system-modules -> boots.
        //   PluginRepository.newPlugin(Map config, String name, ModuleLayer layer)
        Class<?> pluginRepoCls =
            Class.forName("jdk.tools.jlink.internal.PluginRepository");
        Method newPlugin = pluginRepoCls.getMethod(
            "newPlugin", Map.class, String.class, ModuleLayer.class);
        Object systemModules = newPlugin.invoke(
            null, Map.of(), "system-modules", ModuleLayer.boot());
        List<Object> plugins = new ArrayList<>();
        plugins.add(systemModules);

        // Jlink.PluginsConfiguration(List<Plugin>) then parseConfiguration -> stack.
        Constructor<?> cfgCtor = pluginsCfgCls.getConstructor(List.class);
        Object pluginsCfg = cfgCtor.newInstance(plugins);
        Method parse =
            imgPluginCfgCls.getMethod("parseConfiguration", pluginsCfgCls);
        Object stack = parse.invoke(null, pluginsCfg);

        // ImageFileCreator.recreateJimage(Path, Set<Archive>, ImagePluginStack[, boolean])
        // — found by name so a 3-arg (older) vs 4-arg (current, + generateRuntimeImage)
        // signature both work.
        Method recreate = null;
        for (Method m : creatorCls.getDeclaredMethods()) {
            if (m.getName().equals("recreateJimage")) { recreate = m; break; }
        }
        if (recreate == null) {
            throw new NoSuchMethodException(
                "ImageFileCreator.recreateJimage not found (JDK internals changed)");
        }
        recreate.setAccessible(true);
        int pc = recreate.getParameterCount();
        Object[] callArgs = (pc >= 4)
            ? new Object[] { out, archives, stack, Boolean.FALSE }
            : new Object[] { out, archives, stack };
        recreate.invoke(null, callArgs);

        if (!Files.isRegularFile(out)) {
            throw new IllegalStateException("no jimage produced at " + out);
        }
        System.out.println("done: " + Files.size(out) + " bytes");
    }
}
