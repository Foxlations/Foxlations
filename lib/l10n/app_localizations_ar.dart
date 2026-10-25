// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Foxlations';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsSectionApp => 'التطبيق';

  @override
  String get settingsSectionManga => 'المانغا';

  @override
  String get settingsSectionSystem => 'النظام';

  @override
  String get settingsLanguageTitle => 'اللغة';

  @override
  String get settingsLanguageEntrySubtitle => 'لغة عرض التطبيق';

  @override
  String get settingsLanguageSubtitle => 'اختر لغة التطبيق';

  @override
  String get settingsLanguageSystemDefault => 'افتراضي النظام';

  @override
  String get settingsLanguageHeader => 'لغة التطبيق';

  @override
  String get settingsAppearanceTitle => 'المظهر';

  @override
  String get settingsAppearanceSubtitle => 'السمة، الوضع الداكن، العرض';

  @override
  String get settingsNotificationsTitle => 'الإشعارات';

  @override
  String get settingsNotificationsSubtitle => 'التنبيهات، التكرار، التذكيرات';

  @override
  String get settingsStorageTitle => 'التخزين';

  @override
  String get settingsStorageSubtitle => 'التنزيلات، مواقع المجلدات، المزامنة';

  @override
  String get settingsLibraryTitle => 'المكتبة';

  @override
  String get settingsLibrarySubtitle => 'الفئات، التحديث الشامل، العرض';

  @override
  String get settingsReaderTitle => 'القارئ';

  @override
  String get settingsReaderSubtitle => 'وضع القراءة، العرض، التنقل';

  @override
  String get settingsPlayerTitle => 'المشغّل';

  @override
  String get settingsPlayerSubtitle =>
      'التقديم، الإيماءات، السرعة، التشغيل التلقائي';

  @override
  String get settingsDownloadsTitle => 'التنزيلات';

  @override
  String get settingsDownloadsSubtitle => 'التنزيلات التلقائية، حذف الفصول';

  @override
  String get settingsTrackingTitle => 'التتبّع';

  @override
  String get settingsTrackingSubtitle => 'MAL وAniList وKitsu والمزيد';

  @override
  String get settingsAiTitle => 'الذكاء الاصطناعي والترجمة';

  @override
  String get settingsAiSubtitle => 'المزوّد، مفاتيح API، كشف فقاعات الكلام';

  @override
  String get settingsBrowseTitle => 'التصفّح';

  @override
  String get settingsBrowseSubtitle => 'المصادر، الإضافات، البحث الشامل';

  @override
  String get settingsBackupTitle => 'النسخ الاحتياطي والاستعادة';

  @override
  String get settingsBackupSubtitle =>
      'إنشاء/استعادة النسخ، الاستيراد، النسخ التلقائي';

  @override
  String get settingsSecurityTitle => 'الأمان والخصوصية';

  @override
  String get settingsSecuritySubtitle =>
      'قفل التطبيق، القياسات الحيوية، أمان الشاشة';

  @override
  String get settingsAdvancedTitle => 'متقدّم';

  @override
  String get settingsAdvancedSubtitle => 'الشبكة، الإضافات، السجلّات، البيانات';

  @override
  String get settingsAboutTitle => 'حول';

  @override
  String get settingsAboutSubtitle => 'الإصدار، التراخيص، الروابط';

  @override
  String get libraryAdd => 'إضافة';

  @override
  String get libraryAddAnime => 'إضافة أنمي';

  @override
  String get libraryAddLNs => 'إضافة روايات';

  @override
  String get libraryAddManga => 'إضافة مانغا';

  @override
  String get libraryBadges => 'الشارات';

  @override
  String get libraryBatchMigrate => 'ترحيل';

  @override
  String get libraryBatchMove => 'نقل';

  @override
  String get libraryBatchRead => 'مقروء';

  @override
  String get libraryBatchRemove => 'إزالة';

  @override
  String get libraryBatchUnread => 'غير مقروء';

  @override
  String get libraryCategoryUpdate => 'تحديث الفئة';

  @override
  String libraryCategoryUpdateDesc(Object category) {
    return 'التحقق من \"$category\" بحثًا عن فصول جديدة';
  }

  @override
  String libraryChapterProgress(Object read, Object total) {
    return 'فصل $read/$total';
  }

  @override
  String libraryEpisodeProgress(Object read, Object total) {
    return 'حلقة $read/$total';
  }

  @override
  String libraryChaptersAbbrev(Object n) {
    return '$n فصل';
  }

  @override
  String get libraryCheckForUpdates => 'التحقق من التحديثات';

  @override
  String get libraryClose => 'إغلاق';

  @override
  String get libraryCloseSearch => 'إغلاق البحث';

  @override
  String get libraryCompleted => 'مكتمل';

  @override
  String get libraryContinueReading => 'متابعة القراءة';

  @override
  String get libraryContinueWatching => 'متابعة المشاهدة';

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
    return '$days يوم';
  }

  @override
  String get libraryDeselectAll => 'إلغاء تحديد الكل';

  @override
  String get libraryDisplayMode => 'وضع العرض';

  @override
  String get libraryDownloaded => 'مُنزَّل';

  @override
  String get libraryEmpty => 'المكتبة فارغة';

  @override
  String get libraryEmptyDesc => 'مكتبتك فارغة. تصفّح المصادر لإضافة مانغا.';

  @override
  String libraryEmptyStatsLibrary(Object word) {
    return 'أضف $word إلى مكتبتك وابدأ القراءة لرؤية إحصائياتك هنا.';
  }

  @override
  String libraryEmptyStatsVault(Object word) {
    return 'أضف $word إلى خزنتك وابدأ القراءة لرؤية الإحصائيات هنا.';
  }

  @override
  String get libraryFilterSortDisplay => 'التصفية والفرز والعرض';

  @override
  String get libraryGlobalUpdate => 'التحديث الشامل';

  @override
  String get libraryGlobalUpdateDesc => 'التحقق من كل عنصر في مكتبتك';

  @override
  String get libraryHeatmapLess => 'أقل';

  @override
  String get libraryHeatmapMore => 'أكثر';

  @override
  String get libraryItemsPerRow => 'العناصر في كل صف';

  @override
  String libraryLastChecked(Object when) {
    return 'آخر تحقّق: $when';
  }

  @override
  String get libraryLibrary => 'المكتبة';

  @override
  String libraryListChapters(Object read, Object total) {
    return '$read/$total فصل';
  }

  @override
  String get libraryMore => 'المزيد';

  @override
  String get libraryMoveToCategory => 'النقل إلى فئة';

  @override
  String get libraryNever => 'أبدًا';

  @override
  String get libraryNoBookmarks => 'لا إشارات مرجعية بعد';

  @override
  String get libraryNoBookmarksDesc =>
      'اضغط مطوّلًا على مانغا وضع إشارة مرجعية لرؤيتها هنا.';

  @override
  String get libraryNoNewChaptersLastCheck =>
      'لم يُعثر على فصول جديدة في آخر تحقّق.';

  @override
  String get libraryNoResults => 'لا نتائج';

  @override
  String libraryNoResultsDesc(Object query) {
    return 'لا نتائج لـ \"$query\". جرّب بحثًا مختلفًا.';
  }

  @override
  String get libraryNoStatsYet => 'لا إحصائيات بعد';

  @override
  String get libraryOpenRandomEntry => 'فتح عنصر عشوائي';

  @override
  String get libraryResetToDefault => 'إعادة التعيين إلى الافتراضي';

  @override
  String get librarySave => 'حفظ';

  @override
  String get librarySearchHint => 'البحث في المكتبة...';

  @override
  String get librarySearchLibrary => 'البحث في المكتبة';

  @override
  String get librarySelect => 'تحديد';

  @override
  String get librarySelectAll => 'تحديد الكل';

  @override
  String librarySelectedCount(Object n) {
    return '$n محدد';
  }

  @override
  String get libraryShowNumberOfItems => 'إظهار عدد العناصر';

  @override
  String get librarySizeMedium => 'متوسط';

  @override
  String get librarySources => 'المصادر';

  @override
  String get libraryStats => 'الإحصائيات';

  @override
  String get libraryStatusAll => 'الكل';

  @override
  String get libraryStatusCompleted => 'مكتمل';

  @override
  String get libraryStatusDropped => 'متروك';

  @override
  String get libraryStatusOnHold => 'معلّق';

  @override
  String get libraryStatusPlanToRead => 'نية القراءة';

  @override
  String get libraryStatusReading => 'قيد القراءة';

  @override
  String get libraryStatusUnknown => 'غير معروف';

  @override
  String libraryStreakDaysStrong(Object days) {
    return '$days يوم متواصل — واصل التقدّم!';
  }

  @override
  String get libraryTabDisplay => 'العرض';

  @override
  String get libraryTabFilter => 'التصفية';

  @override
  String get libraryTabSort => 'الفرز';

  @override
  String get libraryTabs => 'علامات التبويب';

  @override
  String libraryTotalAbbrev(Object n) {
    return '$n إجمالًا';
  }

  @override
  String get libraryTypeMenuBarrier => 'Library type';

  @override
  String libraryTypeBreakdown(Object type) {
    return 'توزيع $type';
  }

  @override
  String get libraryUnread => 'غير مقروء';

  @override
  String get libraryUpdatesSummary => 'ملخّص التحديثات';

  @override
  String get libraryUpdatesSummaryDesc => 'ما عثر عليه آخر تحقّق';

  @override
  String get libraryVault => 'الخزنة';

  @override
  String get libraryVaultStats => 'إحصائيات الخزنة';

  @override
  String get detailAdd => 'إضافة';

  @override
  String get detailAddNoteHint => 'أضف ملاحظة لهذا العنوان…';

  @override
  String get detailAddToCategory => 'الإضافة إلى فئة';

  @override
  String get detailAddToLibrary => 'الإضافة إلى المكتبة';

  @override
  String get detailAddWithoutCategory => 'الإضافة بدون فئة';

  @override
  String get detailBelowRead => 'ما تحته مقروء';

  @override
  String get detailBelowUnread => 'ما تحته غير مقروء';

  @override
  String get detailBookmark => 'إشارة مرجعية';

  @override
  String get detailBookmarked => 'مُضاف للإشارات';

  @override
  String get detailCancel => 'إلغاء';

  @override
  String get detailChapterFallback => 'فصل';

  @override
  String detailCopiedTo(Object source) {
    return 'تم النسخ إلى $source';
  }

  @override
  String detailCountSelected(Object count) {
    return '$count محدد';
  }

  @override
  String get detailDeleteDownload => 'حذف التنزيل';

  @override
  String get detailDone => 'تم';

  @override
  String get detailDownload => 'تنزيل';

  @override
  String get detailDownloadAllChapters => 'كل الفصول';

  @override
  String get detailDownloadAllUnread => 'كل غير المقروء';

  @override
  String get detailDownloaded => 'مُنزَّل';

  @override
  String get detailDownloadNext10 => 'الفصول العشرة التالية';

  @override
  String get detailDownloadNext5 => 'الفصول الخمسة التالية';

  @override
  String get detailDownloadNextChapter => 'الفصل التالي';

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
  String get detailEditCategories => 'تعديل الفئات';

  @override
  String get detailEditCategoriesTitle => 'تعديل الفئات';

  @override
  String get detailFilter => 'تصفية';

  @override
  String get detailInProgress => 'قيد التقدّم';

  @override
  String get detailLogIn => 'تسجيل الدخول';

  @override
  String get detailMangaNotFound => 'المانغا غير موجودة في المكتبة';

  @override
  String get detailMarkAllAsRead => 'تحديد الكل كمقروء';

  @override
  String get detailMarkAllAsUnread => 'تحديد الكل كغير مقروء';

  @override
  String get detailMarkAllBelowRead => 'تحديد كل ما تحته كمقروء';

  @override
  String get detailMarkAsUnread => 'تحديد كغير مقروء';

  @override
  String get detailMarkChapterAsRead => 'تحديد الفصل كمقروء';

  @override
  String get detailMarkRead => 'تحديد كمقروء';

  @override
  String get detailMarkUnread => 'تحديد كغير مقروء';

  @override
  String get detailMigrate => 'ترحيل';

  @override
  String get detailMigrateCategories => 'الفئات';

  @override
  String get detailMigrateChapters => 'الفصول';

  @override
  String get detailMigrateCopy => 'نسخ';

  @override
  String get detailMigrateDownloadsNoTransfer => 'الفصول المُنزَّلة لا تُنقَل.';

  @override
  String detailMigratedTo(Object source) {
    return 'تم الترحيل إلى $source';
  }

  @override
  String detailMigrateEntriesToSource(Object count, Object source) {
    return '$count عنصر → $source';
  }

  @override
  String get detailMigrateInfo =>
      'اختر المانغا نفسها من مصدر مختلف. سيتم نقل تقدّم القراءة.';

  @override
  String get detailMigrateRemoveDownloads => 'إزالة التنزيلات عند الترحيل';

  @override
  String get detailMigrateSelectData => 'اختر البيانات المراد تضمينها';

  @override
  String get detailMigrateShowEntry => 'إظهار العنصر';

  @override
  String detailMigrateTitleToSource(Object title, Object source) {
    return '$title → $source';
  }

  @override
  String get detailMigrateTracking => 'التتبّع';

  @override
  String get detailMigrating => 'جارٍ الترحيل…';

  @override
  String get detailNewestFirst => 'الأحدث أولًا';

  @override
  String get detailNoChaptersFound => 'لم يُعثر على فصول';

  @override
  String get detailNoChaptersLoginHint =>
      'لم يُحمَّل شيء لهذا العنوان. حاول مجددًا — أو، لهذا المصدر، قد يفتح تسجيل الدخول المزيد أحيانًا.';

  @override
  String get detailNoChaptersRetryHint =>
      'لم يُحمَّل شيء لهذا العنوان. قد لا يحتوي على فصول بعد، أو واجه المصدر مشكلة في تحميلها. حاول مجددًا.';

  @override
  String get detailNoResults => 'لم يُعثر على نتائج';

  @override
  String get detailNotes => 'الملاحظات';

  @override
  String get detailNothingToDownload => 'لا شيء للتنزيل';

  @override
  String get detailOldestFirst => 'الأقدم أولًا';

  @override
  String get detailOpenInBrowser => 'فتح في المتصفح';

  @override
  String get webviewOpenFailed => 'Couldn\'t open the browser';

  @override
  String detailPage(Object page) {
    return 'صفحة $page';
  }

  @override
  String get detailRefresh => 'تحديث';

  @override
  String get detailRemove => 'إزالة';

  @override
  String get detailRemoveBookmark => 'إزالة الإشارة المرجعية';

  @override
  String get detailRemoveFromLibrary => 'إزالة من المكتبة';

  @override
  String get detailRemoveFromLibraryTitle => 'إزالة من المكتبة؟';

  @override
  String get detailResume => 'استئناف';

  @override
  String get detailRetry => 'إعادة المحاولة';

  @override
  String get detailSave => 'حفظ';

  @override
  String get detailSearchChapters => 'البحث في الفصول';

  @override
  String get detailSearchChaptersHint => 'البحث في الفصول...';

  @override
  String get detailSearchEpisodes => 'البحث في الحلقات';

  @override
  String get detailSearchHint => 'البحث عن عنوان مانغا...';

  @override
  String get detailSearchingSources => 'جارٍ البحث في المصادر…';

  @override
  String get detailSelectAll => 'تحديد الكل';

  @override
  String get detailSelectChapters => 'تحديد الفصول';

  @override
  String get detailTracking => 'التتبّع';

  @override
  String get detailUnbookmark => 'إزالة الإشارة المرجعية';

  @override
  String get detailUnread => 'غير مقروء';

  @override
  String get detailWebView => 'WebView';

  @override
  String get appNavLibrary => 'المكتبة';

  @override
  String get appNavUpdates => 'التحديثات';

  @override
  String get appNavBrowse => 'التصفّح';

  @override
  String get appNavDiscover => 'Discover';

  @override
  String get appNavMore => 'المزيد';

  @override
  String get appNavVault => 'الخزنة';

  @override
  String get appUpdatesTitle => 'التحديثات';

  @override
  String get appNoNewChapters => 'لا فصول جديدة';

  @override
  String get appCheckForUpdates => 'التحقق من التحديثات';

  @override
  String get appClearAll => 'مسح الكل';

  @override
  String appCheckingProgress(Object checked, Object total) {
    return 'جارٍ التحقق $checked / $total...';
  }

  @override
  String appLastChecked(Object time) {
    return 'آخر تحقّق: $time';
  }

  @override
  String get appNoUpdatesYet => 'لا تحديثات بعد';

  @override
  String get appTapRefreshForChapters => 'اضغط تحديث للتحقق من الفصول الجديدة';

  @override
  String get appCheckNow => 'تحقّق الآن';

  @override
  String get appJustNow => 'الآن';

  @override
  String appMinutesAgo(Object m) {
    return 'قبل $m د';
  }

  @override
  String appHoursAgo(Object h) {
    return 'قبل $h س';
  }

  @override
  String appDaysAgo(Object d) {
    return 'قبل $d ي';
  }

  @override
  String get appToday => 'اليوم';

  @override
  String get appYesterday => 'أمس';

  @override
  String get appOnLatestVersion => 'أنت على أحدث إصدار';

  @override
  String get appUpdateAvailable => 'يتوفّر تحديث';

  @override
  String appVersionBuild(Object version, Object build) {
    return 'v$version · بناء $build';
  }

  @override
  String get appDownloadUpdate => 'تنزيل التحديث';

  @override
  String appDownloadVersion(Object version) {
    return 'تنزيل v$version';
  }

  @override
  String get appApkDownloadHint =>
      'يفتح تنزيل ملف APK. سيطلب منك Android تأكيد التثبيت.';

  @override
  String get appIosUpdateHint =>
      'حدّث من AltStore أو SideStore — افتحه وأعد التحديث. لا يستطيع iOS تثبيت تطبيق نُزِّل عبر المتصفح.';

  @override
  String get appSourceUrlCopied => 'تم نسخ رابط المصدر — أضفه في AltStore';

  @override
  String get appCopyAltstoreUrl => 'نسخ رابط مصدر AltStore';

  @override
  String get appBack => 'رجوع';

  @override
  String get appForward => 'تقديم';

  @override
  String get appReload => 'إعادة التحميل';

  @override
  String get appDoneSaveCookies => 'تم — حفظ ملفات تعريف الارتباط';

  @override
  String get appVaultPassword => 'كلمة مرور الخزنة';

  @override
  String get appEnterPassword => 'أدخل كلمة المرور';

  @override
  String get appWrongPassword => 'كلمة مرور خاطئة';

  @override
  String get appCancel => 'إلغاء';

  @override
  String get appUnlock => 'فتح القفل';

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
  String get readerExperimentalOnIos => 'تجريبي على iOS';

  @override
  String get readerIosVolumeWarning =>
      'لا يوفّر iOS واجهة برمجية مناسبة لأزرار الصوت، لذا يعمل هذا بمراقبة مستوى صوت النظام — وقد يكون غير مستقر. أثناء القراءة، سيبقى مستوى صوت أي شيء تستمع إليه (موسيقى أو بودكاست) عند 50% ولا يمكن تغييره. هل تريد التفعيل رغم ذلك؟';

  @override
  String get readerCancel => 'إلغاء';

  @override
  String get readerEnable => 'تفعيل';

  @override
  String get readerTitle => 'القارئ';

  @override
  String get readerPreferences => 'التفضيلات';

  @override
  String get readerReadingMode => 'وضع القراءة';

  @override
  String get readerFontSize => 'حجم الخط';

  @override
  String get readerAutoPreloadNextChapter =>
      'التحميل المسبق التلقائي للفصل التالي';

  @override
  String get readerAutoPreloadNextChapterSubtitle =>
      'تحميل الفصل التالي في الخلفية';

  @override
  String get readerGrayscale => 'تدرّج رمادي';

  @override
  String get readerGrayscaleSubtitle => 'عرض الصفحات بتدرّج رمادي';

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
  String get readerInvertColors => 'عكس الألوان';

  @override
  String get readerInvertColorsSubtitle => 'تبديل الألوان الفاتحة والداكنة';

  @override
  String get readerDisplay => 'العرض';

  @override
  String get readerScaleType => 'نوع التحجيم';

  @override
  String get readerBackgroundColor => 'لون الخلفية';

  @override
  String get readerKeepScreenOn => 'إبقاء الشاشة قيد التشغيل';

  @override
  String get readerKeepScreenOnSubtitle => 'منع الشاشة من الدخول في وضع السكون';

  @override
  String get readerShowPageNumber => 'إظهار رقم الصفحة';

  @override
  String get readerShowPageNumberSubtitle => 'عرض مؤشر الصفحة';

  @override
  String get readerFullscreen => 'ملء الشاشة';

  @override
  String get readerFullscreenSubtitle => 'إخفاء أشرطة النظام أثناء القراءة';

  @override
  String get readerNavigation => 'التنقل';

  @override
  String get readerNavigationLayout => 'تخطيط التنقل';

  @override
  String get readerInvertTapZones => 'عكس مناطق اللمس';

  @override
  String get readerInvertTapZonesSubtitle => 'تبديل التنقل باللمس يمين/يسار';

  @override
  String get readerVolumeKeys => 'أزرار الصوت';

  @override
  String get readerVolumeKeysSubtitle =>
      'اضغط لقلب الصفحة/التمرير؛ استمر بالضغط للتمرير (ويبتون)';

  @override
  String get readerHoldScrollSpeed => 'سرعة التمرير المستمر';

  @override
  String get readerSourceNotInstalled => 'المصدر غير مثبّت';

  @override
  String get readerSourceNotInstalledHint =>
      'This title\'s source isn\'t installed — this can happen after restoring a backup. Install it from Extensions, then try again.';

  @override
  String get readerTranslating => 'جارٍ الترجمة…';

  @override
  String get readerRetry => 'إعادة المحاولة';

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
  String get readerLoadingNextChapter => 'جارٍ تحميل الفصل التالي...';

  @override
  String get readerAllCaughtUp => 'لقد تابعت كل شيء!';

  @override
  String get readerEndOfChapter => 'نهاية الفصل';

  @override
  String get readerLatestChapterAvailable => 'هذا هو أحدث فصل متاح.';

  @override
  String get readerLoadNextChapter => 'تحميل الفصل التالي';

  @override
  String get readerBack => 'رجوع';

  @override
  String get readerSettings => 'الإعدادات';

  @override
  String get readerAiTranslate => 'ترجمة بالذكاء الاصطناعي';

  @override
  String get readerPreviousChapter => 'الفصل السابق';

  @override
  String get readerBookmark => 'إشارة مرجعية';

  @override
  String get readerNextChapter => 'الفصل التالي';

  @override
  String readerTranslationFailed(Object error) {
    return 'فشلت الترجمة: $error';
  }

  @override
  String get readerModeLtrLabel => 'من اليسار إلى اليمين';

  @override
  String get readerModeRtlLabel => 'من اليمين إلى اليسار';

  @override
  String get readerModeVerticalLabel => 'تمرير مستمر';

  @override
  String get readerModeWebtoonLabel => 'ويبتون';

  @override
  String get readerModeLtrSubtitle => 'اضغط يسار/يمين لقلب الصفحات';

  @override
  String get readerModeRtlSubtitle => 'بأسلوب المانغا من اليمين إلى اليسار';

  @override
  String get readerModeVerticalSubtitle => 'مرّر عموديًا عبر الصفحات';

  @override
  String get readerModeWebtoonSubtitle => 'مُحسَّن للشرائط العمودية الطويلة';

  @override
  String get readerChapters => 'الفصول';

  @override
  String readerPageOf(int current, int total) {
    return 'صفحة $current من $total';
  }

  @override
  String get readerTabProvider => 'المزوّد';

  @override
  String get readerTabTarget => 'الهدف';

  @override
  String get readerTabSource => 'المصدر';

  @override
  String get readerTabFont => 'الخط';

  @override
  String get readerFontNormal => 'عادي';

  @override
  String get readerFontManga => 'مانغا';

  @override
  String get readerFontNormalDesc => 'خط أنيق بلا زخارف';

  @override
  String get readerFontMangaDesc => 'أسلوب كوميكس عريض';

  @override
  String get readerFontSample => 'مرحبًا بالعالم';

  @override
  String get readerNoChapterText => 'لم يُعثر على نص للفصل';

  @override
  String get readerReadingTitle => 'القراءة';

  @override
  String get readerSmallerText => 'نص أصغر';

  @override
  String get readerLargerText => 'نص أكبر';

  @override
  String get readerPrevious => 'السابق';

  @override
  String get readerNext => 'التالي';

  @override
  String get browseTitle => 'التصفّح';

  @override
  String get browseGlobalSearch => 'البحث الشامل';

  @override
  String get browseRefreshingRepos => 'جارٍ تحديث المستودعات...';

  @override
  String get browseRefreshRepos => 'تحديث المستودعات';

  @override
  String get browseSearch => 'بحث';

  @override
  String get browseAddRepo => 'إضافة مستودع';

  @override
  String get browseTabSources => 'المصادر';

  @override
  String get browseTabExtensions => 'الإضافات';

  @override
  String get browseTabLocal => 'محلي';

  @override
  String get browseSearchHint => 'البحث في الإضافات والمصادر...';

  @override
  String browseRemoveSourceConfirm(Object name) {
    return 'إزالة $name؟';
  }

  @override
  String get browseRemoveSourceDesc =>
      'سيتم إلغاء تثبيت المصدر. تبقى عناصر مكتبتك منه، لكن لن تتمكن من فتحها حتى تعيد تثبيته.';

  @override
  String get browseCancel => 'إلغاء';

  @override
  String get browseRemove => 'إزالة';

  @override
  String get browseProvidedByThisSource => 'مُقدَّم من هذا المصدر';

  @override
  String get browseCouldNotLoadOptions => 'تعذّر تحميل خيارات المصدر';

  @override
  String get browseNoSourceOptions =>
      'لا يحدّد هذا المصدر أي خيارات خاصة به. الإعدادات أعلاه لا تزال تنطبق عليه.';

  @override
  String get browseBaseUrl => 'الرابط الأساسي';

  @override
  String get browseUsingSourceDefault => 'استخدام افتراضي المصدر';

  @override
  String browseBaseUrlDefault(Object url) {
    return '$url  (افتراضي)';
  }

  @override
  String get browseResetToDefault => 'إعادة التعيين إلى الافتراضي';

  @override
  String get browsePinToTop => 'التثبيت في الأعلى';

  @override
  String get browsePinToTopDesc => 'إظهار هذا المصدر أولًا في قائمة المصادر';

  @override
  String get browseSkipGlobalSearch => 'تخطّي في البحث الشامل';

  @override
  String get browseSkipGlobalSearchDesc =>
      'استبعاد هذا المصدر عند البحث في كل شيء';

  @override
  String get browseSkipLibraryUpdates => 'تخطّي في تحديثات المكتبة';

  @override
  String get browseSkipLibraryUpdatesDesc =>
      'عدم التحقق من هذا المصدر بحثًا عن فصول جديدة';

  @override
  String get browseRequestDesktopSite => 'طلب موقع سطح المكتب';

  @override
  String get browseRequestDesktopSiteDesc =>
      'جرّب هذا إذا لم يجد المصدر شيئًا، أو لم يُظهِر فصولًا — ترسل بعض المواقع نسخة مبسّطة للهواتف';

  @override
  String get browseSave => 'حفظ';

  @override
  String get browseNone => 'لا شيء';

  @override
  String browseSelectedCount(Object count) {
    return '$count محدد';
  }

  @override
  String get browseNotSet => 'غير محدد';

  @override
  String get browseIosFolderWarning =>
      'لا يسمح iOS للتطبيقات بالاحتفاظ بالوصول إلى مجلد. استخدم \"استيراد ملف\" لإضافة ملفات .cbz/.cbr/.zip/.epub/.pdf بدلًا من ذلك.';

  @override
  String browseImportedFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم استيراد $count ملف',
      many: 'تم استيراد $count ملفًا',
      few: 'تم استيراد $count ملفات',
      two: 'تم استيراد ملفين',
      one: 'تم استيراد ملف واحد',
      zero: 'لم يُستورَد أي ملف',
    );
    return '$_temp0';
  }

  @override
  String get browseNothingImported =>
      'لم يُستورَد شيء (غير مدعوم أو غير قابل للقراءة)';

  @override
  String browseFolderCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مجلد',
      many: '$count مجلدًا',
      few: '$count مجلدات',
      two: 'مجلدان',
      one: 'مجلد واحد',
      zero: 'لا مجلدات',
    );
    return '$_temp0';
  }

  @override
  String get browseManageFolders => 'إدارة المجلدات';

  @override
  String get browseImportFileTooltip => 'استيراد ملف (CBZ/ZIP/EPUB/PDF)';

  @override
  String get browseAddFolder => 'إضافة مجلد';

  @override
  String get browseRescan => 'إعادة الفحص';

  @override
  String get browseNothingImportedYet => 'لم يُستورَد شيء بعد';

  @override
  String get browseNoLocalSources => 'لا مصادر محلية';

  @override
  String get browseLocalSourcesDesc =>
      'أضف مجلد مانغا، أو استورد ملفًا واحدًا.\nالمدعوم: الصور (JPG وPNG وWebP وGIF)، وCBZ/ZIP، وEPUB وPDF.\n(CBR/RAR فقط إذا كان الملف مضغوطًا فعليًا بصيغة ZIP — صيغة RAR الحقيقية غير مدعومة.)';

  @override
  String get browseAddFolderButton => 'إضافة مجلد';

  @override
  String get browseImportFile => 'استيراد ملف';

  @override
  String get browseLocalSourceFolders => 'مجلدات المصادر المحلية';

  @override
  String get browseNoFoldersAdded => 'لم تُضَف مجلدات';

  @override
  String browseChaptersAbbrev(Object n) {
    return '$n فصل';
  }

  @override
  String get browseInstalled => 'مثبّت';

  @override
  String get browseAvailable => 'متاح';

  @override
  String get browseSourceNotInstalled => 'المصدر غير مثبّت';

  @override
  String get browseManga => 'مانغا';

  @override
  String get browseAnime => 'أنمي';

  @override
  String get browseNovels => 'روايات';

  @override
  String get browseAllLanguages => 'كل اللغات';

  @override
  String get browseFilter => 'تصفية';

  @override
  String browseLanguagesCount(Object count) {
    return '$count لغة';
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
      other: '$count نتيجة',
      many: '$count نتيجةً',
      few: '$count نتائج',
      two: 'نتيجتان',
      one: 'نتيجة واحدة',
      zero: 'لا نتائج',
    );
    return '$_temp0';
  }

  @override
  String get browseNoExtensions => 'لا إضافات بعد';

  @override
  String get browseNoExtensionsDesc =>
      'أضف مستودعًا باستخدام زر الإعدادات\nأعلاه لتصفّح الإضافات.';

  @override
  String browseUpdatedSources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم تحديث $count مصدر',
      many: 'تم تحديث $count مصدرًا',
      few: 'تم تحديث $count مصادر',
      two: 'تم تحديث مصدرين',
      one: 'تم تحديث مصدر واحد',
      zero: 'لم يُحدَّث أي مصدر',
    );
    return '$_temp0';
  }

  @override
  String get browseSourceUpdated => 'تم تحديث المصدر';

  @override
  String get browseNoUpdateAvailable => 'لا تحديث متاح';

  @override
  String browseUpdateFailed(Object error) {
    return 'فشل التحديث: $error';
  }

  @override
  String browseRefreshFailed(Object error) {
    return 'فشل التحديث: $error';
  }

  @override
  String browseUpdatesAvailable(Object count) {
    return 'تتوفّر تحديثات ($count)';
  }

  @override
  String get browseUpdateAll => 'تحديث الكل';

  @override
  String get browseUpdate => 'تحديث';

  @override
  String get browseSettings => 'الإعدادات';

  @override
  String get browseInstall => 'تثبيت';

  @override
  String get browseInstalledBadge => 'مثبّت';

  @override
  String get browseAbout => 'حول';

  @override
  String browseSourceFrom(Object url) {
    return 'مصدر من $url';
  }

  @override
  String browseLanguageLabel(Object lang) {
    return 'اللغة: $lang';
  }

  @override
  String get browseUsesCloudflare => 'يستخدم حماية Cloudflare';

  @override
  String get browseNoCloudflare => 'بدون Cloudflare';

  @override
  String get browseAdultContent => 'محتوى 18+';

  @override
  String get browseSafeForWork => 'آمن للعمل';

  @override
  String get browseFeatures => 'الميزات';

  @override
  String get browsePopular => 'شائع';

  @override
  String get browseLatest => 'الأحدث';

  @override
  String browseSourceAction(Object name) {
    return 'تصفّح $name';
  }

  @override
  String get browseRemoving => 'جارٍ الإزالة...';

  @override
  String get browseInstalling => 'جارٍ التثبيت...';

  @override
  String browseFailed(Object error) {
    return 'فشل: $error';
  }

  @override
  String get browseNoLanguagesMatch => 'No languages match';

  @override
  String get browseYourLanguages => 'Your languages';

  @override
  String get browseSearchLanguages => 'Search languages';

  @override
  String get browseUpdating => 'جارٍ التحديث...';

  @override
  String get browseUpdateExtensionCode => 'تحديث كود الإضافة';

  @override
  String browseUpdatedSource(Object name) {
    return 'تم تحديث $name';
  }

  @override
  String get browsePinned => 'مثبّت';

  @override
  String get browseAll => 'الكل';

  @override
  String get browseNoInstalledSources => 'لا مصادر مثبّتة';

  @override
  String get browseNoInstalledSourcesDesc =>
      'ثبّت الإضافات من علامة تبويب الإضافات\nلرؤية المصادر هنا.';

  @override
  String get browseUnpin => 'إلغاء التثبيت';

  @override
  String get browsePin => 'تثبيت';

  @override
  String get browseSourceNotInstalledBody => 'المصدر غير مثبّت';

  @override
  String get browseBypassingCloudflare => 'جارٍ تجاوز حماية Cloudflare...';

  @override
  String get browseOpenInWebView => 'فتح في WebView';

  @override
  String get browseCloudflareProtection => 'حماية Cloudflare';

  @override
  String get browseFailedToLoad => 'فشل التحميل';

  @override
  String get browseCloudflareChallengeDesc =>
      'يتطلّب هذا المصدر حل تحدي Cloudflare في المتصفح أولًا.';

  @override
  String get browseSolveCloudflare => 'حل Cloudflare';

  @override
  String get browseRetry => 'إعادة المحاولة';

  @override
  String get browseContentAnime => 'أنمي';

  @override
  String get browseContentNovels => 'روايات خفيفة';

  @override
  String get browseContentManga => 'مانغا';

  @override
  String browseNoContentFound(Object noun) {
    return 'لم يُعثر على $noun';
  }

  @override
  String get browseAllCategories => 'كل الفئات';

  @override
  String get browseNoCategories => 'لا فئات';

  @override
  String get browseSearchMangaHint => 'البحث عن مانغا...';

  @override
  String get browseUnknown => 'غير معروف';

  @override
  String get browseSearchAllSourcesHint => 'البحث في كل المصادر...';

  @override
  String get browseNoSourcesInstalled => 'لا مصادر مثبّتة';

  @override
  String get browseNoSourcesInstalledDesc =>
      'ثبّت الإضافات من علامة تبويب التصفّح.';

  @override
  String get browseSearchAllSources => 'البحث في كل المصادر';

  @override
  String browseSearchSourcesAtOnce(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'البحث في $count مصدر دفعة واحدة.',
      many: 'البحث في $count مصدرًا دفعة واحدة.',
      few: 'البحث في $count مصادر دفعة واحدة.',
      two: 'البحث في مصدرين دفعة واحدة.',
      one: 'البحث في مصدر واحد دفعة واحدة.',
      zero: 'لا مصادر للبحث.',
    );
    return '$_temp0';
  }

  @override
  String browseSearchingSources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'جارٍ البحث في $count مصدر...',
      many: 'جارٍ البحث في $count مصدرًا...',
      few: 'جارٍ البحث في $count مصادر...',
      two: 'جارٍ البحث في مصدرين...',
      one: 'جارٍ البحث في مصدر واحد...',
      zero: 'لا مصادر للبحث...',
    );
    return '$_temp0';
  }

  @override
  String get browseSeeAll => 'عرض الكل';

  @override
  String get globalSearchSourceNoResults => 'No results';

  @override
  String get globalSearchSourceFailed => 'Couldn\'t search this source';

  @override
  String get browseSectionSources => 'المصادر';

  @override
  String get browseShowNsfw => 'إظهار المصادر للبالغين';

  @override
  String get browseShowNsfwDesc => 'إظهار مصادر 18+ في التصفّح والبحث';

  @override
  String get browsePinnedOnly => 'المصادر المثبّتة فقط';

  @override
  String get browsePinnedOnlyBrowseDesc =>
      'إظهار المصادر المثبّتة فقط في التصفّح';

  @override
  String get browseSectionGlobalSearch => 'البحث الشامل';

  @override
  String get browsePinnedOnlyGlobalSearchDesc =>
      'البحث في المصادر المثبّتة فقط في البحث الشامل';

  @override
  String get browseSectionWebView => 'WebView';

  @override
  String get browseAdBlocker => 'مانع الإعلانات';

  @override
  String get browseAdBlockerDesc =>
      'حظر الإعلانات والنوافذ المنبثقة والتراكبات في المتصفح';

  @override
  String get browseSectionExtensions => 'الإضافات';

  @override
  String get browseAutoUpdate => 'التحديث التلقائي للإضافات';

  @override
  String get browseAutoUpdateDesc =>
      'تحديث كود الإضافات المثبّتة عند تشغيل التطبيق';

  @override
  String get setxAdvancedTitle => 'متقدّم';

  @override
  String get setxAdvancedSectionLogging => 'السجلّات';

  @override
  String get setxAdvancedVerboseLoggingTitle => 'التسجيل المفصّل';

  @override
  String get setxAdvancedVerboseLoggingSubtitle => 'تسجيل معلومات تصحيح مفصّلة';

  @override
  String get setxAdvancedViewErrorLogsTitle => 'عرض سجلّات الأخطاء';

  @override
  String get setxAdvancedViewErrorLogsSubtitle =>
      'تصفّح سجلّات التصحيح والأخطاء';

  @override
  String get setxAdvancedSectionNetwork => 'الشبكة';

  @override
  String get setxAdvancedDnsOverHttpsTitle => 'DNS عبر HTTPS';

  @override
  String get setxAdvancedDnsOverHttpsSubtitle => 'استخدام تحليل DNS آمن';

  @override
  String get setxAdvancedDnsProviderTitle => 'مزوّد DNS';

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
  String get setxAdvancedSectionExtensions => 'الإضافات';

  @override
  String get setxAdvancedThirdPartyTitle => 'إضافات الطرف الثالث';

  @override
  String get setxAdvancedThirdPartySubtitle =>
      'السماح بالإضافات من مصادر غير معروفة';

  @override
  String get setxAdvancedExtUpdateTitle => 'تنبيهات تحديث الإضافات';

  @override
  String get setxAdvancedExtUpdateSubtitle =>
      'الإشعار عند توفّر تحديثات للإضافات';

  @override
  String get setxAdvancedSectionBrowser => 'المتصفح';

  @override
  String get setxAdvancedExternalBrowserTitle => 'متصفح خارجي';

  @override
  String get setxAdvancedExternalBrowserSubtitle =>
      'فتح الروابط في متصفح النظام';

  @override
  String get setxAdvancedSectionData => 'البيانات';

  @override
  String get setxAdvancedClearCacheTitle => 'مسح ذاكرة الفصول المؤقتة';

  @override
  String get setxAdvancedClearCacheSubtitle => 'تحرير مساحة التخزين';

  @override
  String get setxAdvancedClearDbEntryTitle => 'مسح قاعدة البيانات';

  @override
  String get setxAdvancedClearDbEntrySubtitle =>
      'إعادة تعيين المكتبة والفئات وسجل القراءة';

  @override
  String get setxAdvancedCacheCleared => 'تم مسح ذاكرة صور الفصول المؤقتة';

  @override
  String get setxAdvancedClearDbTitle => 'مسح قاعدة البيانات؟';

  @override
  String get setxAdvancedClearDbBody =>
      'يحذف هذا نهائيًا مكتبتك وفئاتك وسجل القراءة. لن تتأثر الإضافات المثبّتة والتنزيلات.';

  @override
  String get setxAdvancedCancel => 'إلغاء';

  @override
  String get setxAdvancedClear => 'مسح';

  @override
  String get setxAdvancedDbCleared =>
      'تم مسح قاعدة البيانات — أعد تشغيل التطبيق لإعادة تهيئة الافتراضيات';

  @override
  String get setxAdvancedErrorLogsTitle => 'سجلّات الأخطاء';

  @override
  String get setxAdvancedClearAllLogsTooltip => 'مسح كل السجلّات';

  @override
  String get setxAdvancedFilterCategory => 'الفئة';

  @override
  String get setxAdvancedFilterLevel => 'المستوى';

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
  String get setxAdvancedNoLogs => 'لا سجلّات بعد';

  @override
  String get setxAdvancedNoLogsSubtitle =>
      'ستظهر السجلّات هنا أثناء استخدامك للتطبيق';

  @override
  String get setxAdvancedClearLogsTitle => 'مسح كل السجلّات؟';

  @override
  String get setxAdvancedClearLogsBody =>
      'سيحذف هذا نهائيًا كل إدخالات السجلّات المخزَّنة.';

  @override
  String get setxAdvancedLogsCleared => 'تم مسح السجلّات';

  @override
  String get setxAdvancedCopiedToClipboard => 'تم النسخ إلى الحافظة';

  @override
  String get setxNotifTitle => 'الإشعارات';

  @override
  String get setxNotifSectionChapterUpdates => 'تحديثات الفصول';

  @override
  String get setxNotifNewChaptersTitle => 'فصول جديدة';

  @override
  String get setxNotifNewChaptersSubtitle => 'الإشعار عند توفّر فصول جديدة';

  @override
  String get setxNotifLibraryUpdatesTitle => 'تحديثات المكتبة';

  @override
  String get setxNotifLibraryUpdatesSubtitle =>
      'الإشعار بعد اكتمال تحديث المكتبة';

  @override
  String get setxNotifSectionDownloads => 'التنزيلات';

  @override
  String get setxNotifDownloadCompleteTitle => 'اكتمل التنزيل';

  @override
  String get setxNotifDownloadCompleteSubtitle =>
      'الإشعار عند انتهاء تنزيل الفصول';

  @override
  String get setxNotifDownloadErrorTitle => 'خطأ في التنزيل';

  @override
  String get setxNotifDownloadErrorSubtitle => 'الإشعار عند فشل التنزيل';

  @override
  String get setxNotifSectionBehavior => 'السلوك';

  @override
  String get setxNotifSoundTitle => 'الصوت';

  @override
  String get setxNotifSoundSubtitle => 'تشغيل صوت للإشعارات';

  @override
  String get setxNotifVibrationTitle => 'الاهتزاز';

  @override
  String get setxNotifVibrationSubtitle => 'الاهتزاز للإشعارات';

  @override
  String get setxNotifGroupTitle => 'تجميع الإشعارات';

  @override
  String get setxNotifGroupSubtitle => 'دمج عدة إشعارات';

  @override
  String get setxSecurityTitle => 'الأمان والخصوصية';

  @override
  String get setxSecuritySectionAppLock => 'قفل التطبيق';

  @override
  String get setxSecurityAppLockTitle => 'قفل التطبيق';

  @override
  String get setxSecurityAppLockSubtitle => 'طلب المصادقة لفتح التطبيق';

  @override
  String get setxSecurityBiometricsTitle => 'القياسات الحيوية';

  @override
  String get setxSecurityBiometricsSubtitle =>
      'استخدام البصمة أو الوجه لفتح القفل';

  @override
  String get setxSecuritySectionPrivacy => 'الخصوصية';

  @override
  String get setxSecurityIncognitoTitle => 'Incognito mode';

  @override
  String get setxSecurityIncognitoSubtitle =>
      'Don\'t save reading history or update trackers';

  @override
  String get libraryIncognitoActive => 'Incognito mode on';

  @override
  String get setxSecuritySecureScreenTitle => 'شاشة آمنة';

  @override
  String get setxSecuritySecureScreenSubtitle =>
      'إخفاء محتوى التطبيق في التطبيقات الأخيرة';

  @override
  String get setxSecurityHideNotifTitle => 'إخفاء محتوى الإشعارات';

  @override
  String get setxSecurityHideNotifSubtitle => 'إظهار نص إشعار عام';

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
  String get setxBackupTitle => 'النسخ الاحتياطي والاستعادة';

  @override
  String get setxBackupSectionFoxlations => 'نسخة Foxlations الاحتياطية';

  @override
  String get setxBackupCreateTitle => 'إنشاء نسخة احتياطية';

  @override
  String get setxBackupCreateSubtitle =>
      'احفظ مكتبتك وفئاتك وتقدّم القراءة والمصادر والتتبّع';

  @override
  String get setxBackupRestoreTitle => 'استعادة نسخة احتياطية';

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
      'الاستعادة من ملف Foxlations بامتداد .fxbackup';

  @override
  String get setxBackupSectionTachiyomi => 'Tachiyomi / Mihon والنسخ المشتقة';

  @override
  String get setxBackupCreateCompatTitle => 'إنشاء نسخة احتياطية متوافقة';

  @override
  String get setxBackupCreateCompatSubtitle =>
      'تصدير ملف .tachibk يمكن استيراده إلى Tachiyomi وMihon والنسخ المشتقة';

  @override
  String get setxBackupRestoreTachiyomiTitle => 'الاستعادة من Tachiyomi/Mihon';

  @override
  String get setxBackupRestoreTachiyomiSubtitle =>
      'استيراد نسخة احتياطية .tachibk / .tmb / .proto.gz (تطابق المصادر بالاسم)';

  @override
  String get setxBackupSectionAutomatic => 'النسخ الاحتياطي التلقائي';

  @override
  String get setxBackupFrequency => 'التكرار';

  @override
  String setxBackupAutoSubtitle(Object freq) {
    return 'إنشاء نسخة احتياطية تلقائيًا $freq';
  }

  @override
  String setxBackupSectionBackups(Object count) {
    return 'النسخ الاحتياطية ($count)';
  }

  @override
  String get setxBackupNone => 'لا نسخ احتياطية بعد.';

  @override
  String get setxBackupMenuRestore => 'استعادة';

  @override
  String get setxBackupMenuDelete => 'حذف';

  @override
  String get setxBackupFreqOff => 'إيقاف';

  @override
  String get setxBackupFreqDaily => 'يوميًا';

  @override
  String get setxBackupFreqWeekly => 'أسبوعيًا';

  @override
  String get setxBackupFreqMonthly => 'شهريًا';

  @override
  String setxBackupImportedManga(Object count) {
    return 'تم استيراد $count مانغا';
  }

  @override
  String get setxBackupRestoreComplete => 'اكتملت الاستعادة';

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
    return 'فشلت الاستعادة: $error';
  }

  @override
  String get setxAboutTitle => 'حول';

  @override
  String get setxAboutSectionApp => 'التطبيق';

  @override
  String get setxAboutWhatsNewTitle => 'ما الجديد';

  @override
  String get setxAboutWhatsNewSubtitle => 'سجل التغييرات وملاحظات الإصدار';

  @override
  String get setxAboutCheckUpdatesTitle => 'التحقق من التحديثات';

  @override
  String get setxAboutCheckUpdatesSubtitle => 'تحقّق مما إذا صدر بناء أحدث';

  @override
  String get setxAboutSectionLegal => 'قانوني';

  @override
  String get setxAboutLicensesTitle => 'التراخيص';

  @override
  String get setxAboutLicensesSubtitle => 'تراخيص مفتوحة المصدر';

  @override
  String get setxAboutSectionLinks => 'الروابط';

  @override
  String get setxAboutSourceCodeTitle => 'الكود المصدري';

  @override
  String get setxAboutSourceCodeSubtitle => 'اضغط لنسخ رابط GitHub';

  @override
  String get setxAboutReportBugTitle => 'الإبلاغ عن خطأ';

  @override
  String get setxAboutReportBugSubtitle => 'اضغط لنسخ رابط متتبّع المشكلات';

  @override
  String get setxAboutClose => 'إغلاق';

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
    return 'ما الجديد في v$version';
  }

  @override
  String setxAboutLinkCopied(Object label) {
    return 'تم نسخ رابط $label إلى الحافظة';
  }

  @override
  String get setxAboutSourceCodeLabel => 'الكود المصدري';

  @override
  String get setxAboutBugReportLabel => 'بلاغ عن خطأ';

  @override
  String get miscResumePlaybackTitle => 'استئناف التشغيل؟';

  @override
  String miscStoppedWatchingAt(Object time) {
    return 'توقفت عن المشاهدة عند $time.';
  }

  @override
  String get miscStartOver => 'البدء من جديد';

  @override
  String miscContinueAt(Object time) {
    return 'متابعة ($time)';
  }

  @override
  String get miscQuality => 'الجودة';

  @override
  String miscSourceIndex(Object index) {
    return 'المصدر $index';
  }

  @override
  String get miscSubtitles => 'الترجمات';

  @override
  String get miscSubtitleOff => 'إيقاف';

  @override
  String get miscUnknownTrack => 'غير معروف';

  @override
  String get miscSubtitleDelay => 'تأخير الترجمة';

  @override
  String get miscAudio => 'الصوت';

  @override
  String get miscPlaybackSpeed => 'سرعة التشغيل';

  @override
  String get miscSkipOutro => 'تخطّي الخاتمة';

  @override
  String get miscSkipIntro => 'تخطّي المقدّمة';

  @override
  String get miscUnlockControls => 'إلغاء قفل عناصر التحكم';

  @override
  String get miscUnknownError => 'خطأ غير معروف';

  @override
  String get miscRetry => 'إعادة المحاولة';

  @override
  String get miscExtensionRepositories => 'مستودعات الإضافات';

  @override
  String get miscRepositoryUrlHint => 'رابط المستودع (index.json)';

  @override
  String get miscAdd => 'إضافة';

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
  String get miscRepositoriesHeader => 'المستودعات';

  @override
  String get miscNoReposYet => 'لم تُضَف مستودعات بعد';

  @override
  String miscFailedToAddRepo(Object error) {
    return 'فشلت إضافة المستودع: $error';
  }

  @override
  String get miscVerifyHuman => 'تأكيد أنك إنسان';

  @override
  String get miscCfInstructions =>
      'أكمل فحص الموقع أدناه. يُغلق تلقائيًا ولن يسأل مجددًا طالما بقي التحقق ساريًا.';

  @override
  String get trackTitle => 'التتبّع';

  @override
  String get trackNoTrackerConnected => 'لا متتبّع متصل';

  @override
  String get trackConnectHint =>
      'اربط AniList أو MyAnimeList أو Kitsu من الإعدادات › التتبّع.';

  @override
  String trackNotLinkedOn(Object name) {
    return 'غير مرتبط على $name';
  }

  @override
  String get trackLink => 'ربط';

  @override
  String get trackUnlink => 'إلغاء الربط';

  @override
  String get trackStatus => 'الحالة';

  @override
  String get trackChapters => 'الفصول';

  @override
  String get trackScore => 'التقييم';

  @override
  String trackLinkedTo(Object name) {
    return 'مرتبط بـ $name';
  }

  @override
  String trackLinkOn(Object name) {
    return 'الربط على $name';
  }

  @override
  String get trackSearchTitleHint => 'البحث عن عنوان';

  @override
  String get trackSearch => 'بحث';

  @override
  String get trackNoResults => 'لا نتائج';

  @override
  String trackChaptersShort(Object count) {
    return '$count فصل';
  }

  @override
  String trackConnectTracker(Object name) {
    return 'ربط $name';
  }

  @override
  String get trackOauthInstructions =>
      'سجّل الدخول واضغط تفويض. سيتم تسجيل دخولك تلقائيًا.';

  @override
  String get trackServices => 'الخدمات';

  @override
  String get trackServicesDescription =>
      'اربط خدمة تتبّع لمزامنة تقدّم قراءتك. بمجرد ربط مانغا، يُحدَّث التقدّم تلقائيًا أثناء القراءة.';

  @override
  String trackLogInTo(Object name) {
    return 'تسجيل الدخول إلى $name';
  }

  @override
  String get trackEmailOrUsername => 'البريد الإلكتروني أو اسم المستخدم';

  @override
  String get trackPassword => 'كلمة المرور';

  @override
  String get trackCancel => 'إلغاء';

  @override
  String get trackLogIn => 'تسجيل الدخول';

  @override
  String trackConnectedTo(Object name) {
    return 'متصل بـ $name';
  }

  @override
  String get trackLoginFailed => 'فشل تسجيل الدخول — تحقق من بياناتك';

  @override
  String get trackSetClientIdFirst => 'عيّن معرّف العميل أولًا';

  @override
  String get trackCouldNotCompleteSignIn => 'تعذّر إكمال تسجيل الدخول';

  @override
  String trackClientIdTitle(Object name) {
    return 'معرّف عميل $name (متقدّم)';
  }

  @override
  String trackClientIdDescription(Object name) {
    return 'اختياري. يحتوي Foxlations بالفعل على معرّف عميل $name مدمج — فقط اضغط اتصال. عيّن هذا فقط إذا سجّلت تطبيق مطوّر $name خاصًا بك وتريد استخدامه بدلًا منه.';
  }

  @override
  String get trackClientId => 'معرّف العميل';

  @override
  String get trackSave => 'حفظ';

  @override
  String get trackPasteAccessToken => 'الصق رمز الوصول';

  @override
  String get trackPasteTokenHint => 'الصق الرمز الظاهر بعد التفويض';

  @override
  String get trackConnect => 'اتصال';

  @override
  String get trackCouldNotVerifyToken => 'تعذّر التحقق من الرمز';

  @override
  String get trackConnected => 'متصل';

  @override
  String trackConnectedAs(Object username) {
    return 'متصل باسم $username';
  }

  @override
  String get trackTapConnectToAuthorize => 'اضغط اتصال للتفويض';

  @override
  String get trackSignInWithAccount => 'سجّل الدخول بحسابك';

  @override
  String get trackDisconnect => 'قطع الاتصال';

  @override
  String get trackAiTitle => 'الذكاء الاصطناعي والترجمة';

  @override
  String get trackTabTranslation => 'الترجمة';

  @override
  String get trackTabApiKeys => 'مفاتيح API';

  @override
  String get trackTabModels => 'النماذج';

  @override
  String get trackEnableAiTranslation => 'تفعيل الترجمة بالذكاء الاصطناعي';

  @override
  String get trackEnableAiTranslationDesc => 'إظهار زر الترجمة في القارئ';

  @override
  String get trackProvider => 'المزوّد';

  @override
  String get trackOfflineMode => 'وضع عدم الاتصال';

  @override
  String get trackOfflineModeDesc => 'استخدام النماذج المُنزَّلة بدون إنترنت';

  @override
  String get trackTranslationSettings => 'إعدادات الترجمة';

  @override
  String get trackTargetLanguage => 'اللغة الهدف';

  @override
  String get trackTargetLanguageDesc => 'ترجمة نص المانغا إلى هذه اللغة';

  @override
  String get trackBubbleDetection => 'كشف الفقاعات';

  @override
  String get trackBubbleDetectionDesc =>
      'الكشف التلقائي عن فقاعات الكلام في صفحات المانغا';

  @override
  String get trackQuality => 'الجودة';

  @override
  String get trackQualityFast => 'سريع';

  @override
  String get trackQualityBalanced => 'متوازن';

  @override
  String get trackQualityHigh => 'جودة عالية';

  @override
  String get trackKoharuServer => 'خادم Koharu';

  @override
  String get trackServerUrl => 'رابط الخادم';

  @override
  String get trackKoharuServerDesc =>
      'ترميم المانغا بالكامل عبر خادم Docker محلي';

  @override
  String get trackApiKeyRequired => 'مفتاح API مطلوب';

  @override
  String get trackApiKeysNotice =>
      'تُخزَّن المفاتيح محليًا على جهازك ولا تُرسَل أبدًا إلى خوادمنا.';

  @override
  String get trackModelsPlatformOnly =>
      'نماذج الترجمة على الجهاز متاحة على Android وiOS.';

  @override
  String get trackModelsDescription =>
      'نزّل لغة لترجمتها بالكامل دون اتصال. حجم كل حزمة نحو 30 MB وتُجلَب أيضًا تلقائيًا أول مرة تترجم فيها تلك اللغة.';

  @override
  String get trackTranslationLanguages => 'لغات الترجمة';

  @override
  String get trackDownloaded => 'مُنزَّل — متاح دون اتصال';

  @override
  String get trackNotDownloaded => 'غير مُنزَّل';

  @override
  String get trackDelete => 'حذف';

  @override
  String get trackDownload => 'تنزيل';

  @override
  String trackDownloadFailed(Object error) {
    return 'فشل التنزيل: $error';
  }

  @override
  String trackDeleteFailed(Object error) {
    return 'فشل الحذف: $error';
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
  String get repoCancel => 'إلغاء';

  @override
  String get repoName => 'الاسم';

  @override
  String repoImportedSource(Object id) {
    return 'مصدر مستورد · $id';
  }

  @override
  String get repoCheckingMatches => 'جارٍ التحقق من التطابقات';

  @override
  String get repoMigrating => 'جارٍ الترحيل';

  @override
  String get repoMigrateThisSource => 'ترحيل هذا المصدر؟';

  @override
  String repoMatchedByUrl(Object count) {
    return '$count تطابق بالرابط';
  }

  @override
  String repoMatchedByTitle(Object count) {
    return '$count تطابق بالعنوان';
  }

  @override
  String repoNotFoundLeftInPlace(Object count) {
    return '$count غير موجود — تُرِك في مكانه';
  }

  @override
  String get repoMigrateCarryOver =>
      'تُنقَل معه تقدّم القراءة والفئات والتتبّع. تُزال النسخ الأصلية فقط للعناصر التي تُنقَل.';

  @override
  String repoMigrateCount(Object count) {
    return 'ترحيل $count';
  }

  @override
  String get repoMigrateASource => 'ترحيل مصدر';

  @override
  String get repoMigrateIntro =>
      'انقل كل عنصر في المكتبة من مصدر إلى آخر. التبديلات داخل الموقع نفسه تطابق بدقة بالرابط؛ ويمكن أيضًا إعادة توطين العناصر المستوردة من نسخة احتياطية إلى مصدر حقيقي.';

  @override
  String get repoFrom => 'من';

  @override
  String get repoSelectSource => 'اختر مصدرًا…';

  @override
  String get repoTo => 'إلى';

  @override
  String get repoAlsoMatchByTitle => 'المطابقة بالعنوان أيضًا';

  @override
  String get repoAlsoMatchByTitleHint =>
      'للنقل بين المواقع: إذا لم يُعثر على عنصر بالرابط، ابحث في المصدر الجديد بالعنوان وخذ أقرب تطابق. مُعطَّل افتراضيًا حتى لا يربط السلسلة الخاطئة.';

  @override
  String get repoMigrateSource => 'ترحيل المصدر';

  @override
  String get repoMigrationComplete => 'اكتمل الترحيل';

  @override
  String repoMovedByUrl(Object count) {
    return '$count نُقل بالرابط';
  }

  @override
  String repoMovedByTitle(Object count) {
    return '$count نُقل بالعنوان';
  }

  @override
  String repoLeftInPlace(Object count) {
    return '$count تُرِك في مكانه';
  }

  @override
  String get repoNotMigratedHeader => 'لم تُرحَّل (لا تزال على المصدر القديم):';

  @override
  String get repoUsePerTitleMigrate => 'استخدم الترحيل لكل عنوان على حدة لهذه.';

  @override
  String get repoDone => 'تم';

  @override
  String get setdDownloadsTitle => 'التنزيلات';

  @override
  String get setdDownloadsSectionAutomatic => 'التنزيلات التلقائية';

  @override
  String get setdDownloadsNewChapters => 'تنزيل الفصول الجديدة';

  @override
  String get setdDownloadsNewChaptersDesc => 'تنزيل الفصول الجديدة تلقائيًا';

  @override
  String get setdDownloadsWifiOnly => 'عبر Wi-Fi فقط';

  @override
  String get setdDownloadsWifiOnlyDesc => 'التنزيل عبر Wi-Fi فقط';

  @override
  String get setdDownloadsChargingOnly => 'أثناء الشحن فقط';

  @override
  String get setdDownloadsChargingOnlyDesc =>
      'التنزيل أثناء التوصيل بالشاحن فقط';

  @override
  String get setdDownloadsAhead => 'التنزيل المسبق أثناء القراءة';

  @override
  String get setdDownloadsAheadDesc => 'تنزيل الفصل التالي مسبقًا أثناء قراءتك';

  @override
  String get setdDownloadsSectionQueue => 'قائمة انتظار التنزيل';

  @override
  String get setdDownloadsSimultaneous => 'التنزيلات المتزامنة';

  @override
  String get setdDownloadsQuality => 'جودة التنزيل';

  @override
  String get setdDownloadsSectionDelete => 'حذف الفصول المُنزَّلة';

  @override
  String get setdDownloadsAfterReading => 'بعد القراءة';

  @override
  String get setdDownloadsAfterReadingDesc => 'حذف الفصول بعد قراءتها';

  @override
  String get setdDownloadsIncludeBookmarked =>
      'تضمين الفصول ذات الإشارات المرجعية';

  @override
  String get setdDownloadsIncludeBookmarkedDesc =>
      'حذف الفصول ذات الإشارات المرجعية مع البقية';

  @override
  String get setdDownloadsAutoDelete => 'حذف الفصول المقروءة تلقائيًا';

  @override
  String get setdDownloadsSectionFormat => 'التنسيق';

  @override
  String get setdDownloadsSaveCbz => 'الحفظ بصيغة CBZ';

  @override
  String get setdDownloadsSaveCbzDesc =>
      'أرشفة الفصول كملفات CBZ مع البيانات الوصفية';

  @override
  String get setdDownloadsSavePdf => 'الحفظ بصيغة PDF';

  @override
  String get setdDownloadsSavePdfDesc =>
      'تجميع الفصول في ملف PDF واحد (صورة واحدة لكل صفحة)';

  @override
  String get setdDownloadsSectionLocation => 'موقع التنزيل';

  @override
  String get setdDownloadsDefaultLocation => 'الموقع الافتراضي';

  @override
  String get setdDownloadsCustomLocation => 'موقع مخصّص';

  @override
  String get setdDownloadsChooseFolder => 'اختر مجلدًا';

  @override
  String get setdDownloadsIosFolderWarning =>
      'لا يسمح iOS للتطبيقات بالاحتفاظ بالوصول إلى مجلد. تبقى التنزيلات في مجلد التطبيق، ويمكن الوصول إليها عبر الملفات › على جهاز iPhone الخاص بي › Foxlations.';

  @override
  String get setdDownloadsReset => 'إعادة تعيين';

  @override
  String get setdDownloadsSectionStorage => 'التخزين';

  @override
  String setdDownloadsTotalSize(Object size) {
    return 'الإجمالي: $size MB';
  }

  @override
  String setdDownloadsLibraryVaultSize(Object lib, Object vault) {
    return 'المكتبة: $lib MB  |  الخزنة: $vault MB';
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
  String get setdVaultTitle => 'الخزنة';

  @override
  String get setdVaultSectionAccess => 'الوصول';

  @override
  String get setdVaultEnable => 'تفعيل الخزنة';

  @override
  String get setdVaultEnableDesc =>
      'السماح بالوصول إلى الخزنة المخفية بالضغط على المكتبة 8 مرات';

  @override
  String get setdVaultSectionSecurity => 'الأمان';

  @override
  String get setdVaultChangePassword => 'تغيير كلمة المرور';

  @override
  String get setdVaultSetPassword => 'تعيين كلمة المرور';

  @override
  String get setdVaultPasswordSetDesc =>
      'تم تعيين كلمة المرور — اضغط للتغيير أو الإزالة';

  @override
  String get setdVaultPasswordUnsetDesc => 'احمِ الوصول إلى الخزنة بكلمة مرور';

  @override
  String get setdVaultSectionCategories => 'فئات الخزنة';

  @override
  String get setdVaultEditCategories => 'تعديل فئات الخزنة';

  @override
  String get setdVaultEditCategoriesDesc =>
      'إضافة فئات الخزنة وإزالتها وإعادة ترتيبها';

  @override
  String get setdVaultSectionContents => 'المحتويات';

  @override
  String get setdVaultManageContents => 'إدارة محتويات الخزنة';

  @override
  String get setdVaultManageContentsDesc =>
      'نقل المانغا أو الأنمي أو الروايات إلى الخزنة ومنها';

  @override
  String get setdVaultUnlockFirstSnack =>
      'افتح قفل الخزنة أولًا (اضغط من المكتبة)';

  @override
  String get setdVaultSectionHiddenSources => 'المصادر المخفية';

  @override
  String get setdVaultOnlySources => 'مصادر الخزنة فقط';

  @override
  String setdVaultHiddenSourcesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مصدر مخفي',
      many: '$count مصدرًا مخفيًا',
      few: '$count مصادر مخفية',
      two: 'مصدران مخفيان',
      one: 'مصدر واحد مخفي',
      zero: 'لا مصادر مخفية',
    );
    return '$_temp0';
  }

  @override
  String get setdVaultSectionInfo => 'معلومات';

  @override
  String get setdVaultInfoText =>
      'الخزنة مكتبة مخفية بفئاتها ومانغاها الخاصة. اضغط على علامة تبويب المكتبة 8 مرات بسرعة لتبديل وضع الخزنة. تُخزَّن مانغا الخزنة بشكل منفصل ولا تظهر أبدًا في مكتبتك الرئيسية.';

  @override
  String get setdVaultCurrentPasswordHint => 'كلمة المرور الحالية';

  @override
  String get setdVaultNewPasswordHint =>
      'كلمة مرور جديدة (اتركها فارغة للإزالة)';

  @override
  String get setdVaultConfirmPasswordHint => 'تأكيد كلمة المرور الجديدة';

  @override
  String get setdVaultCurrentPasswordWrong => 'كلمة المرور الحالية خاطئة';

  @override
  String get setdVaultPasswordsMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get setdVaultRemovingEncryption => 'جارٍ إزالة التشفير…';

  @override
  String get setdVaultEncrypting => 'جارٍ تشفير الخزنة…';

  @override
  String get setdVaultPasswordRemoved =>
      'تمت إزالة كلمة المرور — الخزنة لم تعد مشفّرة';

  @override
  String get setdVaultPasswordSet => 'تم تعيين كلمة المرور — الخزنة مشفّرة';

  @override
  String get setdVaultNoCategories => 'لا فئات للخزنة';

  @override
  String setdVaultDeleteCategoryConfirm(Object name) {
    return 'هل أنت متأكد من حذف \"$name\"؟ لن تُزال المانغا في هذه الفئة من الخزنة.';
  }

  @override
  String get setdVaultNoInstalledSources => 'لا مصادر مثبّتة';

  @override
  String get setdVaultHiddenSourcesToggleHint =>
      'بدّل المصادر لجعلها مرئية في وضع الخزنة فقط.';

  @override
  String get setdVaultSearchSourcesHint => 'البحث في المصادر...';

  @override
  String get setdCategoryNameHint => 'اسم الفئة';

  @override
  String get setdNewCategory => 'فئة جديدة';

  @override
  String get setdRenameCategory => 'إعادة تسمية الفئة';

  @override
  String get setdDeleteCategory => 'حذف الفئة';

  @override
  String get setdActionCancel => 'إلغاء';

  @override
  String get setdActionSave => 'حفظ';

  @override
  String get setdActionAdd => 'إضافة';

  @override
  String get setdActionDelete => 'حذف';

  @override
  String get setdTapToAddCategory => 'اضغط + لإضافة فئة';

  @override
  String get setdVaultContentsTitle => 'محتويات الخزنة';

  @override
  String get setdVaultContentsLockedMessage =>
      'افتح قفل الخزنة أولًا لإدارة محتوياتها.';

  @override
  String get setdVaultContentsTabManga => 'مانغا';

  @override
  String get setdVaultContentsTabAnime => 'أنمي';

  @override
  String get setdVaultContentsTabNovels => 'روايات';

  @override
  String setdVaultContentsEmptyLibrary(Object type) {
    return 'لا $type في مكتبتك';
  }

  @override
  String setdVaultContentsEmptyVault(Object type) {
    return 'لا $type في الخزنة';
  }

  @override
  String setdVaultContentsMovedIn(Object title) {
    return 'تم نقل \"$title\" إلى الخزنة';
  }

  @override
  String setdVaultContentsMovedOut(Object title) {
    return 'تم نقل \"$title\" خارج الخزنة';
  }

  @override
  String setdVaultContentsReadProgress(Object read, Object total) {
    return '$read/$total مقروء';
  }

  @override
  String get setdLibraryTitle => 'المكتبة';

  @override
  String get setdLibrarySectionCategories => 'الفئات';

  @override
  String get setdLibraryEditCategories => 'تعديل الفئات';

  @override
  String get setdLibraryEditCategoriesDesc =>
      'إضافة الفئات وإزالتها وإعادة ترتيبها';

  @override
  String get setdLibraryHideEmpty => 'إخفاء الفئات الفارغة';

  @override
  String get setdLibraryHideEmptyDesc =>
      'إظهار الفئات التي تحتوي على مانغا فقط';

  @override
  String get setdLibrarySectionGlobalUpdate => 'التحديث الشامل';

  @override
  String get setdLibraryUpdateFrequency => 'تكرار التحديث';

  @override
  String get setdLibraryWifiOnly => 'عبر Wi-Fi فقط';

  @override
  String get setdLibraryWifiOnlyDesc => 'التحديث عبر اتصالات Wi-Fi فقط';

  @override
  String get setdLibraryChargingOnly => 'أثناء الشحن فقط';

  @override
  String get setdLibraryChargingOnlyDesc =>
      'التحديث عندما يكون الجهاز قيد الشحن فقط';

  @override
  String get setdLibrarySectionRestrictions => 'قيود التحديث';

  @override
  String get setdLibrarySkipNotStarted => 'تخطّي ما لم يبدأ';

  @override
  String get setdLibrarySkipNotStartedDesc =>
      'تخطّي المانغا التي لا تقدّم قراءة لها';

  @override
  String get setdLibraryShowUpdateCount => 'إظهار عدد الفصول الجديدة';

  @override
  String get setdLibraryShowUpdateCountDesc =>
      'إظهار شارة على بطاقات مانغا المكتبة';

  @override
  String get setdLibrarySectionData => 'البيانات';

  @override
  String get setdLibraryMigrateSource => 'ترحيل مصدر';

  @override
  String get setdLibraryMigrateSourceDesc => 'نقل كل عنصر من مصدر إلى آخر';

  @override
  String get setdLibraryNoCategories => 'لا فئات';

  @override
  String setdLibraryDeleteCategoryConfirm(Object name) {
    return 'هل أنت متأكد من حذف \"$name\"؟ لن تُزال المانغا في هذه الفئة من مكتبتك.';
  }

  @override
  String get setdPlayerTitle => 'المشغّل';

  @override
  String get setdPlayerSectionSeek => 'النقر المزدوج للتقديم';

  @override
  String get setdPlayerSkipForward => 'تقديم للأمام';

  @override
  String get setdPlayerSkipBackward => 'إرجاع للخلف';

  @override
  String get setdPlayerSectionGestures => 'الإيماءات';

  @override
  String get setdPlayerHoldToSpeed => 'استمر بالضغط للتسريع';

  @override
  String setdPlayerHoldToSpeedDesc(Object speed) {
    return 'اضغط مطوّلًا في أي مكان للتشغيل بسرعة ${speed}x';
  }

  @override
  String get setdPlayerHoldSpeed => 'سرعة الضغط المستمر';

  @override
  String get setdPlayerVolumeSwipe => 'تمرير الصوت';

  @override
  String get setdPlayerVolumeSwipeDesc =>
      'مرّر لأعلى/لأسفل على النصف الأيمن لضبط الصوت';

  @override
  String get setdPlayerBrightnessSwipe => 'تمرير السطوع';

  @override
  String get setdPlayerBrightnessSwipeDesc =>
      'مرّر لأعلى/لأسفل على النصف الأيسر لضبط السطوع';

  @override
  String get setdPlayerSectionPlayback => 'التشغيل';

  @override
  String get setdPlayerDefaultSpeed => 'السرعة الافتراضية';

  @override
  String get setdPlayerAutoplayNext => 'التشغيل التلقائي للحلقة التالية';

  @override
  String get setdPlayerAutoplayNextDesc =>
      'بدء الحلقة التالية تلقائيًا عند انتهاء واحدة';

  @override
  String get setdPlayerAutoSkipIntro => 'تخطّي المقدّمة/الخاتمة تلقائيًا';

  @override
  String get setdPlayerAutoSkipIntroDesc =>
      'تخطّي المقدّمات/الخواتيم التي يحدّدها المصدر دون ضغط';

  @override
  String get setdPlayerSkipAmountTitle => 'مقدار التخطّي';

  @override
  String get setdPlayerShowSkipButton => 'Skip-intro button';

  @override
  String get setdPlayerShowSkipButtonDesc =>
      'Show a Skip Intro button near the start, even when the source has no markers';

  @override
  String get setdPlayerSpeedTitle => 'السرعة';

  @override
  String get setdAppearanceTitle => 'المظهر';

  @override
  String get setdAppearanceSectionTheme => 'السمة';

  @override
  String get setdAppearanceSectionDisplay => 'العرض';

  @override
  String get setdAppearanceInvertColors => 'عكس الألوان';

  @override
  String get setdAppearanceInvertColorsDesc => 'يعكس واجهة التطبيق بالكامل';

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
  String get setdAppearanceDarkMode => 'الوضع الداكن';

  @override
  String get setdAppearanceLightMode => 'الوضع الفاتح';

  @override
  String get setdAppearanceCurrentlyDark => 'داكن حاليًا';

  @override
  String get setdAppearanceCurrentlyLight => 'فاتح حاليًا';

  @override
  String get detailStatusOngoing => 'مستمر';

  @override
  String get detailStatusCompleted => 'مكتمل';

  @override
  String get detailStatusHiatus => 'متوقف مؤقتًا';

  @override
  String get detailStatusCanceled => 'ملغى';

  @override
  String get detailStatusFinished => 'منتهٍ';

  @override
  String get detailStatusUnknown => 'غير معروف';

  @override
  String detailChapterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فصل',
      many: '$count فصلًا',
      few: '$count فصول',
      two: 'فصلان',
      one: 'فصل واحد',
      zero: 'لا فصول',
    );
    return '$_temp0';
  }

  @override
  String detailEpisodeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حلقة',
      many: '$count حلقةً',
      few: '$count حلقات',
      two: 'حلقتان',
      one: 'حلقة واحدة',
      zero: 'لا حلقات',
    );
    return '$_temp0';
  }

  @override
  String detailDownloadingChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'جارٍ تنزيل $count فصل',
      many: 'جارٍ تنزيل $count فصلًا',
      few: 'جارٍ تنزيل $count فصول',
      two: 'جارٍ تنزيل فصلين',
      one: 'جارٍ تنزيل فصل واحد',
      zero: 'لا فصول للتنزيل',
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
