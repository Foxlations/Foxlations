// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Foxlations';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsSectionApp => '应用';

  @override
  String get settingsSectionManga => '漫画';

  @override
  String get settingsSectionSystem => '系统';

  @override
  String get settingsLanguageTitle => '语言';

  @override
  String get settingsLanguageEntrySubtitle => '应用显示语言';

  @override
  String get settingsLanguageSubtitle => '选择应用语言';

  @override
  String get settingsLanguageSystemDefault => '跟随系统';

  @override
  String get settingsLanguageHeader => '应用语言';

  @override
  String get settingsAppearanceTitle => '外观';

  @override
  String get settingsAppearanceSubtitle => '主题、深色模式、显示';

  @override
  String get settingsNotificationsTitle => '通知';

  @override
  String get settingsNotificationsSubtitle => '推送提醒、频率、提醒';

  @override
  String get settingsStorageTitle => '存储';

  @override
  String get settingsStorageSubtitle => '下载、文件夹位置、同步';

  @override
  String get settingsLibraryTitle => '书库';

  @override
  String get settingsLibrarySubtitle => '分类、全局更新、显示';

  @override
  String get settingsReaderTitle => '阅读器';

  @override
  String get settingsReaderSubtitle => '阅读模式、显示、导航';

  @override
  String get settingsPlayerTitle => '播放器';

  @override
  String get settingsPlayerSubtitle => '快进、手势、速度、自动播放';

  @override
  String get settingsDownloadsTitle => '下载';

  @override
  String get settingsDownloadsSubtitle => '自动下载、删除章节';

  @override
  String get settingsTrackingTitle => '追踪';

  @override
  String get settingsTrackingSubtitle => 'MAL、AniList、Kitsu 等';

  @override
  String get settingsAiTitle => 'AI 与翻译';

  @override
  String get settingsAiSubtitle => '提供方、API 密钥、对话框检测';

  @override
  String get settingsBrowseTitle => '浏览';

  @override
  String get settingsBrowseSubtitle => '源、扩展、全局搜索';

  @override
  String get settingsBackupTitle => '备份与恢复';

  @override
  String get settingsBackupSubtitle => '创建/恢复备份、导入、自动备份';

  @override
  String get settingsSecurityTitle => '安全与隐私';

  @override
  String get settingsSecuritySubtitle => '应用锁、生物识别、屏幕安全';

  @override
  String get settingsAdvancedTitle => '高级';

  @override
  String get settingsAdvancedSubtitle => '网络、扩展、日志、数据';

  @override
  String get settingsAboutTitle => '关于';

  @override
  String get settingsAboutSubtitle => '版本、许可、链接';

  @override
  String get libraryAdd => '添加';

  @override
  String get libraryAddAnime => '添加动画';

  @override
  String get libraryAddLNs => '添加轻小说';

  @override
  String get libraryAddManga => '添加漫画';

  @override
  String get libraryBadges => '徽标';

  @override
  String get libraryBatchMigrate => '迁移';

  @override
  String get libraryBatchMove => '移动';

  @override
  String get libraryBatchRead => '已读';

  @override
  String get libraryBatchRemove => '移除';

  @override
  String get libraryBatchUnread => '未读';

  @override
  String get libraryCategoryUpdate => '分类更新';

  @override
  String libraryCategoryUpdateDesc(Object category) {
    return '检查\"$category\"是否有新章节';
  }

  @override
  String libraryChapterProgress(Object read, Object total) {
    return '第 $read/$total 章';
  }

  @override
  String libraryEpisodeProgress(Object read, Object total) {
    return '第 $read/$total 集';
  }

  @override
  String libraryChaptersAbbrev(Object n) {
    return '$n 章';
  }

  @override
  String get libraryCheckForUpdates => '检查更新';

  @override
  String get libraryClose => '关闭';

  @override
  String get libraryCloseSearch => '关闭搜索';

  @override
  String get libraryCompleted => '已完结';

  @override
  String get libraryContinueReading => '继续阅读';

  @override
  String get libraryContinueWatching => '继续观看';

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
    return '$days 天';
  }

  @override
  String get libraryDeselectAll => '取消全选';

  @override
  String get libraryDisplayMode => '显示模式';

  @override
  String get libraryDownloaded => '已下载';

  @override
  String get libraryEmpty => '书库为空';

  @override
  String get libraryEmptyDesc => '你的书库为空。浏览源以添加漫画。';

  @override
  String libraryEmptyStatsLibrary(Object word) {
    return '将$word添加到书库并开始阅读，即可在此查看你的统计数据。';
  }

  @override
  String libraryEmptyStatsVault(Object word) {
    return '将$word添加到保险库并开始阅读，即可在此查看统计数据。';
  }

  @override
  String get libraryFilterSortDisplay => '筛选、排序和显示';

  @override
  String get libraryGlobalUpdate => '全局更新';

  @override
  String get libraryGlobalUpdateDesc => '检查书库中的每一项';

  @override
  String get libraryHeatmapLess => '较少';

  @override
  String get libraryHeatmapMore => '较多';

  @override
  String get libraryItemsPerRow => '每行项数';

  @override
  String libraryLastChecked(Object when) {
    return '上次检查：$when';
  }

  @override
  String get libraryLibrary => '书库';

  @override
  String libraryListChapters(Object read, Object total) {
    return '$read/$total 章';
  }

  @override
  String get libraryMore => '更多';

  @override
  String get libraryMoveToCategory => '移动到分类';

  @override
  String get libraryNever => '从不';

  @override
  String get libraryNoBookmarks => '暂无书签';

  @override
  String get libraryNoBookmarksDesc => '长按漫画并添加书签，即可在此查看。';

  @override
  String get libraryNoNewChaptersLastCheck => '上次检查未发现新章节。';

  @override
  String get libraryNoResults => '没有结果';

  @override
  String libraryNoResultsDesc(Object query) {
    return '没有\"$query\"的结果。请尝试其他搜索。';
  }

  @override
  String get libraryNoStatsYet => '暂无统计';

  @override
  String get libraryOpenRandomEntry => '打开随机条目';

  @override
  String get libraryResetToDefault => '重置为默认';

  @override
  String get librarySave => '保存';

  @override
  String get librarySearchHint => '在书库中搜索...';

  @override
  String get librarySearchLibrary => '搜索书库';

  @override
  String get librarySelect => '选择';

  @override
  String get librarySelectAll => '全选';

  @override
  String librarySelectedCount(Object n) {
    return '已选 $n 项';
  }

  @override
  String get libraryShowNumberOfItems => '显示项数';

  @override
  String get librarySizeMedium => '中';

  @override
  String get librarySources => '源';

  @override
  String get libraryStats => '统计';

  @override
  String get libraryStatusAll => '全部';

  @override
  String get libraryStatusCompleted => '已完结';

  @override
  String get libraryStatusDropped => '已弃坑';

  @override
  String get libraryStatusOnHold => '暂时搁置';

  @override
  String get libraryStatusPlanToRead => '计划阅读';

  @override
  String get libraryStatusReading => '阅读中';

  @override
  String get libraryStatusUnknown => '未知';

  @override
  String libraryStreakDaysStrong(Object days) {
    return '已连续 $days 天——继续保持！';
  }

  @override
  String get libraryTabDisplay => '显示';

  @override
  String get libraryTabFilter => '筛选';

  @override
  String get libraryTabSort => '排序';

  @override
  String get libraryTabs => '标签页';

  @override
  String libraryTotalAbbrev(Object n) {
    return '共 $n 项';
  }

  @override
  String get libraryTypeMenuBarrier => 'Library type';

  @override
  String libraryTypeBreakdown(Object type) {
    return '$type 分布';
  }

  @override
  String get libraryUnread => '未读';

  @override
  String get libraryUpdatesSummary => '更新摘要';

  @override
  String get libraryUpdatesSummaryDesc => '上次检查的结果';

  @override
  String get libraryVault => '保险库';

  @override
  String get libraryVaultStats => '保险库统计';

  @override
  String get detailAdd => '添加';

  @override
  String get detailAddNoteHint => '为此标题添加备注…';

  @override
  String get detailAddToCategory => '添加到分类';

  @override
  String get detailAddToLibrary => '添加到书库';

  @override
  String get detailAddWithoutCategory => '不分类添加';

  @override
  String get detailBelowRead => '以下标为已读';

  @override
  String get detailBelowUnread => '以下标为未读';

  @override
  String get detailBookmark => '书签';

  @override
  String get detailBookmarked => '已加书签';

  @override
  String get detailCancel => '取消';

  @override
  String get detailChapterFallback => '章节';

  @override
  String detailCopiedTo(Object source) {
    return '已复制到 $source';
  }

  @override
  String detailCountSelected(Object count) {
    return '已选 $count 项';
  }

  @override
  String get detailDeleteDownload => '删除下载';

  @override
  String get detailDone => '完成';

  @override
  String get detailDownload => '下载';

  @override
  String get detailDownloadAllChapters => '全部章节';

  @override
  String get detailDownloadAllUnread => '全部未读';

  @override
  String get detailDownloaded => '已下载';

  @override
  String get detailDownloadNext10 => '后 10 章';

  @override
  String get detailDownloadNext5 => '后 5 章';

  @override
  String get detailDownloadNextChapter => '下一章';

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
  String get detailEditCategories => '编辑分类';

  @override
  String get detailEditCategoriesTitle => '编辑分类';

  @override
  String get detailFilter => '筛选';

  @override
  String get detailInProgress => '进行中';

  @override
  String get detailLogIn => '登录';

  @override
  String get detailMangaNotFound => '书库中未找到该漫画';

  @override
  String get detailMarkAllAsRead => '全部标为已读';

  @override
  String get detailMarkAllAsUnread => '全部标为未读';

  @override
  String get detailMarkAllBelowRead => '将以下全部标为已读';

  @override
  String get detailMarkAsUnread => '标为未读';

  @override
  String get detailMarkChapterAsRead => '将本章标为已读';

  @override
  String get detailMarkRead => '标为已读';

  @override
  String get detailMarkUnread => '标为未读';

  @override
  String get detailMigrate => '迁移';

  @override
  String get detailMigrateCategories => '分类';

  @override
  String get detailMigrateChapters => '章节';

  @override
  String get detailMigrateCopy => '复制';

  @override
  String get detailMigrateDownloadsNoTransfer => '已下载的章节不会转移。';

  @override
  String detailMigratedTo(Object source) {
    return '已迁移到 $source';
  }

  @override
  String detailMigrateEntriesToSource(Object count, Object source) {
    return '$count 个条目 → $source';
  }

  @override
  String get detailMigrateInfo => '从其他源选择同一部漫画。阅读进度将被转移。';

  @override
  String get detailMigrateRemoveDownloads => '迁移时移除下载';

  @override
  String get detailMigrateSelectData => '选择要包含的数据';

  @override
  String get detailMigrateShowEntry => '显示条目';

  @override
  String detailMigrateTitleToSource(Object title, Object source) {
    return '$title → $source';
  }

  @override
  String get detailMigrateTracking => '追踪';

  @override
  String get detailMigrating => '正在迁移…';

  @override
  String get detailNewestFirst => '最新在前';

  @override
  String get detailNoChaptersFound => '未找到章节';

  @override
  String get detailNoChaptersLoginHint => '该标题未加载任何内容。请重试——对于此源，登录有时可以解锁更多内容。';

  @override
  String get detailNoChaptersRetryHint => '该标题未加载任何内容。可能尚无章节，或源加载时出现问题。请重试。';

  @override
  String get detailNoResults => '未找到结果';

  @override
  String get detailNotes => '备注';

  @override
  String get detailNothingToDownload => '没有可下载的内容';

  @override
  String get detailOldestFirst => '最旧在前';

  @override
  String get detailOpenInBrowser => '在浏览器中打开';

  @override
  String get webviewOpenFailed => 'Couldn\'t open the browser';

  @override
  String detailPage(Object page) {
    return '第 $page 页';
  }

  @override
  String get detailRefresh => '刷新';

  @override
  String get detailRemove => '移除';

  @override
  String get detailRemoveBookmark => '移除书签';

  @override
  String get detailRemoveFromLibrary => '从书库移除';

  @override
  String get detailRemoveFromLibraryTitle => '从书库移除？';

  @override
  String get detailResume => '继续';

  @override
  String get detailRetry => '重试';

  @override
  String get detailSave => '保存';

  @override
  String get detailSearchChapters => '搜索章节';

  @override
  String get detailSearchChaptersHint => '搜索章节...';

  @override
  String get detailSearchEpisodes => '搜索剧集';

  @override
  String get detailSearchHint => '搜索漫画标题...';

  @override
  String get detailSearchingSources => '正在搜索源…';

  @override
  String get detailSelectAll => '全选';

  @override
  String get detailSelectChapters => '选择章节';

  @override
  String get detailTracking => '追踪';

  @override
  String get detailUnbookmark => '移除书签';

  @override
  String get detailUnread => '未读';

  @override
  String get detailWebView => 'WebView';

  @override
  String get appNavLibrary => '书库';

  @override
  String get appNavUpdates => '更新';

  @override
  String get appNavBrowse => '浏览';

  @override
  String get appNavDiscover => 'Discover';

  @override
  String get appNavMore => '更多';

  @override
  String get appNavVault => '保险库';

  @override
  String get appUpdatesTitle => '更新';

  @override
  String get appNoNewChapters => '没有新章节';

  @override
  String get appCheckForUpdates => '检查更新';

  @override
  String get appClearAll => '全部清除';

  @override
  String appCheckingProgress(Object checked, Object total) {
    return '正在检查 $checked / $total...';
  }

  @override
  String appLastChecked(Object time) {
    return '上次检查：$time';
  }

  @override
  String get appNoUpdatesYet => '暂无更新';

  @override
  String get appTapRefreshForChapters => '点击刷新以检查新章节';

  @override
  String get appCheckNow => '立即检查';

  @override
  String get appJustNow => '刚刚';

  @override
  String appMinutesAgo(Object m) {
    return '$m 分钟前';
  }

  @override
  String appHoursAgo(Object h) {
    return '$h 小时前';
  }

  @override
  String appDaysAgo(Object d) {
    return '$d 天前';
  }

  @override
  String get appToday => '今天';

  @override
  String get appYesterday => '昨天';

  @override
  String get appOnLatestVersion => '你已是最新版本';

  @override
  String get appUpdateAvailable => '有可用更新';

  @override
  String appVersionBuild(Object version, Object build) {
    return 'v$version · 构建 $build';
  }

  @override
  String get appDownloadUpdate => '下载更新';

  @override
  String appDownloadVersion(Object version) {
    return '下载 v$version';
  }

  @override
  String get appApkDownloadHint => '将打开 APK 下载。Android 会要求你确认安装。';

  @override
  String get appIosUpdateHint =>
      '通过 AltStore 或 SideStore 更新——打开它并刷新。iOS 无法安装在浏览器中下载的应用。';

  @override
  String get appSourceUrlCopied => '已复制源 URL——在 AltStore 中添加';

  @override
  String get appCopyAltstoreUrl => '复制 AltStore 源 URL';

  @override
  String get appBack => '返回';

  @override
  String get appForward => '前进';

  @override
  String get appReload => '重新加载';

  @override
  String get appDoneSaveCookies => '完成——保存 cookie';

  @override
  String get appVaultPassword => '保险库密码';

  @override
  String get appEnterPassword => '输入密码';

  @override
  String get appWrongPassword => '密码错误';

  @override
  String get appCancel => '取消';

  @override
  String get appUnlock => '解锁';

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
  String get readerExperimentalOnIos => 'iOS 上为实验性功能';

  @override
  String get readerIosVolumeWarning =>
      'iOS 没有正规的音量键 API，因此此功能通过监测系统音量来实现——可能会不稳定。阅读时，你正在收听的任何内容（音乐、播客）的音量将被固定为 50% 且无法更改。仍要启用吗？';

  @override
  String get readerCancel => '取消';

  @override
  String get readerEnable => '启用';

  @override
  String get readerTitle => '阅读器';

  @override
  String get readerPreferences => '偏好设置';

  @override
  String get readerReadingMode => '阅读模式';

  @override
  String get readerFontSize => '字体大小';

  @override
  String get readerAutoPreloadNextChapter => '自动预载下一章';

  @override
  String get readerAutoPreloadNextChapterSubtitle => '在后台加载下一章';

  @override
  String get readerGrayscale => '灰度';

  @override
  String get readerGrayscaleSubtitle => '以灰度显示页面';

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
  String get readerInvertColors => '反转颜色';

  @override
  String get readerInvertColorsSubtitle => '交换明暗颜色';

  @override
  String get readerDisplay => '显示';

  @override
  String get readerScaleType => '缩放类型';

  @override
  String get readerBackgroundColor => '背景颜色';

  @override
  String get readerKeepScreenOn => '保持屏幕常亮';

  @override
  String get readerKeepScreenOnSubtitle => '防止屏幕休眠';

  @override
  String get readerShowPageNumber => '显示页码';

  @override
  String get readerShowPageNumberSubtitle => '显示页码指示覆盖层';

  @override
  String get readerFullscreen => '全屏';

  @override
  String get readerFullscreenSubtitle => '阅读时隐藏系统栏';

  @override
  String get readerNavigation => '导航';

  @override
  String get readerNavigationLayout => '导航布局';

  @override
  String get readerInvertTapZones => '反转点击区域';

  @override
  String get readerInvertTapZonesSubtitle => '交换左右点击导航';

  @override
  String get readerVolumeKeys => '音量键';

  @override
  String get readerVolumeKeysSubtitle => '点击翻页/滚动；长按滚动（条漫）';

  @override
  String get readerHoldScrollSpeed => '长按滚动速度';

  @override
  String get readerSourceNotInstalled => '源未安装';

  @override
  String get readerSourceNotInstalledHint =>
      'This title\'s source isn\'t installed — this can happen after restoring a backup. Install it from Extensions, then try again.';

  @override
  String get readerTranslating => '正在翻译…';

  @override
  String get readerRetry => '重试';

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
  String get readerLoadingNextChapter => '正在加载下一章...';

  @override
  String get readerAllCaughtUp => '你已全部读完！';

  @override
  String get readerEndOfChapter => '本章结束';

  @override
  String get readerLatestChapterAvailable => '这是目前可用的最新章节。';

  @override
  String get readerLoadNextChapter => '加载下一章';

  @override
  String get readerBack => '返回';

  @override
  String get readerSettings => '设置';

  @override
  String get readerAiTranslate => 'AI 翻译';

  @override
  String get readerPreviousChapter => '上一章';

  @override
  String get readerBookmark => '书签';

  @override
  String get readerNextChapter => '下一章';

  @override
  String readerTranslationFailed(Object error) {
    return '翻译失败：$error';
  }

  @override
  String get readerModeLtrLabel => '从左到右';

  @override
  String get readerModeRtlLabel => '从右到左';

  @override
  String get readerModeVerticalLabel => '连续滚动';

  @override
  String get readerModeWebtoonLabel => '条漫';

  @override
  String get readerModeLtrSubtitle => '点击左/右翻页';

  @override
  String get readerModeRtlSubtitle => '漫画式从右到左';

  @override
  String get readerModeVerticalSubtitle => '垂直滚动浏览页面';

  @override
  String get readerModeWebtoonSubtitle => '为长竖条优化';

  @override
  String get readerChapters => '章节';

  @override
  String readerPageOf(int current, int total) {
    return '第 $current 页，共 $total 页';
  }

  @override
  String get readerTabProvider => '提供方';

  @override
  String get readerTabTarget => '目标';

  @override
  String get readerTabSource => '源';

  @override
  String get readerTabFont => '字体';

  @override
  String get readerFontNormal => '常规';

  @override
  String get readerFontManga => '漫画';

  @override
  String get readerFontNormalDesc => '简洁无衬线';

  @override
  String get readerFontMangaDesc => '粗体漫画风格';

  @override
  String get readerFontSample => 'Hello World';

  @override
  String get readerNoChapterText => '未找到章节文本';

  @override
  String get readerReadingTitle => '阅读中';

  @override
  String get readerSmallerText => '更小的文字';

  @override
  String get readerLargerText => '更大的文字';

  @override
  String get readerPrevious => '上一个';

  @override
  String get readerNext => '下一个';

  @override
  String get browseTitle => '浏览';

  @override
  String get browseGlobalSearch => '全局搜索';

  @override
  String get browseRefreshingRepos => '正在刷新仓库...';

  @override
  String get browseRefreshRepos => '刷新仓库';

  @override
  String get browseSearch => '搜索';

  @override
  String get browseAddRepo => '添加仓库';

  @override
  String get browseTabSources => '源';

  @override
  String get browseTabExtensions => '扩展';

  @override
  String get browseTabLocal => '本地';

  @override
  String get browseSearchHint => '搜索扩展和源...';

  @override
  String browseRemoveSourceConfirm(Object name) {
    return '移除 $name？';
  }

  @override
  String get browseRemoveSourceDesc => '该源将被卸载。你来自该源的书库条目会保留，但在重新安装前将无法打开。';

  @override
  String get browseCancel => '取消';

  @override
  String get browseRemove => '移除';

  @override
  String get browseProvidedByThisSource => '由此源提供';

  @override
  String get browseCouldNotLoadOptions => '无法加载该源的选项';

  @override
  String get browseNoSourceOptions => '该源未定义任何自己的选项。上面的设置仍然适用。';

  @override
  String get browseBaseUrl => '基础 URL';

  @override
  String get browseUsingSourceDefault => '使用源默认值';

  @override
  String browseBaseUrlDefault(Object url) {
    return '$url  （默认）';
  }

  @override
  String get browseResetToDefault => '重置为默认';

  @override
  String get browsePinToTop => '置顶';

  @override
  String get browsePinToTopDesc => '在源列表中优先显示此源';

  @override
  String get browseSkipGlobalSearch => '全局搜索中跳过';

  @override
  String get browseSkipGlobalSearchDesc => '搜索全部内容时不包含此源';

  @override
  String get browseSkipLibraryUpdates => '书库更新中跳过';

  @override
  String get browseSkipLibraryUpdatesDesc => '不检查此源的新章节';

  @override
  String get browseRequestDesktopSite => '请求桌面版网站';

  @override
  String get browseRequestDesktopSiteDesc =>
      '如果此源找不到内容或不显示章节，请尝试此项——有些网站会向手机发送精简版页面';

  @override
  String get browseSave => '保存';

  @override
  String get browseNone => '无';

  @override
  String browseSelectedCount(Object count) {
    return '已选 $count 项';
  }

  @override
  String get browseNotSet => '未设置';

  @override
  String get browseIosFolderWarning =>
      'iOS 不允许应用保持对文件夹的访问权限。请改用\"导入文件\"来添加 .cbz/.cbr/.zip/.epub/.pdf。';

  @override
  String browseImportedFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已导入 $count 个文件',
    );
    return '$_temp0';
  }

  @override
  String get browseNothingImported => '未导入任何内容（不受支持或无法读取）';

  @override
  String browseFolderCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个文件夹',
    );
    return '$_temp0';
  }

  @override
  String get browseManageFolders => '管理文件夹';

  @override
  String get browseImportFileTooltip => '导入文件（CBZ/ZIP/EPUB/PDF）';

  @override
  String get browseAddFolder => '添加文件夹';

  @override
  String get browseRescan => '重新扫描';

  @override
  String get browseNothingImportedYet => '尚未导入任何内容';

  @override
  String get browseNoLocalSources => '没有本地源';

  @override
  String get browseLocalSourcesDesc =>
      '添加漫画文件夹，或导入单个文件。\n支持：图片（JPG、PNG、WebP、GIF）、CBZ/ZIP、EPUB 和 PDF。\n（CBR/RAR 仅当文件实际为 ZIP 打包时支持——不支持真正的 RAR。）';

  @override
  String get browseAddFolderButton => '添加文件夹';

  @override
  String get browseImportFile => '导入文件';

  @override
  String get browseLocalSourceFolders => '本地源文件夹';

  @override
  String get browseNoFoldersAdded => '未添加文件夹';

  @override
  String browseChaptersAbbrev(Object n) {
    return '$n 章';
  }

  @override
  String get browseInstalled => '已安装';

  @override
  String get browseAvailable => '可用';

  @override
  String get browseSourceNotInstalled => '源未安装';

  @override
  String get browseManga => '漫画';

  @override
  String get browseAnime => '动画';

  @override
  String get browseNovels => '小说';

  @override
  String get browseAllLanguages => '所有语言';

  @override
  String get browseFilter => '筛选';

  @override
  String browseLanguagesCount(Object count) {
    return '$count 种语言';
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
      other: '$count 个结果',
    );
    return '$_temp0';
  }

  @override
  String get browseNoExtensions => '暂无扩展';

  @override
  String get browseNoExtensionsDesc => '使用上方的设置按钮添加仓库\n以浏览扩展。';

  @override
  String browseUpdatedSources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已更新 $count 个源',
    );
    return '$_temp0';
  }

  @override
  String get browseSourceUpdated => '源已更新';

  @override
  String get browseNoUpdateAvailable => '没有可用更新';

  @override
  String browseUpdateFailed(Object error) {
    return '更新失败：$error';
  }

  @override
  String browseRefreshFailed(Object error) {
    return '刷新失败：$error';
  }

  @override
  String browseUpdatesAvailable(Object count) {
    return '有可用更新（$count）';
  }

  @override
  String get browseUpdateAll => '全部更新';

  @override
  String get browseUpdate => '更新';

  @override
  String get browseSettings => '设置';

  @override
  String get browseInstall => '安装';

  @override
  String get browseInstalledBadge => '已安装';

  @override
  String get browseAbout => '关于';

  @override
  String browseSourceFrom(Object url) {
    return '来自 $url 的源';
  }

  @override
  String browseLanguageLabel(Object lang) {
    return '语言：$lang';
  }

  @override
  String get browseUsesCloudflare => '使用 Cloudflare 保护';

  @override
  String get browseNoCloudflare => '无 Cloudflare';

  @override
  String get browseAdultContent => '18+ 内容';

  @override
  String get browseSafeForWork => '适合工作场合';

  @override
  String get browseFeatures => '功能';

  @override
  String get browsePopular => '热门';

  @override
  String get browseLatest => '最新';

  @override
  String browseSourceAction(Object name) {
    return '浏览 $name';
  }

  @override
  String get browseRemoving => '正在移除...';

  @override
  String get browseInstalling => '正在安装...';

  @override
  String browseFailed(Object error) {
    return '失败：$error';
  }

  @override
  String get browseNoLanguagesMatch => 'No languages match';

  @override
  String get browseYourLanguages => 'Your languages';

  @override
  String get browseSearchLanguages => 'Search languages';

  @override
  String get browseUpdating => '正在更新...';

  @override
  String get browseUpdateExtensionCode => '更新扩展代码';

  @override
  String browseUpdatedSource(Object name) {
    return '已更新 $name';
  }

  @override
  String get browsePinned => '已置顶';

  @override
  String get browseAll => '全部';

  @override
  String get browseNoInstalledSources => '没有已安装的源';

  @override
  String get browseNoInstalledSourcesDesc => '从扩展标签页安装扩展\n以在此查看源。';

  @override
  String get browseUnpin => '取消置顶';

  @override
  String get browsePin => '置顶';

  @override
  String get browseSourceNotInstalledBody => '源未安装';

  @override
  String get browseBypassingCloudflare => '正在绕过 Cloudflare 保护...';

  @override
  String get browseOpenInWebView => '在 WebView 中打开';

  @override
  String get browseCloudflareProtection => 'Cloudflare 保护';

  @override
  String get browseFailedToLoad => '加载失败';

  @override
  String get browseCloudflareChallengeDesc => '此源需要先在浏览器中完成 Cloudflare 验证。';

  @override
  String get browseSolveCloudflare => '完成 Cloudflare 验证';

  @override
  String get browseRetry => '重试';

  @override
  String get browseContentAnime => '动画';

  @override
  String get browseContentNovels => '轻小说';

  @override
  String get browseContentManga => '漫画';

  @override
  String browseNoContentFound(Object noun) {
    return '未找到$noun';
  }

  @override
  String get browseAllCategories => '所有分类';

  @override
  String get browseNoCategories => '没有分类';

  @override
  String get browseSearchMangaHint => '搜索漫画...';

  @override
  String get browseUnknown => '未知';

  @override
  String get browseSearchAllSourcesHint => '在所有源中搜索...';

  @override
  String get browseNoSourcesInstalled => '没有已安装的源';

  @override
  String get browseNoSourcesInstalledDesc => '从浏览标签页安装扩展。';

  @override
  String get browseSearchAllSources => '搜索所有源';

  @override
  String browseSearchSourcesAtOnce(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '同时搜索 $count 个源。',
    );
    return '$_temp0';
  }

  @override
  String browseSearchingSources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '正在搜索 $count 个源...',
    );
    return '$_temp0';
  }

  @override
  String get browseSeeAll => '查看全部';

  @override
  String get globalSearchSourceNoResults => 'No results';

  @override
  String get globalSearchSourceFailed => 'Couldn\'t search this source';

  @override
  String get browseSectionSources => '源';

  @override
  String get browseShowNsfw => '显示 NSFW 源';

  @override
  String get browseShowNsfwDesc => '在浏览和搜索中显示 18+ 源';

  @override
  String get browsePinnedOnly => '仅置顶的源';

  @override
  String get browsePinnedOnlyBrowseDesc => '浏览时仅显示已置顶的源';

  @override
  String get browseSectionGlobalSearch => '全局搜索';

  @override
  String get browsePinnedOnlyGlobalSearchDesc => '全局搜索时仅搜索已置顶的源';

  @override
  String get browseSectionWebView => 'WebView';

  @override
  String get browseAdBlocker => '广告拦截';

  @override
  String get browseAdBlockerDesc => '在浏览器中拦截广告、弹窗和覆盖层';

  @override
  String get browseSectionExtensions => '扩展';

  @override
  String get browseAutoUpdate => '自动更新扩展';

  @override
  String get browseAutoUpdateDesc => '应用启动时刷新已安装的扩展代码';

  @override
  String get setxAdvancedTitle => '高级';

  @override
  String get setxAdvancedSectionLogging => '日志';

  @override
  String get setxAdvancedVerboseLoggingTitle => '详细日志';

  @override
  String get setxAdvancedVerboseLoggingSubtitle => '记录详细的调试信息';

  @override
  String get setxAdvancedViewErrorLogsTitle => '查看错误日志';

  @override
  String get setxAdvancedViewErrorLogsSubtitle => '浏览调试和错误日志';

  @override
  String get setxAdvancedSectionNetwork => '网络';

  @override
  String get setxAdvancedDnsOverHttpsTitle => 'DNS over HTTPS';

  @override
  String get setxAdvancedDnsOverHttpsSubtitle => '使用安全的 DNS 解析';

  @override
  String get setxAdvancedDnsProviderTitle => 'DNS 提供方';

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
  String get setxAdvancedSectionExtensions => '扩展';

  @override
  String get setxAdvancedThirdPartyTitle => '第三方扩展';

  @override
  String get setxAdvancedThirdPartySubtitle => '允许来自未知来源的扩展';

  @override
  String get setxAdvancedExtUpdateTitle => '扩展更新提醒';

  @override
  String get setxAdvancedExtUpdateSubtitle => '扩展有更新时通知';

  @override
  String get setxAdvancedSectionBrowser => '浏览器';

  @override
  String get setxAdvancedExternalBrowserTitle => '外部浏览器';

  @override
  String get setxAdvancedExternalBrowserSubtitle => '在系统浏览器中打开链接';

  @override
  String get setxAdvancedSectionData => '数据';

  @override
  String get setxAdvancedClearCacheTitle => '清除章节缓存';

  @override
  String get setxAdvancedClearCacheSubtitle => '释放存储空间';

  @override
  String get setxAdvancedClearDbEntryTitle => '清除数据库';

  @override
  String get setxAdvancedClearDbEntrySubtitle => '重置书库、分类和阅读历史';

  @override
  String get setxAdvancedCacheCleared => '章节图片缓存已清除';

  @override
  String get setxAdvancedClearDbTitle => '清除数据库？';

  @override
  String get setxAdvancedClearDbBody => '这将永久删除你的书库、分类和阅读历史。已安装的扩展和下载不受影响。';

  @override
  String get setxAdvancedCancel => '取消';

  @override
  String get setxAdvancedClear => '清除';

  @override
  String get setxAdvancedDbCleared => '数据库已清除——重启应用以重新生成默认值';

  @override
  String get setxAdvancedErrorLogsTitle => '错误日志';

  @override
  String get setxAdvancedClearAllLogsTooltip => '清除所有日志';

  @override
  String get setxAdvancedFilterCategory => '类别';

  @override
  String get setxAdvancedFilterLevel => '级别';

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
  String get setxAdvancedNoLogs => '暂无日志';

  @override
  String get setxAdvancedNoLogsSubtitle => '使用应用时日志将显示在此处';

  @override
  String get setxAdvancedClearLogsTitle => '清除所有日志？';

  @override
  String get setxAdvancedClearLogsBody => '这将永久删除所有存储的日志条目。';

  @override
  String get setxAdvancedLogsCleared => '日志已清除';

  @override
  String get setxAdvancedCopiedToClipboard => '已复制到剪贴板';

  @override
  String get setxNotifTitle => '通知';

  @override
  String get setxNotifSectionChapterUpdates => '章节更新';

  @override
  String get setxNotifNewChaptersTitle => '新章节';

  @override
  String get setxNotifNewChaptersSubtitle => '有新章节时通知';

  @override
  String get setxNotifLibraryUpdatesTitle => '书库更新';

  @override
  String get setxNotifLibraryUpdatesSubtitle => '书库更新完成后通知';

  @override
  String get setxNotifSectionDownloads => '下载';

  @override
  String get setxNotifDownloadCompleteTitle => '下载完成';

  @override
  String get setxNotifDownloadCompleteSubtitle => '章节下载完成时通知';

  @override
  String get setxNotifDownloadErrorTitle => '下载错误';

  @override
  String get setxNotifDownloadErrorSubtitle => '下载失败时通知';

  @override
  String get setxNotifSectionBehavior => '行为';

  @override
  String get setxNotifSoundTitle => '声音';

  @override
  String get setxNotifSoundSubtitle => '通知时播放声音';

  @override
  String get setxNotifVibrationTitle => '振动';

  @override
  String get setxNotifVibrationSubtitle => '通知时振动';

  @override
  String get setxNotifGroupTitle => '通知分组';

  @override
  String get setxNotifGroupSubtitle => '合并多条通知';

  @override
  String get setxSecurityTitle => '安全与隐私';

  @override
  String get setxSecuritySectionAppLock => '应用锁';

  @override
  String get setxSecurityAppLockTitle => '应用锁';

  @override
  String get setxSecurityAppLockSubtitle => '打开应用需要身份验证';

  @override
  String get setxSecurityBiometricsTitle => '生物识别';

  @override
  String get setxSecurityBiometricsSubtitle => '使用指纹或面容解锁';

  @override
  String get setxSecuritySectionPrivacy => '隐私';

  @override
  String get setxSecurityIncognitoTitle => 'Incognito mode';

  @override
  String get setxSecurityIncognitoSubtitle =>
      'Don\'t save reading history or update trackers';

  @override
  String get libraryIncognitoActive => 'Incognito mode on';

  @override
  String get setxSecuritySecureScreenTitle => '屏幕安全';

  @override
  String get setxSecuritySecureScreenSubtitle => '在最近任务中隐藏应用内容';

  @override
  String get setxSecurityHideNotifTitle => '隐藏通知内容';

  @override
  String get setxSecurityHideNotifSubtitle => '显示通用通知文本';

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
  String get setxBackupTitle => '备份与恢复';

  @override
  String get setxBackupSectionFoxlations => 'Foxlations 备份';

  @override
  String get setxBackupCreateTitle => '创建备份';

  @override
  String get setxBackupCreateSubtitle => '保存你的书库、分类、阅读进度、源和追踪';

  @override
  String get setxBackupRestoreTitle => '恢复备份';

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
  String get setxBackupRestoreSubtitle => '从 Foxlations .fxbackup 文件恢复';

  @override
  String get setxBackupSectionTachiyomi => 'Tachiyomi / Mihon 及分支';

  @override
  String get setxBackupCreateCompatTitle => '创建兼容备份';

  @override
  String get setxBackupCreateCompatSubtitle =>
      '导出可导入 Tachiyomi、Mihon 及其分支的 .tachibk';

  @override
  String get setxBackupRestoreTachiyomiTitle => '从 Tachiyomi/Mihon 恢复';

  @override
  String get setxBackupRestoreTachiyomiSubtitle =>
      '导入 .tachibk / .tmb / .proto.gz 备份（按名称匹配源）';

  @override
  String get setxBackupSectionAutomatic => '自动备份';

  @override
  String get setxBackupFrequency => '频率';

  @override
  String setxBackupAutoSubtitle(Object freq) {
    return '自动创建备份（$freq）';
  }

  @override
  String setxBackupSectionBackups(Object count) {
    return '备份（$count）';
  }

  @override
  String get setxBackupNone => '暂无备份。';

  @override
  String get setxBackupMenuRestore => '恢复';

  @override
  String get setxBackupMenuDelete => '删除';

  @override
  String get setxBackupFreqOff => '关闭';

  @override
  String get setxBackupFreqDaily => '每天';

  @override
  String get setxBackupFreqWeekly => '每周';

  @override
  String get setxBackupFreqMonthly => '每月';

  @override
  String setxBackupImportedManga(Object count) {
    return '已导入 $count 部漫画';
  }

  @override
  String get setxBackupRestoreComplete => '恢复完成';

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
    return '恢复失败：$error';
  }

  @override
  String get setxAboutTitle => '关于';

  @override
  String get setxAboutSectionApp => '应用';

  @override
  String get setxAboutWhatsNewTitle => '新增内容';

  @override
  String get setxAboutWhatsNewSubtitle => '更新日志和发行说明';

  @override
  String get setxAboutCheckUpdatesTitle => '检查更新';

  @override
  String get setxAboutCheckUpdatesSubtitle => '查看是否有更新的构建发布';

  @override
  String get setxAboutSectionLegal => '法律';

  @override
  String get setxAboutLicensesTitle => '许可';

  @override
  String get setxAboutLicensesSubtitle => '开源许可';

  @override
  String get setxAboutSectionLinks => '链接';

  @override
  String get setxAboutSourceCodeTitle => '源代码';

  @override
  String get setxAboutSourceCodeSubtitle => '点击复制 GitHub URL';

  @override
  String get setxAboutReportBugTitle => '报告 Bug';

  @override
  String get setxAboutReportBugSubtitle => '点击复制问题追踪 URL';

  @override
  String get setxAboutClose => '关闭';

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
    return 'v$version 新增内容';
  }

  @override
  String setxAboutLinkCopied(Object label) {
    return '$label 链接已复制到剪贴板';
  }

  @override
  String get setxAboutSourceCodeLabel => '源代码';

  @override
  String get setxAboutBugReportLabel => 'Bug 报告';

  @override
  String get miscResumePlaybackTitle => '恢复播放？';

  @override
  String miscStoppedWatchingAt(Object time) {
    return '你在 $time 停止了观看。';
  }

  @override
  String get miscStartOver => '从头开始';

  @override
  String miscContinueAt(Object time) {
    return '继续（$time）';
  }

  @override
  String get miscQuality => '画质';

  @override
  String miscSourceIndex(Object index) {
    return '源 $index';
  }

  @override
  String get miscSubtitles => '字幕';

  @override
  String get miscSubtitleOff => '关闭';

  @override
  String get miscUnknownTrack => '未知';

  @override
  String get miscSubtitleDelay => '字幕延迟';

  @override
  String get miscAudio => '音频';

  @override
  String get miscPlaybackSpeed => '播放速度';

  @override
  String get miscSkipOutro => '跳过片尾';

  @override
  String get miscSkipIntro => '跳过片头';

  @override
  String get miscUnlockControls => '解锁控件';

  @override
  String get miscUnknownError => '未知错误';

  @override
  String get miscRetry => '重试';

  @override
  String get miscExtensionRepositories => '扩展仓库';

  @override
  String get miscRepositoryUrlHint => '仓库 URL（index.json）';

  @override
  String get miscAdd => '添加';

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
  String get miscRepositoriesHeader => '仓库';

  @override
  String get miscNoReposYet => '尚未添加仓库';

  @override
  String miscFailedToAddRepo(Object error) {
    return '添加仓库失败：$error';
  }

  @override
  String get miscVerifyHuman => '验证你是人类';

  @override
  String get miscCfInstructions => '完成下方网站的验证。验证完成后会自动关闭，且在验证有效期内不会再次询问。';

  @override
  String get trackTitle => '追踪';

  @override
  String get trackNoTrackerConnected => '未连接追踪服务';

  @override
  String get trackConnectHint => '在 设置 › 追踪 中连接 AniList、MyAnimeList 或 Kitsu。';

  @override
  String trackNotLinkedOn(Object name) {
    return '未在 $name 关联';
  }

  @override
  String get trackLink => '关联';

  @override
  String get trackUnlink => '取消关联';

  @override
  String get trackStatus => '状态';

  @override
  String get trackChapters => '章节';

  @override
  String get trackScore => '评分';

  @override
  String trackLinkedTo(Object name) {
    return '已关联到 $name';
  }

  @override
  String trackLinkOn(Object name) {
    return '在 $name 关联';
  }

  @override
  String get trackSearchTitleHint => '搜索标题';

  @override
  String get trackSearch => '搜索';

  @override
  String get trackNoResults => '没有结果';

  @override
  String trackChaptersShort(Object count) {
    return '$count 章';
  }

  @override
  String trackConnectTracker(Object name) {
    return '连接 $name';
  }

  @override
  String get trackOauthInstructions => '登录并点击授权。你将自动登录。';

  @override
  String get trackServices => '服务';

  @override
  String get trackServicesDescription => '连接追踪服务以同步你的阅读进度。漫画关联后，进度会随阅读自动更新。';

  @override
  String trackLogInTo(Object name) {
    return '登录 $name';
  }

  @override
  String get trackEmailOrUsername => '邮箱或用户名';

  @override
  String get trackPassword => '密码';

  @override
  String get trackCancel => '取消';

  @override
  String get trackLogIn => '登录';

  @override
  String trackConnectedTo(Object name) {
    return '已连接到 $name';
  }

  @override
  String get trackLoginFailed => '登录失败——请检查你的凭据';

  @override
  String get trackSetClientIdFirst => '请先设置客户端 ID';

  @override
  String get trackCouldNotCompleteSignIn => '无法完成登录';

  @override
  String trackClientIdTitle(Object name) {
    return '$name 客户端 ID（高级）';
  }

  @override
  String trackClientIdDescription(Object name) {
    return '可选。Foxlations 已内置 $name 客户端 ID——直接点击连接即可。仅当你注册了自己的 $name 开发者应用并希望改用它时才设置此项。';
  }

  @override
  String get trackClientId => '客户端 ID';

  @override
  String get trackSave => '保存';

  @override
  String get trackPasteAccessToken => '粘贴访问令牌';

  @override
  String get trackPasteTokenHint => '粘贴授权后显示的令牌';

  @override
  String get trackConnect => '连接';

  @override
  String get trackCouldNotVerifyToken => '无法验证令牌';

  @override
  String get trackConnected => '已连接';

  @override
  String trackConnectedAs(Object username) {
    return '已作为 $username 连接';
  }

  @override
  String get trackTapConnectToAuthorize => '点击连接以授权';

  @override
  String get trackSignInWithAccount => '使用你的账户登录';

  @override
  String get trackDisconnect => '断开连接';

  @override
  String get trackAiTitle => 'AI 与翻译';

  @override
  String get trackTabTranslation => '翻译';

  @override
  String get trackTabApiKeys => 'API 密钥';

  @override
  String get trackTabModels => '模型';

  @override
  String get trackEnableAiTranslation => '启用 AI 翻译';

  @override
  String get trackEnableAiTranslationDesc => '在阅读器中显示翻译按钮';

  @override
  String get trackProvider => '提供方';

  @override
  String get trackOfflineMode => '离线模式';

  @override
  String get trackOfflineModeDesc => '使用已下载的模型，无需联网';

  @override
  String get trackTranslationSettings => '翻译设置';

  @override
  String get trackTargetLanguage => '目标语言';

  @override
  String get trackTargetLanguageDesc => '将漫画文本翻译成此语言';

  @override
  String get trackBubbleDetection => '对话框检测';

  @override
  String get trackBubbleDetectionDesc => '自动检测漫画页面中的对话框';

  @override
  String get trackQuality => '质量';

  @override
  String get trackQualityFast => '快速';

  @override
  String get trackQualityBalanced => '平衡';

  @override
  String get trackQualityHigh => '高质量';

  @override
  String get trackKoharuServer => 'Koharu 服务器';

  @override
  String get trackServerUrl => '服务器 URL';

  @override
  String get trackKoharuServerDesc => '通过本地 Docker 服务器进行完整漫画修复';

  @override
  String get trackApiKeyRequired => '需要 API 密钥';

  @override
  String get trackApiKeysNotice => '密钥仅存储在你的设备本地，绝不会发送到我们的服务器。';

  @override
  String get trackModelsPlatformOnly => '设备端翻译模型在 Android 和 iOS 上可用。';

  @override
  String get trackModelsDescription =>
      '下载某种语言以完全离线翻译。每个语言包约 30 MB，首次翻译该语言时也会自动获取。';

  @override
  String get trackTranslationLanguages => '翻译语言';

  @override
  String get trackDownloaded => '已下载——可离线使用';

  @override
  String get trackNotDownloaded => '未下载';

  @override
  String get trackDelete => '删除';

  @override
  String get trackDownload => '下载';

  @override
  String trackDownloadFailed(Object error) {
    return '下载失败：$error';
  }

  @override
  String trackDeleteFailed(Object error) {
    return '删除失败：$error';
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
  String get repoCancel => '取消';

  @override
  String get repoName => '名称';

  @override
  String repoImportedSource(Object id) {
    return '已导入的源 · $id';
  }

  @override
  String get repoCheckingMatches => '正在检查匹配项';

  @override
  String get repoMigrating => '正在迁移';

  @override
  String get repoMigrateThisSource => '迁移此源？';

  @override
  String repoMatchedByUrl(Object count) {
    return '$count 个按 URL 匹配';
  }

  @override
  String repoMatchedByTitle(Object count) {
    return '$count 个按标题匹配';
  }

  @override
  String repoNotFoundLeftInPlace(Object count) {
    return '$count 个未找到——保留原位';
  }

  @override
  String get repoMigrateCarryOver => '阅读进度、分类和追踪会一并转移。仅移动的条目会移除原件。';

  @override
  String repoMigrateCount(Object count) {
    return '迁移 $count 个';
  }

  @override
  String get repoMigrateASource => '迁移源';

  @override
  String get repoMigrateIntro =>
      '将一个源的所有书库条目移动到另一个源。同站互换按 URL 精确匹配；来自备份的导入条目也可以重新归入真实的源。';

  @override
  String get repoFrom => '从';

  @override
  String get repoSelectSource => '选择一个源…';

  @override
  String get repoTo => '到';

  @override
  String get repoAlsoMatchByTitle => '也按标题匹配';

  @override
  String get repoAlsoMatchByTitleHint =>
      '用于跨站移动：如果按 URL 找不到条目，则按标题在新源中搜索并取最接近的匹配。默认关闭，以免关联错误的系列。';

  @override
  String get repoMigrateSource => '迁移源';

  @override
  String get repoMigrationComplete => '迁移完成';

  @override
  String repoMovedByUrl(Object count) {
    return '$count 个按 URL 移动';
  }

  @override
  String repoMovedByTitle(Object count) {
    return '$count 个按标题移动';
  }

  @override
  String repoLeftInPlace(Object count) {
    return '$count 个保留原位';
  }

  @override
  String get repoNotMigratedHeader => '未迁移（仍在旧源上）：';

  @override
  String get repoUsePerTitleMigrate => '对这些请使用逐个标题的迁移功能。';

  @override
  String get repoDone => '完成';

  @override
  String get setdDownloadsTitle => '下载';

  @override
  String get setdDownloadsSectionAutomatic => '自动下载';

  @override
  String get setdDownloadsNewChapters => '下载新章节';

  @override
  String get setdDownloadsNewChaptersDesc => '自动下载新章节';

  @override
  String get setdDownloadsWifiOnly => '仅 Wi-Fi';

  @override
  String get setdDownloadsWifiOnlyDesc => '仅在 Wi-Fi 下下载';

  @override
  String get setdDownloadsChargingOnly => '仅充电时';

  @override
  String get setdDownloadsChargingOnlyDesc => '仅在充电时下载';

  @override
  String get setdDownloadsAhead => '阅读时提前下载';

  @override
  String get setdDownloadsAheadDesc => '阅读时预先下载下一章';

  @override
  String get setdDownloadsSectionQueue => '下载队列';

  @override
  String get setdDownloadsSimultaneous => '同时下载数';

  @override
  String get setdDownloadsQuality => '下载质量';

  @override
  String get setdDownloadsSectionDelete => '删除已下载章节';

  @override
  String get setdDownloadsAfterReading => '阅读后';

  @override
  String get setdDownloadsAfterReadingDesc => '章节读完后删除';

  @override
  String get setdDownloadsIncludeBookmarked => '包含已加书签的章节';

  @override
  String get setdDownloadsIncludeBookmarkedDesc => '连同其余章节一起删除已加书签的章节';

  @override
  String get setdDownloadsAutoDelete => '自动删除已读章节';

  @override
  String get setdDownloadsSectionFormat => '格式';

  @override
  String get setdDownloadsSaveCbz => '保存为 CBZ';

  @override
  String get setdDownloadsSaveCbzDesc => '将章节归档为带元数据的 CBZ 文件';

  @override
  String get setdDownloadsSavePdf => '保存为 PDF';

  @override
  String get setdDownloadsSavePdfDesc => '将章节打包为单个 PDF（每页一张图片）';

  @override
  String get setdDownloadsSectionLocation => '下载位置';

  @override
  String get setdDownloadsDefaultLocation => '默认位置';

  @override
  String get setdDownloadsCustomLocation => '自定义位置';

  @override
  String get setdDownloadsChooseFolder => '选择文件夹';

  @override
  String get setdDownloadsIosFolderWarning =>
      'iOS 不允许应用保持对文件夹的访问权限。下载内容会保留在应用的文件夹中，可通过 文件 › 我的 iPhone › Foxlations 访问。';

  @override
  String get setdDownloadsReset => '重置';

  @override
  String get setdDownloadsSectionStorage => '存储';

  @override
  String setdDownloadsTotalSize(Object size) {
    return '共计：$size MB';
  }

  @override
  String setdDownloadsLibraryVaultSize(Object lib, Object vault) {
    return '书库：$lib MB  |  保险库：$vault MB';
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
  String get setdVaultTitle => '保险库';

  @override
  String get setdVaultSectionAccess => '访问';

  @override
  String get setdVaultEnable => '启用保险库';

  @override
  String get setdVaultEnableDesc => '通过点击书库 8 次来访问隐藏的保险库';

  @override
  String get setdVaultSectionSecurity => '安全';

  @override
  String get setdVaultChangePassword => '更改密码';

  @override
  String get setdVaultSetPassword => '设置密码';

  @override
  String get setdVaultPasswordSetDesc => '密码已设置——点击以更改或移除';

  @override
  String get setdVaultPasswordUnsetDesc => '使用密码保护保险库访问';

  @override
  String get setdVaultSectionCategories => '保险库分类';

  @override
  String get setdVaultEditCategories => '编辑保险库分类';

  @override
  String get setdVaultEditCategoriesDesc => '添加、移除和重新排序保险库分类';

  @override
  String get setdVaultSectionContents => '内容';

  @override
  String get setdVaultManageContents => '管理保险库内容';

  @override
  String get setdVaultManageContentsDesc => '将漫画、动画或小说移入或移出保险库';

  @override
  String get setdVaultUnlockFirstSnack => '请先解锁保险库（从书库点击进入）';

  @override
  String get setdVaultSectionHiddenSources => '隐藏的源';

  @override
  String get setdVaultOnlySources => '仅保险库的源';

  @override
  String setdVaultHiddenSourcesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已隐藏 $count 个源',
    );
    return '$_temp0';
  }

  @override
  String get setdVaultSectionInfo => '信息';

  @override
  String get setdVaultInfoText =>
      '保险库是一个隐藏的书库，拥有自己的分类和漫画。快速点击书库标签页 8 次即可切换保险库模式。保险库漫画单独存储，绝不会出现在你的主书库中。';

  @override
  String get setdVaultCurrentPasswordHint => '当前密码';

  @override
  String get setdVaultNewPasswordHint => '新密码（留空以移除）';

  @override
  String get setdVaultConfirmPasswordHint => '确认新密码';

  @override
  String get setdVaultCurrentPasswordWrong => '当前密码错误';

  @override
  String get setdVaultPasswordsMismatch => '密码不匹配';

  @override
  String get setdVaultRemovingEncryption => '正在移除加密…';

  @override
  String get setdVaultEncrypting => '正在加密保险库…';

  @override
  String get setdVaultPasswordRemoved => '密码已移除——保险库不再加密';

  @override
  String get setdVaultPasswordSet => '密码已设置——保险库已加密';

  @override
  String get setdVaultNoCategories => '没有保险库分类';

  @override
  String setdVaultDeleteCategoryConfirm(Object name) {
    return '确定要删除\"$name\"吗？此分类中的漫画不会从保险库中移除。';
  }

  @override
  String get setdVaultNoInstalledSources => '没有已安装的源';

  @override
  String get setdVaultHiddenSourcesToggleHint => '切换源以使其仅在保险库模式下可见。';

  @override
  String get setdVaultSearchSourcesHint => '搜索源...';

  @override
  String get setdCategoryNameHint => '分类名称';

  @override
  String get setdNewCategory => '新建分类';

  @override
  String get setdRenameCategory => '重命名分类';

  @override
  String get setdDeleteCategory => '删除分类';

  @override
  String get setdActionCancel => '取消';

  @override
  String get setdActionSave => '保存';

  @override
  String get setdActionAdd => '添加';

  @override
  String get setdActionDelete => '删除';

  @override
  String get setdTapToAddCategory => '点击 + 添加分类';

  @override
  String get setdVaultContentsTitle => '保险库内容';

  @override
  String get setdVaultContentsLockedMessage => '请先解锁保险库以管理其内容。';

  @override
  String get setdVaultContentsTabManga => '漫画';

  @override
  String get setdVaultContentsTabAnime => '动画';

  @override
  String get setdVaultContentsTabNovels => '小说';

  @override
  String setdVaultContentsEmptyLibrary(Object type) {
    return '书库中没有$type';
  }

  @override
  String setdVaultContentsEmptyVault(Object type) {
    return '保险库中没有$type';
  }

  @override
  String setdVaultContentsMovedIn(Object title) {
    return '\"$title\"已移入保险库';
  }

  @override
  String setdVaultContentsMovedOut(Object title) {
    return '\"$title\"已移出保险库';
  }

  @override
  String setdVaultContentsReadProgress(Object read, Object total) {
    return '已读 $read/$total';
  }

  @override
  String get setdLibraryTitle => '书库';

  @override
  String get setdLibrarySectionCategories => '分类';

  @override
  String get setdLibraryEditCategories => '编辑分类';

  @override
  String get setdLibraryEditCategoriesDesc => '添加、移除和重新排序分类';

  @override
  String get setdLibraryHideEmpty => '隐藏空分类';

  @override
  String get setdLibraryHideEmptyDesc => '仅显示有漫画的分类';

  @override
  String get setdLibrarySectionGlobalUpdate => '全局更新';

  @override
  String get setdLibraryUpdateFrequency => '更新频率';

  @override
  String get setdLibraryWifiOnly => '仅 Wi-Fi';

  @override
  String get setdLibraryWifiOnlyDesc => '仅在 Wi-Fi 连接下更新';

  @override
  String get setdLibraryChargingOnly => '仅充电时';

  @override
  String get setdLibraryChargingOnlyDesc => '仅在设备充电时更新';

  @override
  String get setdLibrarySectionRestrictions => '更新限制';

  @override
  String get setdLibrarySkipNotStarted => '跳过未开始';

  @override
  String get setdLibrarySkipNotStartedDesc => '跳过没有阅读进度的漫画';

  @override
  String get setdLibraryShowUpdateCount => '显示新章节数';

  @override
  String get setdLibraryShowUpdateCountDesc => '在书库漫画卡片上显示徽标';

  @override
  String get setdLibrarySectionData => '数据';

  @override
  String get setdLibraryMigrateSource => '迁移源';

  @override
  String get setdLibraryMigrateSourceDesc => '将所有条目从一个源移动到另一个源';

  @override
  String get setdLibraryNoCategories => '没有分类';

  @override
  String setdLibraryDeleteCategoryConfirm(Object name) {
    return '确定要删除\"$name\"吗？此分类中的漫画不会从你的书库中移除。';
  }

  @override
  String get setdPlayerTitle => '播放器';

  @override
  String get setdPlayerSectionSeek => '双击快进/快退';

  @override
  String get setdPlayerSkipForward => '快进';

  @override
  String get setdPlayerSkipBackward => '快退';

  @override
  String get setdPlayerSectionGestures => '手势';

  @override
  String get setdPlayerHoldToSpeed => '长按加速';

  @override
  String setdPlayerHoldToSpeedDesc(Object speed) {
    return '在任意位置按住以 ${speed}x 播放';
  }

  @override
  String get setdPlayerHoldSpeed => '长按速度';

  @override
  String get setdPlayerVolumeSwipe => '音量滑动';

  @override
  String get setdPlayerVolumeSwipeDesc => '在右半部分上下滑动以调节音量';

  @override
  String get setdPlayerBrightnessSwipe => '亮度滑动';

  @override
  String get setdPlayerBrightnessSwipeDesc => '在左半部分上下滑动以调节亮度';

  @override
  String get setdPlayerSectionPlayback => '播放';

  @override
  String get setdPlayerDefaultSpeed => '默认速度';

  @override
  String get setdPlayerAutoplayNext => '自动播放下一集';

  @override
  String get setdPlayerAutoplayNextDesc => '一集结束后自动开始下一集';

  @override
  String get setdPlayerAutoSkipIntro => '自动跳过片头/片尾';

  @override
  String get setdPlayerAutoSkipIntroDesc => '无需点击即可跳过源标记的片头/片尾';

  @override
  String get setdPlayerSkipAmountTitle => '跳过时长';

  @override
  String get setdPlayerShowSkipButton => 'Skip-intro button';

  @override
  String get setdPlayerShowSkipButtonDesc =>
      'Show a Skip Intro button near the start, even when the source has no markers';

  @override
  String get setdPlayerSpeedTitle => '速度';

  @override
  String get setdAppearanceTitle => '外观';

  @override
  String get setdAppearanceSectionTheme => '主题';

  @override
  String get setdAppearanceSectionDisplay => '显示';

  @override
  String get setdAppearanceInvertColors => '反转颜色';

  @override
  String get setdAppearanceInvertColorsDesc => '反转整个应用界面';

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
  String get setdAppearanceDarkMode => '深色模式';

  @override
  String get setdAppearanceLightMode => '浅色模式';

  @override
  String get setdAppearanceCurrentlyDark => '当前为深色';

  @override
  String get setdAppearanceCurrentlyLight => '当前为浅色';

  @override
  String get detailStatusOngoing => '连载中';

  @override
  String get detailStatusCompleted => '已完结';

  @override
  String get detailStatusHiatus => '休刊';

  @override
  String get detailStatusCanceled => '已取消';

  @override
  String get detailStatusFinished => '已完成';

  @override
  String get detailStatusUnknown => '未知';

  @override
  String detailChapterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 章',
    );
    return '$_temp0';
  }

  @override
  String detailEpisodeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 集',
    );
    return '$_temp0';
  }

  @override
  String detailDownloadingChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '正在下载 $count 章',
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
