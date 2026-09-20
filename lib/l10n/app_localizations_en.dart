// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Foxlations';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionApp => 'App';

  @override
  String get settingsSectionManga => 'Manga';

  @override
  String get settingsSectionSystem => 'System';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageEntrySubtitle => 'App display language';

  @override
  String get settingsLanguageSubtitle => 'Choose your app language';

  @override
  String get settingsLanguageSystemDefault => 'System default';

  @override
  String get settingsLanguageHeader => 'App language';

  @override
  String get settingsAppearanceTitle => 'Appearance';

  @override
  String get settingsAppearanceSubtitle => 'Theme, dark mode, display';

  @override
  String get settingsNotificationsTitle => 'Notifications';

  @override
  String get settingsNotificationsSubtitle =>
      'Push alerts, frequency, reminders';

  @override
  String get settingsStorageTitle => 'Storage';

  @override
  String get settingsStorageSubtitle => 'Downloads, folder locations, sync';

  @override
  String get settingsLibraryTitle => 'Library';

  @override
  String get settingsLibrarySubtitle => 'Categories, global update, display';

  @override
  String get settingsReaderTitle => 'Reader';

  @override
  String get settingsReaderSubtitle => 'Reading mode, display, navigation';

  @override
  String get settingsPlayerTitle => 'Player';

  @override
  String get settingsPlayerSubtitle => 'Seek, gestures, speed, autoplay';

  @override
  String get settingsDownloadsTitle => 'Downloads';

  @override
  String get settingsDownloadsSubtitle =>
      'Automatic downloads, delete chapters';

  @override
  String get settingsTrackingTitle => 'Tracking';

  @override
  String get settingsTrackingSubtitle => 'MAL, AniList, Kitsu, and more';

  @override
  String get settingsAiTitle => 'AI & Translation';

  @override
  String get settingsAiSubtitle =>
      'Provider, API keys, speech bubble detection';

  @override
  String get settingsBrowseTitle => 'Browse';

  @override
  String get settingsBrowseSubtitle => 'Sources, extensions, global search';

  @override
  String get settingsRepoForgeTitle => 'RepoForge';

  @override
  String get settingsRepoForgeSubtitle => 'Build & manage sources from any URL';

  @override
  String get settingsBackupTitle => 'Backup & Restore';

  @override
  String get settingsBackupSubtitle =>
      'Create/restore backups, import, auto-backup';

  @override
  String get settingsSecurityTitle => 'Security & Privacy';

  @override
  String get settingsSecuritySubtitle =>
      'App lock, biometrics, screen security';

  @override
  String get settingsAdvancedTitle => 'Advanced';

  @override
  String get settingsAdvancedSubtitle => 'Network, extensions, logging, data';

  @override
  String get settingsAboutTitle => 'About';

  @override
  String get settingsAboutSubtitle => 'Version, licenses, links';

  @override
  String get libraryAdd => 'Add';

  @override
  String get libraryAddAnime => 'Add Anime';

  @override
  String get libraryAddLNs => 'Add LNs';

  @override
  String get libraryAddManga => 'Add Manga';

  @override
  String get libraryApply => 'Apply';

  @override
  String get libraryAscending => 'Ascending';

  @override
  String get libraryBadges => 'Badges';

  @override
  String get libraryBatchMigrate => 'Migrate';

  @override
  String get libraryBatchMove => 'Move';

  @override
  String get libraryBatchRead => 'Read';

  @override
  String get libraryBatchRemove => 'Remove';

  @override
  String get libraryBatchUnread => 'Unread';

  @override
  String get libraryCategoryUpdate => 'Category Update';

  @override
  String libraryCategoryUpdateDesc(Object category) {
    return 'Check \"$category\" for new chapters';
  }

  @override
  String libraryChapterProgress(Object read, Object total) {
    return 'Ch. $read/$total';
  }

  @override
  String libraryChaptersAbbrev(Object n) {
    return '$n ch';
  }

  @override
  String get libraryChaptersRead => 'Chapters Read';

  @override
  String get libraryCheckForUpdates => 'Check for updates';

  @override
  String get libraryClose => 'Close';

  @override
  String get libraryCloseSearch => 'Close search';

  @override
  String get libraryCompleted => 'Completed';

  @override
  String get libraryContinueReading => 'Continue Reading';

  @override
  String get libraryCoverSize => 'Cover Size';

  @override
  String libraryDaysCount(Object days) {
    return '$days days';
  }

  @override
  String get libraryDescending => 'Descending';

  @override
  String get libraryDeselectAll => 'Deselect all';

  @override
  String get libraryDisplayMode => 'Display Mode';

  @override
  String get libraryDownloaded => 'Downloaded';

  @override
  String get libraryEmpty => 'Library is empty';

  @override
  String get libraryEmptyDesc =>
      'Your library is empty. Browse sources to add manga.';

  @override
  String libraryEmptyStatsLibrary(Object word) {
    return 'Add $word to your library and start reading to see your stats here.';
  }

  @override
  String libraryEmptyStatsVault(Object word) {
    return 'Add $word to your vault and start reading to see stats here.';
  }

  @override
  String get libraryFilterSortDisplay => 'Filter, sort & display';

  @override
  String get libraryGlobalUpdate => 'Global Update';

  @override
  String get libraryGlobalUpdateDesc => 'Check every entry in your library';

  @override
  String get libraryHeatmapLess => 'Less';

  @override
  String get libraryHeatmapMore => 'More';

  @override
  String get libraryItemsPerRow => 'Items per row';

  @override
  String libraryLastChecked(Object when) {
    return 'Last checked: $when';
  }

  @override
  String get libraryLibrary => 'Library';

  @override
  String libraryListChapters(Object read, Object total) {
    return '$read/$total chapters';
  }

  @override
  String get libraryMonthlyActivity => 'Monthly Activity';

  @override
  String get libraryMore => 'More';

  @override
  String get libraryMostReadSeries => 'Most-Read Series';

  @override
  String get libraryMoveToCategory => 'Move to Category';

  @override
  String get libraryNever => 'never';

  @override
  String get libraryNoBookmarks => 'No bookmarks yet';

  @override
  String get libraryNoBookmarksDesc =>
      'Long-press a manga and bookmark it to see it here.';

  @override
  String get libraryNoNewChapters => 'No new chapters';

  @override
  String get libraryNoNewChaptersLastCheck =>
      'No new chapters were found in the last check.';

  @override
  String get libraryNoResults => 'No results';

  @override
  String libraryNoResultsDesc(Object query) {
    return 'No results for \"$query\". Try a different search.';
  }

  @override
  String get libraryNoStatsYet => 'No stats yet';

  @override
  String get libraryOpenRandomEntry => 'Open random entry';

  @override
  String get libraryReadingStreak => 'Reading Streak';

  @override
  String get libraryResetToDefault => 'Reset to default';

  @override
  String get librarySave => 'Save';

  @override
  String get librarySearchHint => 'Search in library...';

  @override
  String get librarySearchLibrary => 'Search library';

  @override
  String get librarySelect => 'Select';

  @override
  String get librarySelectAll => 'Select all';

  @override
  String librarySelectedCount(Object n) {
    return '$n selected';
  }

  @override
  String get librarySeries => 'Series';

  @override
  String get libraryShowNumberOfItems => 'Show number of items';

  @override
  String get librarySizeLarge => 'Large';

  @override
  String get librarySizeMedium => 'Medium';

  @override
  String get librarySizeSmall => 'Small';

  @override
  String get librarySortLastUpdated => 'Last Updated';

  @override
  String get librarySortRating => 'Rating';

  @override
  String get librarySortTitle => 'Title';

  @override
  String get librarySortUnreadCount => 'Unread Count';

  @override
  String get librarySources => 'Sources';

  @override
  String get libraryStats => 'Stats';

  @override
  String get libraryStatusAll => 'All';

  @override
  String get libraryStatusCompleted => 'Completed';

  @override
  String get libraryStatusDropped => 'Dropped';

  @override
  String get libraryStatusOnHold => 'On Hold';

  @override
  String get libraryStatusPlanToRead => 'Plan to Read';

  @override
  String get libraryStatusReading => 'Reading';

  @override
  String get libraryStatusUnknown => 'Unknown';

  @override
  String get libraryStreakBest => 'Best';

  @override
  String get libraryStreakCurrent => 'Current';

  @override
  String libraryStreakDaysStrong(Object days) {
    return '$days days strong — keep it up!';
  }

  @override
  String get libraryStreakKeepGoing =>
      'Read tomorrow to keep the streak going!';

  @override
  String get libraryStreakStart => 'Start a streak by reading today!';

  @override
  String get libraryTabDisplay => 'Display';

  @override
  String get libraryTabFilter => 'Filter';

  @override
  String get libraryTabSort => 'Sort';

  @override
  String get libraryTabs => 'Tabs';

  @override
  String libraryTotalAbbrev(Object n) {
    return '$n total';
  }

  @override
  String get libraryTotalChapters => 'Total Chapters';

  @override
  String libraryTypeBreakdown(Object type) {
    return '$type Breakdown';
  }

  @override
  String get libraryUnread => 'Unread';

  @override
  String get libraryUpdatesSummary => 'Updates Summary';

  @override
  String get libraryUpdatesSummaryDesc => 'What the last check found';

  @override
  String get libraryVault => 'Vault';

  @override
  String get libraryVaultBreakdown => 'Vault Breakdown';

  @override
  String get libraryVaultStats => 'Vault Stats';

  @override
  String get detailAdd => 'Add';

  @override
  String get detailAddNoteHint => 'Add a note for this title…';

  @override
  String get detailAddToCategory => 'Add to Category';

  @override
  String get detailAddToLibrary => 'Add to Library';

  @override
  String get detailAddWithoutCategory => 'Add without Category';

  @override
  String get detailBelowRead => 'Below read';

  @override
  String get detailBelowUnread => 'Below unread';

  @override
  String get detailBookmark => 'Bookmark';

  @override
  String get detailBookmarked => 'Bookmarked';

  @override
  String get detailCancel => 'Cancel';

  @override
  String get detailChapterFallback => 'Chapter';

  @override
  String detailCopiedTo(Object source) {
    return 'Copied to $source';
  }

  @override
  String detailCountSelected(Object count) {
    return '$count selected';
  }

  @override
  String get detailDeleteDownload => 'Delete download';

  @override
  String get detailDone => 'Done';

  @override
  String get detailDownload => 'Download';

  @override
  String get detailDownloadAllChapters => 'All chapters';

  @override
  String get detailDownloadAllUnread => 'All unread';

  @override
  String get detailDownloaded => 'Downloaded';

  @override
  String get detailDownloadNext10 => 'Next 10 chapters';

  @override
  String get detailDownloadNext5 => 'Next 5 chapters';

  @override
  String get detailDownloadNextChapter => 'Next chapter';

  @override
  String get detailEditCategories => 'Edit categories';

  @override
  String get detailEditCategoriesTitle => 'Edit Categories';

  @override
  String get detailFilter => 'Filter';

  @override
  String get detailInProgress => 'In progress';

  @override
  String get detailLogIn => 'Log in';

  @override
  String get detailMangaNotFound => 'Manga not found in library';

  @override
  String get detailMarkAllAsRead => 'Mark all as read';

  @override
  String get detailMarkAllAsUnread => 'Mark all as unread';

  @override
  String get detailMarkAllBelowRead => 'Mark all below as read';

  @override
  String get detailMarkAsUnread => 'Mark as unread';

  @override
  String get detailMarkChapterAsRead => 'Mark chapter as read';

  @override
  String get detailMarkRead => 'Mark read';

  @override
  String get detailMarkUnread => 'Mark unread';

  @override
  String get detailMigrate => 'Migrate';

  @override
  String get detailMigrateCategories => 'Categories';

  @override
  String get detailMigrateChapters => 'Chapters';

  @override
  String get detailMigrateCopy => 'Copy';

  @override
  String get detailMigrateDownloadsNoTransfer =>
      'Downloaded chapters do not transfer.';

  @override
  String detailMigratedTo(Object source) {
    return 'Migrated to $source';
  }

  @override
  String detailMigrateEntriesToSource(Object count, Object source) {
    return '$count entries → $source';
  }

  @override
  String get detailMigrateInfo =>
      'Select the same manga from a different source. Read progress will be transferred.';

  @override
  String get detailMigrateRemoveDownloads => 'Remove downloads if migrate';

  @override
  String get detailMigrateSelectData => 'Select data to include';

  @override
  String get detailMigrateShowEntry => 'Show entry';

  @override
  String detailMigrateTitleToSource(Object title, Object source) {
    return '$title → $source';
  }

  @override
  String get detailMigrateTracking => 'Tracking';

  @override
  String get detailMigrating => 'Migrating…';

  @override
  String get detailNewestFirst => 'Newest first';

  @override
  String get detailNoChaptersFound => 'No chapters found';

  @override
  String get detailNoChaptersLoginHint =>
      'Nothing loaded for this title. Try again — or, for this source, logging in can sometimes unlock more.';

  @override
  String get detailNoChaptersRetryHint =>
      'Nothing loaded for this title. It may have none yet, or the source had trouble loading them. Try again.';

  @override
  String get detailNoResults => 'No results found';

  @override
  String get detailNotes => 'Notes';

  @override
  String get detailNothingToDownload => 'Nothing to download';

  @override
  String get detailOldestFirst => 'Oldest first';

  @override
  String get detailOpenInBrowser => 'Open in browser';

  @override
  String detailPage(Object page) {
    return 'Page $page';
  }

  @override
  String get detailRefresh => 'Refresh';

  @override
  String get detailRemove => 'Remove';

  @override
  String get detailRemoveBookmark => 'Remove bookmark';

  @override
  String get detailRemoveFromLibrary => 'Remove from library';

  @override
  String get detailRemoveFromLibraryTitle => 'Remove from library?';

  @override
  String get detailResume => 'Resume';

  @override
  String get detailRetry => 'Retry';

  @override
  String get detailSave => 'Save';

  @override
  String get detailSearchChapters => 'Search chapters';

  @override
  String get detailSearchChaptersHint => 'Search chapters...';

  @override
  String get detailSearchEpisodes => 'Search episodes';

  @override
  String get detailSearchHint => 'Search manga title...';

  @override
  String get detailSearchingSources => 'Searching sources…';

  @override
  String get detailSelectAll => 'Select all';

  @override
  String get detailSelectChapters => 'Select chapters';

  @override
  String get detailTracking => 'Tracking';

  @override
  String get detailUnbookmark => 'Unbookmark';

  @override
  String get detailUnread => 'Unread';

  @override
  String get detailWebView => 'WebView';

  @override
  String get appNavLibrary => 'Library';

  @override
  String get appNavUpdates => 'Updates';

  @override
  String get appNavBrowse => 'Browse';

  @override
  String get appNavDiscover => 'Discover';

  @override
  String get appNavMore => 'More';

  @override
  String get appNavVault => 'Vault';

  @override
  String get appUpdatesTitle => 'Updates';

  @override
  String get appNoNewChapters => 'No new chapters';

  @override
  String get appCheckForUpdates => 'Check for updates';

  @override
  String get appClearAll => 'Clear all';

  @override
  String appCheckingProgress(Object checked, Object total) {
    return 'Checking $checked / $total...';
  }

  @override
  String appLastChecked(Object time) {
    return 'Last checked: $time';
  }

  @override
  String get appNoUpdatesYet => 'No updates yet';

  @override
  String get appTapRefreshForChapters =>
      'Tap refresh to check for new chapters';

  @override
  String get appCheckNow => 'Check Now';

  @override
  String get appJustNow => 'Just now';

  @override
  String appMinutesAgo(Object m) {
    return '${m}m ago';
  }

  @override
  String appHoursAgo(Object h) {
    return '${h}h ago';
  }

  @override
  String appDaysAgo(Object d) {
    return '${d}d ago';
  }

  @override
  String get appToday => 'TODAY';

  @override
  String get appYesterday => 'YESTERDAY';

  @override
  String get appOnLatestVersion => 'You\'re on the latest version';

  @override
  String get appUpdateAvailable => 'Update available';

  @override
  String appVersionBuild(Object version, Object build) {
    return 'v$version · build $build';
  }

  @override
  String get appDownloadUpdate => 'Download update';

  @override
  String appDownloadVersion(Object version) {
    return 'Download v$version';
  }

  @override
  String get appApkDownloadHint =>
      'Opens the APK download. Android will ask you to confirm the install.';

  @override
  String get appIosUpdateHint =>
      'Update from AltStore or SideStore — open it and refresh. iOS can\'t install an app downloaded in a browser.';

  @override
  String get appSourceUrlCopied => 'Source URL copied — add it in AltStore';

  @override
  String get appCopyAltstoreUrl => 'Copy AltStore source URL';

  @override
  String get appBack => 'Back';

  @override
  String get appForward => 'Forward';

  @override
  String get appReload => 'Reload';

  @override
  String get appDoneSaveCookies => 'Done — save cookies';

  @override
  String get appVaultPassword => 'Vault Password';

  @override
  String get appEnterPassword => 'Enter password';

  @override
  String get appWrongPassword => 'Wrong password';

  @override
  String get appCancel => 'Cancel';

  @override
  String get appUnlock => 'Unlock';

  @override
  String get readerExperimentalOnIos => 'Experimental on iOS';

  @override
  String get readerIosVolumeWarning =>
      'iOS has no proper volume-button API, so this works by watching the system volume — it can be glitchy. While reading, the volume of anything you\'re listening to (music, a podcast) will be held at 50% and can\'t be changed. Enable anyway?';

  @override
  String get readerCancel => 'Cancel';

  @override
  String get readerEnable => 'Enable';

  @override
  String get readerTitle => 'Reader';

  @override
  String get readerPreferences => 'Preferences';

  @override
  String get readerReadingMode => 'Reading Mode';

  @override
  String get readerFontSize => 'Font Size';

  @override
  String get readerImageZoom => 'Image Zoom';

  @override
  String get readerAutoPreloadNextChapter => 'Auto-Preload Next Chapter';

  @override
  String get readerAutoPreloadNextChapterSubtitle =>
      'Load next chapter in background';

  @override
  String get readerCropBorders => 'Crop Borders';

  @override
  String get readerCropBordersSubtitle => 'Remove white borders from pages';

  @override
  String get readerGrayscale => 'Grayscale';

  @override
  String get readerGrayscaleSubtitle => 'Display pages in grayscale';

  @override
  String get readerInvertColors => 'Invert Colors';

  @override
  String get readerInvertColorsSubtitle => 'Swap light and dark colors';

  @override
  String get readerDisplay => 'Display';

  @override
  String get readerScaleType => 'Scale Type';

  @override
  String get readerZoomStartPosition => 'Zoom Start Position';

  @override
  String get readerBackgroundColor => 'Background Color';

  @override
  String get readerKeepScreenOn => 'Keep Screen On';

  @override
  String get readerKeepScreenOnSubtitle => 'Prevent screen from sleeping';

  @override
  String get readerShowPageNumber => 'Show Page Number';

  @override
  String get readerShowPageNumberSubtitle => 'Display page indicator overlay';

  @override
  String get readerFullscreen => 'Fullscreen';

  @override
  String get readerFullscreenSubtitle => 'Hide system bars while reading';

  @override
  String get readerNavigation => 'Navigation';

  @override
  String get readerNavigationLayout => 'Navigation Layout';

  @override
  String get readerInvertTapZones => 'Invert Tap Zones';

  @override
  String get readerInvertTapZonesSubtitle => 'Swap left/right tap navigation';

  @override
  String get readerVolumeKeys => 'Volume Keys';

  @override
  String get readerVolumeKeysSubtitle =>
      'Tap to turn a page/scroll; hold to scroll (webtoon)';

  @override
  String get readerHoldScrollSpeed => 'Hold-scroll Speed';

  @override
  String get readerTransitions => 'Transitions';

  @override
  String get readerPageTransition => 'Page Transition';

  @override
  String get readerSourceNotInstalled => 'Source not installed';

  @override
  String get readerTranslating => 'Translating…';

  @override
  String get readerRetry => 'Retry';

  @override
  String get readerLoadingNextChapter => 'Loading next chapter...';

  @override
  String readerFinishedChapter(Object name) {
    return 'Finished: $name';
  }

  @override
  String get readerAllCaughtUp => 'You\'re all caught up!';

  @override
  String get readerEndOfChapter => 'End of Chapter';

  @override
  String get readerLatestChapterAvailable =>
      'This is the latest chapter available.';

  @override
  String get readerLoadNextChapter => 'Load Next Chapter';

  @override
  String get readerBack => 'Back';

  @override
  String get readerSettings => 'Settings';

  @override
  String get readerAiTranslate => 'AI Translate';

  @override
  String get readerPreviousChapter => 'Previous chapter';

  @override
  String get readerBookmark => 'Bookmark';

  @override
  String get readerNextChapter => 'Next chapter';

  @override
  String readerTranslationFailed(Object error) {
    return 'Translation failed: $error';
  }

  @override
  String get readerModeLtrLabel => 'Left to Right';

  @override
  String get readerModeRtlLabel => 'Right to Left';

  @override
  String get readerModeVerticalLabel => 'Continuous Scroll';

  @override
  String get readerModeWebtoonLabel => 'Webtoon';

  @override
  String get readerModeLtrSubtitle => 'Tap left/right to turn pages';

  @override
  String get readerModeRtlSubtitle => 'Manga-style right to left';

  @override
  String get readerModeVerticalSubtitle => 'Scroll vertically through pages';

  @override
  String get readerModeWebtoonSubtitle => 'Optimized for long vertical strips';

  @override
  String get readerChapters => 'Chapters';

  @override
  String readerPageOf(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get readerTabProvider => 'Provider';

  @override
  String get readerTabTarget => 'Target';

  @override
  String get readerTabSource => 'Source';

  @override
  String get readerTabFont => 'Font';

  @override
  String get readerFontNormal => 'Normal';

  @override
  String get readerFontManga => 'Manga';

  @override
  String get readerFontNormalDesc => 'Clean sans-serif';

  @override
  String get readerFontMangaDesc => 'Bold comic style';

  @override
  String get readerFontSample => 'Hello World';

  @override
  String get readerNoChapterText => 'No chapter text found';

  @override
  String get readerReadingTitle => 'Reading';

  @override
  String get readerSmallerText => 'Smaller text';

  @override
  String get readerLargerText => 'Larger text';

  @override
  String get readerPrevious => 'Previous';

  @override
  String get readerNext => 'Next';

  @override
  String get browseTitle => 'Browse';

  @override
  String get browseGlobalSearch => 'Global search';

  @override
  String get browseRefreshingRepos => 'Refreshing repos...';

  @override
  String get browseRefreshRepos => 'Refresh repos';

  @override
  String get browseSearch => 'Search';

  @override
  String get browseRepoForgeTooltip => 'RepoForge — build & manage sources';

  @override
  String get browseAddRepo => 'Add repo';

  @override
  String get browseTabSources => 'Sources';

  @override
  String get browseTabExtensions => 'Extensions';

  @override
  String get browseTabLocal => 'Local';

  @override
  String get browseSearchHint => 'Search extensions & sources...';

  @override
  String browseRemoveSourceConfirm(Object name) {
    return 'Remove $name?';
  }

  @override
  String get browseRemoveSourceDesc =>
      'The source will be uninstalled. Your library entries from it are kept, but you won\'t be able to open them until you reinstall it.';

  @override
  String get browseCancel => 'Cancel';

  @override
  String get browseRemove => 'Remove';

  @override
  String get browseProvidedByThisSource => 'PROVIDED BY THIS SOURCE';

  @override
  String get browseCouldNotLoadOptions =>
      'Could not load the source\'s options';

  @override
  String get browseNoSourceOptions =>
      'This source doesn\'t define any options of its own. The settings above still apply to it.';

  @override
  String get browseBaseUrl => 'Base URL';

  @override
  String get browseUsingSourceDefault => 'Using the source default';

  @override
  String browseBaseUrlDefault(Object url) {
    return '$url  (default)';
  }

  @override
  String get browseResetToDefault => 'Reset to default';

  @override
  String get browsePinToTop => 'Pin to top';

  @override
  String get browsePinToTopDesc => 'Show this source first in the sources list';

  @override
  String get browseSkipGlobalSearch => 'Skip in global search';

  @override
  String get browseSkipGlobalSearchDesc =>
      'Leave this source out when searching everything';

  @override
  String get browseSkipLibraryUpdates => 'Skip in library updates';

  @override
  String get browseSkipLibraryUpdatesDesc =>
      'Don\'t check this source for new chapters';

  @override
  String get browseRequestDesktopSite => 'Request desktop site';

  @override
  String get browseRequestDesktopSiteDesc =>
      'Try this if the source finds nothing, or shows no chapters — some sites send phones a cut-down page';

  @override
  String get browseSave => 'Save';

  @override
  String get browseNone => 'None';

  @override
  String browseSelectedCount(Object count) {
    return '$count selected';
  }

  @override
  String get browseNotSet => 'Not set';

  @override
  String get browseIosFolderWarning =>
      'iOS does not allow apps to keep access to a folder. Use \"Import File\" to add .cbz/.cbr/.zip/.epub/.pdf instead.';

  @override
  String browseImportedFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Imported $count files',
      one: 'Imported 1 file',
    );
    return '$_temp0';
  }

  @override
  String get browseNothingImported =>
      'Nothing imported (unsupported or unreadable)';

  @override
  String browseFolderCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count folders',
      one: '1 folder',
    );
    return '$_temp0';
  }

  @override
  String get browseManageFolders => 'Manage folders';

  @override
  String get browseImportFileTooltip => 'Import file (CBZ/ZIP/EPUB/PDF)';

  @override
  String get browseAddFolder => 'Add folder';

  @override
  String get browseRescan => 'Rescan';

  @override
  String get browseNothingImportedYet => 'Nothing imported yet';

  @override
  String get browseNoLocalSources => 'No local sources';

  @override
  String get browseLocalSourcesDesc =>
      'Add a folder of manga, or import a single file.\nSupported: images (JPG, PNG, WebP, GIF), CBZ/ZIP, EPUB and PDF.\n(CBR/RAR only if the file is actually ZIP-packed — true RAR isn\'t supported.)';

  @override
  String get browseAddFolderButton => 'Add Folder';

  @override
  String get browseImportFile => 'Import File';

  @override
  String get browseLocalSourceFolders => 'Local Source Folders';

  @override
  String get browseNoFoldersAdded => 'No folders added';

  @override
  String browseChaptersAbbrev(Object n) {
    return '$n ch';
  }

  @override
  String get browseInstalled => 'INSTALLED';

  @override
  String get browseAvailable => 'AVAILABLE';

  @override
  String get browseSourceNotInstalled => 'Source is not installed';

  @override
  String get browseManga => 'Manga';

  @override
  String get browseAnime => 'Anime';

  @override
  String get browseNovels => 'Novels';

  @override
  String get browseAllLanguages => 'All languages';

  @override
  String get browseFilter => 'Filter';

  @override
  String browseLanguagesCount(Object count) {
    return '$count languages';
  }

  @override
  String get browseFilterRepository => 'Repository';

  @override
  String get browseAllRepositories => 'All repositories';

  @override
  String browseReposCount(Object count) {
    return '$count repositories';
  }

  @override
  String browseResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
    );
    return '$_temp0';
  }

  @override
  String get browseNoExtensions => 'No extensions yet';

  @override
  String get browseNoExtensionsDesc =>
      'Add a repository using the settings\nbutton above to browse extensions.';

  @override
  String browseUpdatedSources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Updated $count sources',
      one: 'Updated 1 source',
    );
    return '$_temp0';
  }

  @override
  String get browseSourceUpdated => 'Source updated';

  @override
  String get browseNoUpdateAvailable => 'No update available';

  @override
  String browseUpdateFailed(Object error) {
    return 'Update failed: $error';
  }

  @override
  String browseRefreshFailed(Object error) {
    return 'Refresh failed: $error';
  }

  @override
  String browseUpdatesAvailable(Object count) {
    return 'UPDATES AVAILABLE ($count)';
  }

  @override
  String get browseUpdateAll => 'Update all';

  @override
  String get browseUpdate => 'Update';

  @override
  String get browseSettings => 'Settings';

  @override
  String get browseInstall => 'Install';

  @override
  String get browseInstalledBadge => 'Installed';

  @override
  String get browseAbout => 'ABOUT';

  @override
  String browseSourceFrom(Object url) {
    return 'Source from $url';
  }

  @override
  String browseLanguageLabel(Object lang) {
    return 'Language: $lang';
  }

  @override
  String get browseUsesCloudflare => 'Uses Cloudflare protection';

  @override
  String get browseNoCloudflare => 'No Cloudflare';

  @override
  String get browseAdultContent => '18+ Content';

  @override
  String get browseSafeForWork => 'Safe for work';

  @override
  String get browseFeatures => 'FEATURES';

  @override
  String get browsePopular => 'Popular';

  @override
  String get browseLatest => 'Latest';

  @override
  String browseSourceAction(Object name) {
    return 'Browse $name';
  }

  @override
  String get browseRemoving => 'Removing...';

  @override
  String get browseInstalling => 'Installing...';

  @override
  String browseFailed(Object error) {
    return 'Failed: $error';
  }

  @override
  String get browseUpdating => 'Updating...';

  @override
  String get browseUpdateExtensionCode => 'Update extension code';

  @override
  String browseUpdatedSource(Object name) {
    return 'Updated $name';
  }

  @override
  String get browsePinned => 'PINNED';

  @override
  String get browseAll => 'All';

  @override
  String get browseNoInstalledSources => 'No installed sources';

  @override
  String get browseNoInstalledSourcesDesc =>
      'Install extensions from the Extensions tab\nto see sources here.';

  @override
  String get browseUnpin => 'Unpin';

  @override
  String get browsePin => 'Pin';

  @override
  String get browseSourceNotInstalledBody => 'Source not installed';

  @override
  String get browseBypassingCloudflare => 'Bypassing Cloudflare protection...';

  @override
  String get browseOpenInWebView => 'Open in WebView';

  @override
  String get browseCloudflareProtection => 'Cloudflare Protection';

  @override
  String get browseFailedToLoad => 'Failed to load';

  @override
  String get browseCloudflareChallengeDesc =>
      'This source requires solving a Cloudflare challenge in the browser first.';

  @override
  String get browseSolveCloudflare => 'Solve Cloudflare';

  @override
  String get browseRetry => 'Retry';

  @override
  String get browseContentAnime => 'anime';

  @override
  String get browseContentNovels => 'light novels';

  @override
  String get browseContentManga => 'manga';

  @override
  String browseNoContentFound(Object noun) {
    return 'No $noun found';
  }

  @override
  String get browseAllCategories => 'All categories';

  @override
  String get browseNoCategories => 'No categories';

  @override
  String get browseSearchMangaHint => 'Search manga...';

  @override
  String get browseUnknown => 'Unknown';

  @override
  String get browseSearchAllSourcesHint => 'Search across all sources...';

  @override
  String get browseNoSourcesInstalled => 'No sources installed';

  @override
  String get browseNoSourcesInstalledDesc =>
      'Install extensions from Browse tab.';

  @override
  String get browseSearchAllSources => 'Search All Sources';

  @override
  String browseSearchSourcesAtOnce(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Search $count sources at once.',
      one: 'Search 1 source at once.',
    );
    return '$_temp0';
  }

  @override
  String browseSearchingSources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Searching $count sources...',
      one: 'Searching 1 source...',
    );
    return '$_temp0';
  }

  @override
  String get browseSeeAll => 'See all';

  @override
  String get browseNoResultsFound => 'No results found';

  @override
  String get browseSectionSources => 'Sources';

  @override
  String get browseShowNsfw => 'Show NSFW Sources';

  @override
  String get browseShowNsfwDesc => 'Show 18+ sources in browse and search';

  @override
  String get browsePinnedOnly => 'Pinned Sources Only';

  @override
  String get browsePinnedOnlyBrowseDesc => 'Only show pinned sources in browse';

  @override
  String get browseSectionGlobalSearch => 'Global Search';

  @override
  String get browsePinnedOnlyGlobalSearchDesc =>
      'Only search pinned sources in global search';

  @override
  String get browseSectionWebView => 'WebView';

  @override
  String get browseAdBlocker => 'Ad Blocker';

  @override
  String get browseAdBlockerDesc =>
      'Block ads, popups, and overlays in the browser';

  @override
  String get browseSectionExtensions => 'Extensions';

  @override
  String get browseAutoUpdate => 'Auto-Update Extensions';

  @override
  String get browseAutoUpdateDesc =>
      'Refresh installed extension code on app launch';

  @override
  String get setxAdvancedTitle => 'Advanced';

  @override
  String get setxAdvancedSectionLogging => 'Logging';

  @override
  String get setxAdvancedVerboseLoggingTitle => 'Verbose Logging';

  @override
  String get setxAdvancedVerboseLoggingSubtitle =>
      'Log detailed debug information';

  @override
  String get setxAdvancedViewErrorLogsTitle => 'View Error Logs';

  @override
  String get setxAdvancedViewErrorLogsSubtitle => 'Browse debug and error logs';

  @override
  String get setxAdvancedSectionNetwork => 'Network';

  @override
  String get setxAdvancedDnsOverHttpsTitle => 'DNS over HTTPS';

  @override
  String get setxAdvancedDnsOverHttpsSubtitle => 'Use secure DNS resolution';

  @override
  String get setxAdvancedDnsProviderTitle => 'DNS Provider';

  @override
  String get setxAdvancedSectionExtensions => 'Extensions';

  @override
  String get setxAdvancedThirdPartyTitle => 'Third-Party Extensions';

  @override
  String get setxAdvancedThirdPartySubtitle =>
      'Allow extensions from unknown sources';

  @override
  String get setxAdvancedExtUpdateTitle => 'Extension Update Alerts';

  @override
  String get setxAdvancedExtUpdateSubtitle =>
      'Notify when extensions have updates';

  @override
  String get setxAdvancedSectionBrowser => 'Browser';

  @override
  String get setxAdvancedExternalBrowserTitle => 'External Browser';

  @override
  String get setxAdvancedExternalBrowserSubtitle =>
      'Open links in system browser';

  @override
  String get setxAdvancedSectionData => 'Data';

  @override
  String get setxAdvancedClearCacheTitle => 'Clear Chapter Cache';

  @override
  String get setxAdvancedClearCacheSubtitle => 'Free up storage space';

  @override
  String get setxAdvancedClearDbEntryTitle => 'Clear Database';

  @override
  String get setxAdvancedClearDbEntrySubtitle =>
      'Reset library, categories, and read history';

  @override
  String get setxAdvancedCacheCleared => 'Chapter image cache cleared';

  @override
  String get setxAdvancedClearDbTitle => 'Clear database?';

  @override
  String get setxAdvancedClearDbBody =>
      'This permanently deletes your library, categories, and read history. Installed extensions and downloads are not affected.';

  @override
  String get setxAdvancedCancel => 'Cancel';

  @override
  String get setxAdvancedClear => 'Clear';

  @override
  String get setxAdvancedDbCleared =>
      'Database cleared — restart the app to reseed defaults';

  @override
  String get setxAdvancedErrorLogsTitle => 'Error Logs';

  @override
  String get setxAdvancedClearAllLogsTooltip => 'Clear all logs';

  @override
  String get setxAdvancedFilterCategory => 'Category';

  @override
  String get setxAdvancedFilterLevel => 'Level';

  @override
  String get setxAdvancedNoLogs => 'No logs yet';

  @override
  String get setxAdvancedNoLogsSubtitle =>
      'Logs will appear here as you use the app';

  @override
  String get setxAdvancedClearLogsTitle => 'Clear all logs?';

  @override
  String get setxAdvancedClearLogsBody =>
      'This will permanently delete all stored log entries.';

  @override
  String get setxAdvancedLogsCleared => 'Logs cleared';

  @override
  String get setxAdvancedCopiedToClipboard => 'Copied to clipboard';

  @override
  String get setxNotifTitle => 'Notifications';

  @override
  String get setxNotifSectionChapterUpdates => 'Chapter Updates';

  @override
  String get setxNotifNewChaptersTitle => 'New Chapters';

  @override
  String get setxNotifNewChaptersSubtitle =>
      'Notify when new chapters are available';

  @override
  String get setxNotifLibraryUpdatesTitle => 'Library Updates';

  @override
  String get setxNotifLibraryUpdatesSubtitle =>
      'Notify after library update completes';

  @override
  String get setxNotifSectionDownloads => 'Downloads';

  @override
  String get setxNotifDownloadCompleteTitle => 'Download Complete';

  @override
  String get setxNotifDownloadCompleteSubtitle =>
      'Notify when chapters finish downloading';

  @override
  String get setxNotifDownloadErrorTitle => 'Download Error';

  @override
  String get setxNotifDownloadErrorSubtitle => 'Notify when a download fails';

  @override
  String get setxNotifSectionBehavior => 'Behavior';

  @override
  String get setxNotifSoundTitle => 'Sound';

  @override
  String get setxNotifSoundSubtitle => 'Play sound for notifications';

  @override
  String get setxNotifVibrationTitle => 'Vibration';

  @override
  String get setxNotifVibrationSubtitle => 'Vibrate for notifications';

  @override
  String get setxNotifGroupTitle => 'Group Notifications';

  @override
  String get setxNotifGroupSubtitle => 'Combine multiple notifications';

  @override
  String get setxSecurityTitle => 'Security & Privacy';

  @override
  String get setxSecuritySectionAppLock => 'App Lock';

  @override
  String get setxSecurityAppLockTitle => 'App Lock';

  @override
  String get setxSecurityAppLockSubtitle =>
      'Require authentication to open app';

  @override
  String get setxSecurityBiometricsTitle => 'Biometrics';

  @override
  String get setxSecurityBiometricsSubtitle =>
      'Use fingerprint or face to unlock';

  @override
  String get setxSecuritySectionPrivacy => 'Privacy';

  @override
  String get setxSecuritySecureScreenTitle => 'Secure Screen';

  @override
  String get setxSecuritySecureScreenSubtitle =>
      'Hide app content in recent apps';

  @override
  String get setxSecurityHideNotifTitle => 'Hide Notification Content';

  @override
  String get setxSecurityHideNotifSubtitle => 'Show generic notification text';

  @override
  String get setxBackupTitle => 'Backup & Restore';

  @override
  String get setxBackupSectionFoxlations => 'Foxlations backup';

  @override
  String get setxBackupCreateTitle => 'Create backup';

  @override
  String get setxBackupCreateSubtitle =>
      'Save your library, categories, read progress, sources and tracking';

  @override
  String get setxBackupRestoreTitle => 'Restore backup';

  @override
  String get setxBackupRestoreSubtitle =>
      'Restore from a Foxlations .fxbackup file';

  @override
  String get setxBackupSectionTachiyomi => 'Tachiyomi / Mihon & forks';

  @override
  String get setxBackupCreateCompatTitle => 'Create compatible backup';

  @override
  String get setxBackupCreateCompatSubtitle =>
      'Export a .tachibk you can import into Tachiyomi, Mihon and forks';

  @override
  String get setxBackupRestoreTachiyomiTitle => 'Restore from Tachiyomi/Mihon';

  @override
  String get setxBackupRestoreTachiyomiSubtitle =>
      'Import a .tachibk / .tmb / .proto.gz backup (matches sources by name)';

  @override
  String get setxBackupSectionAutomatic => 'Automatic backup';

  @override
  String get setxBackupFrequency => 'Frequency';

  @override
  String setxBackupAutoSubtitle(Object freq) {
    return 'Auto-create a backup $freq';
  }

  @override
  String setxBackupSectionBackups(Object count) {
    return 'Backups ($count)';
  }

  @override
  String get setxBackupNone => 'No backups yet.';

  @override
  String get setxBackupMenuRestore => 'Restore';

  @override
  String get setxBackupMenuDelete => 'Delete';

  @override
  String get setxBackupFreqOff => 'Off';

  @override
  String get setxBackupFreqDaily => 'Daily';

  @override
  String get setxBackupFreqWeekly => 'Weekly';

  @override
  String get setxBackupFreqMonthly => 'Monthly';

  @override
  String setxBackupImportedManga(Object count) {
    return 'Imported $count manga';
  }

  @override
  String get setxBackupRestoreComplete => 'Restore complete';

  @override
  String setxBackupRestoreFailed(Object error) {
    return 'Restore failed: $error';
  }

  @override
  String get setxAboutTitle => 'About';

  @override
  String get setxAboutSectionApp => 'App';

  @override
  String get setxAboutWhatsNewTitle => 'What\'s New';

  @override
  String get setxAboutWhatsNewSubtitle => 'Changelog and release notes';

  @override
  String get setxAboutCheckUpdatesTitle => 'Check for Updates';

  @override
  String get setxAboutCheckUpdatesSubtitle =>
      'See if a newer build has been released';

  @override
  String get setxAboutSectionLegal => 'Legal';

  @override
  String get setxAboutLicensesTitle => 'Licenses';

  @override
  String get setxAboutLicensesSubtitle => 'Open source licenses';

  @override
  String get setxAboutSectionLinks => 'Links';

  @override
  String get setxAboutSourceCodeTitle => 'Source Code';

  @override
  String get setxAboutSourceCodeSubtitle => 'Tap to copy GitHub URL';

  @override
  String get setxAboutReportBugTitle => 'Report a Bug';

  @override
  String get setxAboutReportBugSubtitle => 'Tap to copy issue tracker URL';

  @override
  String get setxAboutClose => 'Close';

  @override
  String setxAboutWhatsNewVersioned(Object version) {
    return 'What\'s New in v$version';
  }

  @override
  String setxAboutLinkCopied(Object label) {
    return '$label link copied to clipboard';
  }

  @override
  String get setxAboutSourceCodeLabel => 'Source code';

  @override
  String get setxAboutBugReportLabel => 'Bug report';

  @override
  String get miscResumePlaybackTitle => 'Resume playback?';

  @override
  String miscStoppedWatchingAt(Object time) {
    return 'You stopped watching at $time.';
  }

  @override
  String get miscStartOver => 'Start over';

  @override
  String miscContinueAt(Object time) {
    return 'Continue ($time)';
  }

  @override
  String get miscQuality => 'Quality';

  @override
  String miscSourceIndex(Object index) {
    return 'Source $index';
  }

  @override
  String get miscSubtitles => 'Subtitles';

  @override
  String get miscSubtitleOff => 'Off';

  @override
  String get miscUnknownTrack => 'Unknown';

  @override
  String get miscSubtitleDelay => 'Subtitle delay';

  @override
  String get miscAudio => 'Audio';

  @override
  String get miscPlaybackSpeed => 'Playback speed';

  @override
  String get miscSkipOutro => 'Skip Outro';

  @override
  String get miscSkipIntro => 'Skip Intro';

  @override
  String get miscUnlockControls => 'Unlock controls';

  @override
  String get miscUnknownError => 'Unknown error';

  @override
  String get miscRetry => 'Retry';

  @override
  String get miscExtensionRepositories => 'Extension Repositories';

  @override
  String get miscRepositoryUrlHint => 'Repository URL (index.json)';

  @override
  String get miscAdd => 'Add';

  @override
  String get miscRepositoriesHeader => 'REPOSITORIES';

  @override
  String get miscNoReposYet => 'No repos added yet';

  @override
  String miscFailedToAddRepo(Object error) {
    return 'Failed to add repo: $error';
  }

  @override
  String get miscVerifyHuman => 'Verify you are human';

  @override
  String get miscCfInstructions =>
      'Complete the site’s check below. It closes automatically and won’t ask again while the verification lasts.';

  @override
  String get trackTitle => 'Tracking';

  @override
  String get trackNoTrackerConnected => 'No tracker connected';

  @override
  String get trackConnectHint =>
      'Connect AniList, MyAnimeList, or Kitsu in Settings › Tracking.';

  @override
  String trackNotLinkedOn(Object name) {
    return 'Not linked on $name';
  }

  @override
  String get trackLink => 'Link';

  @override
  String get trackUnlink => 'Unlink';

  @override
  String get trackStatus => 'Status';

  @override
  String get trackChapters => 'Chapters';

  @override
  String get trackScore => 'Score';

  @override
  String trackLinkedTo(Object name) {
    return 'Linked to $name';
  }

  @override
  String trackLinkOn(Object name) {
    return 'Link on $name';
  }

  @override
  String get trackSearchTitleHint => 'Search title';

  @override
  String get trackSearch => 'Search';

  @override
  String get trackNoResults => 'No results';

  @override
  String trackChaptersShort(Object count) {
    return '$count ch';
  }

  @override
  String trackConnectTracker(Object name) {
    return 'Connect $name';
  }

  @override
  String get trackOauthInstructions =>
      'Log in and press Authorize. You’ll be signed in automatically.';

  @override
  String get trackServices => 'Services';

  @override
  String get trackServicesDescription =>
      'Connect a tracking service to sync your reading progress. Once a manga is linked, progress updates automatically as you read.';

  @override
  String trackLogInTo(Object name) {
    return 'Log in to $name';
  }

  @override
  String get trackEmailOrUsername => 'Email or username';

  @override
  String get trackPassword => 'Password';

  @override
  String get trackCancel => 'Cancel';

  @override
  String get trackLogIn => 'Log in';

  @override
  String trackConnectedTo(Object name) {
    return 'Connected to $name';
  }

  @override
  String get trackLoginFailed => 'Login failed — check your credentials';

  @override
  String get trackSetClientIdFirst => 'Set a client ID first';

  @override
  String get trackCouldNotCompleteSignIn => 'Could not complete sign-in';

  @override
  String trackClientIdTitle(Object name) {
    return '$name client ID (advanced)';
  }

  @override
  String trackClientIdDescription(Object name) {
    return 'Optional. Foxlations already has a built-in $name client ID — just tap Connect. Only set this if you registered your own $name developer app and want to use it instead.';
  }

  @override
  String get trackClientId => 'Client ID';

  @override
  String get trackSave => 'Save';

  @override
  String get trackPasteAccessToken => 'Paste access token';

  @override
  String get trackPasteTokenHint => 'Paste the token shown after authorizing';

  @override
  String get trackConnect => 'Connect';

  @override
  String get trackCouldNotVerifyToken => 'Could not verify token';

  @override
  String get trackConnected => 'Connected';

  @override
  String trackConnectedAs(Object username) {
    return 'Connected as $username';
  }

  @override
  String get trackTapConnectToAuthorize => 'Tap Connect to authorize';

  @override
  String get trackSignInWithAccount => 'Sign in with your account';

  @override
  String get trackDisconnect => 'Disconnect';

  @override
  String get trackAiTitle => 'AI & Translation';

  @override
  String get trackTabTranslation => 'Translation';

  @override
  String get trackTabApiKeys => 'API Keys';

  @override
  String get trackTabModels => 'Models';

  @override
  String get trackEnableAiTranslation => 'Enable AI Translation';

  @override
  String get trackEnableAiTranslationDesc =>
      'Show translate button in the reader';

  @override
  String get trackProvider => 'Provider';

  @override
  String get trackOfflineMode => 'Offline Mode';

  @override
  String get trackOfflineModeDesc => 'Use downloaded models without internet';

  @override
  String get trackTranslationSettings => 'Translation Settings';

  @override
  String get trackTargetLanguage => 'Target Language';

  @override
  String get trackTargetLanguageDesc =>
      'Translate manga text into this language';

  @override
  String get trackBubbleDetection => 'Bubble Detection';

  @override
  String get trackBubbleDetectionDesc =>
      'Auto-detect speech bubbles in manga pages';

  @override
  String get trackQuality => 'Quality';

  @override
  String get trackQualityFast => 'Fast';

  @override
  String get trackQualityBalanced => 'Balanced';

  @override
  String get trackQualityHigh => 'High Quality';

  @override
  String get trackKoharuServer => 'Koharu Server';

  @override
  String get trackServerUrl => 'Server URL';

  @override
  String get trackKoharuServerDesc =>
      'Full manga inpainting via local Docker server';

  @override
  String get trackApiKeyRequired => 'API key required';

  @override
  String get trackApiKeysNotice =>
      'Keys are stored locally on your device and never sent to our servers.';

  @override
  String get trackModelsPlatformOnly =>
      'On-device translation models are available on Android and iOS.';

  @override
  String get trackModelsDescription =>
      'Download a language to translate it fully offline. Each pack is about 30 MB and is also fetched automatically the first time you translate that language.';

  @override
  String get trackTranslationLanguages => 'TRANSLATION LANGUAGES';

  @override
  String get trackDownloaded => 'Downloaded — available offline';

  @override
  String get trackNotDownloaded => 'Not downloaded';

  @override
  String get trackDelete => 'Delete';

  @override
  String get trackDownload => 'Download';

  @override
  String trackDownloadFailed(Object error) {
    return 'Download failed: $error';
  }

  @override
  String trackDeleteFailed(Object error) {
    return 'Delete failed: $error';
  }

  @override
  String get repoDeleteSourceTitle => 'Delete source?';

  @override
  String repoDeleteSourceBody(Object name) {
    return '\"$name\" will be removed from My Sources.';
  }

  @override
  String get repoCancel => 'Cancel';

  @override
  String get repoDelete => 'Delete';

  @override
  String repoDeletedSource(Object name) {
    return 'Deleted \"$name\"';
  }

  @override
  String get repoNoSourcesToExport => 'No sources to export';

  @override
  String get repoExportDialogTitle => 'Export RepoForge sources';

  @override
  String repoExportedSources(Object count) {
    return 'Exported $count sources';
  }

  @override
  String repoExportFailed(Object error) {
    return 'Export failed: $error';
  }

  @override
  String repoImportedSources(Object count) {
    return 'Imported $count source(s)';
  }

  @override
  String repoImportFailed(Object error) {
    return 'Import failed: $error';
  }

  @override
  String get repoBuildFromUrl => 'Build sources from any URL';

  @override
  String get repoBeta => 'BETA';

  @override
  String get repoHeroDescription =>
      'Detect a site\'s framework, tune selectors, and install a working manga / anime / novel source — no server, all on-device. RepoForge is in beta, so it won\'t always get a source right — check the result and tweak the selectors if a site doesn\'t come out correct.';

  @override
  String repoCoverageSummary(Object frameworks, Object manga, Object novel) {
    return '$frameworks frameworks · $manga manga + $novel novel sites known';
  }

  @override
  String get repoNewSource => 'New Source';

  @override
  String get repoImport => 'Import';

  @override
  String get repoMySources => 'MY SOURCES';

  @override
  String get repoExportAll => 'Export all';

  @override
  String get repoNoSourcesYet => 'No sources yet';

  @override
  String get repoEmptyStateHint =>
      'Tap \"New Source\" to generate one from a site URL.';

  @override
  String get repoNotInstalled => 'not installed';

  @override
  String get repoOpenInBrowse => 'Open in browse';

  @override
  String get repoEditRedetect => 'Edit / re-detect';

  @override
  String get repoKnownNovelSite => 'Known light-novel site';

  @override
  String get repoNovelGenericDetail =>
      'Recognized as a novel site — generated with the generic novel body (browse may need selector tuning).';

  @override
  String repoNovelFrameworkDetail(Object framework) {
    return 'Generated as a Novel source using the $framework body — browsing + reader work out of the box.';
  }

  @override
  String get repoKnownMangaSite => 'Known manga site';

  @override
  String get repoMangaApiDetail =>
      'Community-verified API source — RepoForge builds it from the site\'s API.';

  @override
  String repoMangaThemeDetail(Object theme) {
    return 'Community-verified theme: $theme — selectors are known.';
  }

  @override
  String get repoMangaCustomDetail =>
      'Community-verified custom selectors are on file for this site.';

  @override
  String get repoNotInKb => 'Not in the knowledge base';

  @override
  String get repoNotInKbDetail =>
      'RepoForge will detect its framework live when you add it, then fall back to heuristic \"what-is-what\" scraping if it\'s bespoke.';

  @override
  String get repoCoverage => 'Coverage';

  @override
  String get repoCheckASite => 'Check a site';

  @override
  String get repoPasteSiteUrlHint => 'paste a site URL';

  @override
  String get repoCheck => 'Check';

  @override
  String get repoSupportedFrameworks => 'Supported frameworks';

  @override
  String get repoMangaSites => 'manga sites';

  @override
  String get repoNovelSites => 'novel sites';

  @override
  String get repoFrameworks => 'frameworks';

  @override
  String get repoRoleItem => 'List item (each card)';

  @override
  String get repoRoleTitle => 'Title';

  @override
  String get repoRoleCover => 'Cover image';

  @override
  String get repoRoleNextPage => 'Next-page link';

  @override
  String get repoRoleDetailTitle => 'Detail — title';

  @override
  String get repoRoleChapters => 'Chapter list item';

  @override
  String get repoRolePageImages => 'Reader page images';

  @override
  String get repoRoleEpisodes => 'Episode list (anime)';

  @override
  String get repoStepFetching => 'Fetching page…';

  @override
  String get repoStepMatching => 'Matching framework signatures…';

  @override
  String get repoStepExtracting => 'Extracting selectors…';

  @override
  String get repoStepFinalizing => 'Finalizing…';

  @override
  String get repoEnterUrlFirst => 'Enter a site URL first.';

  @override
  String repoDetectionFailed(Object error) {
    return 'Detection failed: $error';
  }

  @override
  String get repoFetchFailed => 'Fetch failed';

  @override
  String repoFetchedChars(Object count) {
    return 'Fetched $count chars — now test selectors';
  }

  @override
  String get repoFetchPageFirst => 'Fetch a page first';

  @override
  String repoGenerationFailed(Object error) {
    return 'Generation failed: $error';
  }

  @override
  String get repoDetectSiteFirst => 'Detect a site first';

  @override
  String repoCreatedInstalled(Object name) {
    return 'Created & installed \"$name\"';
  }

  @override
  String repoSaveFailed(Object error) {
    return 'Save failed: $error';
  }

  @override
  String get repoCreateSource => 'Create Source';

  @override
  String get repoSiteUrl => 'Site URL';

  @override
  String get repoDetect => 'Detect';

  @override
  String repoConfidence(Object pct) {
    return 'confidence $pct%';
  }

  @override
  String get repoApiSource => 'API source';

  @override
  String get repoDetails => 'Details';

  @override
  String get repoSourceNameHint => 'Source name';

  @override
  String get repoName => 'Name';

  @override
  String get repoLang => 'Lang';

  @override
  String get repoManga => 'Manga';

  @override
  String get repoAnime => 'Anime';

  @override
  String get repoNovel => 'Novel';

  @override
  String get repoNsfw => 'NSFW';

  @override
  String get repoScrapingStudio => 'Scraping Studio';

  @override
  String get repoScrapingStudioHint =>
      'Fetch a page, then test each selector to see how many elements it matches.';

  @override
  String get repoUrlToTestHint => 'URL to test against';

  @override
  String get repoFetch => 'Fetch';

  @override
  String get repoFetchFailedBlocked =>
      'Fetch failed — the site may block automated access.';

  @override
  String repoLoadedChars(Object count) {
    return 'Loaded $count chars.';
  }

  @override
  String get repoPreviewJs => 'Preview JS';

  @override
  String get repoCreateInstall => 'Create & Install';

  @override
  String get repoPickKnownSelector => 'Pick a known selector';

  @override
  String get repoTest => 'Test';

  @override
  String repoNoCatalogedSelectors(Object label) {
    return 'No cataloged selectors for \"$label\"';
  }

  @override
  String get repoInvalid => 'invalid';

  @override
  String get repoNoMatch => 'no match';

  @override
  String get repoGeneratedSource => 'Generated source';

  @override
  String get repoCopy => 'Copy';

  @override
  String get repoCopiedToClipboard => 'Copied source to clipboard';

  @override
  String repoSelectorFor(Object field) {
    return 'Selector for $field';
  }

  @override
  String get repoSearchSelectors => 'Search selectors…';

  @override
  String repoImportedSource(Object id) {
    return 'Imported source · $id';
  }

  @override
  String get repoCheckingMatches => 'Checking matches';

  @override
  String get repoMigrating => 'Migrating';

  @override
  String get repoMigrateThisSource => 'Migrate this source?';

  @override
  String repoMatchedByUrl(Object count) {
    return '$count matched by URL';
  }

  @override
  String repoMatchedByTitle(Object count) {
    return '$count matched by title';
  }

  @override
  String repoNotFoundLeftInPlace(Object count) {
    return '$count not found — left in place';
  }

  @override
  String get repoMigrateCarryOver =>
      'Read progress, categories and tracking carry over. The originals are removed only for entries that move.';

  @override
  String repoMigrateCount(Object count) {
    return 'Migrate $count';
  }

  @override
  String get repoMigrateASource => 'Migrate a source';

  @override
  String get repoMigrateIntro =>
      'Move every library entry from one source to another. Same-site swaps match exactly by URL; imported entries from a backup can be re-homed to a real source too.';

  @override
  String get repoFrom => 'FROM';

  @override
  String get repoSelectSource => 'Select a source…';

  @override
  String get repoTo => 'TO';

  @override
  String get repoAlsoMatchByTitle => 'Also match by title';

  @override
  String get repoAlsoMatchByTitleHint =>
      'For cross-site moves: if an entry isn\'t found by URL, search the new source by title and take the closest match. Off by default so it can\'t attach the wrong series.';

  @override
  String get repoMigrateSource => 'Migrate source';

  @override
  String get repoMigrationComplete => 'Migration complete';

  @override
  String repoMovedByUrl(Object count) {
    return '$count moved by URL';
  }

  @override
  String repoMovedByTitle(Object count) {
    return '$count moved by title';
  }

  @override
  String repoLeftInPlace(Object count) {
    return '$count left in place';
  }

  @override
  String get repoNotMigratedHeader => 'Not migrated (still on the old source):';

  @override
  String get repoUsePerTitleMigrate => 'Use the per-title Migrate for these.';

  @override
  String get repoDone => 'Done';

  @override
  String get setdDownloadsTitle => 'Downloads';

  @override
  String get setdDownloadsSectionAutomatic => 'Automatic Downloads';

  @override
  String get setdDownloadsNewChapters => 'Download New Chapters';

  @override
  String get setdDownloadsNewChaptersDesc =>
      'Automatically download new chapters';

  @override
  String get setdDownloadsWifiOnly => 'Wi-Fi Only';

  @override
  String get setdDownloadsWifiOnlyDesc => 'Only download on Wi-Fi';

  @override
  String get setdDownloadsChargingOnly => 'Charging Only';

  @override
  String get setdDownloadsChargingOnlyDesc => 'Only download while plugged in';

  @override
  String get setdDownloadsAhead => 'Download Ahead While Reading';

  @override
  String get setdDownloadsAheadDesc => 'Pre-download next chapter as you read';

  @override
  String get setdDownloadsSectionQueue => 'Download Queue';

  @override
  String get setdDownloadsSimultaneous => 'Simultaneous Downloads';

  @override
  String get setdDownloadsQuality => 'Download Quality';

  @override
  String get setdDownloadsSectionDelete => 'Delete Downloaded Chapters';

  @override
  String get setdDownloadsAfterReading => 'After Reading';

  @override
  String get setdDownloadsAfterReadingDesc =>
      'Delete chapters after they are read';

  @override
  String get setdDownloadsIncludeBookmarked => 'Include Bookmarked Chapters';

  @override
  String get setdDownloadsIncludeBookmarkedDesc =>
      'Delete bookmarked chapters along with the rest';

  @override
  String get setdDownloadsAutoDelete => 'Auto-Delete Read Chapters';

  @override
  String get setdDownloadsSectionFormat => 'Format';

  @override
  String get setdDownloadsSaveCbz => 'Save as CBZ';

  @override
  String get setdDownloadsSaveCbzDesc =>
      'Archive chapters as CBZ files with metadata';

  @override
  String get setdDownloadsSavePdf => 'Save as PDF';

  @override
  String get setdDownloadsSavePdfDesc =>
      'Package chapters as a single PDF (one image per page)';

  @override
  String get setdDownloadsSectionLocation => 'Download Location';

  @override
  String get setdDownloadsDefaultLocation => 'Default Location';

  @override
  String get setdDownloadsCustomLocation => 'Custom Location';

  @override
  String get setdDownloadsChooseFolder => 'Choose Folder';

  @override
  String get setdDownloadsIosFolderWarning =>
      'iOS does not allow apps to keep access to a folder. Downloads stay in the app\'s folder, reachable via Files › On My iPhone › Foxlations.';

  @override
  String get setdDownloadsReset => 'Reset';

  @override
  String get setdDownloadsSectionStorage => 'Storage';

  @override
  String setdDownloadsTotalSize(Object size) {
    return 'Total: $size MB';
  }

  @override
  String setdDownloadsLibraryVaultSize(Object lib, Object vault) {
    return 'Library: $lib MB  |  Vault: $vault MB';
  }

  @override
  String get setdVaultTitle => 'Vault';

  @override
  String get setdVaultSectionAccess => 'Access';

  @override
  String get setdVaultEnable => 'Enable Vault';

  @override
  String get setdVaultEnableDesc =>
      'Allow access to the hidden vault by tapping Library 8 times';

  @override
  String get setdVaultSectionSecurity => 'Security';

  @override
  String get setdVaultChangePassword => 'Change Password';

  @override
  String get setdVaultSetPassword => 'Set Password';

  @override
  String get setdVaultPasswordSetDesc =>
      'Password is set — tap to change or remove';

  @override
  String get setdVaultPasswordUnsetDesc =>
      'Protect vault access with a password';

  @override
  String get setdVaultSectionCategories => 'Vault Categories';

  @override
  String get setdVaultEditCategories => 'Edit Vault Categories';

  @override
  String get setdVaultEditCategoriesDesc =>
      'Add, remove, and reorder vault categories';

  @override
  String get setdVaultSectionContents => 'Contents';

  @override
  String get setdVaultManageContents => 'Manage Vault Contents';

  @override
  String get setdVaultManageContentsDesc =>
      'Move manga, anime or novels in and out of the vault';

  @override
  String get setdVaultUnlockFirstSnack =>
      'Unlock the vault first (tap in from the library)';

  @override
  String get setdVaultSectionHiddenSources => 'Hidden Sources';

  @override
  String get setdVaultOnlySources => 'Vault-Only Sources';

  @override
  String setdVaultHiddenSourcesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources hidden',
      one: '1 source hidden',
    );
    return '$_temp0';
  }

  @override
  String get setdVaultSectionInfo => 'Info';

  @override
  String get setdVaultInfoText =>
      'The vault is a hidden library with its own categories and manga. Tap the Library tab 8 times rapidly to toggle vault mode. Vault manga are stored separately and never appear in your main library.';

  @override
  String get setdVaultCurrentPasswordHint => 'Current password';

  @override
  String get setdVaultNewPasswordHint => 'New password (leave empty to remove)';

  @override
  String get setdVaultConfirmPasswordHint => 'Confirm new password';

  @override
  String get setdVaultCurrentPasswordWrong => 'Current password is wrong';

  @override
  String get setdVaultPasswordsMismatch => 'Passwords do not match';

  @override
  String get setdVaultRemovingEncryption => 'Removing encryption…';

  @override
  String get setdVaultEncrypting => 'Encrypting vault…';

  @override
  String get setdVaultPasswordRemoved =>
      'Password removed — vault is no longer encrypted';

  @override
  String get setdVaultPasswordSet => 'Password set — vault encrypted';

  @override
  String get setdVaultNoCategories => 'No vault categories';

  @override
  String setdVaultDeleteCategoryConfirm(Object name) {
    return 'Are you sure you want to delete \"$name\"? Manga in this category will not be removed from the vault.';
  }

  @override
  String get setdVaultNoInstalledSources => 'No installed sources';

  @override
  String get setdVaultHiddenSourcesToggleHint =>
      'Toggle sources to make them only visible in vault mode.';

  @override
  String get setdVaultSearchSourcesHint => 'Search sources...';

  @override
  String get setdCategoryNameHint => 'Category name';

  @override
  String get setdNewCategory => 'New Category';

  @override
  String get setdRenameCategory => 'Rename Category';

  @override
  String get setdDeleteCategory => 'Delete Category';

  @override
  String get setdActionCancel => 'Cancel';

  @override
  String get setdActionSave => 'Save';

  @override
  String get setdActionAdd => 'Add';

  @override
  String get setdActionDelete => 'Delete';

  @override
  String get setdTapToAddCategory => 'Tap + to add a category';

  @override
  String get setdVaultContentsTitle => 'Vault Contents';

  @override
  String get setdVaultContentsLockedMessage =>
      'Unlock the vault first to manage its contents.';

  @override
  String get setdVaultContentsTabManga => 'Manga';

  @override
  String get setdVaultContentsTabAnime => 'Anime';

  @override
  String get setdVaultContentsTabNovels => 'Novels';

  @override
  String get setdVaultContentsInLibrary => 'In your library';

  @override
  String get setdVaultContentsMoveIntoHint => '→ move into vault';

  @override
  String get setdVaultContentsInVault => 'In the vault';

  @override
  String get setdVaultContentsMoveOutHint => '← move back out';

  @override
  String setdVaultContentsEmptyLibrary(Object type) {
    return 'No $type in your library';
  }

  @override
  String setdVaultContentsEmptyVault(Object type) {
    return 'No $type in the vault';
  }

  @override
  String setdVaultContentsMovedIn(Object title) {
    return '\"$title\" moved to vault';
  }

  @override
  String setdVaultContentsMovedOut(Object title) {
    return '\"$title\" moved out of vault';
  }

  @override
  String setdVaultContentsReadProgress(Object read, Object total) {
    return '$read/$total read';
  }

  @override
  String get setdLibraryTitle => 'Library';

  @override
  String get setdLibrarySectionCategories => 'Categories';

  @override
  String get setdLibraryEditCategories => 'Edit Categories';

  @override
  String get setdLibraryEditCategoriesDesc =>
      'Add, remove, and reorder categories';

  @override
  String get setdLibraryHideEmpty => 'Hide Empty Categories';

  @override
  String get setdLibraryHideEmptyDesc => 'Only show categories with manga';

  @override
  String get setdLibrarySectionGlobalUpdate => 'Global Update';

  @override
  String get setdLibraryUpdateFrequency => 'Update Frequency';

  @override
  String get setdLibraryWifiOnly => 'Wi-Fi Only';

  @override
  String get setdLibraryWifiOnlyDesc => 'Only update on Wi-Fi connections';

  @override
  String get setdLibraryChargingOnly => 'Only While Charging';

  @override
  String get setdLibraryChargingOnlyDesc =>
      'Only update when device is charging';

  @override
  String get setdLibrarySectionRestrictions => 'Update Restrictions';

  @override
  String get setdLibrarySkipNotStarted => 'Skip Not Started';

  @override
  String get setdLibrarySkipNotStartedDesc =>
      'Skip manga with no reading progress';

  @override
  String get setdLibraryShowUpdateCount => 'Show New Chapter Count';

  @override
  String get setdLibraryShowUpdateCountDesc =>
      'Show badge on library manga cards';

  @override
  String get setdLibrarySectionData => 'Data';

  @override
  String get setdLibraryMigrateSource => 'Migrate a Source';

  @override
  String get setdLibraryMigrateSourceDesc =>
      'Move every entry from one source to another';

  @override
  String get setdLibraryNoCategories => 'No categories';

  @override
  String setdLibraryDeleteCategoryConfirm(Object name) {
    return 'Are you sure you want to delete \"$name\"? Manga in this category will not be removed from your library.';
  }

  @override
  String get setdPlayerTitle => 'Player';

  @override
  String get setdPlayerSectionSeek => 'DOUBLE-TAP TO SEEK';

  @override
  String get setdPlayerSkipForward => 'Skip forward';

  @override
  String get setdPlayerSkipBackward => 'Skip backward';

  @override
  String get setdPlayerSectionGestures => 'GESTURES';

  @override
  String get setdPlayerHoldToSpeed => 'Hold to speed up';

  @override
  String setdPlayerHoldToSpeedDesc(Object speed) {
    return 'Press and hold anywhere to play at ${speed}x';
  }

  @override
  String get setdPlayerHoldSpeed => 'Hold speed';

  @override
  String get setdPlayerVolumeSwipe => 'Volume swipe';

  @override
  String get setdPlayerVolumeSwipeDesc =>
      'Slide up/down on the right half to adjust volume';

  @override
  String get setdPlayerBrightnessSwipe => 'Brightness swipe';

  @override
  String get setdPlayerBrightnessSwipeDesc =>
      'Slide up/down on the left half to adjust brightness';

  @override
  String get setdPlayerSectionPlayback => 'PLAYBACK';

  @override
  String get setdPlayerDefaultSpeed => 'Default speed';

  @override
  String get setdPlayerAutoplayNext => 'Autoplay next episode';

  @override
  String get setdPlayerAutoplayNextDesc =>
      'Start the next episode automatically when one ends';

  @override
  String get setdPlayerAutoSkipIntro => 'Auto-skip intro/outro';

  @override
  String get setdPlayerAutoSkipIntroDesc =>
      'Skip source-marked openings/endings without tapping';

  @override
  String get setdPlayerSkipAmountTitle => 'Skip amount';

  @override
  String get setdPlayerSpeedTitle => 'Speed';

  @override
  String get setdAppearanceTitle => 'Appearance';

  @override
  String get setdAppearanceSectionTheme => 'Theme';

  @override
  String get setdAppearanceSectionDisplay => 'Display';

  @override
  String get setdAppearanceInvertColors => 'Invert Colors';

  @override
  String get setdAppearanceInvertColorsDesc => 'Inverts the entire app UI';

  @override
  String get setdAppearanceDarkMode => 'Dark Mode';

  @override
  String get setdAppearanceLightMode => 'Light Mode';

  @override
  String get setdAppearanceCurrentlyDark => 'Currently dark';

  @override
  String get setdAppearanceCurrentlyLight => 'Currently light';

  @override
  String get detailStatusOngoing => 'Ongoing';

  @override
  String get detailStatusCompleted => 'Completed';

  @override
  String get detailStatusHiatus => 'Hiatus';

  @override
  String get detailStatusCanceled => 'Canceled';

  @override
  String get detailStatusFinished => 'Finished';

  @override
  String get detailStatusUnknown => 'Unknown';

  @override
  String detailChapterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Chapters',
      one: '1 Chapter',
    );
    return '$_temp0';
  }

  @override
  String detailEpisodeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Episodes',
      one: '1 Episode',
    );
    return '$_temp0';
  }

  @override
  String detailDownloadingChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Downloading $count chapters',
      one: 'Downloading 1 chapter',
    );
    return '$_temp0';
  }

  @override
  String get discoverTitle => 'Discover';

  @override
  String get discoverSort => 'Sort';

  @override
  String get discoverSortTrending => 'Trending';

  @override
  String get discoverSortPopular => 'Popular';

  @override
  String get discoverKindManga => 'Manga';

  @override
  String get discoverKindAnime => 'Anime';

  @override
  String get discoverKindNovel => 'Novels';

  @override
  String get discoverClearGenres => 'Clear';

  @override
  String get discoverEmpty => 'Nothing to recommend right now';

  @override
  String get discoverEmptyHint =>
      'Try another type, clear genre filters, or check your connection.';

  @override
  String get discoverRetry => 'Try again';

  @override
  String get discoverAddedToLibrary => 'Added to library';

  @override
  String get discoverRead => 'Read';

  @override
  String get discoverAdded => 'Added';

  @override
  String get discoverFindingSource => 'Finding a source…';

  @override
  String get discoverAddToLibrary => 'Add to Library';

  @override
  String get discoverNoSourceMatch => 'Not in your sources';

  @override
  String get discoverSaved => 'Saved';

  @override
  String get discoverSaveForLater => 'Save for later';

  @override
  String get discoverNext => 'Next';

  @override
  String get discoverWishlistTitle => 'Saved for later';

  @override
  String get discoverWishlistEmpty => 'Nothing saved yet';

  @override
  String get discoverWishlistEmptyHint =>
      'Save recommendations here to read once you have a source for them.';

  @override
  String get discoverNoSourceYet => 'No source found yet';

  @override
  String get discoverFindSource => 'Find source';

  @override
  String get discoverSource => 'Recommendation source';

  @override
  String discoverBecauseYouRead(String title) {
    return 'Because you read $title';
  }
}
