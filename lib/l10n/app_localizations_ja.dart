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
  String get settingsRepoForgeTitle => 'RepoForge';

  @override
  String get settingsRepoForgeSubtitle => '任意のURLからソースを作成・管理';

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
  String get libraryApply => '適用';

  @override
  String get libraryAscending => '昇順';

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
  String get libraryChaptersRead => '読んだ話数';

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
  String get libraryCoverSize => '表紙のサイズ';

  @override
  String libraryDaysCount(Object days) {
    return '$days日';
  }

  @override
  String get libraryDescending => '降順';

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
  String get libraryMonthlyActivity => '月間アクティビティ';

  @override
  String get libraryMore => 'もっと見る';

  @override
  String get libraryMostReadSeries => 'よく読んだシリーズ';

  @override
  String get libraryMoveToCategory => 'カテゴリへ移動';

  @override
  String get libraryNever => '未確認';

  @override
  String get libraryNoBookmarks => 'ブックマークはありません';

  @override
  String get libraryNoBookmarksDesc => 'マンガを長押ししてブックマークすると、ここに表示されます。';

  @override
  String get libraryNoNewChapters => '新着なし';

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
  String get libraryReadingStreak => '連続読書記録';

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
  String get librarySeries => 'シリーズ';

  @override
  String get libraryShowNumberOfItems => '項目数を表示';

  @override
  String get librarySizeLarge => '大';

  @override
  String get librarySizeMedium => '中';

  @override
  String get librarySizeSmall => '小';

  @override
  String get librarySortLastUpdated => '最終更新';

  @override
  String get librarySortRating => '評価';

  @override
  String get librarySortTitle => 'タイトル';

  @override
  String get librarySortUnreadCount => '未読数';

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
  String get libraryStreakBest => '最高';

  @override
  String get libraryStreakCurrent => '現在';

  @override
  String libraryStreakDaysStrong(Object days) {
    return '$days日継続中 — この調子！';
  }

  @override
  String get libraryStreakKeepGoing => '明日も読んで連続記録を伸ばそう！';

  @override
  String get libraryStreakStart => '今日読んで連続記録を始めよう！';

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
  String get libraryTotalChapters => '総話数';

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
  String get libraryVaultBreakdown => 'Vaultの内訳';

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
  String get readerImageZoom => '画像のズーム';

  @override
  String get readerAutoPreloadNextChapter => '次の話を自動先読み';

  @override
  String get readerAutoPreloadNextChapterSubtitle => '次の話をバックグラウンドで読み込む';

  @override
  String get readerCropBorders => '余白を切り取る';

  @override
  String get readerCropBordersSubtitle => 'ページの白い余白を削除';

  @override
  String get readerGrayscale => 'グレースケール';

  @override
  String get readerGrayscaleSubtitle => 'ページをグレースケールで表示';

  @override
  String get readerAutoCrop => 'Auto-crop borders';

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
  String get readerZoomStartPosition => 'ズームの開始位置';

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
  String get readerTransitions => '切り替え効果';

  @override
  String get readerPageTransition => 'ページの切り替え';

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
  String readerFinishedChapter(Object name) {
    return '読了: $name';
  }

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
  String get browseRepoForgeTooltip => 'RepoForge — ソースの作成と管理';

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
  String get browseNoResultsFound => '結果が見つかりません';

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
  String get commonBeta => 'BETA';

  @override
  String get setxAdvancedSectionBeta => 'Experimental';

  @override
  String get setxAdvancedBeta => 'Beta features';

  @override
  String get setxAdvancedBetaDesc =>
      'Show experimental features — hands-free & volume-key scrolling, RepoForge, AI translation and auto-crop. They may be unstable or change.';

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
  String get repoDeleteSourceTitle => 'ソースを削除しますか？';

  @override
  String repoDeleteSourceBody(Object name) {
    return '「$name」がマイソースから削除されます。';
  }

  @override
  String get repoCancel => 'キャンセル';

  @override
  String get repoDelete => '削除';

  @override
  String repoDeletedSource(Object name) {
    return '「$name」を削除しました';
  }

  @override
  String get repoNoSourcesToExport => 'エクスポートするソースがありません';

  @override
  String get repoExportDialogTitle => 'RepoForgeソースをエクスポート';

  @override
  String repoExportedSources(Object count) {
    return '$count個のソースをエクスポートしました';
  }

  @override
  String repoExportFailed(Object error) {
    return 'エクスポートに失敗しました: $error';
  }

  @override
  String repoImportedSources(Object count) {
    return '$count個のソースをインポートしました';
  }

  @override
  String repoImportFailed(Object error) {
    return 'インポートに失敗しました: $error';
  }

  @override
  String get repoBuildFromUrl => '任意のURLからソースを作成';

  @override
  String get repoBeta => 'ベータ';

  @override
  String get repoHeroDescription =>
      'サイトのフレームワークを検出し、セレクターを調整して、動作するマンガ／アニメ／小説ソースをインストール — サーバー不要、すべてオンデバイス。RepoForgeはベータ版のため、常に正しくソースを作成できるとは限りません。結果を確認し、サイトが正しく表示されない場合はセレクターを調整してください。';

  @override
  String repoCoverageSummary(Object frameworks, Object manga, Object novel) {
    return '$frameworks個のフレームワーク · マンガ$manga件 + 小説$novel件を認識';
  }

  @override
  String get repoNewSource => '新しいソース';

  @override
  String get repoImport => 'インポート';

  @override
  String get repoMySources => 'マイソース';

  @override
  String get repoExportAll => 'すべてエクスポート';

  @override
  String get repoNoSourcesYet => 'まだソースがありません';

  @override
  String get repoEmptyStateHint => '「新しいソース」をタップして、サイトURLから作成しましょう。';

  @override
  String get repoNotInstalled => '未インストール';

  @override
  String get repoOpenInBrowse => 'ブラウズで開く';

  @override
  String get repoEditRedetect => '編集／再検出';

  @override
  String get repoKnownNovelSite => '既知のライトノベルサイト';

  @override
  String get repoNovelGenericDetail =>
      '小説サイトとして認識 — 汎用の小説ボディで生成されました（ブラウズにはセレクター調整が必要な場合があります）。';

  @override
  String repoNovelFrameworkDetail(Object framework) {
    return '$frameworkボディを使用した小説ソースとして生成 — ブラウズとリーダーはそのまま動作します。';
  }

  @override
  String get repoKnownMangaSite => '既知のマンガサイト';

  @override
  String get repoMangaApiDetail =>
      'コミュニティ検証済みのAPIソース — RepoForgeがサイトのAPIから作成します。';

  @override
  String repoMangaThemeDetail(Object theme) {
    return 'コミュニティ検証済みのテーマ: $theme — セレクターは既知です。';
  }

  @override
  String get repoMangaCustomDetail => 'このサイトにはコミュニティ検証済みのカスタムセレクターが登録されています。';

  @override
  String get repoNotInKb => 'ナレッジベースにありません';

  @override
  String get repoNotInKbDetail =>
      '追加時にRepoForgeがフレームワークをその場で検出し、独自仕様の場合はヒューリスティックな「何が何か」のスクレイピングにフォールバックします。';

  @override
  String get repoCoverage => '対応状況';

  @override
  String get repoCheckASite => 'サイトを確認';

  @override
  String get repoPasteSiteUrlHint => 'サイトのURLを貼り付け';

  @override
  String get repoCheck => '確認';

  @override
  String get repoSupportedFrameworks => '対応フレームワーク';

  @override
  String get repoMangaSites => 'マンガサイト';

  @override
  String get repoNovelSites => '小説サイト';

  @override
  String get repoFrameworks => 'フレームワーク';

  @override
  String get repoRoleItem => 'リスト項目（各カード）';

  @override
  String get repoRoleTitle => 'タイトル';

  @override
  String get repoRoleCover => '表紙画像';

  @override
  String get repoRoleNextPage => '次ページのリンク';

  @override
  String get repoRoleDetailTitle => '詳細 — タイトル';

  @override
  String get repoRoleChapters => 'チャプター一覧の項目';

  @override
  String get repoRolePageImages => 'リーダーのページ画像';

  @override
  String get repoRoleEpisodes => 'エピソード一覧（アニメ）';

  @override
  String get repoStepFetching => 'ページを取得中…';

  @override
  String get repoStepMatching => 'フレームワークの特徴を照合中…';

  @override
  String get repoStepExtracting => 'セレクターを抽出中…';

  @override
  String get repoStepFinalizing => '仕上げ中…';

  @override
  String get repoEnterUrlFirst => '先にサイトのURLを入力してください。';

  @override
  String repoDetectionFailed(Object error) {
    return '検出に失敗しました: $error';
  }

  @override
  String get repoFetchFailed => '取得に失敗しました';

  @override
  String repoFetchedChars(Object count) {
    return '$count文字を取得しました — セレクターをテストしてください';
  }

  @override
  String get repoFetchPageFirst => '先にページを取得してください';

  @override
  String repoGenerationFailed(Object error) {
    return '生成に失敗しました: $error';
  }

  @override
  String get repoDetectSiteFirst => '先にサイトを検出してください';

  @override
  String repoCreatedInstalled(Object name) {
    return '「$name」を作成・インストールしました';
  }

  @override
  String repoSaveFailed(Object error) {
    return '保存に失敗しました: $error';
  }

  @override
  String get repoCreateSource => 'ソースを作成';

  @override
  String get repoSiteUrl => 'サイトURL';

  @override
  String get repoDetect => '検出';

  @override
  String repoConfidence(Object pct) {
    return '信頼度 $pct%';
  }

  @override
  String get repoApiSource => 'APIソース';

  @override
  String get repoDetails => '詳細';

  @override
  String get repoSourceNameHint => 'ソース名';

  @override
  String get repoName => '名前';

  @override
  String get repoLang => '言語';

  @override
  String get repoManga => 'マンガ';

  @override
  String get repoAnime => 'アニメ';

  @override
  String get repoNovel => '小説';

  @override
  String get repoNsfw => 'NSFW';

  @override
  String get repoScrapingStudio => 'スクレイピングスタジオ';

  @override
  String get repoScrapingStudioHint =>
      'ページを取得してから各セレクターをテストし、いくつの要素に一致するか確認できます。';

  @override
  String get repoUrlToTestHint => 'テスト対象のURL';

  @override
  String get repoFetch => '取得';

  @override
  String get repoFetchFailedBlocked =>
      '取得に失敗しました — サイトが自動アクセスをブロックしている可能性があります。';

  @override
  String repoLoadedChars(Object count) {
    return '$count文字を読み込みました。';
  }

  @override
  String get repoPreviewJs => 'JSをプレビュー';

  @override
  String get repoCreateInstall => '作成してインストール';

  @override
  String get repoPickKnownSelector => '既知のセレクターを選択';

  @override
  String get repoTest => 'テスト';

  @override
  String repoNoCatalogedSelectors(Object label) {
    return '「$label」のカタログ済みセレクターはありません';
  }

  @override
  String get repoInvalid => '無効';

  @override
  String get repoNoMatch => '一致なし';

  @override
  String get repoGeneratedSource => '生成されたソース';

  @override
  String get repoCopy => 'コピー';

  @override
  String get repoCopiedToClipboard => 'ソースをクリップボードにコピーしました';

  @override
  String repoSelectorFor(Object field) {
    return '$fieldのセレクター';
  }

  @override
  String get repoSearchSelectors => 'セレクターを検索…';

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
  String get setdVaultContentsInLibrary => 'ライブラリ内';

  @override
  String get setdVaultContentsMoveIntoHint => '→ Vaultに移動';

  @override
  String get setdVaultContentsInVault => 'Vault内';

  @override
  String get setdVaultContentsMoveOutHint => '← Vaultから戻す';

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
