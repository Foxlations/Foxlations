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
  String get settingsRepoForgeTitle => 'RepoForge';

  @override
  String get settingsRepoForgeSubtitle => 'إنشاء المصادر وإدارتها من أي رابط';

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
  String get libraryApply => 'تطبيق';

  @override
  String get libraryAscending => 'تصاعدي';

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
  String libraryChaptersAbbrev(Object n) {
    return '$n فصل';
  }

  @override
  String get libraryChaptersRead => 'الفصول المقروءة';

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
  String get libraryCoverSize => 'حجم الغلاف';

  @override
  String libraryDaysCount(Object days) {
    return '$days يوم';
  }

  @override
  String get libraryDescending => 'تنازلي';

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
  String get libraryMonthlyActivity => 'النشاط الشهري';

  @override
  String get libraryMore => 'المزيد';

  @override
  String get libraryMostReadSeries => 'الأكثر قراءة';

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
  String get libraryNoNewChapters => 'لا فصول جديدة';

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
  String get libraryReadingStreak => 'سلسلة القراءة';

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
  String get librarySeries => 'السلاسل';

  @override
  String get libraryShowNumberOfItems => 'إظهار عدد العناصر';

  @override
  String get librarySizeLarge => 'كبير';

  @override
  String get librarySizeMedium => 'متوسط';

  @override
  String get librarySizeSmall => 'صغير';

  @override
  String get librarySortLastUpdated => 'آخر تحديث';

  @override
  String get librarySortRating => 'التقييم';

  @override
  String get librarySortTitle => 'العنوان';

  @override
  String get librarySortUnreadCount => 'عدد غير المقروء';

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
  String get libraryStreakBest => 'الأفضل';

  @override
  String get libraryStreakCurrent => 'الحالي';

  @override
  String libraryStreakDaysStrong(Object days) {
    return '$days يوم متواصل — واصل التقدّم!';
  }

  @override
  String get libraryStreakKeepGoing => 'اقرأ غدًا للحفاظ على السلسلة!';

  @override
  String get libraryStreakStart => 'ابدأ سلسلة بالقراءة اليوم!';

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
  String get libraryTotalChapters => 'إجمالي الفصول';

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
  String get libraryVaultBreakdown => 'توزيع الخزنة';

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
  String get readerImageZoom => 'تكبير الصورة';

  @override
  String get readerAutoPreloadNextChapter =>
      'التحميل المسبق التلقائي للفصل التالي';

  @override
  String get readerAutoPreloadNextChapterSubtitle =>
      'تحميل الفصل التالي في الخلفية';

  @override
  String get readerCropBorders => 'اقتصاص الحواف';

  @override
  String get readerCropBordersSubtitle => 'إزالة الحواف البيضاء من الصفحات';

  @override
  String get readerGrayscale => 'تدرّج رمادي';

  @override
  String get readerGrayscaleSubtitle => 'عرض الصفحات بتدرّج رمادي';

  @override
  String get readerInvertColors => 'عكس الألوان';

  @override
  String get readerInvertColorsSubtitle => 'تبديل الألوان الفاتحة والداكنة';

  @override
  String get readerDisplay => 'العرض';

  @override
  String get readerScaleType => 'نوع التحجيم';

  @override
  String get readerZoomStartPosition => 'موضع بدء التكبير';

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
  String get readerTransitions => 'الانتقالات';

  @override
  String get readerPageTransition => 'انتقال الصفحة';

  @override
  String get readerSourceNotInstalled => 'المصدر غير مثبّت';

  @override
  String get readerTranslating => 'جارٍ الترجمة…';

  @override
  String get readerRetry => 'إعادة المحاولة';

  @override
  String get readerLoadingNextChapter => 'جارٍ تحميل الفصل التالي...';

  @override
  String readerFinishedChapter(Object name) {
    return 'انتهى: $name';
  }

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
  String get browseRepoForgeTooltip => 'RepoForge — إنشاء المصادر وإدارتها';

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
  String get browseNoResultsFound => 'لم يُعثر على نتائج';

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
  String get setxSecuritySecureScreenTitle => 'شاشة آمنة';

  @override
  String get setxSecuritySecureScreenSubtitle =>
      'إخفاء محتوى التطبيق في التطبيقات الأخيرة';

  @override
  String get setxSecurityHideNotifTitle => 'إخفاء محتوى الإشعارات';

  @override
  String get setxSecurityHideNotifSubtitle => 'إظهار نص إشعار عام';

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
  String get repoDeleteSourceTitle => 'حذف المصدر؟';

  @override
  String repoDeleteSourceBody(Object name) {
    return 'ستتم إزالة \"$name\" من مصادري.';
  }

  @override
  String get repoCancel => 'إلغاء';

  @override
  String get repoDelete => 'حذف';

  @override
  String repoDeletedSource(Object name) {
    return 'تم حذف \"$name\"';
  }

  @override
  String get repoNoSourcesToExport => 'لا مصادر للتصدير';

  @override
  String get repoExportDialogTitle => 'تصدير مصادر RepoForge';

  @override
  String repoExportedSources(Object count) {
    return 'تم تصدير $count مصدر';
  }

  @override
  String repoExportFailed(Object error) {
    return 'فشل التصدير: $error';
  }

  @override
  String repoImportedSources(Object count) {
    return 'تم استيراد $count مصدر';
  }

  @override
  String repoImportFailed(Object error) {
    return 'فشل الاستيراد: $error';
  }

  @override
  String get repoBuildFromUrl => 'إنشاء المصادر من أي رابط';

  @override
  String get repoBeta => 'تجريبي';

  @override
  String get repoHeroDescription =>
      'يكتشف إطار عمل الموقع، ويضبط المحدِّدات، ويثبّت مصدر مانغا / أنمي / روايات يعمل — دون خادم، كله على الجهاز. RepoForge في مرحلة تجريبية، لذا لن يصيب المصدر دائمًا — تحقّق من النتيجة واضبط المحدِّدات إذا لم يظهر الموقع بشكل صحيح.';

  @override
  String repoCoverageSummary(Object frameworks, Object manga, Object novel) {
    return '$frameworks إطار عمل · $manga موقع مانغا + $novel موقع روايات معروف';
  }

  @override
  String get repoNewSource => 'مصدر جديد';

  @override
  String get repoImport => 'استيراد';

  @override
  String get repoMySources => 'مصادري';

  @override
  String get repoExportAll => 'تصدير الكل';

  @override
  String get repoNoSourcesYet => 'لا مصادر بعد';

  @override
  String get repoEmptyStateHint =>
      'اضغط \"مصدر جديد\" لإنشاء واحد من رابط موقع.';

  @override
  String get repoNotInstalled => 'غير مثبّت';

  @override
  String get repoOpenInBrowse => 'فتح في التصفّح';

  @override
  String get repoEditRedetect => 'تعديل / إعادة الكشف';

  @override
  String get repoKnownNovelSite => 'موقع روايات معروف';

  @override
  String get repoNovelGenericDetail =>
      'تم التعرّف عليه كموقع روايات — أُنشئ ببنية الروايات العامة (قد يحتاج التصفّح إلى ضبط المحدِّدات).';

  @override
  String repoNovelFrameworkDetail(Object framework) {
    return 'أُنشئ كمصدر روايات باستخدام بنية $framework — التصفّح والقارئ يعملان فورًا.';
  }

  @override
  String get repoKnownMangaSite => 'موقع مانغا معروف';

  @override
  String get repoMangaApiDetail =>
      'مصدر API موثّق من المجتمع — ينشئه RepoForge من واجهة API الخاصة بالموقع.';

  @override
  String repoMangaThemeDetail(Object theme) {
    return 'سمة موثّقة من المجتمع: $theme — المحدِّدات معروفة.';
  }

  @override
  String get repoMangaCustomDetail =>
      'محدِّدات مخصّصة موثّقة من المجتمع مسجّلة لهذا الموقع.';

  @override
  String get repoNotInKb => 'غير موجود في قاعدة المعرفة';

  @override
  String get repoNotInKbDetail =>
      'سيكتشف RepoForge إطار عمله مباشرة عند إضافته، ثم يعود إلى الاستخلاص الاستدلالي \"ما هو ماذا\" إذا كان مخصّصًا.';

  @override
  String get repoCoverage => 'التغطية';

  @override
  String get repoCheckASite => 'فحص موقع';

  @override
  String get repoPasteSiteUrlHint => 'الصق رابط موقع';

  @override
  String get repoCheck => 'فحص';

  @override
  String get repoSupportedFrameworks => 'أطر العمل المدعومة';

  @override
  String get repoMangaSites => 'مواقع مانغا';

  @override
  String get repoNovelSites => 'مواقع روايات';

  @override
  String get repoFrameworks => 'أطر العمل';

  @override
  String get repoRoleItem => 'عنصر القائمة (كل بطاقة)';

  @override
  String get repoRoleTitle => 'العنوان';

  @override
  String get repoRoleCover => 'صورة الغلاف';

  @override
  String get repoRoleNextPage => 'رابط الصفحة التالية';

  @override
  String get repoRoleDetailTitle => 'التفاصيل — العنوان';

  @override
  String get repoRoleChapters => 'عنصر قائمة الفصول';

  @override
  String get repoRolePageImages => 'صور صفحات القارئ';

  @override
  String get repoRoleEpisodes => 'قائمة الحلقات (أنمي)';

  @override
  String get repoStepFetching => 'جارٍ جلب الصفحة…';

  @override
  String get repoStepMatching => 'جارٍ مطابقة بصمات إطار العمل…';

  @override
  String get repoStepExtracting => 'جارٍ استخلاص المحدِّدات…';

  @override
  String get repoStepFinalizing => 'جارٍ الإنهاء…';

  @override
  String get repoEnterUrlFirst => 'أدخل رابط موقع أولًا.';

  @override
  String repoDetectionFailed(Object error) {
    return 'فشل الكشف: $error';
  }

  @override
  String get repoFetchFailed => 'فشل الجلب';

  @override
  String repoFetchedChars(Object count) {
    return 'تم جلب $count حرف — اختبر المحدِّدات الآن';
  }

  @override
  String get repoFetchPageFirst => 'اجلب صفحة أولًا';

  @override
  String repoGenerationFailed(Object error) {
    return 'فشل الإنشاء: $error';
  }

  @override
  String get repoDetectSiteFirst => 'اكتشف موقعًا أولًا';

  @override
  String repoCreatedInstalled(Object name) {
    return 'تم إنشاء وتثبيت \"$name\"';
  }

  @override
  String repoSaveFailed(Object error) {
    return 'فشل الحفظ: $error';
  }

  @override
  String get repoCreateSource => 'إنشاء مصدر';

  @override
  String get repoSiteUrl => 'رابط الموقع';

  @override
  String get repoDetect => 'كشف';

  @override
  String repoConfidence(Object pct) {
    return 'ثقة $pct%';
  }

  @override
  String get repoApiSource => 'مصدر API';

  @override
  String get repoDetails => 'التفاصيل';

  @override
  String get repoSourceNameHint => 'اسم المصدر';

  @override
  String get repoName => 'الاسم';

  @override
  String get repoLang => 'اللغة';

  @override
  String get repoManga => 'مانغا';

  @override
  String get repoAnime => 'أنمي';

  @override
  String get repoNovel => 'رواية';

  @override
  String get repoNsfw => 'للبالغين';

  @override
  String get repoScrapingStudio => 'استوديو الاستخلاص';

  @override
  String get repoScrapingStudioHint =>
      'اجلب صفحة، ثم اختبر كل محدِّد لترى عدد العناصر التي يطابقها.';

  @override
  String get repoUrlToTestHint => 'رابط للاختبار عليه';

  @override
  String get repoFetch => 'جلب';

  @override
  String get repoFetchFailedBlocked =>
      'فشل الجلب — قد يحظر الموقع الوصول الآلي.';

  @override
  String repoLoadedChars(Object count) {
    return 'تم تحميل $count حرف.';
  }

  @override
  String get repoPreviewJs => 'معاينة JS';

  @override
  String get repoCreateInstall => 'إنشاء وتثبيت';

  @override
  String get repoPickKnownSelector => 'اختر محدِّدًا معروفًا';

  @override
  String get repoTest => 'اختبار';

  @override
  String repoNoCatalogedSelectors(Object label) {
    return 'لا محدِّدات مفهرسة لـ \"$label\"';
  }

  @override
  String get repoInvalid => 'غير صالح';

  @override
  String get repoNoMatch => 'لا تطابق';

  @override
  String get repoGeneratedSource => 'المصدر المُنشأ';

  @override
  String get repoCopy => 'نسخ';

  @override
  String get repoCopiedToClipboard => 'تم نسخ المصدر إلى الحافظة';

  @override
  String repoSelectorFor(Object field) {
    return 'محدِّد لـ $field';
  }

  @override
  String get repoSearchSelectors => 'البحث في المحدِّدات…';

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
  String get setdVaultContentsInLibrary => 'في مكتبتك';

  @override
  String get setdVaultContentsMoveIntoHint => '→ نقل إلى الخزنة';

  @override
  String get setdVaultContentsInVault => 'في الخزنة';

  @override
  String get setdVaultContentsMoveOutHint => '← إخراج مجددًا';

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
}
