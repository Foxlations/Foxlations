#!/usr/bin/env python3
"""Slim the Suwayomi-Server fat-jar for the HEADLESS on-device iOS extension host.

The iOS build embeds a JVM to run Kotlin extensions (Android uses ART instead).
Suwayomi-Server-*.jar ships as a full server fat-jar (~166 MB), but the on-device
host is a headless extension RUNNER — no web server, no DB, no UI, no JS engine.
An empirical `-verbose:class` harness boot + a source getPopular op proved the
packages removed below are NEVER loaded and have zero static references from the
extension runtime, so stripping them shrinks the iOS IPA with no behaviour change.
The real SourceRunner host was re-booted against the slimmed jar and getPopular
still worked, loading zero stripped classes.

KEPT on purpose (still exercised or reflectively reached): rx/RxJava (HttpSource's
default fetch* path), dex2jar/ASM/javassist/apk-parser (anime + APK-import path),
androidx.preference (getPreferences), and the whole core runtime (okhttp3, okio,
jsoup, kotlin(+serialization), koin, logback, AndroidCompat, eu.kanade, suwayomi).

When a package is removed, its META-INF/services provider entries are pruned too —
otherwise the first ServiceLoader lookup throws ServiceConfigurationError at boot.

Usage: python3 slim_suwayomi_jar.py <path-to-suwayomi-server.jar>
"""
import os
import sys
import zipfile

# Top-level prefixes to drop (proven never-loaded / server- or desktop-only):
#   GraalJS engine, bundled fonts, ICU, JCEF desktop webview, GraphQL server,
#   Jetty, servlet/jakarta, Javalin, H2 + Postgres drivers, fastjson2, JNA,
#   TwelveMonkeys ImageIO, and native libs (Linux/Mac/Windows — no iOS slice).
STRIP_PREFIXES = [
    "com/oracle/", "org/graalvm/",
    "font/",
    "com/ibm/",
    "com/jetbrains/", "org/cef/",
    "graphql/", "com/expediagroup/", "org/antlr/",
    "org/eclipse/jetty/", "jakarta/", "io/javalin/",
    "org/h2/", "org/postgresql/",
    "com/alibaba/", "com/twelvemonkeys/",
    "com/sun/",
    "native/", "jni/",
]
STRIP_EXACT = {"WebUI.zip"}


def main() -> int:
    jar = sys.argv[1]
    tmp = jar + ".slim"
    before = os.path.getsize(jar)
    zin = zipfile.ZipFile(jar)

    def is_stripped(name: str) -> bool:
        return name in STRIP_EXACT or any(name.startswith(p) for p in STRIP_PREFIXES)

    keep = [i for i in zin.infolist() if not is_stripped(i.filename)]
    kept_names = {i.filename for i in keep}

    def present(cls: str) -> bool:
        return (cls.replace(".", "/") + ".class") in kept_names

    zout = zipfile.ZipFile(tmp, "w", zipfile.ZIP_DEFLATED)
    kept = dropped_svc = 0
    for info in keep:
        name = info.filename
        if name.startswith("META-INF/services/") and not name.endswith("/"):
            lines = zin.read(name).decode("utf-8", "replace").splitlines()
            pruned = [ln for ln in lines
                      if (not ln.split("#")[0].strip()) or present(ln.split("#")[0].strip())]
            if not any(ln.split("#")[0].strip() for ln in pruned):
                dropped_svc += 1
                continue  # no providers survive -> drop the file entirely
            data = ("\n".join(pruned) + "\n").encode()
        else:
            data = zin.read(name)
        zi = zipfile.ZipInfo(name, date_time=info.date_time)
        zi.compress_type = info.compress_type
        zi.external_attr = info.external_attr
        zout.writestr(zi, data)
        kept += 1
    zin.close()
    zout.close()
    os.replace(tmp, jar)
    after = os.path.getsize(jar)
    print("slim_suwayomi_jar: kept %d entries, dropped %d empty service files; "
          "%.1f MB -> %.1f MB" % (kept, dropped_svc, before / 1048576, after / 1048576))
    return 0


if __name__ == "__main__":
    sys.exit(main())
