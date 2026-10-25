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
  String libraryEpisodeProgress(Object read, Object total) {
    return 'Ep. $read/$total';
  }

  @override
  String libraryChaptersAbbrev(Object n) {
    return '$n ch';
  }

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
  String get libraryContinueWatching => 'Continue Watching';

  @override
  String get readerListen => 'Listen';

  @override
  String get readerTtsStop => 'Stop';

  @override
  String get readerTtsSpeed => 'Speed';

  @override
  String get readerTtsVoice => 'Voice';

  @override
  String get readerTtsNoVoices => 'No voices available on this device';

  @override
  String get readerTtsSystemVoice => 'System default';

  @override
  String libraryDaysCount(Object days) {
    return '$days days';
  }

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
  String get libraryMore => 'More';

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
  String get libraryShowNumberOfItems => 'Show number of items';

  @override
  String get librarySizeMedium => 'Medium';

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
  String libraryStreakDaysStrong(Object days) {
    return '$days days strong — keep it up!';
  }

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
  String get libraryTypeMenuBarrier => 'Library type';

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
  String get detailDownloadNextEpisode => 'Next episode';

  @override
  String get detailDownloadNext5Episodes => 'Next 5 episodes';

  @override
  String get detailDownloadNext10Episodes => 'Next 10 episodes';

  @override
  String get detailDownloadAllEpisodes => 'All episodes';

  @override
  String get detailSelectEpisodes => 'Select episodes';

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
  String get webviewOpenFailed => 'Couldn\'t open the browser';

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
  String get appBiometrics => 'Biometrics';

  @override
  String appVaultTapsToEnter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more taps to enter vault',
      one: '1 more tap to enter vault',
    );
    return '$_temp0';
  }

  @override
  String appVaultTapsToExit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more taps to exit vault',
      one: '1 more tap to exit vault',
    );
    return '$_temp0';
  }

  @override
  String detailRemoveFromLibraryBody(String title) {
    return 'Remove \"$title\" from your library?';
  }

  @override
  String get detailThisTitle => 'this title';

  @override
  String get detailTitleCopied => 'Title copied';

  @override
  String get detailSortBy => 'Sort by';

  @override
  String get detailSortSourceOrder => 'Source order';

  @override
  String get detailSortChapterNumber => 'Chapter number';

  @override
  String get detailSortUploadDate => 'Upload date';

  @override
  String get detailLoginPageTitle => 'Login';

  @override
  String get detailRemovedFromLibrary => 'Removed from library';

  @override
  String get detailUndo => 'Undo';

  @override
  String detailQueuePosition(int position, int total) {
    return '$position of $total';
  }

  @override
  String get insightsTitle => 'Reading Insights';

  @override
  String get insightsEmptyTitle => 'Nothing to rank yet';

  @override
  String get insightsEmptyBody =>
      'Read a little and your most-read titles show up here.';

  @override
  String get insightsEstimatedFromHistory => 'Estimated from your history';

  @override
  String insightsTrackedSince(String month, String year) {
    return 'Tracked since $month $year';
  }

  @override
  String get insightsMonthJanuary => 'January';

  @override
  String get insightsMonthFebruary => 'February';

  @override
  String get insightsMonthMarch => 'March';

  @override
  String get insightsMonthApril => 'April';

  @override
  String get insightsMonthMay => 'May';

  @override
  String get insightsMonthJune => 'June';

  @override
  String get insightsMonthJuly => 'July';

  @override
  String get insightsMonthAugust => 'August';

  @override
  String get insightsMonthSeptember => 'September';

  @override
  String get insightsMonthOctober => 'October';

  @override
  String get insightsMonthNovember => 'November';

  @override
  String get insightsMonthDecember => 'December';

  @override
  String get repoNoTitlesToMigrate => 'No titles in this library to migrate.';

  @override
  String get repoChooseSourceFirst => 'Choose a source to migrate from first.';

  @override
  String get trackProviderClaudeDesc => 'Best for nuanced translation';

  @override
  String get trackProviderOpenaiDesc => 'Fast & accurate';

  @override
  String get trackProviderGeminiDesc => 'Multilingual specialist';

  @override
  String get trackProviderDeeplDesc => 'High-quality European languages';

  @override
  String get trackProviderHuggingfaceDesc => 'Open-source - Offline capable';

  @override
  String get trackProviderOpenrouterDesc =>
      'One key, many models - free tier available';

  @override
  String get trackBadgeRecommended => 'Recommended';

  @override
  String get trackBadgeOffline => 'Offline';

  @override
  String get trackBadgeFree => 'Free models';

  @override
  String get setdAppearanceSectionPalette => 'Palette';

  @override
  String get setdAppearanceThemeStrength => 'Theme color strength';

  @override
  String get setdAppearanceThemeStrengthDesc =>
      'How much the theme color takes over the app. 0 keeps the usual dark or light background; higher tints the whole app with the theme color.';

  @override
  String get setxBackupCreateComplete => 'Backup complete';

  @override
  String setxBackupCreateFailed(String error) {
    return 'Backup failed: $error';
  }

  @override
  String get setxBackupExportComplete => 'Export complete';

  @override
  String setxBackupExportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get setxBackupTargetApp => 'Target app';

  @override
  String get setxBackupIncludeLabel => 'Include';

  @override
  String get setxBackupTypeNovels => 'Light novels';

  @override
  String get setxBackupAutoTag => 'auto';

  @override
  String get setdDownloadsChaptersAhead => 'Chapters ahead';

  @override
  String get setdLibraryNoItemsToRefresh => 'No library items to refresh';

  @override
  String get setdLibraryRefreshingCovers => 'Refreshing covers';

  @override
  String get setdLibraryCoverRefreshStopped => 'Cover refresh stopped';

  @override
  String setdLibraryCoversRefreshed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Refreshed $count covers',
      one: 'Refreshed 1 cover',
    );
    return '$_temp0';
  }

  @override
  String get setdLibrarySectionContinueReading => 'Continue reading';

  @override
  String get setdLibraryContinueShowAs => 'Show as';

  @override
  String get setdLibraryDefaultCategory => 'Default category';

  @override
  String get setdLibraryAlwaysAsk => 'Always ask';

  @override
  String get setdLibrarySkipHasUnread => 'Skip titles with unread chapters';

  @override
  String get setdLibrarySkipHasUnreadDesc =>
      'Don\'t check titles you haven\'t caught up on yet';

  @override
  String get setdLibrarySkipCompleted => 'Skip completed series';

  @override
  String get setdLibrarySkipCompletedDesc =>
      'Finished series won\'t get new chapters';

  @override
  String get setdLibraryRefreshCovers => 'Refresh library covers';

  @override
  String get setdLibraryRefreshCoversDesc => 'Fetch covers again from source';

  @override
  String get setdActionMove => 'Move';

  @override
  String get setdActionConfirm => 'Confirm';

  @override
  String get setdActionRemove => 'Remove';

  @override
  String get setdActionUndo => 'Undo';

  @override
  String get setxSecurityLockAfterTitle => 'Lock after';

  @override
  String get setxSecurityLockAfterSubtitle =>
      'Wait this long before re-locking on reopen';

  @override
  String get setxSecurityLockAfterImmediately => 'Immediately';

  @override
  String setxSecurityLockAfterMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String get setdVaultChangeDecoyPassword => 'Change decoy password';

  @override
  String get setdVaultSetDecoyPassword => 'Set decoy password';

  @override
  String get setdVaultDecoyPasswordDesc =>
      'A second password that opens a separate, empty-looking vault';

  @override
  String get setdVaultBiometricUnlock => 'Unlock with biometrics';

  @override
  String get setdVaultBiometricDesc =>
      'Use Face ID / fingerprint to open the vault';

  @override
  String get setdVaultConfirmPasswordTitle => 'Confirm vault password';

  @override
  String get setdVaultBiometricEnabled => 'Biometric unlock enabled';

  @override
  String get setdVaultShakeToExit => 'Shake to exit';

  @override
  String get setdVaultShakeToExitDesc =>
      'While in the vault, shake the phone to instantly leave it';

  @override
  String get setdVaultLibraryMoveAction => 'Move-to-vault in library';

  @override
  String get setdVaultLibraryMoveActionDesc =>
      'Add a \"Move to vault\" action when selecting titles in your library';

  @override
  String get setdVaultPasswordHint => 'Password';

  @override
  String get setdVaultDecoyPasswordDialogTitle => 'Decoy password';

  @override
  String get setdVaultDecoyPasswordExplain =>
      'Entering this instead of your real password opens a separate, isolated vault - so you can hand over the phone without revealing your real content.';

  @override
  String get setdVaultDecoyPasswordHint => 'Decoy password';

  @override
  String get setdVaultEnterPassword => 'Enter a password';

  @override
  String get setdVaultDecoyPasswordSet => 'Decoy password set';

  @override
  String get setdVaultDecoyMustDiffer => 'Must differ from your real password';

  @override
  String setdVaultContentsMovedInCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Moved $count to vault',
      one: 'Moved 1 to vault',
    );
    return '$_temp0';
  }

  @override
  String setdVaultContentsMovedOutCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Moved $count out of vault',
      one: 'Moved 1 out of vault',
    );
    return '$_temp0';
  }

  @override
  String setdVaultContentsMoveConfirmTitle(String what) {
    return 'Move $what?';
  }

  @override
  String setdVaultContentsMoveConfirmBody(int count, String dest, String into) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Move $count titles to $dest$into?',
      one: 'Move 1 title to $dest$into?',
    );
    return '$_temp0';
  }

  @override
  String get setdVaultContentsDestVault => 'the vault';

  @override
  String get setdVaultContentsDestLibrary => 'your library';

  @override
  String setdVaultContentsIntoCategory(String name) {
    return ' → \"$name\"';
  }

  @override
  String setdVaultContentsMoveAllShown(int count) {
    return 'all $count shown';
  }

  @override
  String setdVaultContentsMoveEverythingIn(String name) {
    return 'everything in \"$name\"';
  }

  @override
  String get setdVaultContentsNoMatches => 'No matches';

  @override
  String get setdVaultContentsDone => 'Done';

  @override
  String get setdVaultContentsSelect => 'Select';

  @override
  String get setdVaultContentsDirToVault => 'To Vault';

  @override
  String get setdVaultContentsDirFromVault => 'From Vault';

  @override
  String get setdVaultContentsSearchHint => 'Search titles';

  @override
  String get setdVaultContentsMoveCategoryTooltip => 'Move a category';

  @override
  String get setdVaultContentsMoveAllToVault => 'Move all to vault';

  @override
  String get setdVaultContentsMoveAllOut => 'Move all out';

  @override
  String get setdVaultContentsSelectNone => 'None';

  @override
  String get setdVaultContentsSelectAll => 'All';

  @override
  String setdVaultContentsSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected',
      one: '1 selected',
    );
    return '$_temp0';
  }

  @override
  String get setdVaultContentsMoveToVault => 'Move to vault';

  @override
  String get setdVaultContentsMoveOut => 'Move out';

  @override
  String get setdVaultContentsPickSourceLibrary =>
      'Move which library category?';

  @override
  String get setdVaultContentsPickSourceVault => 'Move which vault category?';

  @override
  String get setdVaultContentsPickDestVault => 'Into which vault category?';

  @override
  String get setdVaultContentsPickDestLibrary => 'Into which library category?';

  @override
  String get setdVaultContentsNoCategoriesToPick =>
      'No categories to pick from.';

  @override
  String get setdVaultContentsNoCategory => 'No category';

  @override
  String setdVaultContentsNothingIn(String name) {
    return 'Nothing in \"$name\"';
  }

  @override
  String get settingsHelpSubtitle => 'Tutorial, Discord & quick tips';

  @override
  String get dictNetworkError =>
      'Couldn\'t reach the dictionary. Check your connection and try again.';

  @override
  String dictNoDefinition(String word) {
    return 'No definition found for \"$word\".';
  }

  @override
  String get readerAlignment => 'Alignment';

  @override
  String get readerBrightness => 'Brightness';

  @override
  String readerCalibrateSampleLine(int n) {
    return 'Sample line $n';
  }

  @override
  String get readerChapterArrowsSubtitle =>
      'Prev / next chapter beside the page slider';

  @override
  String get readerChapterArrowsTitle => 'Chapter arrows on the slider';

  @override
  String get readerCustomizeMenu => 'Customize menu';

  @override
  String get readerCustomizeMenuMangaSubtitle =>
      'Choose and reorder the manga actions';

  @override
  String get readerCustomizeMenuNovelSubtitle =>
      'Choose and reorder the light novel actions';

  @override
  String get readerDoublePages => 'Double pages';

  @override
  String get readerDoublePagesSubtitle =>
      'Show two pages side-by-side when the phone is in landscape (page-by-page modes only)';

  @override
  String get readerHandsFreeIntro =>
      'Scroll or turn pages without touching the screen. These share one scroll input, so turning one on turns the others off.';

  @override
  String get readerHandsFreeMotion => 'Hands-free & motion';

  @override
  String get readerHandsFreeMotionSubtitle =>
      'Volume buttons, tilt and gaze scrolling';

  @override
  String get readerHyphenation => 'Hyphenation';

  @override
  String get readerHyphenationSubtitle =>
      'Break long words to even out justified lines';

  @override
  String get readerLightNovel => 'Light novel';

  @override
  String get readerLightNovelMenu => 'Light novel menu';

  @override
  String get readerLineSpacing => 'Line spacing';

  @override
  String get readerManga => 'Manga';

  @override
  String get readerMangaMenu => 'Manga menu';

  @override
  String get readerMargins => 'Margins';

  @override
  String get readerMenuStyle => 'Menu style';

  @override
  String get readerMenuStyleTail => 'Tail';

  @override
  String get readerMenuStyleWheel => 'Wheel';

  @override
  String get readerModeLtrShort => 'LTR';

  @override
  String get readerModeRtlShort => 'RTL';

  @override
  String get readerModeVerticalShort => 'Vertical';

  @override
  String get readerNovelLayoutPaged => 'Paged';

  @override
  String get readerNovelLayoutScroll => 'Scroll';

  @override
  String get readerNovelRadialMenuSubtitle =>
      'Use the wheel in the novel reader (off = classic bars)';

  @override
  String get readerPitch => 'Pitch';

  @override
  String readerRadialReorderHint(int count) {
    return 'Drag to reorder the wheel; toggle to show or hide. $count shown.';
  }

  @override
  String get readerReaderTheme => 'Reader theme';

  @override
  String get readerReset => 'Reset';

  @override
  String get readerSectionEyeComfort => 'Eye comfort';

  @override
  String get readerSectionImage => 'Image';

  @override
  String get readerSectionLayout => 'Layout';

  @override
  String get readerSectionListen => 'Listen (text to speech)';

  @override
  String get readerSectionText => 'Text';

  @override
  String get readerSentenceHighlight => 'Sentence highlight';

  @override
  String get readerSettingsFor => 'Settings for';

  @override
  String get readerSideLeft => 'Left';

  @override
  String get readerSideRight => 'Right';

  @override
  String get readerSplitWidePages => 'Split wide pages';

  @override
  String get readerSplitWidePagesSubtitle =>
      'Give a wide double-page spread its own screen instead of pairing it with another page';

  @override
  String get readerTextSize => 'Text size';

  @override
  String get readerVolumeAutoScroll => 'Volume sets auto-scroll speed';

  @override
  String get readerVolumeAutoScrollSubtitle =>
      'While the manga reader auto-scrolls, the volume buttons speed it up or slow it down. They do not turn pages.';

  @override
  String get readerVolumeButtons => 'Volume buttons';

  @override
  String get readerWarmFilter => 'Warm filter';

  @override
  String get readerWordHighlight => 'Word highlight';

  @override
  String get libraryUpdateTitle => 'Library update';

  @override
  String libraryUpdateCounts(int completed, int skipped, int failed) {
    return '$completed completed · $skipped skipped · $failed failed';
  }

  @override
  String libraryNewChaptersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new chapters',
      one: '1 new chapter',
    );
    return '$_temp0';
  }

  @override
  String get libraryUpToDate => 'Up to date';

  @override
  String get librarySkipped => 'Skipped';

  @override
  String libraryUpdateCount(int count) {
    return 'Update $count';
  }

  @override
  String libraryStatusTapUpdate(String status) {
    return '$status · tap Update to force';
  }

  @override
  String libraryStatusNoNewChapters(String status) {
    return '$status · no new chapters expected';
  }

  @override
  String get libraryUpdateThisTitle => 'Update this title';

  @override
  String get libraryFailed => 'Failed';

  @override
  String get libraryRetryAll => 'Retry all';

  @override
  String get libraryUpdateFailedTapOpen => 'Update failed · tap to open';

  @override
  String get libraryRetryThisTitle => 'Retry this title';

  @override
  String get libraryNoTitlesChecked => 'No titles were checked.';

  @override
  String libraryCategoryWithCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String libraryEntriesWithNewChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries have new chapters.',
      one: '1 entry has new chapters.',
    );
    return '$_temp0';
  }

  @override
  String get libraryUnlockVaultFirst =>
      'Unlock the vault first to move titles into it';

  @override
  String get libraryCouldNotMoveToVault => 'Could not move to vault';

  @override
  String get libraryCouldNotMoveOutOfVault => 'Could not move out of vault';

  @override
  String libraryMovedToVault(int count) {
    return 'Moved $count to vault';
  }

  @override
  String libraryMovedOutOfVault(int count) {
    return 'Moved $count out of vault';
  }

  @override
  String get libraryMoveOut => 'Move out';

  @override
  String get libraryToVault => 'To vault';

  @override
  String get libraryUpdateComplete => 'Update complete';

  @override
  String libraryUpdatingProgress(String title, int checked, int total) {
    return 'Updating $title  $checked/$total';
  }

  @override
  String get libraryUpdating => 'Updating…';

  @override
  String get libraryTapRetryUpdateSkipped => 'Tap to retry / update skipped';

  @override
  String get librarySortBy => 'Sort by';

  @override
  String get libraryCoverTitle => 'Cover title';

  @override
  String get libraryBadgePlacement => 'Badge placement';

  @override
  String get libraryReadingProgress => 'Reading progress';

  @override
  String get libraryLanguage => 'Language';

  @override
  String get libraryLocal => 'Local';

  @override
  String get libraryFilterShowOnly => 'show only';

  @override
  String get libraryFilterHide => 'hide';

  @override
  String get libraryArchetypeNewcomer => 'The Newcomer';

  @override
  String get libraryArchetypeNewcomerDesc =>
      'Just getting started - your type sharpens as you read.';

  @override
  String get libraryArchetypeOmnivore => 'The Omnivore';

  @override
  String get libraryArchetypeOmnivoreDesc =>
      'A bit of everything - manga, anime and novels all in rotation.';

  @override
  String get libraryArchetypeBinger => 'The Binger';

  @override
  String get libraryArchetypeBingerDesc =>
      'You tear through chapters in long sittings.';

  @override
  String get libraryArchetypeCompletionist => 'The Completionist';

  @override
  String get libraryArchetypeCompletionistDesc =>
      'You go deep - few series at a time, read to the end.';

  @override
  String get libraryArchetypeDevoted => 'The Devoted';

  @override
  String get libraryArchetypeDevotedDesc =>
      'Day after day - you keep a steady habit.';

  @override
  String get libraryArchetypeExplorer => 'The Explorer';

  @override
  String get libraryArchetypeExplorerDesc =>
      'Always something new - you spread across many series.';

  @override
  String libraryChaptersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapters',
      one: '1 chapter',
    );
    return '$_temp0';
  }

  @override
  String libraryBestStreakDays(int days) {
    return '$days-day best streak';
  }

  @override
  String librarySeriesCount(int count) {
    return '$count series';
  }

  @override
  String get libraryReadingActivity => 'Reading activity';

  @override
  String get libraryChaptersPerDayHint =>
      'Chapters read each day - brighter = more.';

  @override
  String get libraryByType => 'Library by type';

  @override
  String get libraryByStatus => 'Library by status';

  @override
  String get libraryBacklog => 'Backlog';

  @override
  String libraryWaitingCount(int count) {
    return '$count waiting';
  }

  @override
  String get libraryAddedNeverStarted => 'Added but never started';

  @override
  String get libraryNothingWaiting =>
      'Nothing waiting - you\'ve started everything.';

  @override
  String get libraryMilestones => 'Milestones';

  @override
  String get libraryReadingPersonality => 'Reading personality';

  @override
  String get libraryTotalTimeRead => 'Total time read · tap for breakdown';

  @override
  String get libraryStatTitles => 'Titles';

  @override
  String get libraryStatChaptersRead => 'Chapters read';

  @override
  String get libraryStatDayStreak => 'Day streak';

  @override
  String libraryActivitySummary(int activeDays, int chapters) {
    return 'You read on $activeDays of the last 35 days · $chapters chapters this week.';
  }

  @override
  String libraryTrendVsLastWeek(int pct) {
    return '$pct% vs last week';
  }

  @override
  String get libraryStatusOther => 'Other';

  @override
  String libraryMostReadGenre(String genre) {
    return 'Most-read genre · $genre';
  }

  @override
  String get libraryContentWordManga => 'manga';

  @override
  String get libraryContentWordAnime => 'anime';

  @override
  String get libraryContentWordLightNovels => 'light novels';

  @override
  String libraryBacklogAddedAge(String age, String type) {
    return 'Added $age · $type';
  }

  @override
  String get libraryStart => 'Start';

  @override
  String get libraryAllMilestonesUnlocked => 'All milestones unlocked 🎉';

  @override
  String get libraryNextUp => 'NEXT UP';

  @override
  String get libraryYourReadingType => 'YOUR READING TYPE';

  @override
  String get libraryAxisVolume => 'Volume';

  @override
  String get libraryAxisDepth => 'Depth';

  @override
  String get libraryAxisConsistency => 'Consist.';

  @override
  String get libraryAxisBreadth => 'Breadth';

  @override
  String get libraryAxisVariety => 'Variety';

  @override
  String get libraryUnitChapters => 'ch';

  @override
  String get libraryUnitHours => 'h';

  @override
  String get libraryUnitDays => 'days';

  @override
  String get libraryUnitTitles => 'titles';

  @override
  String get libraryUnitSources => 'sources';

  @override
  String get libraryUnitFormats => 'formats';

  @override
  String get libraryUnitEpisodes => 'ep';

  @override
  String get libraryBadgeFirstSteps => 'First Steps';

  @override
  String get libraryBadgeFirstStepsDesc => 'Read your first chapter.';

  @override
  String get libraryBadgeGettingStarted => 'Getting Started';

  @override
  String get libraryBadgeGettingStartedDesc => 'Read 10 chapters.';

  @override
  String get libraryBadgeBookworm => 'Bookworm';

  @override
  String get libraryBadgeBookwormDesc => 'Read 50 chapters.';

  @override
  String get libraryBadgeCenturion => 'Centurion';

  @override
  String get libraryBadgeCenturionDesc => 'Read 100 chapters.';

  @override
  String get libraryBadgeDevourer => 'Devourer';

  @override
  String get libraryBadgeDevourerDesc => 'Read 250 chapters.';

  @override
  String get libraryBadgeQuincentenary => 'Quincentenary';

  @override
  String get libraryBadgeQuincentenaryDesc => 'Read 500 chapters.';

  @override
  String get libraryBadgeMarathoner => 'Marathoner';

  @override
  String get libraryBadgeMarathonerDesc => 'Read 1,000 chapters.';

  @override
  String get libraryBadgeChapterFiend => 'Chapter Fiend';

  @override
  String get libraryBadgeChapterFiendDesc => 'Read 2,500 chapters.';

  @override
  String get libraryBadgeLoremaster => 'Loremaster';

  @override
  String get libraryBadgeLoremasterDesc => 'Read 5,000 chapters.';

  @override
  String get libraryBadgeTenThousandClub => 'Ten-Thousand Club';

  @override
  String get libraryBadgeTenThousandClubDesc => 'Read 10,000 chapters.';

  @override
  String get libraryBadgeFirstHour => 'First Hour';

  @override
  String get libraryBadgeFirstHourDesc => 'Spend 1 hour reading.';

  @override
  String get libraryBadgeGettingComfortable => 'Getting Comfortable';

  @override
  String get libraryBadgeGettingComfortableDesc => 'Spend 10 hours reading.';

  @override
  String get libraryBadgeWeekendLost => 'Weekend Lost';

  @override
  String get libraryBadgeWeekendLostDesc => 'Spend 50 hours reading.';

  @override
  String get libraryBadgeDedicated => 'Dedicated';

  @override
  String get libraryBadgeDedicatedDesc => 'Spend 100 hours reading.';

  @override
  String get libraryBadgeTimeSink => 'Time Sink';

  @override
  String get libraryBadgeTimeSinkDesc => 'Spend 250 hours reading.';

  @override
  String get libraryBadgeImmersed => 'Immersed';

  @override
  String get libraryBadgeImmersedDesc => 'Spend 500 hours reading.';

  @override
  String get libraryBadgeEternal => 'Eternal';

  @override
  String get libraryBadgeEternalDesc => 'Spend 1,000 hours reading.';

  @override
  String get libraryBadgeWarmingUp => 'Warming Up';

  @override
  String get libraryBadgeWarmingUpDesc => 'Read 3 days in a row.';

  @override
  String get libraryBadgeHotStreak => 'Hot Streak';

  @override
  String get libraryBadgeHotStreakDesc => 'Read 7 days in a row.';

  @override
  String get libraryBadgeFortnight => 'Fortnight';

  @override
  String get libraryBadgeFortnightDesc => 'Read 14 days in a row.';

  @override
  String get libraryBadgeDevoted => 'Devoted';

  @override
  String get libraryBadgeDevotedDesc => 'Read 30 days in a row.';

  @override
  String get libraryBadgeStarterShelf => 'Starter Shelf';

  @override
  String get libraryBadgeStarterShelfDesc => 'Collect 10 titles.';

  @override
  String get libraryBadgeBibliophile => 'Bibliophile';

  @override
  String get libraryBadgeBibliophileDesc => 'Collect 50 titles.';

  @override
  String get libraryBadgeCurator => 'Curator';

  @override
  String get libraryBadgeCuratorDesc => 'Collect 100 titles.';

  @override
  String get libraryBadgeArchivist => 'Archivist';

  @override
  String get libraryBadgeArchivistDesc => 'Collect 250 titles.';

  @override
  String get libraryBadgeExplorer => 'Explorer';

  @override
  String get libraryBadgeExplorerDesc => 'Read from 5 sources.';

  @override
  String get libraryBadgeGlobetrotter => 'Globetrotter';

  @override
  String get libraryBadgeGlobetrotterDesc => 'Read from 15 sources.';

  @override
  String get libraryBadgeBoundless => 'Boundless';

  @override
  String get libraryBadgeBoundlessDesc => 'Read from 30 sources.';

  @override
  String get libraryBadgeDabbler => 'Dabbler';

  @override
  String get libraryBadgeDabblerDesc => 'Read 2 different formats.';

  @override
  String get libraryBadgeOmnivore => 'Omnivore';

  @override
  String get libraryBadgeOmnivoreDesc => 'Read all 3 formats.';

  @override
  String get libraryBadgeMangaDevotee => 'Manga Devotee';

  @override
  String get libraryBadgeMangaDevoteeDesc => 'Read 500 manga chapters.';

  @override
  String get libraryBadgeBingeWatcher => 'Binge Watcher';

  @override
  String get libraryBadgeBingeWatcherDesc => 'Watch 250 anime episodes.';

  @override
  String get libraryBadgeNovelNerd => 'Novel Nerd';

  @override
  String get libraryBadgeNovelNerdDesc => 'Read 250 novel chapters.';

  @override
  String get discoverGenres => 'Genres';

  @override
  String get discoverRemovedFromWishlist => 'Removed from wishlist';

  @override
  String get discoverRemove => 'Remove';

  @override
  String get novelDefine => 'Define';

  @override
  String get novelTts => 'Text-to-speech';

  @override
  String get novelVoice => 'Voice';

  @override
  String get novelVoiceSystemDefault => 'System default';

  @override
  String get novelVoiceEngine => 'Voice engine (experimental)';

  @override
  String get novelVoiceDevice => 'Device';

  @override
  String get novelSearchVoices => 'Search voices';

  @override
  String get novelResetPill => 'Reset pill position';

  @override
  String get novelMoreVoices => 'More voices & tuning →';

  @override
  String get novelActionSize => 'Size';

  @override
  String get novelActionTheme => 'Theme';

  @override
  String get novelActionAlign => 'Align';

  @override
  String get novelActionSpacing => 'Spacing';

  @override
  String get novelActionListen => 'Listen';

  @override
  String get novelHighlightColours => 'Highlight colours';

  @override
  String get novelHighlightSentence => 'Sentence';

  @override
  String get novelHighlightWord => 'Word';

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
  String get readerAutoPreloadNextChapter => 'Auto-Preload Next Chapter';

  @override
  String get readerAutoPreloadNextChapterSubtitle =>
      'Load next chapter in background';

  @override
  String get readerGrayscale => 'Grayscale';

  @override
  String get readerGrayscaleSubtitle => 'Display pages in grayscale';

  @override
  String get readerAutoCrop => 'Auto-crop borders';

  @override
  String get readerAutoScroll => 'Auto-scroll';

  @override
  String get readerAutoScrollSpeed => 'Auto-scroll speed';

  @override
  String get readerFilterReset => 'Reset';

  @override
  String get readerFilterPaper => 'Paper';

  @override
  String get readerFilterNight => 'Night';

  @override
  String get readerFilterVivid => 'Vivid';

  @override
  String get readerFilterSepia => 'Sepia';

  @override
  String get readerFilterContrast => 'Contrast';

  @override
  String get readerFilterSaturation => 'Saturation';

  @override
  String get readerEyeComfort => 'Eye comfort';

  @override
  String get readerEyeComfortWarm => 'Warm';

  @override
  String get readerEyeComfortBrightness => 'Brightness';

  @override
  String get readerGazeModeEyes => 'Eyes';

  @override
  String get readerGazeModeHead => 'Head';

  @override
  String get readerGazeModeBoth => 'Both';

  @override
  String get readerAutoCropSubtitle =>
      'Trim solid white/black margins so pages fill the screen';

  @override
  String get readerInvertColors => 'Invert Colors';

  @override
  String get readerInvertColorsSubtitle => 'Swap light and dark colors';

  @override
  String get readerDisplay => 'Display';

  @override
  String get readerScaleType => 'Scale Type';

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
  String get readerSourceNotInstalled => 'Source not installed';

  @override
  String get readerSourceNotInstalledHint =>
      'This title\'s source isn\'t installed — this can happen after restoring a backup. Install it from Extensions, then try again.';

  @override
  String get readerTranslating => 'Translating…';

  @override
  String get readerRetry => 'Retry';

  @override
  String get readerPageShare => 'Share';

  @override
  String get readerPageSave => 'Save image';

  @override
  String get readerPageSetCover => 'Set as cover';

  @override
  String get readerPageRecognizeText => 'Recognize text';

  @override
  String get readerPageSaved => 'Saved to gallery';

  @override
  String get readerPageSaveFailed => 'Couldn\'t save the image';

  @override
  String get readerPageCoverSet => 'Cover updated';

  @override
  String get readerPageCoverNeedsLibrary =>
      'Add this title to your library first';

  @override
  String get readerPageImageUnavailable => 'Image isn\'t available yet';

  @override
  String get readerPageOcrTitle => 'Recognized text';

  @override
  String get readerPageOcrEmpty => 'No text found on this page';

  @override
  String get readerPageOcrCopy => 'Copy';

  @override
  String get readerLoadingNextChapter => 'Loading next chapter...';

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
  String get browseNoLanguagesMatch => 'No languages match';

  @override
  String get browseYourLanguages => 'Your languages';

  @override
  String get browseSearchLanguages => 'Search languages';

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
  String get globalSearchSourceNoResults => 'No results';

  @override
  String get globalSearchSourceFailed => 'Couldn\'t search this source';

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
  String get setxAdvancedDnsAddCustom => 'Add custom DNS';

  @override
  String get setxAdvancedDnsName => 'Name';

  @override
  String get setxAdvancedDnsNameHint => 'My DNS';

  @override
  String get setxAdvancedDnsUrlLabel => 'DoH URL';

  @override
  String get setxAdvancedDnsInvalidUrl => 'Enter a valid https:// URL';

  @override
  String get setxAdvancedDnsAdd => 'Add';

  @override
  String get setxAdvancedDnsDelete => 'Delete';

  @override
  String get setxAdvancedDnsDeleteTitle => 'Delete custom DNS?';

  @override
  String setxAdvancedDnsDeleteBody(String name) {
    return 'Remove \"$name\" from your DNS providers?';
  }

  @override
  String get commonBeta => 'BETA';

  @override
  String get setxAdvancedSectionBeta => 'Experimental';

  @override
  String get setxAdvancedBeta => 'Beta features';

  @override
  String get setxAdvancedBetaDesc =>
      'Show experimental features: hands-free and volume-key scrolling, AI translation and auto-crop. They may be unstable or change.';

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
  String get setxAdvancedLogAll => 'All';

  @override
  String get setxAdvancedLogCatRepo => 'Repo';

  @override
  String get setxAdvancedLogCatExtension => 'Extension';

  @override
  String get setxAdvancedLogCatNetwork => 'Network';

  @override
  String get setxAdvancedLogCatInstall => 'Install';

  @override
  String get setxAdvancedLogCatLibrary => 'Library';

  @override
  String get setxAdvancedLogCatGeneral => 'General';

  @override
  String get setxAdvancedLogLvlDebug => 'Debug';

  @override
  String get setxAdvancedLogLvlInfo => 'Info';

  @override
  String get setxAdvancedLogLvlWarning => 'Warning';

  @override
  String get setxAdvancedLogLvlError => 'Error';

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
  String get setxSecurityIncognitoTitle => 'Incognito mode';

  @override
  String get setxSecurityIncognitoSubtitle =>
      'Don\'t save reading history or update trackers';

  @override
  String get libraryIncognitoActive => 'Incognito mode on';

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
  String get notifChannelUpdatesName => 'Library updates';

  @override
  String get notifChannelUpdatesDesc => 'New chapters and update summaries';

  @override
  String get notifChannelDownloadsName => 'Downloads';

  @override
  String get notifChannelDownloadsDesc => 'Download completion and errors';

  @override
  String get notifDownloadCompleteTitle => 'Download complete';

  @override
  String get notifDownloadFailedTitle => 'Download failed';

  @override
  String get notifDownloadsDoneTitle => 'Downloads complete';

  @override
  String notifDownloadsDoneBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items downloaded',
      one: '1 item downloaded',
    );
    return '$_temp0';
  }

  @override
  String notifDownloadsDoneBodyFailed(int count, int failed) {
    return '$count downloaded · $failed failed';
  }

  @override
  String notifNewChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new chapters',
      one: '1 new chapter',
    );
    return '$_temp0';
  }

  @override
  String get notifLibraryUpdatedTitle => 'Library updated';

  @override
  String notifLibrarySummaryBody(int count, int titles) {
    return '$count new chapters across $titles titles';
  }

  @override
  String get notifHiddenBody => 'New activity';

  @override
  String get notifExtensionUpdatesTitle => 'Extension updates';

  @override
  String notifExtensionUpdates(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count extension updates available',
      one: '1 extension update available',
    );
    return '$_temp0';
  }

  @override
  String get securityLockedTitle => 'Foxlations is locked';

  @override
  String get securityUnlock => 'Unlock';

  @override
  String get securityUnlockReason => 'Unlock Foxlations';

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
  String get backupIncludeVault => 'Include vault';

  @override
  String get backupIncludeVaultSubtitle =>
      'Adds your vault titles under “Vault-” categories — requires unlocking';

  @override
  String get backupUnlockVaultTitle => 'Unlock vault';

  @override
  String get backupUnlockVaultHint => 'Vault password';

  @override
  String get backupRestoreConfirmTitle => 'Restore this backup?';

  @override
  String backupRestoreConfirmBody(String name) {
    return 'This adds “$name” to your library. You can cancel if you changed your mind.';
  }

  @override
  String get setxBackupRestoreSubtitle =>
      'Restore from a Foxlations .fxbackup file';

  @override
  String get setxBackupSectionTachiyomi => 'Import from other apps';

  @override
  String get setxBackupCreateCompatTitle => 'Create compatible backup';

  @override
  String get setxBackupCreateCompatSubtitle =>
      'Export a .tachibk you can import into Tachiyomi, Mihon and forks';

  @override
  String get setxBackupRestoreTachiyomiTitle => 'Import from another app';

  @override
  String get setxBackupRestoreTachiyomiSubtitle =>
      'Mihon / Tachiyomi & forks, Aniyomi, Tachimanga, Mangayomi (matches sources by name)';

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
  String get backupOrganizeTitle => 'Organize imported categories';

  @override
  String backupOrganizePrompt(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'The backup added $count categories. Keep each, or send it to one of yours.',
      one: 'The backup added 1 category. Keep it, or send it to one of yours.',
    );
    return '$_temp0';
  }

  @override
  String get backupOrganizeKeepAll => 'Keep as-is';

  @override
  String get backupOrganizeApply => 'Apply';

  @override
  String get backupOrganizeKeep => 'Keep';

  @override
  String get backupOrganizeShowVault => 'Show vault categories';

  @override
  String get backupOrganizeUnlockVault =>
      'Unlock the vault to use its categories';

  @override
  String backupOrganizeVaultPrefix(String name) {
    return 'Vault: $name';
  }

  @override
  String backupOrganizeItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titles',
      one: '1 title',
    );
    return '$_temp0';
  }

  @override
  String backupOrganizeDone(int count) {
    return 'Reorganized $count titles';
  }

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
  String setxAboutVersionBuild(String version, String build) {
    return 'Version $version (Build $build)';
  }

  @override
  String get setxAboutDiscordSubtitle => 'Join the community';

  @override
  String get helpTipsTitle => 'Help & Tips';

  @override
  String get helpTipsViewTutorial => 'View tutorial';

  @override
  String get helpTipsViewTutorialSub => 'A quick tour of the app';

  @override
  String get helpTipsDiscord => 'Join our Discord';

  @override
  String get helpTipsDiscordSub => 'Help, requests & community';

  @override
  String get helpTipsSectionTips => 'Tips';

  @override
  String get helpTipsNoContentTitle => 'No content showing?';

  @override
  String get helpTipsNoContentBody =>
      'Add an extension repository in Browse → ⋯ to install sources first.';

  @override
  String get helpTipsGesturesTitle => 'Reader gestures';

  @override
  String get helpTipsGesturesBody =>
      'Tap the edges to turn pages, the center to show controls; long-press a page for more.';

  @override
  String get helpTipsVaultTitle => 'The Vault';

  @override
  String get helpTipsVaultBody =>
      'Move private titles into the Vault to keep them behind a lock.';

  @override
  String get helpTipsUpdateTitle => 'Keep up to date';

  @override
  String get helpTipsUpdateBody =>
      'Pull down on the Library to check for new chapters; set a schedule in Library settings.';

  @override
  String get tutorialSkip => 'Skip';

  @override
  String get tutorialNext => 'Next';

  @override
  String get tutorialGetStarted => 'Get started';

  @override
  String get tutorialJoinDiscord => 'Join Discord';

  @override
  String get tutorialSlide1Title => 'Welcome to Foxlations';

  @override
  String get tutorialSlide1Body =>
      'One app for manga and manhwa, anime, and light novels - read, watch and listen, all from sources you add yourself. No account, no ads, nothing phoning home.';

  @override
  String get tutorialSlide2Title => 'Get your content';

  @override
  String get tutorialSlide2Body =>
      'Foxlations ships empty - you choose the sources. In the Browse tab, open the ⋯ menu to add an extension repository (a link your community shares). Installed sources show up ready to search.';

  @override
  String get tutorialSlide3Title => 'Build your library';

  @override
  String get tutorialSlide3Body =>
      'Search a source or use global search across all of them, open a title, and tap the heart to add it. Your library is organized with categories (Reading, On-hold, your own…) and a “Continue reading” shortcut right up top.';

  @override
  String get tutorialSlide4Title => 'Read your way';

  @override
  String get tutorialSlide4Body =>
      'Paged, webtoon or double-page; tap the edges to turn pages and the centre for controls. Dial in eye-comfort (warm filter + dim), customise the novel reader, let it read novels aloud, and skip anime intros automatically.';

  @override
  String get tutorialSlide5Title => 'Private & offline';

  @override
  String get tutorialSlide5Body =>
      'Download chapters and episodes to read with no connection, back up your whole library, and keep private titles locked away in the Vault. There’s incognito mode and an app lock too.';

  @override
  String get tutorialSlide6Title => 'Join the community';

  @override
  String get tutorialSlide6Body =>
      'Questions, source help, feature requests, or just want to chat? Come say hi on our Discord - and you can reopen this tour any time from Settings → Help & Tips.';

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
  String get deeplinkAddRepoTitle => 'Add source repo?';

  @override
  String deeplinkFromHost(String host) {
    return 'From $host';
  }

  @override
  String deeplinkAddedNamed(String name) {
    return 'Added \"$name\" - see Browse > Extensions';
  }

  @override
  String get deeplinkAdded => 'Repo added - see Browse > Extensions';

  @override
  String deeplinkAddFailed(String error) {
    return 'Couldn\'t add repo: $error';
  }

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
  String get repoReinstallSources => 'Reinstall sources';

  @override
  String get repoCopyUrl => 'Copy repo URL';

  @override
  String get repoOpenGithubPage => 'Open GitHub page';

  @override
  String get repoOpenWebsite => 'Open website';

  @override
  String get repoOpenDiscord => 'Open Discord';

  @override
  String get repoDeleteRepo => 'Delete repo';

  @override
  String repoCouldNotOpen(String url) {
    return 'Couldn\'t open $url';
  }

  @override
  String get repoReinstalling => 'Reinstalling sources…';

  @override
  String get repoRefreshed => 'Repo refreshed';

  @override
  String repoReinstalledCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Reinstalled $count sources',
      one: 'Reinstalled 1 source',
    );
    return '$_temp0';
  }

  @override
  String repoReinstallFailed(String error) {
    return 'Reinstall failed: $error';
  }

  @override
  String get repoDeleteTitle => 'Delete repo?';

  @override
  String repoDeleteBody(String name) {
    return 'Remove \"$name\" and uninstall its sources?';
  }

  @override
  String get repoDeleteConfirm => 'Delete';

  @override
  String repoSourceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources',
      one: '1 source',
    );
    return '$_temp0';
  }

  @override
  String get repoCancel => 'Cancel';

  @override
  String get repoName => 'Name';

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
  String get dlQueueTitle => 'Downloads';

  @override
  String get dlQueueSettingsTooltip => 'Download settings';

  @override
  String get dlQueueRecent => 'Recently Downloaded';

  @override
  String get dlQueueResume => 'Resume';

  @override
  String get dlQueuePause => 'Pause';

  @override
  String dlQueueConcurrent(Object count) {
    return 'Concurrent downloads: $count';
  }

  @override
  String get dlQueueEmpty => 'No Downloads';

  @override
  String get dlQueuePaused => 'Downloads paused';

  @override
  String get dlQueueStatusQueued => 'Queued';

  @override
  String get dlQueueStatusDownloading => 'Downloading';

  @override
  String get dlQueueCancelAll => 'Cancel all';

  @override
  String get dlQueueCancelItem => 'Cancel download';

  @override
  String dlQueueProgress(Object done, Object total) {
    return '$done / $total';
  }

  @override
  String get dlQueueRecentTitle => 'Recently Downloaded';

  @override
  String get dlQueueRecentEmpty => 'Nothing downloaded yet';

  @override
  String get dlQueueRecentClear => 'Clear';

  @override
  String get dlQueueRecentNote => 'This session only';

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
  String get setdPlayerShowSkipButton => 'Skip-intro button';

  @override
  String get setdPlayerShowSkipButtonDesc =>
      'Show a Skip Intro button near the start, even when the source has no markers';

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
  String get setdAppearanceOledBlack => 'Pure black (OLED)';

  @override
  String get setdAppearanceOledBlackDesc =>
      'True-black background in dark mode — saves power on OLED screens';

  @override
  String get setdAppearanceNavOrder => 'Navigation bar';

  @override
  String get setdAppearanceNavOrderDesc =>
      'Drag to arrange the bottom tabs in any order';

  @override
  String get setdAppearanceNavOrderReset => 'Reset';

  @override
  String get setdAppearanceStartTab => 'Open to';

  @override
  String get setdAppearanceStartTabDesc =>
      'Which screen the app opens on at launch';

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

  @override
  String get readerGazeScroll => 'Hands-free scrolling';

  @override
  String get readerGazeScrollSubtitle =>
      'Scroll by looking toward the top or bottom of the screen. Uses the front camera.';

  @override
  String get readerGazeCameraTitle => 'Use the front camera?';

  @override
  String get readerGazeCameraWarning =>
      'Hands-free scrolling watches your gaze with the front camera while you read. It runs entirely on your device — nothing is recorded or sent anywhere — but it uses extra battery.';

  @override
  String get readerGazeMode => 'Control with';

  @override
  String get readerGazeSensitivity => 'Sensitivity';

  @override
  String get readerGazeHoldTime => 'Hold time';

  @override
  String get readerGazeSmoothing => 'Smoothing';

  @override
  String get readerGazeCalibrate => 'Calibrate';

  @override
  String get readerGazeCalibrateSubtitle =>
      'Set your resting gaze and head position as the baseline.';

  @override
  String get readerGazeCalibrating => 'Look at the centre and hold still…';

  @override
  String get readerTiltScroll => 'Tilt to scroll';

  @override
  String get readerTiltScrollSubtitle =>
      'Scroll by tilting the phone forward or back. Works on any phone.';

  @override
  String get readerTiltCalibrateSubtitle =>
      'Hold the phone at your reading angle, then set it as the baseline.';

  @override
  String get readerTiltCalibrating =>
      'Hold the phone still at your reading angle…';

  @override
  String get readerScrollSpeed => 'Scroll speed';

  @override
  String get readerHandsFreeOptions => 'Hands-free options';

  @override
  String get readerCalibrateTitle => 'Gaze calibration';

  @override
  String get readerCalibrateInstruction => 'Look at the dot and hold still';

  @override
  String get readerCalibrateSuccess => 'Calibrated!';

  @override
  String get readerCalibrateTestPrompt => 'Try it — look up or down to scroll';

  @override
  String get readerCalibrateKeep => 'Save';

  @override
  String get readerCalibrateRedo => 'Recalibrate';

  @override
  String get readerCalibrateDoneTest => 'Done testing';

  @override
  String readerCalibratePointOf(int n, int total) {
    return 'Point $n of $total';
  }

  @override
  String get readerRadialMenu => 'Radial menu';

  @override
  String get readerRadialMenuSubtitle =>
      'Replace the reader bars with a back button and a corner wheel. Hold the wheel for quick actions and the page slider.';

  @override
  String get readerShiftPages => 'Shift double pages';

  @override
  String get readerShiftPagesDesc =>
      'Nudge the pairing by one if two-page spreads land split across the middle.';

  @override
  String get readerFinishedLabel => 'Finished';

  @override
  String get readerUpNextLabel => 'Up next';

  @override
  String get readerRadialCorner => 'Wheel corner';

  @override
  String get readerCalibrateGetReady => 'Follow the dot to each corner';

  @override
  String get readerCalibrateDarkTitle => 'Too dark for eye tracking';

  @override
  String get readerCalibrateDarkBody =>
      'Your eyes need some light to track. Switched to head-tilt — it works in any light. Tilt your head up or down to scroll.';

  @override
  String get readerCalibrateTestPromptHead =>
      'Tilt your head up or down to scroll';
}
