import 'dart:async' show unawaited, StreamSubscription;
import 'dart:io' show Platform;
import 'dart:math' show Random, sqrt;

import 'package:sensors_plus/sensors_plus.dart';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'core/app_nav.dart';
import 'core/models/manga_model.dart';
import 'core/models/chapter_model.dart';
import 'core/models/category_model.dart';
import 'package:rhttp/rhttp.dart';
import 'core/services/webview_service.dart';
import 'core/services/cf_flaresolverr_server.dart';
import 'eval/kotlin/jvm_bridge.dart';
import 'core/services/app_logger.dart';
import 'core/services/crash_reporter.dart';
import 'core/providers/source_provider.dart';
import 'core/providers/library_provider.dart';
import 'core/providers/tracking_provider.dart';
import 'core/providers/vault_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/download_provider.dart';
import 'core/providers/library_type_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/nav_prefs_provider.dart';
import 'core/providers/beta_provider.dart';
import 'core/providers/incognito_provider.dart';
import 'core/providers/app_lock_provider.dart';
import 'presentation/widgets/app_lock_gate.dart';
import 'core/services/settings_store.dart';
import 'core/services/tts_media_session.dart';
import 'core/services/secure_screen_service.dart';
import 'core/services/notification_service.dart';
import 'core/providers/discover_provider.dart';
import 'core/services/library_update_service.dart';
import 'core/services/backup_service.dart';
import 'core/services/app_navigator.dart';
import 'core/services/deep_link_service.dart';
import 'core/services/secure_store.dart';
import 'theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'l10n/app_localizations.dart';
import 'widgets/app_navigation.dart';
import 'widgets/library_type_menu.dart';
import 'presentation/library_screen/library_screen.dart';
import 'presentation/tutorial/tutorial_screen.dart';
import 'presentation/updates_screen/updates_screen.dart';
import 'presentation/browse_screen/browse_screen.dart';
import 'presentation/discover_screen/discover_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Bound the decoded-image cache so a large cover grid can't balloon memory /
  // thrash (Flutter's default 100 MB / 1000 entries is easy to blow past with
  // full-res covers; MangaImage now decodes covers at display size too).
  PaintingBinding.instance.imageCache.maximumSizeBytes = 128 * 1024 * 1024;

  // Route uncaught Dart errors into the in-app error log. Native crashes (the
  // embedded JVM aborting) kill the process before Dart runs, so those are
  // recovered from the JVM's crash files on the next launch by CrashReporter below.
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    logger.error('Flutter error: ${details.exceptionAsString()}',
        category: LogCategory.general, detail: details.stack?.toString());
  };
  WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
    logger.error('Uncaught error: $error',
        category: LogCategory.general, detail: stack.toString());
    return true;
  };

  MediaKit.ensureInitialized();
  // Hive storage location. On mobile, initFlutter() uses
  // getApplicationDocumentsDirectory(), which is an app-private sandbox - the
  // right place. On desktop that SAME call resolves to the user's shared
  // Documents folder, so initFlutter() would drop library_*.hive files straight
  // into Documents (visible, un-sandboxed, and shared with any other Hive app
  // using the same box names). Point desktop at the app-private support dir
  // instead - %APPDATA%\Roaming\<app> on Windows - so the library lives with
  // the app and a reinstall/uninstall governs it. Mobile keeps initFlutter() so
  // existing installs' data stays exactly where it already is.
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    final supportDir = await getApplicationSupportDirectory();
    Hive.init(supportDir.path);
  } else {
    await Hive.initFlutter();
  }
  Hive.registerAdapter(LibraryMangaAdapter());
  Hive.registerAdapter(LibraryChapterAdapter());
  Hive.registerAdapter(CategoryAdapter());
  // These four are needed before the app is usable but are independent of each
  // other, so run them in parallel instead of in series on the first-frame path:
  //  - SecureStore: must finish before any credential-bearing box opens (the
  //    providers read SecureStore.cipher in their initialize()).
  //  - Rhttp: the Rust HTTP client used by every image/source request.
  //  - WebView env: Cloudflare cookie extraction.
  //  - SettingsStore: durable settings providers/pages read on startup.
  await Future.wait([
    SecureStore.initialize(),
    Rhttp.init(),
    initWebViewEnvironment(),
    SettingsStore.instance.load(),
    // Lock-screen / background media controls for the novel "Listen" TTS
    // (Android/iOS only; never throws - see initTtsMediaSession).
    initTtsMediaSession(),
  ]);
  // Not needed to render or interact with the first frame - kick these off after
  // first paint so they don't add to time-to-interactive:
  //  - CfFlareSolverr: loopback endpoint only used when a Kotlin source hits
  //    Cloudflare (also re-armed on resume via ensureRunning).
  //  - CrashReporter: surfaces a previous native crash into the log (does a
  //    synchronous dir scan - keep it off the boot path).
  //  - Notifications: channel/plugin setup; the permission prompt is already
  //    deferred, so init can be too.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(CfFlareSolverrServer.instance.start());
    unawaited(CrashReporter.reportPreviousCrash());
    unawaited(NotificationService.instance.initialize());
  });
  // Background isolate starts lazily on first use
  // Don't start here - Windows may crash on Isolate.spawn during init
  runApp(const MangaReaderApp());
}

class MangaReaderApp extends StatelessWidget {
  const MangaReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => NavPrefsProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => BetaProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => IncognitoProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => AppLockProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => SourceProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => LibraryProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => TrackingProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => VaultProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => LibraryTypeProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()..initialize()),
        ChangeNotifierProvider(create: (ctx) {
          // Discover reads (never mutates) the tracking / source / library /
          // vault providers, all registered above, so they resolve here.
          final d = DiscoverProvider();
          d.tracking = ctx.read<TrackingProvider>();
          d.sources = ctx.read<SourceProvider>();
          d.library = ctx.read<LibraryProvider>();
          d.vault = ctx.read<VaultProvider>();
          d.initialize();
          return d;
        }),
        ChangeNotifierProvider(create: (ctx) {
          final dp = DownloadProvider()..initialize();
          // Wire source provider reference after build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            dp.sourceProvider = ctx.read<SourceProvider>();
          });
          return dp;
        }),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (_, themeProvider, localeProvider, _) {
          // Surfaces follow the palette-flip strength: a preset breed tints the
          // backgrounds/surfaces toward its hue as the strength rises.
          final lightS = themeProvider.surfacesFor(Brightness.light);
          final darkS = themeProvider.surfacesFor(Brightness.dark);
          final lightThemeData = AppTheme.lightTheme(
              primaryColor: themeProvider.primaryColor(Brightness.light),
              background: lightS.background,
              surface: lightS.surface,
              surfaceHighest: lightS.surfaceHighest,
              onSurface: lightS.onSurface);
          final darkThemeData = AppTheme.darkTheme(
              primaryColor: themeProvider.primaryColor(Brightness.dark),
              oled: themeProvider.oledBlack,
              background: darkS.background,
              surface: darkS.surface,
              surfaceHighest: darkS.surfaceHighest,
              onSurface: darkS.onSurface);
          final mode = themeProvider.themeMode;
          return MaterialApp(
            title: 'Foxlations',
            locale: localeProvider.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            navigatorKey: rootNavigatorKey,
            scaffoldMessengerKey: rootMessengerKey,
            debugShowCheckedModeBanner: false,
            theme: lightThemeData,
            darkTheme: darkThemeData,
            themeMode: mode,
            // Always boot into the shell, even when the OS launches us via a
            // foxlations:// deep link - its URL would otherwise become the
            // platform's initial route name, bypass `home`, and fall through
            // onGenerateRoute's default to a bare, shell-less screen (no bottom
            // nav). DeepLinkService handles the link on top of the shell.
            onGenerateInitialRoutes: (_) =>
                [MaterialPageRoute(builder: (_) => const AppShell())],
            navigatorObservers: [routeObserver],
            onGenerateRoute: AppRoutes.onGenerateRoute,
            // Wrap the entire app in a ColorFiltered when invert colors is
            // enabled in Appearance settings. The matrix is the standard
            // RGB invert; alpha is preserved.
            builder: (context, child) {
              Widget content = child ?? const SizedBox.shrink();
              if (themeProvider.invertColors && child != null) {
                content = ColorFiltered(
                  colorFilter: const ColorFilter.matrix([
                    -1,  0,  0, 0, 255,
                     0, -1,  0, 0, 255,
                     0,  0, -1, 0, 255,
                     0,  0,  0, 1,   0,
                  ]),
                  child: content,
                );
              }
              // App lock sits outermost so nothing (not even the splash) shows
              // until the device auth succeeds.
              return AppLockGate(child: _SplashGate(child: content));
            },
          );
        },
      ),
    );
  }
}

/// Cold-boot splash: covers the first frame/load with the fox logo + title, then
/// fades out once the app has settled. Shown once per launch - its State persists
/// across the MaterialApp builder's rebuilds (theme/locale changes).
class _SplashGate extends StatefulWidget {
  final Widget child;
  const _SplashGate({required this.child});
  @override
  State<_SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<_SplashGate>
    with TickerProviderStateMixin {
  // One of these is picked at random each cold boot.
  static const _pool = ['zoom', 'leaves', 'glow', 'split'];
  static const _leafColors = [
    Color(0xFFF0A73E), Color(0xFFE8822C), Color(0xFFD35B28),
    Color(0xFFC0392B), Color(0xFFE6B422), Color(0xFFB5651D),
  ];

  late final String _style;
  late final AnimationController _enter;
  late final AnimationController _exit;
  late final List<_Leaf> _leaves;
  bool _gone = false;

  @override
  void initState() {
    super.initState();
    final rnd = Random();
    _style = _pool[rnd.nextInt(_pool.length)];
    _enter = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 620))
      ..forward();
    _exit = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed && mounted) {
          setState(() => _gone = true);
        }
      });
    _leaves = _style == 'leaves' ? _buildLeaves(rnd) : const <_Leaf>[];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 950), () {
        if (mounted) _exit.forward();
      });
    });
  }

  List<_Leaf> _buildLeaves(Random r) => List.generate(16, (i) {
        final thruLogo = r.nextDouble() < 0.6;
        return _Leaf(
          fx0: 1.05 + r.nextDouble() * 0.5,
          fx1: -0.1 - r.nextDouble() * 0.2,
          fy0: thruLogo ? 0.44 + (r.nextDouble() - 0.5) * 0.32 : r.nextDouble(),
          fvy: (r.nextDouble() - 0.5) * 0.28,
          rot: (r.nextDouble() - 0.5) * 9.0,
          sz: 16 + r.nextDouble() * 16,
          start: r.nextDouble() * 0.42,
          span: 0.5 + r.nextDouble() * 0.35,
          color: _leafColors[r.nextInt(_leafColors.length)],
        );
      });

  @override
  void dispose() {
    _enter.dispose();
    _exit.dispose();
    super.dispose();
  }

  // num.clamp() returns num; coerce back to double for opacity/scale params.
  double _cl(num v) => v.clamp(0.0, 1.0).toDouble();

  Widget _logo(ColorScheme cs) {
    final te = _cl(Curves.easeOutCubic.transform(_enter.value));
    return Opacity(
      opacity: te,
      child: Transform.scale(
        scale: 0.9 + 0.1 * te,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/foxlations.png',
                width: 118, height: 118),
            const SizedBox(height: 18),
            Text('Foxlations',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: cs.onSurface,
                  // Kill the default yellow double-underline that Flutter adds to
                  // text rendered without a Material ancestor (the splash overlay
                  // sits above the navigator, not inside a Scaffold/Material).
                  decoration: TextDecoration.none,
                )),
          ],
        ),
      ),
    );
  }

  Widget _box(ColorScheme cs, Widget child) =>
      Container(color: cs.surface, alignment: Alignment.center, child: child);

  Widget _glowCircle() => Container(
        width: 150,
        height: 150,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [Color(0xF0FFC48C), Color(0x66F0823C), Color(0x00F0823C)],
            stops: [0.0, 0.45, 0.72],
          ),
        ),
      );

  Widget _buildExit(ColorScheme cs) {
    final e = _exit.value;
    switch (_style) {
      case 'leaves':
        final size = MediaQuery.of(context).size;
        final overlayOp =
            1 - Curves.easeOut.transform(_cl((e - 0.42) / 0.58));
        final leaves = <Widget>[];
        for (final lf in _leaves) {
          final lp = _cl((e - lf.start) / lf.span);
          if (lp <= 0 || lp >= 1) continue;
          final x = (lf.fx0 + (lf.fx1 - lf.fx0) * lp) * size.width;
          final y = (lf.fy0 + lf.fvy * lp) * size.height;
          final double op =
              lp < 0.12 ? lp / 0.12 : (lp > 0.8 ? 1 - (lp - 0.8) / 0.2 : 1.0);
          leaves.add(Transform.translate(
            offset: Offset(x, y),
            child: Transform.rotate(
              angle: lf.rot * lp,
              child: Opacity(
                opacity: _cl(op),
                child: CustomPaint(
                    size: Size(lf.sz, lf.sz),
                    painter: _LeafPainter(lf.color)),
              ),
            ),
          ));
        }
        return Stack(children: [
          Positioned.fill(
              child: Opacity(opacity: overlayOp, child: _box(cs, _logo(cs)))),
          ...leaves,
        ]);
      case 'glow':
        final bg = 1 - Curves.easeOut.transform(_cl((e - 0.30) / 0.70));
        final double gScale, gOp;
        if (e < 0.35) {
          final k = e / 0.35;
          gScale = 0.3 + 1.2 * k;
          gOp = k;
        } else {
          final k = (e - 0.35) / 0.65;
          gScale = 1.5 + 5.5 * k;
          gOp = 1 - k;
        }
        final markScale = 1 + 0.16 * Curves.easeOut.transform(e);
        return Stack(alignment: Alignment.center, children: [
          Positioned.fill(
              child: Opacity(opacity: bg, child: Container(color: cs.surface))),
          Opacity(
              opacity: _cl(gOp * 0.9),
              child: Transform.scale(scale: gScale, child: _glowCircle())),
          Opacity(
              opacity: bg,
              child: Transform.scale(scale: markScale, child: _logo(cs))),
        ]);
      case 'split':
        final w = MediaQuery.of(context).size.width;
        final p = Curves.easeInOutCubic.transform(e);
        final dx = w * 0.6 * p;
        final double op = e < 0.45 ? 1.0 : _cl(1 - (e - 0.45) / 0.55);
        return Stack(children: [
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(-dx, 0),
              child: Opacity(
                opacity: op,
                child: ClipRect(
                    clipper: _HalfClipper(true), child: _box(cs, _logo(cs))),
              ),
            ),
          ),
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(dx, 0),
              child: Opacity(
                opacity: op,
                child: ClipRect(
                    clipper: _HalfClipper(false), child: _box(cs, _logo(cs))),
              ),
            ),
          ),
        ]);
      case 'zoom':
      default:
        final f = Curves.easeOut.transform(e);
        return Opacity(
          opacity: 1 - f,
          child:
              _box(cs, Transform.scale(scale: 1 + 0.12 * f, child: _logo(cs))),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_gone) return widget.child;
    final cs = Theme.of(context).colorScheme;
    return Stack(children: [
      widget.child,
      Positioned.fill(
        child: AbsorbPointer(
          child: AnimatedBuilder(
            animation: Listenable.merge([_enter, _exit]),
            builder: (_, _) => _buildExit(cs),
          ),
        ),
      ),
    ]);
  }
}

class _Leaf {
  final double fx0, fx1, fy0, fvy, rot, sz, start, span;
  final Color color;
  const _Leaf({
    required this.fx0,
    required this.fx1,
    required this.fy0,
    required this.fvy,
    required this.rot,
    required this.sz,
    required this.start,
    required this.span,
    required this.color,
  });
}

class _LeafPainter extends CustomPainter {
  final Color color;
  _LeafPainter(this.color);
  @override
  void paint(Canvas c, Size s) {
    final k = s.width / 24.0;
    final path = Path()
      ..moveTo(12 * k, 1.5 * k)
      ..cubicTo(6.5 * k, 6 * k, 4 * k, 13 * k, 12 * k, 22.5 * k)
      ..cubicTo(20 * k, 13 * k, 17.5 * k, 6 * k, 12 * k, 1.5 * k)
      ..close();
    c.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill);
    final vein = Paint()
      ..color = const Color(0x6B4A1C08)
      ..strokeWidth = 1 * k
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    c.drawLine(Offset(12 * k, 4 * k), Offset(12 * k, 20 * k), vein);
    c.drawLine(Offset(12 * k, 9 * k), Offset(8.5 * k, 7 * k), vein);
    c.drawLine(Offset(12 * k, 9 * k), Offset(15.5 * k, 7 * k), vein);
    c.drawLine(Offset(12 * k, 13.5 * k), Offset(8 * k, 11.5 * k), vein);
    c.drawLine(Offset(12 * k, 13.5 * k), Offset(16 * k, 11.5 * k), vein);
  }

  @override
  bool shouldRepaint(_LeafPainter old) => old.color != color;
}

class _HalfClipper extends CustomClipper<Rect> {
  final bool left;
  _HalfClipper(this.left);
  @override
  Rect getClip(Size s) => left
      ? Rect.fromLTWH(0, 0, s.width / 2, s.height)
      : Rect.fromLTWH(s.width / 2, 0, s.width / 2, s.height);
  @override
  bool shouldReclip(_HalfClipper old) => old.left != left;
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with WidgetsBindingObserver {
  // The active screen tab's id (one of _screenIds). `more` opens Settings and
  // never becomes active. Tabs are keyed by id so the bar can be reordered.
  String _activeTabId = 'library';
  static const _screenIds = ['library', 'updates', 'browse', 'discover'];
  int _libraryTapCount = 0;
  DateTime _lastLibraryTap = DateTime(2000);
  int _updatesBadge = 0;
  bool _showUpdateCount = true;

  // Panic exit: shake the phone to instantly leave the vault (opt-in). The
  // accelerometer is only listened to while the vault is active AND the toggle is on.
  StreamSubscription<AccelerometerEvent>? _shakeSub;
  final List<int> _shakeHits = [];
  DateTime _lastPanic = DateTime(2000);

  final _screens = const [
    LibraryScreen(),
    UpdatesScreen(),
    BrowseScreen(),
    DiscoverScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _applyStartTab();
    navTabRequest.addListener(_onNavTabRequest);
    // Handle foxlations:// deep links (source-repo auto-install).
    DeepLinkService.initialize();
    // Push the persisted Secure-Screen setting to the platform now the engine's
    // channels are up (FLAG_SECURE on Android / app-switcher blur on iOS).
    SecureScreenService.apply();
    _loadUpdatesBadge();
    LibraryUpdateService.badge.addListener(_onBadgeTick);
    // Run any due automatic backup once the library boxes have opened, then a
    // due automatic library update (Settings > Library > Update frequency). Both
    // wait for the providers to finish loading from disk.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Ask for notification permission once the UI is up (not pre-first-frame).
      NotificationService.instance.requestPermission();
      // First-launch tutorial (new installs only - existing users are skipped).
      _maybeShowTutorial();
      // Heal any library entries a restore stranded on a source name, and keep
      // healing as sources get installed this session.
      if (mounted) {
        context.read<SourceProvider>().onInstalledChanged =
            _relinkRestoredSources;
      }
      await Future.delayed(const Duration(seconds: 4));
      await _relinkRestoredSources();
      try {
        await BackupService().maybeRunAuto();
      } catch (_) {}
      await _maybeAutoUpdateLibrary();
    });
  }

  /// Show the first-launch tutorial, but ONLY to a genuinely new install.
  /// An existing user upgrading into this version (they have library items or
  /// installed sources) is silently marked "seen" so they don't get prompted.
  /// Either way it's replayable from Settings → Help & Tips.
  void _maybeShowTutorial() {
    if (SettingsStore.instance.getBool(tutorialSeenKey) ?? false) return;
    final lib = context.read<LibraryProvider>();
    void decide() {
      if (!mounted) return;
      final hasData = lib.manga.isNotEmpty ||
          context.read<SourceProvider>().installedSources.isNotEmpty;
      if (hasData) {
        SettingsStore.instance.setBool(tutorialSeenKey, true);
        return;
      }
      // New install - show it once the splash has cleared.
      Future.delayed(const Duration(milliseconds: 1100), () {
        if (mounted &&
            !(SettingsStore.instance.getBool(tutorialSeenKey) ?? false)) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const TutorialScreen(), fullscreenDialog: true));
        }
      });
    }

    if (lib.initialized) {
      decide();
    } else {
      void listener() {
        if (lib.initialized) {
          lib.removeListener(listener);
          decide();
        }
      }

      lib.addListener(listener);
    }
  }

  /// Re-link library/vault entries that a Tachiyomi/Mihon restore left pointing
  /// at a source name onto the installed source id. Safe to call repeatedly
  /// (idempotent) - runs on launch and after each source install.
  Future<void> _relinkRestoredSources() async {
    if (!mounted) return;
    try {
      final map = context.read<SourceProvider>().installedIdToName;
      if (map.isEmpty) return;
      final lib = context.read<LibraryProvider>();
      final vault = context.read<VaultProvider>();
      await lib.relinkSources(map);
      await vault.relinkSources(map);
    } catch (_) {
      // Best-effort maintenance - never let it crash startup or an install.
    }
  }

  /// Runs a library update if one is due per the frequency / Wi-Fi / charging
  /// settings. Best-effort and silent: an auto-update must never interrupt the
  /// user or crash the app. Called on launch and on resume.
  Future<void> _maybeAutoUpdateLibrary() async {
    try {
      if (!await LibraryUpdateService.shouldAutoUpdate()) return;
      if (!mounted) return;
      final lib = context.read<LibraryProvider>();
      final src = context.read<SourceProvider>();
      if (lib.manga.isEmpty) return; // Providers not loaded yet, or empty library.
      await LibraryUpdateService.checkForUpdates(
          libraryProvider: lib,
          sourceProvider: src,
          downloadProvider: context.read<DownloadProvider>(),
          notify: true);
      if (mounted) _loadUpdatesBadge();
    } catch (_) {
      // Swallow - foreground auto-update is a convenience, not a guarantee.
    }
  }

  void _showVaultPasswordDialog(VaultProvider vault) {
    final controller = TextEditingController();
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);
    String? error;
    var bioTried = false;

    Future<void> tryBio(BuildContext ctx) async {
      if (await vault.unlockWithBiometric()) {
        if (ctx.mounted) {
          Navigator.pop(ctx);
          vault.enterVault();
        }
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        // Auto-prompt Face ID / fingerprint once when the dialog opens.
        if (vault.biometricEnabled && !bioTried) {
          bioTried = true;
          WidgetsBinding.instance.addPostFrameCallback((_) => tryBio(ctx));
        }
        return StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: cs.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(children: [
            Icon(Icons.shield_rounded, size: 20, color: cs.primary),
            const SizedBox(width: 8),
            Text(t.appVaultPassword, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16, fontWeight: FontWeight.w700, color: cs.onSurface)),
          ]),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: controller,
              obscureText: true,
              autofocus: true,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14, color: cs.onSurface),
              decoration: InputDecoration(
                hintText: t.appEnterPassword,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14, color: cs.outline),
                errorText: error,
                filled: true,
                fillColor: cs.surfaceContainerHighest,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                prefixIcon: Icon(Icons.lock_outline_rounded, size: 18, color: cs.outline),
              ),
              onSubmitted: (_) async {
                // unlock() derives the key and opens the encrypted boxes, so
                // it's async (~1s) and a wrong password simply can't decrypt.
                setDialogState(() => error = null);
                if (await vault.unlock(controller.text)) {
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                  vault.enterVault();
                } else {
                  setDialogState(() => error = t.appWrongPassword);
                }
              },
            ),
          ]),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(t.appCancel, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: cs.outline))),
            FilledButton(
              onPressed: () async {
                // unlock() derives the key and opens the encrypted boxes, so
                // it's async (~1s) and a wrong password simply can't decrypt.
                setDialogState(() => error = null);
                if (await vault.unlock(controller.text)) {
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                  vault.enterVault();
                } else {
                  setDialogState(() => error = t.appWrongPassword);
                }
              },
              style: FilledButton.styleFrom(backgroundColor: cs.primary),
              child: Text(t.appUnlock, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700))),
            if (vault.biometricEnabled)
              TextButton.icon(
                onPressed: () => tryBio(ctx),
                icon: const Icon(Icons.fingerprint_rounded, size: 18),
                label: Text(t.appBiometrics,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
              ),
          ],
        ),
      );
      },
    );
  }

  Future<void> _loadUpdatesBadge() async {
    // Honour Settings > Library > "Show update count". When off, keep the badge
    // at 0. Seed the live badge notifier from the persisted count; the listener
    // (_onBadgeTick) then keeps _updatesBadge in sync as the service bumps it
    // live during a check and zeroes it on "Clear all".
    _showUpdateCount =
        SettingsStore.instance.getBool('lib_show_update_count') ?? true;
    LibraryUpdateService.badge.value =
        await LibraryUpdateService.getUnreadCount();
    _onBadgeTick();
  }

  void _onBadgeTick() {
    if (!mounted) return;
    setState(() => _updatesBadge =
        _showUpdateCount ? LibraryUpdateService.badge.value : 0);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    navTabRequest.removeListener(_onNavTabRequest);
    LibraryUpdateService.badge.removeListener(_onBadgeTick);
    _shakeSub?.cancel();
    super.dispose();
  }

  /// Subscribe to the accelerometer only while the vault is active and the
  /// shake-to-exit toggle is on; otherwise release it. Called from build().
  void _syncShakeListener() {
    final vault = context.read<VaultProvider>();
    final on = vault.vaultActive &&
        (SettingsStore.instance.getBool('vault_panic_shake') ?? false);
    if (on && _shakeSub == null) {
      _shakeSub = accelerometerEventStream(samplingPeriod: SensorInterval.uiInterval)
          .listen(_onShakeSample);
    } else if (!on && _shakeSub != null) {
      _shakeSub!.cancel();
      _shakeSub = null;
      _shakeHits.clear();
    }
  }

  void _onShakeSample(AccelerometerEvent e) {
    // Includes gravity (~9.8 at rest); count only strong jerks.
    final mag = sqrt(e.x * e.x + e.y * e.y + e.z * e.z);
    if (mag < 26) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    _shakeHits
      ..add(now)
      ..removeWhere((t) => now - t > 700);
    if (_shakeHits.length >= 3) {
      _shakeHits.clear();
      _triggerPanicExit();
    }
  }

  void _triggerPanicExit() {
    if (DateTime.now().difference(_lastPanic).inSeconds < 2) return;
    _lastPanic = DateTime.now();
    final vault = context.read<VaultProvider>();
    if (!vault.vaultActive) return;
    vault.exitVault();
    // Leave any vault screen (reader, vault settings) and land on the library.
    rootNavigatorKey.currentState?.popUntil((r) => r.isFirst);
    if (mounted) setState(() => _activeTabId = 'library');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Exit vault + re-arm the app lock when backgrounded (device locked,
    // app switcher, etc.) so returning to the foreground requires auth again.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      context.read<VaultProvider>().exitVault();
      context.read<AppLockProvider>().onPaused();
    }
    // On return to the foreground, check whether a library update has come due.
    // Delay it: on iOS the auto-update can reach the embedded Zero JVM, and
    // kicking a JVM op *during* the background->foreground transition is exactly
    // the signal-race window behind the reopen-from-background crash. Letting the
    // transition settle first (the native handler-restore in AppDelegate covers
    // the rest) keeps JVM work out of that window.
    if (state == AppLifecycleState.resumed) {
      // Re-lock if the backgrounded idle grace period has elapsed (0 = already
      // locked on pause). Synchronous + Dart-only, so safe in this window.
      if (mounted) context.read<AppLockProvider>().onResumed();
      // Open the JVM quiet period FIRST, so any JVM op that fires during the
      // background->foreground transition (a user-triggered source call, warmup)
      // is held until the process has settled - the window behind the iOS
      // reopen-from-background Zero-VM crash.
      FoxJvm.markResumed();
      // iOS drops the loopback FlareSolverr listener across background cycles,
      // leaving Kotlin/JVM sources with "ConnectException 127.0.0.1:52700" (the
      // Manganato error). Re-bind it. This is Dart-only (no JVM op), so it is
      // safe inside the background-transition window the JVM signal-handler
      // restore protects - unlike the library auto-update below, which is
      // deferred for exactly that reason.
      unawaited(CfFlareSolverrServer.instance.ensureRunning());
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) _maybeAutoUpdateLibrary();
      });
    }
  }

  /// Open the app on the user's chosen launch tab (Settings > Appearance >
  /// Open to). `more` lands on Library and pushes Settings over it; Discover
  /// kicks off its feed since the user opted to start there.
  void _applyStartTab() {
    final start = context.read<NavPrefsProvider>().startTabId;
    if (start == 'more') {
      _activeTabId = 'library';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pushNamed(context, AppRoutes.settings);
      });
      return;
    }
    if (!_screenIds.contains(start)) return; // keep the 'library' default
    _activeTabId = start;
    if (start == 'discover') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.read<DiscoverProvider>().ensureLoaded();
      });
    }
  }

  void _onTabTapped(String id) {
    // "More" opens Settings rather than a stack page - it never becomes active.
    if (id == 'more') {
      Navigator.pushNamed(context, AppRoutes.settings);
      return;
    }

    // Discover: kick off the first feed load only when the tab is opened, so the
    // recommendation fetch never runs at app startup for users who don't use it.
    if (id == 'discover') {
      context.read<DiscoverProvider>().ensureLoaded();
    }

    // Track rapid taps on Library tab for vault activation
    if (id == 'library' && _activeTabId == 'library') {
      final now = DateTime.now();
      if (now.difference(_lastLibraryTap).inMilliseconds < 2000) {
        _libraryTapCount++;
      } else {
        _libraryTapCount = 1;
      }
      _lastLibraryTap = now;

      final vault = context.read<VaultProvider>();
      if (vault.vaultEnabled && _libraryTapCount >= 6 && _libraryTapCount < 8) {
        final remaining = 8 - _libraryTapCount;
        final t = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).clearSnackBars();
        AppTheme.showSnackBar(context,
            vault.vaultActive
                ? t.appVaultTapsToExit(remaining)
                : t.appVaultTapsToEnter(remaining),
            duration: const Duration(milliseconds: 800));
      }
      if (_libraryTapCount >= 8 && vault.vaultEnabled) {
        _libraryTapCount = 0;
        ScaffoldMessenger.of(context).clearSnackBars();
        if (vault.vaultActive) {
          vault.exitVault();
        } else {
          if (vault.hasPassword) {
            _showVaultPasswordDialog(vault);
          } else {
            vault.enterVault();
          }
        }
        return;
      }
    } else {
      _libraryTapCount = 0;
    }

    setState(() => _activeTabId = id);
  }

  /// Switch tabs when a descendant asks via [navTabRequest] (e.g. the Library
  /// "Add" FAB → Browse) - keeps the bottom nav bar instead of pushing a route
  /// over it.
  void _onNavTabRequest() {
    final id = navTabRequest.value;
    if (id == null) return;
    navTabRequest.value = null; // consume
    if (!mounted || !_screenIds.contains(id) || id == _activeTabId) return;
    // Drop any pushed routes first so we land on the shell's tab, not under a
    // stacked screen.
    Navigator.of(context).popUntil((r) => r.isFirst);
    setState(() => _activeTabId = id);
  }

  @override
  Widget build(BuildContext context) {
    final vault = context.watch<VaultProvider>();
    final isVault = vault.vaultActive;
    _syncShakeListener(); // start/stop panic-shake with vault state (guarded)
    final contentType = context.watch<LibraryTypeProvider>().type;
    // Browse-tab badge: installed extensions with a newer version, scoped to the
    // current space (vault sources only in vault mode, non-vault sources otherwise).
    final browseBadge = context
        .watch<SourceProvider>()
        .updatesForContext(
            vaultActive: vault.vaultActive, vaultIds: vault.vaultSourceIds)
        .length;
    return Scaffold(
      body: IndexedStack(
        index: _screenIds.indexOf(_activeTabId).clamp(0, _screens.length - 1),
        children: _screens,
      ),
      bottomNavigationBar: AppNavigation(
        tabIds: context.watch<NavPrefsProvider>().order,
        activeId: _activeTabId,
        onTapId: (id) {
          _onTabTapped(id);
          if (id != 'updates') {
            _loadUpdatesBadge();
          } else {
            // The Updates screen stays alive in the IndexedStack, so nudge it
            // to re-read the persisted feed (a category/auto update may have
            // added entries while it wasn't visible).
            UpdatesScreen.reloadSignal.value++;
          }
        },
        isVaultMode: isVault,
        updatesBadge: _updatesBadge,
        browseBadge: browseBadge,
        contentType: contentType,
        // Long-press the Library tab to switch between Manga / Anime / Novels;
        // the bubble anchors just above the tab (anchor = its global rect).
        onLibraryLongPress: (anchor) => showLibraryTypeBubble(context, anchor),
      ),
    );
  }
}
