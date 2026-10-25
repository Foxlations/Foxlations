// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Foxlations';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsSectionApp => 'アプリ';

  @override
  String get settingsSectionManga => 'マンガ';

  @override
  String get settingsSectionSystem => 'システム';

  @override
  String get settingsLanguageTitle => '言語';

  @override
  String get settingsLanguageEntrySubtitle => 'アプリの表示言語';

  @override
  String get settingsLanguageSubtitle => 'アプリの言語を選択';

  @override
  String get settingsLanguageSystemDefault => 'システムのデフォルト';

  @override
  String get settingsLanguageHeader => 'アプリの言語';

  @override
  String get settingsAppearanceTitle => '外観';

  @override
  String get settingsAppearanceSubtitle => 'テーマ、ダークモード、表示';

  @override
  String get settingsNotificationsTitle => '通知';

  @override
  String get settingsNotificationsSubtitle => 'プッシュ通知、頻度、リマインダー';

  @override
  String get settingsStorageTitle => 'ストレージ';

  @override
  String get settingsStorageSubtitle => 'ダウンロード、保存先、同期';

  @override
  String get settingsLibraryTitle => 'ライブラリ';

  @override
  String get settingsLibrarySubtitle => 'カテゴリ、全体更新、表示';

  @override
  String get settingsReaderTitle => 'リーダー';

  @override
  String get settingsReaderSubtitle => '読書モード、表示、操作';

  @override
  String get settingsPlayerTitle => 'プレーヤー';

  @override
  String get settingsPlayerSubtitle => 'シーク、ジェスチャー、速度、自動再生';

  @override
  String get settingsDownloadsTitle => 'ダウンロード';

  @override
  String get settingsDownloadsSubtitle => '自動ダウンロード、章の削除';

  @override
  String get settingsTrackingTitle => 'トラッキング';

  @override
  String get settingsTrackingSubtitle => 'MAL、AniList、Kitsu ほか';

  @override
  String get settingsAiTitle => 'AI と翻訳';

  @override
  String get settingsAiSubtitle => 'プロバイダー、APIキー、吹き出し検出';

  @override
  String get settingsBrowseTitle => 'ブラウズ';

  @override
  String get settingsBrowseSubtitle => 'ソース、拡張機能、グローバル検索';

  @override
  String get settingsBackupTitle => 'バックアップと復元';

  @override
  String get settingsBackupSubtitle => 'バックアップの作成・復元、インポート、自動バックアップ';

  @override
  String get settingsSecurityTitle => 'セキュリティとプライバシー';

  @override
  String get settingsSecuritySubtitle => 'アプリロック、生体認証、画面のセキュリティ';

  @override
  String get settingsAdvancedTitle => '詳細設定';

  @override
  String get settingsAdvancedSubtitle => 'ネットワーク、拡張機能、ログ、データ';

  @override
  String get settingsAboutTitle => 'このアプリについて';

  @override
  String get settingsAboutSubtitle => 'バージョン、ライセンス、リンク';

  @override
  String get libraryAdd => '追加';

  @override
  String get libraryAddAnime => 'アニメを追加';

  @override
  String get libraryAddLNs => 'ラノベを追加';

  @override
  String get libraryAddManga => 'マンガを追加';

  @override
  String get libraryBadges => 'バッジ';

  @override
  String get libraryBatchMigrate => '移行';

  @override
  String get libraryBatchMove => '移動';

  @override
  String get libraryBatchRead => '既読';

  @override
  String get libraryBatchRemove => '削除';

  @override
  String get libraryBatchUnread => '未読';

  @override
  String get libraryCategoryUpdate => 'カテゴリの更新';

  @override
  String libraryCategoryUpdateDesc(Object category) {
    return '「$category」の新着をチェック';
  }

  @override
  String libraryChapterProgress(Object read, Object total) {
    return '$read/$total話';
  }

  @override
  String libraryEpisodeProgress(Object read, Object total) {
    return '$read/$total話';
  }

  @override
  String libraryChaptersAbbrev(Object n) {
    return '$n話';
  }

  @override
  String get libraryCheckForUpdates => '更新を確認';

  @override
  String get libraryClose => '閉じる';

  @override
  String get libraryCloseSearch => '検索を閉じる';

  @override
  String get libraryCompleted => '完結';

  @override
  String get libraryContinueReading => '続きを読む';

  @override
  String get libraryContinueWatching => '続きを見る';

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
    return '$days日';
  }

  @override
  String get libraryDeselectAll => 'すべて選択解除';

  @override
  String get libraryDisplayMode => '表示モード';

  @override
  String get libraryDownloaded => 'ダウンロード済み';

  @override
  String get libraryEmpty => 'ライブラリは空です';

  @override
  String get libraryEmptyDesc => 'ライブラリは空です。ソースをブラウズしてマンガを追加しましょう。';

  @override
  String libraryEmptyStatsLibrary(Object word) {
    return '$wordをライブラリに追加して読み始めると、ここに統計が表示されます。';
  }

  @override
  String libraryEmptyStatsVault(Object word) {
    return '$wordをVaultに追加して読み始めると、ここに統計が表示されます。';
  }

  @override
  String get libraryFilterSortDisplay => 'フィルター・並び替え・表示';

  @override
  String get libraryGlobalUpdate => '全体更新';

  @override
  String get libraryGlobalUpdateDesc => 'ライブラリのすべての項目をチェック';

  @override
  String get libraryHeatmapLess => '少ない';

  @override
  String get libraryHeatmapMore => '多い';

  @override
  String get libraryItemsPerRow => '1行あたりの項目数';

  @override
  String libraryLastChecked(Object when) {
    return '最終確認: $when';
  }

  @override
  String get libraryLibrary => 'ライブラリ';

  @override
  String libraryListChapters(Object read, Object total) {
    return '$read/$total話';
  }

  @override
  String get libraryMore => 'もっと見る';

  @override
  String get libraryMoveToCategory => 'カテゴリへ移動';

  @override
  String get libraryNever => '未確認';

  @override
  String get libraryNoBookmarks => 'ブックマークはありません';

  @override
  String get libraryNoBookmarksDesc => 'マンガを長押ししてブックマークすると、ここに表示されます。';

  @override
  String get libraryNoNewChaptersLastCheck => '前回の確認では新着が見つかりませんでした。';

  @override
  String get libraryNoResults => '結果なし';

  @override
  String libraryNoResultsDesc(Object query) {
    return '「$query」の結果はありません。別のキーワードで検索してください。';
  }

  @override
  String get libraryNoStatsYet => 'まだ統計がありません';

  @override
  String get libraryOpenRandomEntry => 'ランダムに開く';

  @override
  String get libraryResetToDefault => 'デフォルトに戻す';

  @override
  String get librarySave => '保存';

  @override
  String get librarySearchHint => 'ライブラリ内を検索...';

  @override
  String get librarySearchLibrary => 'ライブラリを検索';

  @override
  String get librarySelect => '選択';

  @override
  String get librarySelectAll => 'すべて選択';

  @override
  String librarySelectedCount(Object n) {
    return '$n件選択中';
  }

  @override
  String get libraryShowNumberOfItems => '項目数を表示';

  @override
  String get librarySizeMedium => '中';

  @override
  String get librarySources => 'ソース';

  @override
  String get libraryStats => '統計';

  @override
  String get libraryStatusAll => 'すべて';

  @override
  String get libraryStatusCompleted => '完結';

  @override
  String get libraryStatusDropped => '中断';

  @override
  String get libraryStatusOnHold => '保留中';

  @override
  String get libraryStatusPlanToRead => '読む予定';

  @override
  String get libraryStatusReading => '読書中';

  @override
  String get libraryStatusUnknown => '不明';

  @override
  String libraryStreakDaysStrong(Object days) {
    return '$days日継続中 — この調子！';
  }

  @override
  String get libraryTabDisplay => '表示';

  @override
  String get libraryTabFilter => 'フィルター';

  @override
  String get libraryTabSort => '並び替え';

  @override
  String get libraryTabs => 'タブ';

  @override
  String libraryTotalAbbrev(Object n) {
    return '計$n件';
  }

  @override
  String get libraryTypeMenuBarrier => 'Library type';

  @override
  String libraryTypeBreakdown(Object type) {
    return '$typeの内訳';
  }

  @override
  String get libraryUnread => '未読';

  @override
  String get libraryUpdatesSummary => '更新の概要';

  @override
  String get libraryUpdatesSummaryDesc => '前回の確認結果';

  @override
  String get libraryVault => 'Vault';

  @override
  String get libraryVaultStats => 'Vaultの統計';

  @override
  String get detailAdd => '追加';

  @override
  String get detailAddNoteHint => 'このタイトルにメモを追加…';

  @override
  String get detailAddToCategory => 'カテゴリに追加';

  @override
  String get detailAddToLibrary => 'ライブラリに追加';

  @override
  String get detailAddWithoutCategory => 'カテゴリなしで追加';

  @override
  String get detailBelowRead => 'これより下を既読';

  @override
  String get detailBelowUnread => 'これより下を未読';

  @override
  String get detailBookmark => 'ブックマーク';

  @override
  String get detailBookmarked => 'ブックマーク済み';

  @override
  String get detailCancel => 'キャンセル';

  @override
  String get detailChapterFallback => 'チャプター';

  @override
  String detailCopiedTo(Object source) {
    return '$sourceにコピーしました';
  }

  @override
  String detailCountSelected(Object count) {
    return '$count件選択中';
  }

  @override
  String get detailDeleteDownload => 'ダウンロードを削除';

  @override
  String get detailDone => '完了';

  @override
  String get detailDownload => 'ダウンロード';

  @override
  String get detailDownloadAllChapters => 'すべてのチャプター';

  @override
  String get detailDownloadAllUnread => '未読すべて';

  @override
  String get detailDownloaded => 'ダウンロード済み';

  @override
  String get detailDownloadNext10 => '次の10話';

  @override
  String get detailDownloadNext5 => '次の5話';

  @override
  String get detailDownloadNextChapter => '次の話';

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
  String get detailEditCategories => 'カテゴリを編集';

  @override
  String get detailEditCategoriesTitle => 'カテゴリを編集';

  @override
  String get detailFilter => 'フィルター';

  @override
  String get detailInProgress => '進行中';

  @override
  String get detailLogIn => 'ログイン';

  @override
  String get detailMangaNotFound => 'ライブラリにマンガが見つかりません';

  @override
  String get detailMarkAllAsRead => 'すべて既読にする';

  @override
  String get detailMarkAllAsUnread => 'すべて未読にする';

  @override
  String get detailMarkAllBelowRead => 'これより下をすべて既読にする';

  @override
  String get detailMarkAsUnread => '未読にする';

  @override
  String get detailMarkChapterAsRead => 'この話を既読にする';

  @override
  String get detailMarkRead => '既読にする';

  @override
  String get detailMarkUnread => '未読にする';

  @override
  String get detailMigrate => '移行';

  @override
  String get detailMigrateCategories => 'カテゴリ';

  @override
  String get detailMigrateChapters => 'チャプター';

  @override
  String get detailMigrateCopy => 'コピー';

  @override
  String get detailMigrateDownloadsNoTransfer => 'ダウンロード済みの話は移行されません。';

  @override
  String detailMigratedTo(Object source) {
    return '$sourceに移行しました';
  }

  @override
  String detailMigrateEntriesToSource(Object count, Object source) {
    return '$count件 → $source';
  }

  @override
  String get detailMigrateInfo => '別のソースから同じマンガを選択してください。読書の進捗が引き継がれます。';

  @override
  String get detailMigrateRemoveDownloads => '移行時にダウンロードを削除';

  @override
  String get detailMigrateSelectData => '含めるデータを選択';

  @override
  String get detailMigrateShowEntry => '項目を表示';

  @override
  String detailMigrateTitleToSource(Object title, Object source) {
    return '$title → $source';
  }

  @override
  String get detailMigrateTracking => 'トラッキング';

  @override
  String get detailMigrating => '移行中…';

  @override
  String get detailNewestFirst => '新しい順';

  @override
  String get detailNoChaptersFound => '話が見つかりません';

  @override
  String get detailNoChaptersLoginHint =>
      'このタイトルの内容を読み込めませんでした。もう一度試すか、このソースではログインするとさらに表示される場合があります。';

  @override
  String get detailNoChaptersRetryHint =>
      'このタイトルの内容を読み込めませんでした。まだ話がないか、ソース側で読み込みに問題があった可能性があります。もう一度お試しください。';

  @override
  String get detailNoResults => '結果が見つかりません';

  @override
  String get detailNotes => 'メモ';

  @override
  String get detailNothingToDownload => 'ダウンロードするものがありません';

  @override
  String get detailOldestFirst => '古い順';

  @override
  String get detailOpenInBrowser => 'ブラウザで開く';

  @override
  String get webviewOpenFailed => 'Couldn\'t open the browser';

  @override
  String detailPage(Object page) {
    return '$pageページ';
  }

  @override
  String get detailRefresh => '更新';

  @override
  String get detailRemove => '削除';

  @override
  String get detailRemoveBookmark => 'ブックマークを削除';

  @override
  String get detailRemoveFromLibrary => 'ライブラリから削除';

  @override
  String get detailRemoveFromLibraryTitle => 'ライブラリから削除しますか？';

  @override
  String get detailResume => '続きから';

  @override
  String get detailRetry => '再試行';

  @override
  String get detailSave => '保存';

  @override
  String get detailSearchChapters => 'チャプターを検索';

  @override
  String get detailSearchChaptersHint => 'チャプターを検索...';

  @override
  String get detailSearchEpisodes => 'エピソードを検索';

  @override
  String get detailSearchHint => 'マンガのタイトルを検索...';

  @override
  String get detailSearchingSources => 'ソースを検索中…';

  @override
  String get detailSelectAll => 'すべて選択';

  @override
  String get detailSelectChapters => 'チャプターを選択';

  @override
  String get detailTracking => 'トラッキング';

  @override
  String get detailUnbookmark => 'ブックマーク解除';

  @override
  String get detailUnread => '未読';

  @override
  String get detailWebView => 'WebView';

  @override
  String get appNavLibrary => 'ライブラリ';

  @override
  String get appNavUpdates => '更新';

  @override
  String get appNavBrowse => 'ブラウズ';

  @override
  String get appNavDiscover => 'Discover';

  @override
  String get appNavMore => 'その他';

  @override
  String get appNavVault => 'Vault';

  @override
  String get appUpdatesTitle => '更新';

  @override
  String get appNoNewChapters => '新着なし';

  @override
  String get appCheckForUpdates => '更新を確認';

  @override
  String get appClearAll => 'すべてクリア';

  @override
  String appCheckingProgress(Object checked, Object total) {
    return '確認中 $checked / $total...';
  }

  @override
  String appLastChecked(Object time) {
    return '最終確認: $time';
  }

  @override
  String get appNoUpdatesYet => 'まだ更新はありません';

  @override
  String get appTapRefreshForChapters => '更新をタップして新着をチェック';

  @override
  String get appCheckNow => '今すぐ確認';

  @override
  String get appJustNow => 'たった今';

  @override
  String appMinutesAgo(Object m) {
    return '$m分前';
  }

  @override
  String appHoursAgo(Object h) {
    return '$h時間前';
  }

  @override
  String appDaysAgo(Object d) {
    return '$d日前';
  }

  @override
  String get appToday => '今日';

  @override
  String get appYesterday => '昨日';

  @override
  String get appOnLatestVersion => '最新バージョンです';

  @override
  String get appUpdateAvailable => '更新があります';

  @override
  String appVersionBuild(Object version, Object build) {
    return 'v$version · ビルド $build';
  }

  @override
  String get appDownloadUpdate => '更新をダウンロード';

  @override
  String appDownloadVersion(Object version) {
    return 'v$versionをダウンロード';
  }

  @override
  String get appApkDownloadHint => 'APKのダウンロードを開きます。Androidでインストールの確認が表示されます。';

  @override
  String get appIosUpdateHint =>
      'AltStore または SideStore から更新してください — アプリを開いて更新（Refresh）します。iOSではブラウザでダウンロードしたアプリはインストールできません。';

  @override
  String get appSourceUrlCopied => 'ソースURLをコピーしました — AltStoreで追加してください';

  @override
  String get appCopyAltstoreUrl => 'AltStoreのソースURLをコピー';

  @override
  String get appBack => '戻る';

  @override
  String get appForward => '進む';

  @override
  String get appReload => '再読み込み';

  @override
  String get appDoneSaveCookies => '完了 — Cookieを保存';

  @override
  String get appVaultPassword => 'Vaultのパスワード';

  @override
  String get appEnterPassword => 'パスワードを入力';

  @override
  String get appWrongPassword => 'パスワードが違います';

  @override
  String get appCancel => 'キャンセル';

  @override
  String get appUnlock => 'ロック解除';

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
  String get readerExperimentalOnIos => 'iOSでは実験的機能';

  @override
  String get readerIosVolumeWarning =>
      'iOSには適切な音量ボタンAPIがないため、システム音量を監視して動作します — 不安定な場合があります。読書中は、再生している音声（音楽やポッドキャストなど）の音量が50%に固定され、変更できなくなります。それでも有効にしますか？';

  @override
  String get readerCancel => 'キャンセル';

  @override
  String get readerEnable => '有効にする';

  @override
  String get readerTitle => 'リーダー';

  @override
  String get readerPreferences => '設定';

  @override
  String get readerReadingMode => '読書モード';

  @override
  String get readerFontSize => '文字サイズ';

  @override
  String get readerAutoPreloadNextChapter => '次の話を自動先読み';

  @override
  String get readerAutoPreloadNextChapterSubtitle => '次の話をバックグラウンドで読み込む';

  @override
  String get readerGrayscale => 'グレースケール';

  @override
  String get readerGrayscaleSubtitle => 'ページをグレースケールで表示';

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
  String get readerInvertColors => '色を反転';

  @override
  String get readerInvertColorsSubtitle => '明暗の色を入れ替える';

  @override
  String get readerDisplay => '表示';

  @override
  String get readerScaleType => '拡大方法';

  @override
  String get readerBackgroundColor => '背景色';

  @override
  String get readerKeepScreenOn => '画面をオンのままにする';

  @override
  String get readerKeepScreenOnSubtitle => '画面が消灯しないようにする';

  @override
  String get readerShowPageNumber => 'ページ番号を表示';

  @override
  String get readerShowPageNumberSubtitle => 'ページ番号のオーバーレイを表示';

  @override
  String get readerFullscreen => '全画面表示';

  @override
  String get readerFullscreenSubtitle => '読書中はシステムバーを隠す';

  @override
  String get readerNavigation => '操作';

  @override
  String get readerNavigationLayout => '操作レイアウト';

  @override
  String get readerInvertTapZones => 'タップ領域を反転';

  @override
  String get readerInvertTapZonesSubtitle => '左右のタップ操作を入れ替える';

  @override
  String get readerVolumeKeys => '音量キー';

  @override
  String get readerVolumeKeysSubtitle => 'タップでページ送り／スクロール、長押しでスクロール（Webtoon）';

  @override
  String get readerHoldScrollSpeed => '長押しスクロールの速度';

  @override
  String get readerSourceNotInstalled => 'ソースがインストールされていません';

  @override
  String get readerSourceNotInstalledHint =>
      'This title\'s source isn\'t installed — this can happen after restoring a backup. Install it from Extensions, then try again.';

  @override
  String get readerTranslating => '翻訳中…';

  @override
  String get readerRetry => '再試行';

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
  String get readerLoadingNextChapter => '次の話を読み込み中...';

  @override
  String get readerAllCaughtUp => 'すべて読み終わりました！';

  @override
  String get readerEndOfChapter => '話の終わり';

  @override
  String get readerLatestChapterAvailable => 'これが最新の話です。';

  @override
  String get readerLoadNextChapter => '次の話を読み込む';

  @override
  String get readerBack => '戻る';

  @override
  String get readerSettings => '設定';

  @override
  String get readerAiTranslate => 'AI翻訳';

  @override
  String get readerPreviousChapter => '前の話';

  @override
  String get readerBookmark => 'ブックマーク';

  @override
  String get readerNextChapter => '次の話';

  @override
  String readerTranslationFailed(Object error) {
    return '翻訳に失敗しました: $error';
  }

  @override
  String get readerModeLtrLabel => '左から右';

  @override
  String get readerModeRtlLabel => '右から左';

  @override
  String get readerModeVerticalLabel => '縦スクロール（連続）';

  @override
  String get readerModeWebtoonLabel => 'Webtoon';

  @override
  String get readerModeLtrSubtitle => '左右をタップしてページ送り';

  @override
  String get readerModeRtlSubtitle => 'マンガ式の右から左';

  @override
  String get readerModeVerticalSubtitle => 'ページを縦にスクロール';

  @override
  String get readerModeWebtoonSubtitle => '縦長ストリップ向けに最適化';

  @override
  String get readerChapters => 'チャプター';

  @override
  String readerPageOf(int current, int total) {
    return '$current / $totalページ';
  }

  @override
  String get readerTabProvider => 'プロバイダー';

  @override
  String get readerTabTarget => '翻訳先';

  @override
  String get readerTabSource => '翻訳元';

  @override
  String get readerTabFont => 'フォント';

  @override
  String get readerFontNormal => '標準';

  @override
  String get readerFontManga => 'マンガ';

  @override
  String get readerFontNormalDesc => 'すっきりしたサンセリフ';

  @override
  String get readerFontMangaDesc => '太字のコミック風';

  @override
  String get readerFontSample => 'こんにちは世界';

  @override
  String get readerNoChapterText => '本文が見つかりません';

  @override
  String get readerReadingTitle => '読書中';

  @override
  String get readerSmallerText => '文字を小さく';

  @override
  String get readerLargerText => '文字を大きく';

  @override
  String get readerPrevious => '前へ';

  @override
  String get readerNext => '次へ';

  @override
  String get browseTitle => 'ブラウズ';

  @override
  String get browseGlobalSearch => 'グローバル検索';

  @override
  String get browseRefreshingRepos => 'リポジトリを更新中...';

  @override
  String get browseRefreshRepos => 'リポジトリを更新';

  @override
  String get browseSearch => '検索';

  @override
  String get browseAddRepo => 'リポジトリを追加';

  @override
  String get browseTabSources => 'ソース';

  @override
  String get browseTabExtensions => '拡張機能';

  @override
  String get browseTabLocal => 'ローカル';

  @override
  String get browseSearchHint => '拡張機能・ソースを検索...';

  @override
  String browseRemoveSourceConfirm(Object name) {
    return '$nameを削除しますか？';
  }

  @override
  String get browseRemoveSourceDesc =>
      'ソースがアンインストールされます。このソースのライブラリ項目は残りますが、再インストールするまで開けなくなります。';

  @override
  String get browseCancel => 'キャンセル';

  @override
  String get browseRemove => '削除';

  @override
  String get browseProvidedByThisSource => 'このソースが提供';

  @override
  String get browseCouldNotLoadOptions => 'ソースのオプションを読み込めませんでした';

  @override
  String get browseNoSourceOptions => 'このソースには独自のオプションがありません。上記の設定は引き続き適用されます。';

  @override
  String get browseBaseUrl => 'ベースURL';

  @override
  String get browseUsingSourceDefault => 'ソースのデフォルトを使用中';

  @override
  String browseBaseUrlDefault(Object url) {
    return '$url  （デフォルト）';
  }

  @override
  String get browseResetToDefault => 'デフォルトに戻す';

  @override
  String get browsePinToTop => '先頭に固定';

  @override
  String get browsePinToTopDesc => 'このソースをソース一覧の先頭に表示';

  @override
  String get browseSkipGlobalSearch => 'グローバル検索から除外';

  @override
  String get browseSkipGlobalSearchDesc => 'すべてを検索する際にこのソースを除外';

  @override
  String get browseSkipLibraryUpdates => 'ライブラリ更新から除外';

  @override
  String get browseSkipLibraryUpdatesDesc => 'このソースの新着をチェックしない';

  @override
  String get browseRequestDesktopSite => 'デスクトップ版サイトを要求';

  @override
  String get browseRequestDesktopSiteDesc =>
      'ソースが何も見つけられない、または話が表示されない場合に試してください。スマホには簡易版ページを返すサイトがあります';

  @override
  String get browseSave => '保存';

  @override
  String get browseNone => 'なし';

  @override
  String browseSelectedCount(Object count) {
    return '$count件選択中';
  }

  @override
  String get browseNotSet => '未設定';

  @override
  String get browseIosFolderWarning =>
      'iOSではアプリがフォルダへのアクセスを保持できません。代わりに「ファイルをインポート」で .cbz/.cbr/.zip/.epub/.pdf を追加してください。';

  @override
  String browseImportedFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件のファイルをインポートしました',
    );
    return '$_temp0';
  }

  @override
  String get browseNothingImported => 'インポートできませんでした（非対応または読み取り不可）';

  @override
  String browseFolderCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個のフォルダ',
    );
    return '$_temp0';
  }

  @override
  String get browseManageFolders => 'フォルダを管理';

  @override
  String get browseImportFileTooltip => 'ファイルをインポート（CBZ/ZIP/EPUB/PDF）';

  @override
  String get browseAddFolder => 'フォルダを追加';

  @override
  String get browseRescan => '再スキャン';

  @override
  String get browseNothingImportedYet => 'まだインポートされていません';

  @override
  String get browseNoLocalSources => 'ローカルソースがありません';

  @override
  String get browseLocalSourcesDesc =>
      'マンガのフォルダを追加するか、単一ファイルをインポートしてください。\n対応形式: 画像（JPG、PNG、WebP、GIF）、CBZ/ZIP、EPUB、PDF。\n（CBR/RARは実際にZIP形式で圧縮されている場合のみ対応 — 本来のRARは非対応です。）';

  @override
  String get browseAddFolderButton => 'フォルダを追加';

  @override
  String get browseImportFile => 'ファイルをインポート';

  @override
  String get browseLocalSourceFolders => 'ローカルソースのフォルダ';

  @override
  String get browseNoFoldersAdded => 'フォルダが追加されていません';

  @override
  String browseChaptersAbbrev(Object n) {
    return '$n話';
  }

  @override
  String get browseInstalled => 'インストール済み';

  @override
  String get browseAvailable => '利用可能';

  @override
  String get browseSourceNotInstalled => 'ソースがインストールされていません';

  @override
  String get browseManga => 'マンガ';

  @override
  String get browseAnime => 'アニメ';

  @override
  String get browseNovels => '小説';

  @override
  String get browseAllLanguages => 'すべての言語';

  @override
  String get browseFilter => 'フィルター';

  @override
  String browseLanguagesCount(Object count) {
    return '$count言語';
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
      other: '$count件の結果',
    );
    return '$_temp0';
  }

  @override
  String get browseNoExtensions => 'まだ拡張機能がありません';

  @override
  String get browseNoExtensionsDesc => '上の設定ボタンからリポジトリを追加して\n拡張機能をブラウズしてください。';

  @override
  String browseUpdatedSources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個のソースを更新しました',
    );
    return '$_temp0';
  }

  @override
  String get browseSourceUpdated => 'ソースを更新しました';

  @override
  String get browseNoUpdateAvailable => '更新はありません';

  @override
  String browseUpdateFailed(Object error) {
    return '更新に失敗しました: $error';
  }

  @override
  String browseRefreshFailed(Object error) {
    return '更新に失敗しました: $error';
  }

  @override
  String browseUpdatesAvailable(Object count) {
    return '更新あり（$count）';
  }

  @override
  String get browseUpdateAll => 'すべて更新';

  @override
  String get browseUpdate => '更新';

  @override
  String get browseSettings => '設定';

  @override
  String get browseInstall => 'インストール';

  @override
  String get browseInstalledBadge => 'インストール済み';

  @override
  String get browseAbout => '詳細';

  @override
  String browseSourceFrom(Object url) {
    return '$urlのソース';
  }

  @override
  String browseLanguageLabel(Object lang) {
    return '言語: $lang';
  }

  @override
  String get browseUsesCloudflare => 'Cloudflare保護を使用';

  @override
  String get browseNoCloudflare => 'Cloudflareなし';

  @override
  String get browseAdultContent => '18+コンテンツ';

  @override
  String get browseSafeForWork => '全年齢対象';

  @override
  String get browseFeatures => '機能';

  @override
  String get browsePopular => '人気';

  @override
  String get browseLatest => '新着';

  @override
  String browseSourceAction(Object name) {
    return '$nameをブラウズ';
  }

  @override
  String get browseRemoving => '削除中...';

  @override
  String get browseInstalling => 'インストール中...';

  @override
  String browseFailed(Object error) {
    return '失敗: $error';
  }

  @override
  String get browseNoLanguagesMatch => 'No languages match';

  @override
  String get browseYourLanguages => 'Your languages';

  @override
  String get browseSearchLanguages => 'Search languages';

  @override
  String get browseUpdating => '更新中...';

  @override
  String get browseUpdateExtensionCode => '拡張機能のコードを更新';

  @override
  String browseUpdatedSource(Object name) {
    return '$nameを更新しました';
  }

  @override
  String get browsePinned => '固定済み';

  @override
  String get browseAll => 'すべて';

  @override
  String get browseNoInstalledSources => 'インストール済みのソースがありません';

  @override
  String get browseNoInstalledSourcesDesc =>
      '拡張機能タブから拡張機能をインストールすると\nここにソースが表示されます。';

  @override
  String get browseUnpin => '固定を解除';

  @override
  String get browsePin => '固定';

  @override
  String get browseSourceNotInstalledBody => 'ソースがインストールされていません';

  @override
  String get browseBypassingCloudflare => 'Cloudflare保護を回避中...';

  @override
  String get browseOpenInWebView => 'WebViewで開く';

  @override
  String get browseCloudflareProtection => 'Cloudflare保護';

  @override
  String get browseFailedToLoad => '読み込みに失敗しました';

  @override
  String get browseCloudflareChallengeDesc =>
      'このソースを利用するには、まずブラウザでCloudflareのチェックを通過する必要があります。';

  @override
  String get browseSolveCloudflare => 'Cloudflareを解決';

  @override
  String get browseRetry => '再試行';

  @override
  String get browseContentAnime => 'アニメ';

  @override
  String get browseContentNovels => 'ライトノベル';

  @override
  String get browseContentManga => 'マンガ';

  @override
  String browseNoContentFound(Object noun) {
    return '$nounが見つかりません';
  }

  @override
  String get browseAllCategories => 'すべてのカテゴリ';

  @override
  String get browseNoCategories => 'カテゴリがありません';

  @override
  String get browseSearchMangaHint => 'マンガを検索...';

  @override
  String get browseUnknown => '不明';

  @override
  String get browseSearchAllSourcesHint => 'すべてのソースを横断検索...';

  @override
  String get browseNoSourcesInstalled => 'ソースがインストールされていません';

  @override
  String get browseNoSourcesInstalledDesc => 'ブラウズタブから拡張機能をインストールしてください。';

  @override
  String get browseSearchAllSources => 'すべてのソースを検索';

  @override
  String browseSearchSourcesAtOnce(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個のソースを一度に検索します。',
    );
    return '$_temp0';
  }

  @override
  String browseSearchingSources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個のソースを検索中...',
    );
    return '$_temp0';
  }

  @override
  String get browseSeeAll => 'すべて見る';

  @override
  String get globalSearchSourceNoResults => 'No results';

  @override
  String get globalSearchSourceFailed => 'Couldn\'t search this source';

  @override
  String get browseSectionSources => 'ソース';

  @override
  String get browseShowNsfw => 'NSFWソースを表示';

  @override
  String get browseShowNsfwDesc => 'ブラウズと検索で18+ソースを表示';

  @override
  String get browsePinnedOnly => '固定したソースのみ';

  @override
  String get browsePinnedOnlyBrowseDesc => 'ブラウズで固定したソースのみ表示';

  @override
  String get browseSectionGlobalSearch => 'グローバル検索';

  @override
  String get browsePinnedOnlyGlobalSearchDesc => 'グローバル検索で固定したソースのみ検索';

  @override
  String get browseSectionWebView => 'WebView';

  @override
  String get browseAdBlocker => '広告ブロッカー';

  @override
  String get browseAdBlockerDesc => 'ブラウザで広告・ポップアップ・オーバーレイをブロック';

  @override
  String get browseSectionExtensions => '拡張機能';

  @override
  String get browseAutoUpdate => '拡張機能を自動更新';

  @override
  String get browseAutoUpdateDesc => 'アプリ起動時にインストール済み拡張機能のコードを更新';

  @override
  String get setxAdvancedTitle => '詳細設定';

  @override
  String get setxAdvancedSectionLogging => 'ログ';

  @override
  String get setxAdvancedVerboseLoggingTitle => '詳細ログ';

  @override
  String get setxAdvancedVerboseLoggingSubtitle => '詳細なデバッグ情報を記録';

  @override
  String get setxAdvancedViewErrorLogsTitle => 'エラーログを表示';

  @override
  String get setxAdvancedViewErrorLogsSubtitle => 'デバッグ・エラーログを閲覧';

  @override
  String get setxAdvancedSectionNetwork => 'ネットワーク';

  @override
  String get setxAdvancedDnsOverHttpsTitle => 'DNS over HTTPS';

  @override
  String get setxAdvancedDnsOverHttpsSubtitle => 'セキュアなDNS解決を使用';

  @override
  String get setxAdvancedDnsProviderTitle => 'DNSプロバイダー';

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
  String get setxAdvancedSectionExtensions => '拡張機能';

  @override
  String get setxAdvancedThirdPartyTitle => 'サードパーティ拡張機能';

  @override
  String get setxAdvancedThirdPartySubtitle => '不明なソースからの拡張機能を許可';

  @override
  String get setxAdvancedExtUpdateTitle => '拡張機能の更新通知';

  @override
  String get setxAdvancedExtUpdateSubtitle => '拡張機能に更新があるときに通知';

  @override
  String get setxAdvancedSectionBrowser => 'ブラウザ';

  @override
  String get setxAdvancedExternalBrowserTitle => '外部ブラウザ';

  @override
  String get setxAdvancedExternalBrowserSubtitle => 'リンクをシステムのブラウザで開く';

  @override
  String get setxAdvancedSectionData => 'データ';

  @override
  String get setxAdvancedClearCacheTitle => 'チャプターキャッシュを消去';

  @override
  String get setxAdvancedClearCacheSubtitle => 'ストレージの空き容量を増やす';

  @override
  String get setxAdvancedClearDbEntryTitle => 'データベースを消去';

  @override
  String get setxAdvancedClearDbEntrySubtitle => 'ライブラリ、カテゴリ、読書履歴をリセット';

  @override
  String get setxAdvancedCacheCleared => 'チャプター画像のキャッシュを消去しました';

  @override
  String get setxAdvancedClearDbTitle => 'データベースを消去しますか？';

  @override
  String get setxAdvancedClearDbBody =>
      'ライブラリ、カテゴリ、読書履歴が完全に削除されます。インストール済みの拡張機能とダウンロードには影響しません。';

  @override
  String get setxAdvancedCancel => 'キャンセル';

  @override
  String get setxAdvancedClear => '消去';

  @override
  String get setxAdvancedDbCleared => 'データベースを消去しました — アプリを再起動するとデフォルトが再作成されます';

  @override
  String get setxAdvancedErrorLogsTitle => 'エラーログ';

  @override
  String get setxAdvancedClearAllLogsTooltip => 'すべてのログを消去';

  @override
  String get setxAdvancedFilterCategory => 'カテゴリ';

  @override
  String get setxAdvancedFilterLevel => 'レベル';

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
  String get setxAdvancedNoLogs => 'まだログがありません';

  @override
  String get setxAdvancedNoLogsSubtitle => 'アプリを使うとここにログが表示されます';

  @override
  String get setxAdvancedClearLogsTitle => 'すべてのログを消去しますか？';

  @override
  String get setxAdvancedClearLogsBody => '保存されているすべてのログエントリが完全に削除されます。';

  @override
  String get setxAdvancedLogsCleared => 'ログを消去しました';

  @override
  String get setxAdvancedCopiedToClipboard => 'クリップボードにコピーしました';

  @override
  String get setxNotifTitle => '通知';

  @override
  String get setxNotifSectionChapterUpdates => 'チャプターの更新';

  @override
  String get setxNotifNewChaptersTitle => '新着チャプター';

  @override
  String get setxNotifNewChaptersSubtitle => '新しい話が利用可能になったときに通知';

  @override
  String get setxNotifLibraryUpdatesTitle => 'ライブラリの更新';

  @override
  String get setxNotifLibraryUpdatesSubtitle => 'ライブラリの更新完了後に通知';

  @override
  String get setxNotifSectionDownloads => 'ダウンロード';

  @override
  String get setxNotifDownloadCompleteTitle => 'ダウンロード完了';

  @override
  String get setxNotifDownloadCompleteSubtitle => '話のダウンロードが完了したときに通知';

  @override
  String get setxNotifDownloadErrorTitle => 'ダウンロードエラー';

  @override
  String get setxNotifDownloadErrorSubtitle => 'ダウンロードが失敗したときに通知';

  @override
  String get setxNotifSectionBehavior => '動作';

  @override
  String get setxNotifSoundTitle => 'サウンド';

  @override
  String get setxNotifSoundSubtitle => '通知音を鳴らす';

  @override
  String get setxNotifVibrationTitle => 'バイブレーション';

  @override
  String get setxNotifVibrationSubtitle => '通知時に振動する';

  @override
  String get setxNotifGroupTitle => '通知をグループ化';

  @override
  String get setxNotifGroupSubtitle => '複数の通知をまとめる';

  @override
  String get setxSecurityTitle => 'セキュリティとプライバシー';

  @override
  String get setxSecuritySectionAppLock => 'アプリロック';

  @override
  String get setxSecurityAppLockTitle => 'アプリロック';

  @override
  String get setxSecurityAppLockSubtitle => 'アプリを開くのに認証を要求';

  @override
  String get setxSecurityBiometricsTitle => '生体認証';

  @override
  String get setxSecurityBiometricsSubtitle => '指紋または顔認証でロック解除';

  @override
  String get setxSecuritySectionPrivacy => 'プライバシー';

  @override
  String get setxSecurityIncognitoTitle => 'Incognito mode';

  @override
  String get setxSecurityIncognitoSubtitle =>
      'Don\'t save reading history or update trackers';

  @override
  String get libraryIncognitoActive => 'Incognito mode on';

  @override
  String get setxSecuritySecureScreenTitle => '画面を保護';

  @override
  String get setxSecuritySecureScreenSubtitle => '最近使ったアプリでコンテンツを隠す';

  @override
  String get setxSecurityHideNotifTitle => '通知内容を隠す';

  @override
  String get setxSecurityHideNotifSubtitle => '一般的な通知テキストを表示';

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
  String get setxBackupTitle => 'バックアップと復元';

  @override
  String get setxBackupSectionFoxlations => 'Foxlationsバックアップ';

  @override
  String get setxBackupCreateTitle => 'バックアップを作成';

  @override
  String get setxBackupCreateSubtitle => 'ライブラリ、カテゴリ、読書の進捗、ソース、トラッキングを保存';

  @override
  String get setxBackupRestoreTitle => 'バックアップを復元';

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
  String get setxBackupRestoreSubtitle => 'Foxlationsの .fxbackup ファイルから復元';

  @override
  String get setxBackupSectionTachiyomi => 'Tachiyomi / Mihon とフォーク';

  @override
  String get setxBackupCreateCompatTitle => '互換バックアップを作成';

  @override
  String get setxBackupCreateCompatSubtitle =>
      'Tachiyomi、Mihon、フォークにインポートできる .tachibk を書き出す';

  @override
  String get setxBackupRestoreTachiyomiTitle => 'Tachiyomi/Mihonから復元';

  @override
  String get setxBackupRestoreTachiyomiSubtitle =>
      '.tachibk / .tmb / .proto.gz バックアップをインポート（ソースは名前で照合）';

  @override
  String get setxBackupSectionAutomatic => '自動バックアップ';

  @override
  String get setxBackupFrequency => '頻度';

  @override
  String setxBackupAutoSubtitle(Object freq) {
    return '$freqに自動でバックアップを作成';
  }

  @override
  String setxBackupSectionBackups(Object count) {
    return 'バックアップ（$count）';
  }

  @override
  String get setxBackupNone => 'まだバックアップがありません。';

  @override
  String get setxBackupMenuRestore => '復元';

  @override
  String get setxBackupMenuDelete => '削除';

  @override
  String get setxBackupFreqOff => 'オフ';

  @override
  String get setxBackupFreqDaily => '毎日';

  @override
  String get setxBackupFreqWeekly => '毎週';

  @override
  String get setxBackupFreqMonthly => '毎月';

  @override
  String setxBackupImportedManga(Object count) {
    return '$count件のマンガをインポートしました';
  }

  @override
  String get setxBackupRestoreComplete => '復元が完了しました';

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
    return '復元に失敗しました: $error';
  }

  @override
  String get setxAboutTitle => 'このアプリについて';

  @override
  String get setxAboutSectionApp => 'アプリ';

  @override
  String get setxAboutWhatsNewTitle => '新機能';

  @override
  String get setxAboutWhatsNewSubtitle => '変更履歴とリリースノート';

  @override
  String get setxAboutCheckUpdatesTitle => '更新を確認';

  @override
  String get setxAboutCheckUpdatesSubtitle => '新しいビルドがリリースされているか確認';

  @override
  String get setxAboutSectionLegal => '法的情報';

  @override
  String get setxAboutLicensesTitle => 'ライセンス';

  @override
  String get setxAboutLicensesSubtitle => 'オープンソースライセンス';

  @override
  String get setxAboutSectionLinks => 'リンク';

  @override
  String get setxAboutSourceCodeTitle => 'ソースコード';

  @override
  String get setxAboutSourceCodeSubtitle => 'タップしてGitHub URLをコピー';

  @override
  String get setxAboutReportBugTitle => 'バグを報告';

  @override
  String get setxAboutReportBugSubtitle => 'タップしてIssueトラッカーのURLをコピー';

  @override
  String get setxAboutClose => '閉じる';

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
    return 'v$versionの新機能';
  }

  @override
  String setxAboutLinkCopied(Object label) {
    return '$labelのリンクをクリップボードにコピーしました';
  }

  @override
  String get setxAboutSourceCodeLabel => 'ソースコード';

  @override
  String get setxAboutBugReportLabel => 'バグ報告';

  @override
  String get miscResumePlaybackTitle => '再生を再開しますか？';

  @override
  String miscStoppedWatchingAt(Object time) {
    return '$timeで視聴を中断しました。';
  }

  @override
  String get miscStartOver => '最初から';

  @override
  String miscContinueAt(Object time) {
    return '続きから（$time）';
  }

  @override
  String get miscQuality => '画質';

  @override
  String miscSourceIndex(Object index) {
    return 'ソース $index';
  }

  @override
  String get miscSubtitles => '字幕';

  @override
  String get miscSubtitleOff => 'オフ';

  @override
  String get miscUnknownTrack => '不明';

  @override
  String get miscSubtitleDelay => '字幕の遅延';

  @override
  String get miscAudio => '音声';

  @override
  String get miscPlaybackSpeed => '再生速度';

  @override
  String get miscSkipOutro => 'エンディングをスキップ';

  @override
  String get miscSkipIntro => 'イントロをスキップ';

  @override
  String get miscUnlockControls => '操作をロック解除';

  @override
  String get miscUnknownError => '不明なエラー';

  @override
  String get miscRetry => '再試行';

  @override
  String get miscExtensionRepositories => '拡張機能リポジトリ';

  @override
  String get miscRepositoryUrlHint => 'リポジトリURL（index.json）';

  @override
  String get miscAdd => '追加';

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
  String get miscRepositoriesHeader => 'リポジトリ';

  @override
  String get miscNoReposYet => 'まだリポジトリが追加されていません';

  @override
  String miscFailedToAddRepo(Object error) {
    return 'リポジトリの追加に失敗しました: $error';
  }

  @override
  String get miscVerifyHuman => '人間であることを確認';

  @override
  String get miscCfInstructions =>
      '以下のサイトのチェックを完了してください。自動的に閉じ、認証が有効な間は再度求められません。';

  @override
  String get trackTitle => 'トラッキング';

  @override
  String get trackNoTrackerConnected => 'トラッカーが接続されていません';

  @override
  String get trackConnectHint =>
      '設定 › トラッキング で AniList、MyAnimeList、Kitsu を接続してください。';

  @override
  String trackNotLinkedOn(Object name) {
    return '$nameでリンクされていません';
  }

  @override
  String get trackLink => 'リンク';

  @override
  String get trackUnlink => 'リンク解除';

  @override
  String get trackStatus => 'ステータス';

  @override
  String get trackChapters => 'チャプター';

  @override
  String get trackScore => 'スコア';

  @override
  String trackLinkedTo(Object name) {
    return '$nameにリンク済み';
  }

  @override
  String trackLinkOn(Object name) {
    return '$nameでリンク';
  }

  @override
  String get trackSearchTitleHint => 'タイトルを検索';

  @override
  String get trackSearch => '検索';

  @override
  String get trackNoResults => '結果なし';

  @override
  String trackChaptersShort(Object count) {
    return '$count話';
  }

  @override
  String trackConnectTracker(Object name) {
    return '$nameを接続';
  }

  @override
  String get trackOauthInstructions =>
      'ログインして「承認（Authorize）」を押してください。自動的にサインインされます。';

  @override
  String get trackServices => 'サービス';

  @override
  String get trackServicesDescription =>
      'トラッキングサービスを接続すると、読書の進捗を同期できます。マンガをリンクすると、読むたびに進捗が自動更新されます。';

  @override
  String trackLogInTo(Object name) {
    return '$nameにログイン';
  }

  @override
  String get trackEmailOrUsername => 'メールアドレスまたはユーザー名';

  @override
  String get trackPassword => 'パスワード';

  @override
  String get trackCancel => 'キャンセル';

  @override
  String get trackLogIn => 'ログイン';

  @override
  String trackConnectedTo(Object name) {
    return '$nameに接続しました';
  }

  @override
  String get trackLoginFailed => 'ログインに失敗しました — 認証情報を確認してください';

  @override
  String get trackSetClientIdFirst => '先にクライアントIDを設定してください';

  @override
  String get trackCouldNotCompleteSignIn => 'サインインを完了できませんでした';

  @override
  String trackClientIdTitle(Object name) {
    return '$nameのクライアントID（詳細設定）';
  }

  @override
  String trackClientIdDescription(Object name) {
    return '任意。Foxlationsには$nameのクライアントIDが組み込まれています — 「接続」をタップするだけです。自分で登録した$nameの開発者アプリを使いたい場合のみ設定してください。';
  }

  @override
  String get trackClientId => 'クライアントID';

  @override
  String get trackSave => '保存';

  @override
  String get trackPasteAccessToken => 'アクセストークンを貼り付け';

  @override
  String get trackPasteTokenHint => '承認後に表示されるトークンを貼り付けてください';

  @override
  String get trackConnect => '接続';

  @override
  String get trackCouldNotVerifyToken => 'トークンを検証できませんでした';

  @override
  String get trackConnected => '接続済み';

  @override
  String trackConnectedAs(Object username) {
    return '$usernameとして接続中';
  }

  @override
  String get trackTapConnectToAuthorize => '「接続」をタップして承認';

  @override
  String get trackSignInWithAccount => 'アカウントでサインイン';

  @override
  String get trackDisconnect => '接続を解除';

  @override
  String get trackAiTitle => 'AIと翻訳';

  @override
  String get trackTabTranslation => '翻訳';

  @override
  String get trackTabApiKeys => 'APIキー';

  @override
  String get trackTabModels => 'モデル';

  @override
  String get trackEnableAiTranslation => 'AI翻訳を有効にする';

  @override
  String get trackEnableAiTranslationDesc => 'リーダーに翻訳ボタンを表示';

  @override
  String get trackProvider => 'プロバイダー';

  @override
  String get trackOfflineMode => 'オフラインモード';

  @override
  String get trackOfflineModeDesc => 'インターネットなしでダウンロード済みモデルを使用';

  @override
  String get trackTranslationSettings => '翻訳設定';

  @override
  String get trackTargetLanguage => '翻訳先の言語';

  @override
  String get trackTargetLanguageDesc => 'マンガのテキストをこの言語に翻訳';

  @override
  String get trackBubbleDetection => '吹き出し検出';

  @override
  String get trackBubbleDetectionDesc => 'マンガページの吹き出しを自動検出';

  @override
  String get trackQuality => '品質';

  @override
  String get trackQualityFast => '高速';

  @override
  String get trackQualityBalanced => 'バランス';

  @override
  String get trackQualityHigh => '高品質';

  @override
  String get trackKoharuServer => 'Koharuサーバー';

  @override
  String get trackServerUrl => 'サーバーURL';

  @override
  String get trackKoharuServerDesc => 'ローカルDockerサーバーによる完全なマンガのインペインティング';

  @override
  String get trackApiKeyRequired => 'APIキーが必要です';

  @override
  String get trackApiKeysNotice => 'キーはデバイス内にローカル保存され、当社のサーバーに送信されることはありません。';

  @override
  String get trackModelsPlatformOnly => 'オンデバイス翻訳モデルはAndroidとiOSで利用できます。';

  @override
  String get trackModelsDescription =>
      '言語をダウンロードすると完全オフラインで翻訳できます。各パックは約30MBで、その言語を初めて翻訳する際に自動で取得されます。';

  @override
  String get trackTranslationLanguages => '翻訳言語';

  @override
  String get trackDownloaded => 'ダウンロード済み — オフラインで利用可能';

  @override
  String get trackNotDownloaded => '未ダウンロード';

  @override
  String get trackDelete => '削除';

  @override
  String get trackDownload => 'ダウンロード';

  @override
  String trackDownloadFailed(Object error) {
    return 'ダウンロードに失敗しました: $error';
  }

  @override
  String trackDeleteFailed(Object error) {
    return '削除に失敗しました: $error';
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
  String get repoCancel => 'キャンセル';

  @override
  String get repoName => '名前';

  @override
  String repoImportedSource(Object id) {
    return 'インポートしたソース · $id';
  }

  @override
  String get repoCheckingMatches => '一致を確認中';

  @override
  String get repoMigrating => '移行中';

  @override
  String get repoMigrateThisSource => 'このソースを移行しますか？';

  @override
  String repoMatchedByUrl(Object count) {
    return '$count件がURLで一致';
  }

  @override
  String repoMatchedByTitle(Object count) {
    return '$count件がタイトルで一致';
  }

  @override
  String repoNotFoundLeftInPlace(Object count) {
    return '$count件が見つからず — そのまま残しました';
  }

  @override
  String get repoMigrateCarryOver =>
      '読書の進捗、カテゴリ、トラッキングは引き継がれます。移動する項目のみ元の項目が削除されます。';

  @override
  String repoMigrateCount(Object count) {
    return '$count件を移行';
  }

  @override
  String get repoMigrateASource => 'ソースを移行';

  @override
  String get repoMigrateIntro =>
      'あるソースから別のソースへ、すべてのライブラリ項目を移動します。同一サイト間の入れ替えはURLで正確に一致し、バックアップからインポートした項目も実際のソースに再割り当てできます。';

  @override
  String get repoFrom => '移行元';

  @override
  String get repoSelectSource => 'ソースを選択…';

  @override
  String get repoTo => '移行先';

  @override
  String get repoAlsoMatchByTitle => 'タイトルでも照合';

  @override
  String get repoAlsoMatchByTitleHint =>
      'サイト間移動用: URLで項目が見つからない場合、新しいソースをタイトルで検索し、最も近いものを採用します。誤ったシリーズに紐づかないよう既定ではオフです。';

  @override
  String get repoMigrateSource => 'ソースを移行';

  @override
  String get repoMigrationComplete => '移行が完了しました';

  @override
  String repoMovedByUrl(Object count) {
    return '$count件をURLで移動';
  }

  @override
  String repoMovedByTitle(Object count) {
    return '$count件をタイトルで移動';
  }

  @override
  String repoLeftInPlace(Object count) {
    return '$count件をそのまま残しました';
  }

  @override
  String get repoNotMigratedHeader => '未移行（旧ソースのまま）:';

  @override
  String get repoUsePerTitleMigrate => 'これらはタイトルごとの移行を使用してください。';

  @override
  String get repoDone => '完了';

  @override
  String get setdDownloadsTitle => 'ダウンロード';

  @override
  String get setdDownloadsSectionAutomatic => '自動ダウンロード';

  @override
  String get setdDownloadsNewChapters => '新着チャプターをダウンロード';

  @override
  String get setdDownloadsNewChaptersDesc => '新しい話を自動的にダウンロード';

  @override
  String get setdDownloadsWifiOnly => 'Wi-Fiのみ';

  @override
  String get setdDownloadsWifiOnlyDesc => 'Wi-Fi接続時のみダウンロード';

  @override
  String get setdDownloadsChargingOnly => '充電中のみ';

  @override
  String get setdDownloadsChargingOnlyDesc => '充電中のみダウンロード';

  @override
  String get setdDownloadsAhead => '読書中に先読みダウンロード';

  @override
  String get setdDownloadsAheadDesc => '読書中に次の話を事前ダウンロード';

  @override
  String get setdDownloadsSectionQueue => 'ダウンロードキュー';

  @override
  String get setdDownloadsSimultaneous => '同時ダウンロード数';

  @override
  String get setdDownloadsQuality => 'ダウンロード品質';

  @override
  String get setdDownloadsSectionDelete => 'ダウンロード済みチャプターを削除';

  @override
  String get setdDownloadsAfterReading => '読了後';

  @override
  String get setdDownloadsAfterReadingDesc => '読み終わった話を削除';

  @override
  String get setdDownloadsIncludeBookmarked => 'ブックマークした話も含める';

  @override
  String get setdDownloadsIncludeBookmarkedDesc => 'ブックマークした話も一緒に削除';

  @override
  String get setdDownloadsAutoDelete => '読了した話を自動削除';

  @override
  String get setdDownloadsSectionFormat => '形式';

  @override
  String get setdDownloadsSaveCbz => 'CBZで保存';

  @override
  String get setdDownloadsSaveCbzDesc => 'メタデータ付きのCBZファイルとして章をアーカイブ';

  @override
  String get setdDownloadsSavePdf => 'PDFで保存';

  @override
  String get setdDownloadsSavePdfDesc => '章を1つのPDFにまとめる（1ページに1画像）';

  @override
  String get setdDownloadsSectionLocation => 'ダウンロード先';

  @override
  String get setdDownloadsDefaultLocation => 'デフォルトの場所';

  @override
  String get setdDownloadsCustomLocation => 'カスタムの場所';

  @override
  String get setdDownloadsChooseFolder => 'フォルダを選択';

  @override
  String get setdDownloadsIosFolderWarning =>
      'iOSではアプリがフォルダへのアクセスを保持できません。ダウンロードはアプリのフォルダ内に保存され、ファイル › iPhone内 › Foxlations からアクセスできます。';

  @override
  String get setdDownloadsReset => 'リセット';

  @override
  String get setdDownloadsSectionStorage => 'ストレージ';

  @override
  String setdDownloadsTotalSize(Object size) {
    return '合計: $size MB';
  }

  @override
  String setdDownloadsLibraryVaultSize(Object lib, Object vault) {
    return 'ライブラリ: $lib MB  |  Vault: $vault MB';
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
  String get setdVaultSectionAccess => 'アクセス';

  @override
  String get setdVaultEnable => 'Vaultを有効にする';

  @override
  String get setdVaultEnableDesc => 'ライブラリを8回タップして隠しVaultにアクセスできるようにする';

  @override
  String get setdVaultSectionSecurity => 'セキュリティ';

  @override
  String get setdVaultChangePassword => 'パスワードを変更';

  @override
  String get setdVaultSetPassword => 'パスワードを設定';

  @override
  String get setdVaultPasswordSetDesc => 'パスワードが設定されています — タップして変更または削除';

  @override
  String get setdVaultPasswordUnsetDesc => 'パスワードでVaultへのアクセスを保護';

  @override
  String get setdVaultSectionCategories => 'Vaultのカテゴリ';

  @override
  String get setdVaultEditCategories => 'Vaultのカテゴリを編集';

  @override
  String get setdVaultEditCategoriesDesc => 'Vaultカテゴリの追加、削除、並べ替え';

  @override
  String get setdVaultSectionContents => 'コンテンツ';

  @override
  String get setdVaultManageContents => 'Vaultのコンテンツを管理';

  @override
  String get setdVaultManageContentsDesc => 'マンガ、アニメ、小説をVaultに出し入れ';

  @override
  String get setdVaultUnlockFirstSnack =>
      '先にVaultのロックを解除してください（ライブラリからタップして入ります）';

  @override
  String get setdVaultSectionHiddenSources => '非表示ソース';

  @override
  String get setdVaultOnlySources => 'Vault専用ソース';

  @override
  String setdVaultHiddenSourcesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個のソースを非表示',
    );
    return '$_temp0';
  }

  @override
  String get setdVaultSectionInfo => '情報';

  @override
  String get setdVaultInfoText =>
      'Vaultは独自のカテゴリとマンガを持つ隠しライブラリです。ライブラリタブを素早く8回タップするとVaultモードを切り替えられます。Vaultのマンガは別に保存され、メインライブラリには表示されません。';

  @override
  String get setdVaultCurrentPasswordHint => '現在のパスワード';

  @override
  String get setdVaultNewPasswordHint => '新しいパスワード（空欄で削除）';

  @override
  String get setdVaultConfirmPasswordHint => '新しいパスワードを確認';

  @override
  String get setdVaultCurrentPasswordWrong => '現在のパスワードが違います';

  @override
  String get setdVaultPasswordsMismatch => 'パスワードが一致しません';

  @override
  String get setdVaultRemovingEncryption => '暗号化を解除中…';

  @override
  String get setdVaultEncrypting => 'Vaultを暗号化中…';

  @override
  String get setdVaultPasswordRemoved => 'パスワードを削除しました — Vaultの暗号化が解除されました';

  @override
  String get setdVaultPasswordSet => 'パスワードを設定しました — Vaultを暗号化しました';

  @override
  String get setdVaultNoCategories => 'Vaultカテゴリがありません';

  @override
  String setdVaultDeleteCategoryConfirm(Object name) {
    return '「$name」を削除してもよろしいですか？このカテゴリのマンガはVaultから削除されません。';
  }

  @override
  String get setdVaultNoInstalledSources => 'インストール済みのソースがありません';

  @override
  String get setdVaultHiddenSourcesToggleHint =>
      'ソースを切り替えて、Vaultモードでのみ表示するようにします。';

  @override
  String get setdVaultSearchSourcesHint => 'ソースを検索...';

  @override
  String get setdCategoryNameHint => 'カテゴリ名';

  @override
  String get setdNewCategory => '新しいカテゴリ';

  @override
  String get setdRenameCategory => 'カテゴリ名を変更';

  @override
  String get setdDeleteCategory => 'カテゴリを削除';

  @override
  String get setdActionCancel => 'キャンセル';

  @override
  String get setdActionSave => '保存';

  @override
  String get setdActionAdd => '追加';

  @override
  String get setdActionDelete => '削除';

  @override
  String get setdTapToAddCategory => '＋をタップしてカテゴリを追加';

  @override
  String get setdVaultContentsTitle => 'Vaultのコンテンツ';

  @override
  String get setdVaultContentsLockedMessage =>
      'コンテンツを管理するには、先にVaultのロックを解除してください。';

  @override
  String get setdVaultContentsTabManga => 'マンガ';

  @override
  String get setdVaultContentsTabAnime => 'アニメ';

  @override
  String get setdVaultContentsTabNovels => '小説';

  @override
  String setdVaultContentsEmptyLibrary(Object type) {
    return 'ライブラリに$typeがありません';
  }

  @override
  String setdVaultContentsEmptyVault(Object type) {
    return 'Vaultに$typeがありません';
  }

  @override
  String setdVaultContentsMovedIn(Object title) {
    return '「$title」をVaultに移動しました';
  }

  @override
  String setdVaultContentsMovedOut(Object title) {
    return '「$title」をVaultから戻しました';
  }

  @override
  String setdVaultContentsReadProgress(Object read, Object total) {
    return '$read/$total読了';
  }

  @override
  String get setdLibraryTitle => 'ライブラリ';

  @override
  String get setdLibrarySectionCategories => 'カテゴリ';

  @override
  String get setdLibraryEditCategories => 'カテゴリを編集';

  @override
  String get setdLibraryEditCategoriesDesc => 'カテゴリの追加、削除、並べ替え';

  @override
  String get setdLibraryHideEmpty => '空のカテゴリを隠す';

  @override
  String get setdLibraryHideEmptyDesc => 'マンガのあるカテゴリのみ表示';

  @override
  String get setdLibrarySectionGlobalUpdate => '全体更新';

  @override
  String get setdLibraryUpdateFrequency => '更新頻度';

  @override
  String get setdLibraryWifiOnly => 'Wi-Fiのみ';

  @override
  String get setdLibraryWifiOnlyDesc => 'Wi-Fi接続時のみ更新';

  @override
  String get setdLibraryChargingOnly => '充電中のみ';

  @override
  String get setdLibraryChargingOnlyDesc => 'デバイスの充電中のみ更新';

  @override
  String get setdLibrarySectionRestrictions => '更新の制限';

  @override
  String get setdLibrarySkipNotStarted => '未開始をスキップ';

  @override
  String get setdLibrarySkipNotStartedDesc => '読書の進捗がないマンガをスキップ';

  @override
  String get setdLibraryShowUpdateCount => '新着チャプター数を表示';

  @override
  String get setdLibraryShowUpdateCountDesc => 'ライブラリのマンガカードにバッジを表示';

  @override
  String get setdLibrarySectionData => 'データ';

  @override
  String get setdLibraryMigrateSource => 'ソースを移行';

  @override
  String get setdLibraryMigrateSourceDesc => 'あるソースから別のソースへすべての項目を移動';

  @override
  String get setdLibraryNoCategories => 'カテゴリがありません';

  @override
  String setdLibraryDeleteCategoryConfirm(Object name) {
    return '「$name」を削除してもよろしいですか？このカテゴリのマンガはライブラリから削除されません。';
  }

  @override
  String get setdPlayerTitle => 'プレーヤー';

  @override
  String get setdPlayerSectionSeek => 'ダブルタップでシーク';

  @override
  String get setdPlayerSkipForward => '早送り';

  @override
  String get setdPlayerSkipBackward => '巻き戻し';

  @override
  String get setdPlayerSectionGestures => 'ジェスチャー';

  @override
  String get setdPlayerHoldToSpeed => '長押しで速度アップ';

  @override
  String setdPlayerHoldToSpeedDesc(Object speed) {
    return '画面のどこかを長押しすると$speed倍速で再生';
  }

  @override
  String get setdPlayerHoldSpeed => '長押し時の速度';

  @override
  String get setdPlayerVolumeSwipe => '音量スワイプ';

  @override
  String get setdPlayerVolumeSwipeDesc => '画面右半分を上下にスライドして音量を調整';

  @override
  String get setdPlayerBrightnessSwipe => '明るさスワイプ';

  @override
  String get setdPlayerBrightnessSwipeDesc => '画面左半分を上下にスライドして明るさを調整';

  @override
  String get setdPlayerSectionPlayback => '再生';

  @override
  String get setdPlayerDefaultSpeed => 'デフォルトの速度';

  @override
  String get setdPlayerAutoplayNext => '次のエピソードを自動再生';

  @override
  String get setdPlayerAutoplayNextDesc => 'エピソードが終わると自動的に次を再生';

  @override
  String get setdPlayerAutoSkipIntro => 'イントロ／エンディングを自動スキップ';

  @override
  String get setdPlayerAutoSkipIntroDesc => 'ソースが指定したオープニング／エンディングをタップせずにスキップ';

  @override
  String get setdPlayerSkipAmountTitle => 'スキップ量';

  @override
  String get setdPlayerShowSkipButton => 'Skip-intro button';

  @override
  String get setdPlayerShowSkipButtonDesc =>
      'Show a Skip Intro button near the start, even when the source has no markers';

  @override
  String get setdPlayerSpeedTitle => '速度';

  @override
  String get setdAppearanceTitle => '外観';

  @override
  String get setdAppearanceSectionTheme => 'テーマ';

  @override
  String get setdAppearanceSectionDisplay => '表示';

  @override
  String get setdAppearanceInvertColors => '色を反転';

  @override
  String get setdAppearanceInvertColorsDesc => 'アプリのUI全体を反転します';

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
  String get setdAppearanceDarkMode => 'ダークモード';

  @override
  String get setdAppearanceLightMode => 'ライトモード';

  @override
  String get setdAppearanceCurrentlyDark => '現在ダーク';

  @override
  String get setdAppearanceCurrentlyLight => '現在ライト';

  @override
  String get detailStatusOngoing => '連載中';

  @override
  String get detailStatusCompleted => '完結';

  @override
  String get detailStatusHiatus => '休載中';

  @override
  String get detailStatusCanceled => '打ち切り';

  @override
  String get detailStatusFinished => '完結';

  @override
  String get detailStatusUnknown => '不明';

  @override
  String detailChapterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count話',
    );
    return '$_temp0';
  }

  @override
  String detailEpisodeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countエピソード',
    );
    return '$_temp0';
  }

  @override
  String detailDownloadingChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count話をダウンロード中',
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
