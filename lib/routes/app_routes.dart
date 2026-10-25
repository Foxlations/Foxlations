import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoRouteTransitionMixin;
import '../presentation/browse_screen/browse_screen.dart';
import '../presentation/library_screen/library_screen.dart';
import '../presentation/updates_screen/updates_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/global_search_screen/global_search_screen.dart';
import '../presentation/source_catalog_screen/source_catalog_screen.dart';
import '../presentation/manga_detail_screen/manga_detail_screen.dart';
import '../presentation/reader_screen/reader_screen.dart';
import '../presentation/player_screen/player_screen.dart';
import '../presentation/webview_screen/webview_screen.dart';
import '../presentation/novel_reader_screen/novel_reader_screen.dart';
import '../presentation/reading_insights_screen/reading_insights_screen.dart';

/// Lets a screen know when a route pushed on top of it (e.g. a settings page)
/// has been popped, so it can re-read preferences that page may have changed.
/// The library screen subscribes to pick up Settings > Library changes without
/// an app restart.
final RouteObserver<PageRoute<dynamic>> routeObserver =
    RouteObserver<PageRoute<dynamic>>();

class AppRoutes {
  static const String library = '/';
  static const String updates = '/updates';
  static const String browse = '/browse';
  static const String settings = '/settings';
  static const String globalSearch = '/global-search';
  static const String sourceCatalog = '/source-catalog';
  static const String mangaDetail = '/manga-detail';
  static const String reader = '/reader';
  static const String player = '/player';
  static const String webview = '/webview';
  static const String novelReader = '/novel-reader';
  static const String readingInsights = '/reading-insights';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case library:
        return _fadeSlide(const LibraryScreen(), settings);
      case updates:
        return _fadeSlide(const UpdatesScreen(), settings);
      case browse:
        return _fadeSlide(const BrowseScreen(), settings);
      case AppRoutes.settings:
        return _swipeable(const SettingsScreen(), settings);
      case globalSearch:
        final args = settings.arguments as Map<String, dynamic>?;
        return _fadeSlide(
            GlobalSearchScreen(
              initialQuery: args?['query'] as String?,
              initialType: args?['type'] as String?,
            ),
            settings);
      case sourceCatalog:
        final args = settings.arguments as Map<String, dynamic>;
        return _fadeSlide(
          SourceCatalogScreen(
            sourceId: args['sourceId'] as String,
            sourceName: args['sourceName'] as String,
            initialSearchQuery: args['searchQuery'] as String?,
          ),
          settings,
        );
      case mangaDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return _swipeable(
          MangaDetailScreen(
            mangaUrl: args['mangaUrl'] as String,
            sourceId: args['sourceId'] as String,
            title: args['title'] as String?,
            coverUrl: args['coverUrl'] as String?,
            resume: args['resume'] as bool? ?? false,
            isVault: args['isVault'] as bool? ?? false,
          ),
          settings,
        );
      case reader:
        final args = settings.arguments as Map<String, dynamic>;
        return _scaleFade(
          ReaderScreen(
            chapterUrl: args['chapterUrl'] as String,
            sourceId: args['sourceId'] as String,
            mangaUrl: args['mangaUrl'] as String?,
            chapterTitle: args['chapterTitle'] as String?,
            mangaTitle: args['mangaTitle'] as String?,
            chapters: args['chapters'] as List<Map<String, dynamic>>?,
            currentIndex: args['currentIndex'] as int? ?? 0,
            startPage: args['startPage'] as int? ?? 0,
            isVault: args['isVault'] as bool? ?? false,
          ),
          settings,
        );
      case player:
        final args = settings.arguments as Map<String, dynamic>;
        return _scaleFade(
          PlayerScreen(
            sourceId: args['sourceId'] as String,
            episodeUrl: args['episodeUrl'] as String,
            episodeTitle: args['episodeTitle'] as String?,
            animeTitle: args['animeTitle'] as String?,
            mangaUrl: args['mangaUrl'] as String?,
            episodes: args['episodes'] as List<Map<String, dynamic>>?,
            currentIndex: args['currentIndex'] as int? ?? 0,
            isVault: args['isVault'] as bool? ?? false,
          ),
          settings,
        );
      case readingInsights:
        final args = settings.arguments as Map<String, dynamic>?;
        return _fadeSlide(
          ReadingInsightsScreen(
            isVault: args?['isVault'] as bool? ?? false,
            initialType: args?['contentType'] as String?,
          ),
          settings,
        );
      case novelReader:
        final args = settings.arguments as Map<String, dynamic>;
        return _scaleFade(
          NovelReaderScreen(
            chapterUrl: args['chapterUrl'] as String,
            sourceId: args['sourceId'] as String,
            mangaUrl: args['mangaUrl'] as String?,
            chapterTitle: args['chapterTitle'] as String?,
            mangaTitle: args['mangaTitle'] as String?,
            chapters: (args['chapters'] as List?)?.cast<Map<String, dynamic>>(),
            currentIndex: args['currentIndex'] as int? ?? 0,
            startOffset: args['startOffset'] as int? ?? 0,
            startFraction: (args['startFraction'] as num?)?.toDouble() ?? 0.0,
            isVault: args['isVault'] as bool? ?? false,
          ),
          settings,
        );
      case webview:
        final args = settings.arguments as Map<String, dynamic>;
        return _fadeSlide(
          WebViewScreen(
            url: args['url'] as String,
            title: args['title'] as String? ?? 'WebView',
            cloudflareMode: args['cloudflareMode'] as bool? ?? false,
          ),
          settings,
        );
      default:
        return _fadeSlide(const LibraryScreen(), settings);
    }
  }

  static PageRouteBuilder _fadeSlide(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.03, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          ),
        );
      },
    );
  }

  static PageRouteBuilder _scaleFade(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }

  // Keeps a fade transition but adds the iOS edge-swipe-back gesture (via
  // CupertinoRouteTransitionMixin) - used for top-level pushed pages like
  // Details and Settings.
  static Route<dynamic> _swipeable(Widget page, RouteSettings settings) =>
      _SwipeableRoute<dynamic>(child: page, settings: settings);
}

class _SwipeableRoute<T> extends PageRoute<T>
    with CupertinoRouteTransitionMixin<T> {
  _SwipeableRoute({required this.child, super.settings});

  final Widget child;

  @override
  Widget buildContent(BuildContext context) => child;

  @override
  String? get title => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // The mixin's transition carries the Cupertino slide + the back-swipe
    // gesture; layer a gentle fade over it.
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child:
          super.buildTransitions(context, animation, secondaryAnimation, child),
    );
  }
}
