// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Foxlations';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsSectionApp => 'Aplicación';

  @override
  String get settingsSectionManga => 'Manga';

  @override
  String get settingsSectionSystem => 'Sistema';

  @override
  String get settingsLanguageTitle => 'Idioma';

  @override
  String get settingsLanguageEntrySubtitle => 'Idioma de la aplicación';

  @override
  String get settingsLanguageSubtitle => 'Elige el idioma de la aplicación';

  @override
  String get settingsLanguageSystemDefault => 'Predeterminado del sistema';

  @override
  String get settingsLanguageHeader => 'Idioma de la aplicación';

  @override
  String get settingsAppearanceTitle => 'Apariencia';

  @override
  String get settingsAppearanceSubtitle => 'Tema, modo oscuro, pantalla';

  @override
  String get settingsNotificationsTitle => 'Notificaciones';

  @override
  String get settingsNotificationsSubtitle =>
      'Alertas, frecuencia, recordatorios';

  @override
  String get settingsStorageTitle => 'Almacenamiento';

  @override
  String get settingsStorageSubtitle =>
      'Descargas, ubicaciones de carpetas, sincronización';

  @override
  String get settingsLibraryTitle => 'Biblioteca';

  @override
  String get settingsLibrarySubtitle =>
      'Categorías, actualización global, visualización';

  @override
  String get settingsReaderTitle => 'Lector';

  @override
  String get settingsReaderSubtitle =>
      'Modo de lectura, visualización, navegación';

  @override
  String get settingsPlayerTitle => 'Reproductor';

  @override
  String get settingsPlayerSubtitle =>
      'Avance, gestos, velocidad, reproducción automática';

  @override
  String get settingsDownloadsTitle => 'Descargas';

  @override
  String get settingsDownloadsSubtitle =>
      'Descargas automáticas, eliminar capítulos';

  @override
  String get settingsTrackingTitle => 'Seguimiento';

  @override
  String get settingsTrackingSubtitle => 'MAL, AniList, Kitsu y más';

  @override
  String get settingsAiTitle => 'IA y traducción';

  @override
  String get settingsAiSubtitle =>
      'Proveedor, claves de API, detección de bocadillos';

  @override
  String get settingsBrowseTitle => 'Explorar';

  @override
  String get settingsBrowseSubtitle => 'Fuentes, extensiones, búsqueda global';

  @override
  String get settingsBackupTitle => 'Copia de seguridad';

  @override
  String get settingsBackupSubtitle =>
      'Crear/restaurar copias, importar, copia automática';

  @override
  String get settingsSecurityTitle => 'Seguridad y privacidad';

  @override
  String get settingsSecuritySubtitle =>
      'Bloqueo de app, biometría, seguridad de pantalla';

  @override
  String get settingsAdvancedTitle => 'Avanzado';

  @override
  String get settingsAdvancedSubtitle => 'Red, extensiones, registros, datos';

  @override
  String get settingsAboutTitle => 'Acerca de';

  @override
  String get settingsAboutSubtitle => 'Versión, licencias, enlaces';

  @override
  String get libraryAdd => 'Añadir';

  @override
  String get libraryAddAnime => 'Añadir anime';

  @override
  String get libraryAddLNs => 'Añadir novelas';

  @override
  String get libraryAddManga => 'Añadir manga';

  @override
  String get libraryBadges => 'Insignias';

  @override
  String get libraryBatchMigrate => 'Migrar';

  @override
  String get libraryBatchMove => 'Mover';

  @override
  String get libraryBatchRead => 'Leído';

  @override
  String get libraryBatchRemove => 'Eliminar';

  @override
  String get libraryBatchUnread => 'No leído';

  @override
  String get libraryCategoryUpdate => 'Actualizar categoría';

  @override
  String libraryCategoryUpdateDesc(Object category) {
    return 'Buscar capítulos nuevos en \"$category\"';
  }

  @override
  String libraryChapterProgress(Object read, Object total) {
    return 'Cap. $read/$total';
  }

  @override
  String libraryEpisodeProgress(Object read, Object total) {
    return 'Ep. $read/$total';
  }

  @override
  String libraryChaptersAbbrev(Object n) {
    return '$n cap';
  }

  @override
  String get libraryCheckForUpdates => 'Buscar actualizaciones';

  @override
  String get libraryClose => 'Cerrar';

  @override
  String get libraryCloseSearch => 'Cerrar búsqueda';

  @override
  String get libraryCompleted => 'Completado';

  @override
  String get libraryContinueReading => 'Continuar leyendo';

  @override
  String get libraryContinueWatching => 'Continuar viendo';

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
    return '$days días';
  }

  @override
  String get libraryDeselectAll => 'Deseleccionar todo';

  @override
  String get libraryDisplayMode => 'Modo de visualización';

  @override
  String get libraryDownloaded => 'Descargado';

  @override
  String get libraryEmpty => 'La biblioteca está vacía';

  @override
  String get libraryEmptyDesc =>
      'Tu biblioteca está vacía. Explora las fuentes para añadir manga.';

  @override
  String libraryEmptyStatsLibrary(Object word) {
    return 'Añade $word a tu biblioteca y empieza a leer para ver tus estadísticas aquí.';
  }

  @override
  String libraryEmptyStatsVault(Object word) {
    return 'Añade $word a tu bóveda y empieza a leer para ver estadísticas aquí.';
  }

  @override
  String get libraryFilterSortDisplay => 'Filtrar, ordenar y ver';

  @override
  String get libraryGlobalUpdate => 'Actualización global';

  @override
  String get libraryGlobalUpdateDesc =>
      'Comprobar todas las entradas de tu biblioteca';

  @override
  String get libraryHeatmapLess => 'Menos';

  @override
  String get libraryHeatmapMore => 'Más';

  @override
  String get libraryItemsPerRow => 'Elementos por fila';

  @override
  String libraryLastChecked(Object when) {
    return 'Última comprobación: $when';
  }

  @override
  String get libraryLibrary => 'Biblioteca';

  @override
  String libraryListChapters(Object read, Object total) {
    return '$read/$total capítulos';
  }

  @override
  String get libraryMore => 'Más';

  @override
  String get libraryMoveToCategory => 'Mover a categoría';

  @override
  String get libraryNever => 'nunca';

  @override
  String get libraryNoBookmarks => 'Aún no hay marcadores';

  @override
  String get libraryNoBookmarksDesc =>
      'Mantén pulsado un manga y márcalo para verlo aquí.';

  @override
  String get libraryNoNewChaptersLastCheck =>
      'No se encontraron capítulos nuevos en la última comprobación.';

  @override
  String get libraryNoResults => 'Sin resultados';

  @override
  String libraryNoResultsDesc(Object query) {
    return 'Sin resultados para \"$query\". Prueba con otra búsqueda.';
  }

  @override
  String get libraryNoStatsYet => 'Aún no hay estadísticas';

  @override
  String get libraryOpenRandomEntry => 'Abrir entrada aleatoria';

  @override
  String get libraryResetToDefault => 'Restablecer valores predeterminados';

  @override
  String get librarySave => 'Guardar';

  @override
  String get librarySearchHint => 'Buscar en la biblioteca...';

  @override
  String get librarySearchLibrary => 'Buscar en la biblioteca';

  @override
  String get librarySelect => 'Seleccionar';

  @override
  String get librarySelectAll => 'Seleccionar todo';

  @override
  String librarySelectedCount(Object n) {
    return '$n seleccionados';
  }

  @override
  String get libraryShowNumberOfItems => 'Mostrar número de elementos';

  @override
  String get librarySizeMedium => 'Mediano';

  @override
  String get librarySources => 'Fuentes';

  @override
  String get libraryStats => 'Estadísticas';

  @override
  String get libraryStatusAll => 'Todos';

  @override
  String get libraryStatusCompleted => 'Completado';

  @override
  String get libraryStatusDropped => 'Abandonado';

  @override
  String get libraryStatusOnHold => 'En pausa';

  @override
  String get libraryStatusPlanToRead => 'Pendiente de leer';

  @override
  String get libraryStatusReading => 'Leyendo';

  @override
  String get libraryStatusUnknown => 'Desconocido';

  @override
  String libraryStreakDaysStrong(Object days) {
    return '¡$days días seguidos, sigue así!';
  }

  @override
  String get libraryTabDisplay => 'Visualización';

  @override
  String get libraryTabFilter => 'Filtrar';

  @override
  String get libraryTabSort => 'Ordenar';

  @override
  String get libraryTabs => 'Pestañas';

  @override
  String libraryTotalAbbrev(Object n) {
    return '$n en total';
  }

  @override
  String get libraryTypeMenuBarrier => 'Library type';

  @override
  String libraryTypeBreakdown(Object type) {
    return 'Desglose de $type';
  }

  @override
  String get libraryUnread => 'Sin leer';

  @override
  String get libraryUpdatesSummary => 'Resumen de actualizaciones';

  @override
  String get libraryUpdatesSummaryDesc =>
      'Lo que encontró la última comprobación';

  @override
  String get libraryVault => 'Bóveda';

  @override
  String get libraryVaultStats => 'Estadísticas de la bóveda';

  @override
  String get detailAdd => 'Añadir';

  @override
  String get detailAddNoteHint => 'Añade una nota para este título…';

  @override
  String get detailAddToCategory => 'Añadir a categoría';

  @override
  String get detailAddToLibrary => 'Añadir a la biblioteca';

  @override
  String get detailAddWithoutCategory => 'Añadir sin categoría';

  @override
  String get detailBelowRead => 'Siguientes leídos';

  @override
  String get detailBelowUnread => 'Siguientes no leídos';

  @override
  String get detailBookmark => 'Añadir marcador';

  @override
  String get detailBookmarked => 'Marcados';

  @override
  String get detailCancel => 'Cancelar';

  @override
  String get detailChapterFallback => 'Capítulo';

  @override
  String detailCopiedTo(Object source) {
    return 'Copiado a $source';
  }

  @override
  String detailCountSelected(Object count) {
    return '$count seleccionados';
  }

  @override
  String get detailDeleteDownload => 'Eliminar descarga';

  @override
  String get detailDone => 'Listo';

  @override
  String get detailDownload => 'Descargar';

  @override
  String get detailDownloadAllChapters => 'Todos los capítulos';

  @override
  String get detailDownloadAllUnread => 'Todos los no leídos';

  @override
  String get detailDownloaded => 'Descargado';

  @override
  String get detailDownloadNext10 => 'Siguientes 10 capítulos';

  @override
  String get detailDownloadNext5 => 'Siguientes 5 capítulos';

  @override
  String get detailDownloadNextChapter => 'Siguiente capítulo';

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
  String get detailEditCategories => 'Editar categorías';

  @override
  String get detailEditCategoriesTitle => 'Editar categorías';

  @override
  String get detailFilter => 'Filtrar';

  @override
  String get detailInProgress => 'En curso';

  @override
  String get detailLogIn => 'Iniciar sesión';

  @override
  String get detailMangaNotFound => 'Manga no encontrado en la biblioteca';

  @override
  String get detailMarkAllAsRead => 'Marcar todo como leído';

  @override
  String get detailMarkAllAsUnread => 'Marcar todo como no leído';

  @override
  String get detailMarkAllBelowRead => 'Marcar todo lo siguiente como leído';

  @override
  String get detailMarkAsUnread => 'Marcar como no leído';

  @override
  String get detailMarkChapterAsRead => 'Marcar capítulo como leído';

  @override
  String get detailMarkRead => 'Marcar leído';

  @override
  String get detailMarkUnread => 'Marcar no leído';

  @override
  String get detailMigrate => 'Migrar';

  @override
  String get detailMigrateCategories => 'Categorías';

  @override
  String get detailMigrateChapters => 'Capítulos';

  @override
  String get detailMigrateCopy => 'Copiar';

  @override
  String get detailMigrateDownloadsNoTransfer =>
      'Los capítulos descargados no se transfieren.';

  @override
  String detailMigratedTo(Object source) {
    return 'Migrado a $source';
  }

  @override
  String detailMigrateEntriesToSource(Object count, Object source) {
    return '$count entradas → $source';
  }

  @override
  String get detailMigrateInfo =>
      'Selecciona el mismo manga desde otra fuente. El progreso de lectura se transferirá.';

  @override
  String get detailMigrateRemoveDownloads => 'Eliminar descargas al migrar';

  @override
  String get detailMigrateSelectData => 'Selecciona los datos a incluir';

  @override
  String get detailMigrateShowEntry => 'Ver entrada';

  @override
  String detailMigrateTitleToSource(Object title, Object source) {
    return '$title → $source';
  }

  @override
  String get detailMigrateTracking => 'Seguimiento';

  @override
  String get detailMigrating => 'Migrando…';

  @override
  String get detailNewestFirst => 'Más recientes primero';

  @override
  String get detailNoChaptersFound => 'No se encontraron capítulos';

  @override
  String get detailNoChaptersLoginHint =>
      'No se cargó nada para este título. Inténtalo de nuevo o, para esta fuente, iniciar sesión a veces desbloquea más.';

  @override
  String get detailNoChaptersRetryHint =>
      'No se cargó nada para este título. Puede que aún no tenga ninguno, o que la fuente tuviera problemas para cargarlos. Inténtalo de nuevo.';

  @override
  String get detailNoResults => 'No se encontraron resultados';

  @override
  String get detailNotes => 'Notas';

  @override
  String get detailNothingToDownload => 'Nada que descargar';

  @override
  String get detailOldestFirst => 'Más antiguos primero';

  @override
  String get detailOpenInBrowser => 'Abrir en el navegador';

  @override
  String get webviewOpenFailed => 'Couldn\'t open the browser';

  @override
  String detailPage(Object page) {
    return 'Página $page';
  }

  @override
  String get detailRefresh => 'Actualizar';

  @override
  String get detailRemove => 'Quitar';

  @override
  String get detailRemoveBookmark => 'Quitar marcador';

  @override
  String get detailRemoveFromLibrary => 'Quitar de la biblioteca';

  @override
  String get detailRemoveFromLibraryTitle => '¿Quitar de la biblioteca?';

  @override
  String get detailResume => 'Reanudar';

  @override
  String get detailRetry => 'Reintentar';

  @override
  String get detailSave => 'Guardar';

  @override
  String get detailSearchChapters => 'Buscar capítulos';

  @override
  String get detailSearchChaptersHint => 'Buscar capítulos...';

  @override
  String get detailSearchEpisodes => 'Buscar episodios';

  @override
  String get detailSearchHint => 'Buscar título del manga...';

  @override
  String get detailSearchingSources => 'Buscando fuentes…';

  @override
  String get detailSelectAll => 'Seleccionar todo';

  @override
  String get detailSelectChapters => 'Seleccionar capítulos';

  @override
  String get detailTracking => 'Seguimiento';

  @override
  String get detailUnbookmark => 'Quitar marcador';

  @override
  String get detailUnread => 'No leídos';

  @override
  String get detailWebView => 'WebView';

  @override
  String get appNavLibrary => 'Biblioteca';

  @override
  String get appNavUpdates => 'Novedades';

  @override
  String get appNavBrowse => 'Explorar';

  @override
  String get appNavDiscover => 'Discover';

  @override
  String get appNavMore => 'Más';

  @override
  String get appNavVault => 'Bóveda';

  @override
  String get appUpdatesTitle => 'Novedades';

  @override
  String get appNoNewChapters => 'No hay capítulos nuevos';

  @override
  String get appCheckForUpdates => 'Buscar actualizaciones';

  @override
  String get appClearAll => 'Borrar todo';

  @override
  String appCheckingProgress(Object checked, Object total) {
    return 'Comprobando $checked / $total...';
  }

  @override
  String appLastChecked(Object time) {
    return 'Última comprobación: $time';
  }

  @override
  String get appNoUpdatesYet => 'Aún no hay novedades';

  @override
  String get appTapRefreshForChapters =>
      'Toca actualizar para buscar capítulos nuevos';

  @override
  String get appCheckNow => 'Buscar ahora';

  @override
  String get appJustNow => 'Ahora mismo';

  @override
  String appMinutesAgo(Object m) {
    return 'hace $m min';
  }

  @override
  String appHoursAgo(Object h) {
    return 'hace $h h';
  }

  @override
  String appDaysAgo(Object d) {
    return 'hace $d d';
  }

  @override
  String get appToday => 'HOY';

  @override
  String get appYesterday => 'AYER';

  @override
  String get appOnLatestVersion => 'Ya tienes la última versión';

  @override
  String get appUpdateAvailable => 'Actualización disponible';

  @override
  String appVersionBuild(Object version, Object build) {
    return 'v$version · compilación $build';
  }

  @override
  String get appDownloadUpdate => 'Descargar actualización';

  @override
  String appDownloadVersion(Object version) {
    return 'Descargar v$version';
  }

  @override
  String get appApkDownloadHint =>
      'Abre la descarga del APK. Android te pedirá que confirmes la instalación.';

  @override
  String get appIosUpdateHint =>
      'Actualiza desde AltStore o SideStore: ábrelo y actualiza. iOS no puede instalar una app descargada en un navegador.';

  @override
  String get appSourceUrlCopied => 'URL de origen copiada: añádela en AltStore';

  @override
  String get appCopyAltstoreUrl => 'Copiar URL de origen de AltStore';

  @override
  String get appBack => 'Atrás';

  @override
  String get appForward => 'Adelante';

  @override
  String get appReload => 'Recargar';

  @override
  String get appDoneSaveCookies => 'Listo: guardar cookies';

  @override
  String get appVaultPassword => 'Contraseña de la bóveda';

  @override
  String get appEnterPassword => 'Introduce la contraseña';

  @override
  String get appWrongPassword => 'Contraseña incorrecta';

  @override
  String get appCancel => 'Cancelar';

  @override
  String get appUnlock => 'Desbloquear';

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
  String get readerExperimentalOnIos => 'Experimental en iOS';

  @override
  String get readerIosVolumeWarning =>
      'iOS no tiene una API adecuada para los botones de volumen, así que esto funciona vigilando el volumen del sistema, lo que puede fallar. Mientras lees, el volumen de lo que estés escuchando (música, un pódcast) se mantendrá al 50 % y no podrá cambiarse. ¿Activar de todos modos?';

  @override
  String get readerCancel => 'Cancelar';

  @override
  String get readerEnable => 'Activar';

  @override
  String get readerTitle => 'Lector';

  @override
  String get readerPreferences => 'Preferencias';

  @override
  String get readerReadingMode => 'Modo de lectura';

  @override
  String get readerFontSize => 'Tamaño de fuente';

  @override
  String get readerAutoPreloadNextChapter => 'Precargar el siguiente capítulo';

  @override
  String get readerAutoPreloadNextChapterSubtitle =>
      'Cargar el siguiente capítulo en segundo plano';

  @override
  String get readerGrayscale => 'Escala de grises';

  @override
  String get readerGrayscaleSubtitle =>
      'Mostrar las páginas en escala de grises';

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
  String get readerInvertColors => 'Invertir colores';

  @override
  String get readerInvertColorsSubtitle =>
      'Intercambiar colores claros y oscuros';

  @override
  String get readerDisplay => 'Pantalla';

  @override
  String get readerScaleType => 'Tipo de escala';

  @override
  String get readerBackgroundColor => 'Color de fondo';

  @override
  String get readerKeepScreenOn => 'Mantener la pantalla encendida';

  @override
  String get readerKeepScreenOnSubtitle => 'Evitar que la pantalla se apague';

  @override
  String get readerShowPageNumber => 'Mostrar número de página';

  @override
  String get readerShowPageNumberSubtitle =>
      'Mostrar el indicador de página superpuesto';

  @override
  String get readerFullscreen => 'Pantalla completa';

  @override
  String get readerFullscreenSubtitle =>
      'Ocultar las barras del sistema al leer';

  @override
  String get readerNavigation => 'Navegación';

  @override
  String get readerNavigationLayout => 'Disposición de navegación';

  @override
  String get readerInvertTapZones => 'Invertir zonas de toque';

  @override
  String get readerInvertTapZonesSubtitle =>
      'Intercambiar la navegación por toque izquierda/derecha';

  @override
  String get readerVolumeKeys => 'Botones de volumen';

  @override
  String get readerVolumeKeysSubtitle =>
      'Toca para pasar página o desplazarte; mantén pulsado para desplazar (webtoon)';

  @override
  String get readerHoldScrollSpeed => 'Velocidad de desplazamiento al mantener';

  @override
  String get readerSourceNotInstalled => 'Fuente no instalada';

  @override
  String get readerSourceNotInstalledHint =>
      'This title\'s source isn\'t installed — this can happen after restoring a backup. Install it from Extensions, then try again.';

  @override
  String get readerTranslating => 'Traduciendo…';

  @override
  String get readerRetry => 'Reintentar';

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
  String get readerLoadingNextChapter => 'Cargando el siguiente capítulo...';

  @override
  String get readerAllCaughtUp => '¡Estás al día!';

  @override
  String get readerEndOfChapter => 'Fin del capítulo';

  @override
  String get readerLatestChapterAvailable =>
      'Este es el último capítulo disponible.';

  @override
  String get readerLoadNextChapter => 'Cargar el siguiente capítulo';

  @override
  String get readerBack => 'Atrás';

  @override
  String get readerSettings => 'Ajustes';

  @override
  String get readerAiTranslate => 'Traducir con IA';

  @override
  String get readerPreviousChapter => 'Capítulo anterior';

  @override
  String get readerBookmark => 'Marcador';

  @override
  String get readerNextChapter => 'Capítulo siguiente';

  @override
  String readerTranslationFailed(Object error) {
    return 'Error de traducción: $error';
  }

  @override
  String get readerModeLtrLabel => 'De izquierda a derecha';

  @override
  String get readerModeRtlLabel => 'De derecha a izquierda';

  @override
  String get readerModeVerticalLabel => 'Desplazamiento continuo';

  @override
  String get readerModeWebtoonLabel => 'Webtoon';

  @override
  String get readerModeLtrSubtitle =>
      'Toca izquierda/derecha para pasar páginas';

  @override
  String get readerModeRtlSubtitle => 'Estilo manga de derecha a izquierda';

  @override
  String get readerModeVerticalSubtitle =>
      'Desplázate verticalmente por las páginas';

  @override
  String get readerModeWebtoonSubtitle =>
      'Optimizado para tiras verticales largas';

  @override
  String get readerChapters => 'Capítulos';

  @override
  String readerPageOf(int current, int total) {
    return 'Página $current de $total';
  }

  @override
  String get readerTabProvider => 'Proveedor';

  @override
  String get readerTabTarget => 'Destino';

  @override
  String get readerTabSource => 'Origen';

  @override
  String get readerTabFont => 'Fuente';

  @override
  String get readerFontNormal => 'Normal';

  @override
  String get readerFontManga => 'Manga';

  @override
  String get readerFontNormalDesc => 'Sans-serif limpia';

  @override
  String get readerFontMangaDesc => 'Estilo cómic en negrita';

  @override
  String get readerFontSample => 'Hola Mundo';

  @override
  String get readerNoChapterText => 'No se encontró texto del capítulo';

  @override
  String get readerReadingTitle => 'Lectura';

  @override
  String get readerSmallerText => 'Texto más pequeño';

  @override
  String get readerLargerText => 'Texto más grande';

  @override
  String get readerPrevious => 'Anterior';

  @override
  String get readerNext => 'Siguiente';

  @override
  String get browseTitle => 'Explorar';

  @override
  String get browseGlobalSearch => 'Búsqueda global';

  @override
  String get browseRefreshingRepos => 'Actualizando repositorios...';

  @override
  String get browseRefreshRepos => 'Actualizar repositorios';

  @override
  String get browseSearch => 'Buscar';

  @override
  String get browseAddRepo => 'Añadir repositorio';

  @override
  String get browseTabSources => 'Fuentes';

  @override
  String get browseTabExtensions => 'Extensiones';

  @override
  String get browseTabLocal => 'Local';

  @override
  String get browseSearchHint => 'Buscar extensiones y fuentes...';

  @override
  String browseRemoveSourceConfirm(Object name) {
    return '¿Eliminar $name?';
  }

  @override
  String get browseRemoveSourceDesc =>
      'Se desinstalará la fuente. Las entradas de tu biblioteca que provienen de ella se conservan, pero no podrás abrirlas hasta que la reinstales.';

  @override
  String get browseCancel => 'Cancelar';

  @override
  String get browseRemove => 'Eliminar';

  @override
  String get browseProvidedByThisSource => 'PROPORCIONADO POR ESTA FUENTE';

  @override
  String get browseCouldNotLoadOptions =>
      'No se pudieron cargar las opciones de la fuente';

  @override
  String get browseNoSourceOptions =>
      'Esta fuente no define opciones propias. Los ajustes de arriba siguen aplicándose a ella.';

  @override
  String get browseBaseUrl => 'URL base';

  @override
  String get browseUsingSourceDefault =>
      'Usando el valor predeterminado de la fuente';

  @override
  String browseBaseUrlDefault(Object url) {
    return '$url  (predeterminado)';
  }

  @override
  String get browseResetToDefault => 'Restablecer al valor predeterminado';

  @override
  String get browsePinToTop => 'Fijar arriba';

  @override
  String get browsePinToTopDesc =>
      'Mostrar esta fuente primero en la lista de fuentes';

  @override
  String get browseSkipGlobalSearch => 'Omitir en la búsqueda global';

  @override
  String get browseSkipGlobalSearchDesc =>
      'Dejar esta fuente fuera al buscar en todo';

  @override
  String get browseSkipLibraryUpdates =>
      'Omitir en las actualizaciones de la biblioteca';

  @override
  String get browseSkipLibraryUpdatesDesc =>
      'No comprobar nuevos capítulos en esta fuente';

  @override
  String get browseRequestDesktopSite => 'Solicitar sitio de escritorio';

  @override
  String get browseRequestDesktopSiteDesc =>
      'Prueba esto si la fuente no encuentra nada o no muestra capítulos; algunos sitios envían una página reducida a los teléfonos';

  @override
  String get browseSave => 'Guardar';

  @override
  String get browseNone => 'Ninguno';

  @override
  String browseSelectedCount(Object count) {
    return '$count seleccionados';
  }

  @override
  String get browseNotSet => 'Sin establecer';

  @override
  String get browseIosFolderWarning =>
      'iOS no permite que las apps mantengan el acceso a una carpeta. Usa \"Importar archivo\" para añadir .cbz/.cbr/.zip/.epub/.pdf en su lugar.';

  @override
  String browseImportedFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count archivos importados',
      one: '1 archivo importado',
    );
    return '$_temp0';
  }

  @override
  String get browseNothingImported =>
      'No se importó nada (no compatible o ilegible)';

  @override
  String browseFolderCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count carpetas',
      one: '1 carpeta',
    );
    return '$_temp0';
  }

  @override
  String get browseManageFolders => 'Gestionar carpetas';

  @override
  String get browseImportFileTooltip => 'Importar archivo (CBZ/ZIP/EPUB/PDF)';

  @override
  String get browseAddFolder => 'Añadir carpeta';

  @override
  String get browseRescan => 'Reescanear';

  @override
  String get browseNothingImportedYet => 'Aún no se ha importado nada';

  @override
  String get browseNoLocalSources => 'Sin fuentes locales';

  @override
  String get browseLocalSourcesDesc =>
      'Añade una carpeta de manga o importa un solo archivo.\nCompatibles: imágenes (JPG, PNG, WebP, GIF), CBZ/ZIP, EPUB y PDF.\n(CBR/RAR solo si el archivo está empaquetado como ZIP; el RAR real no es compatible.)';

  @override
  String get browseAddFolderButton => 'Añadir carpeta';

  @override
  String get browseImportFile => 'Importar archivo';

  @override
  String get browseLocalSourceFolders => 'Carpetas de fuentes locales';

  @override
  String get browseNoFoldersAdded => 'No hay carpetas añadidas';

  @override
  String browseChaptersAbbrev(Object n) {
    return '$n cap';
  }

  @override
  String get browseInstalled => 'INSTALADAS';

  @override
  String get browseAvailable => 'DISPONIBLES';

  @override
  String get browseSourceNotInstalled => 'La fuente no está instalada';

  @override
  String get browseManga => 'Manga';

  @override
  String get browseAnime => 'Anime';

  @override
  String get browseNovels => 'Novelas';

  @override
  String get browseAllLanguages => 'Todos los idiomas';

  @override
  String get browseFilter => 'Filtrar';

  @override
  String browseLanguagesCount(Object count) {
    return '$count idiomas';
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
      other: '$count resultados',
      one: '1 resultado',
    );
    return '$_temp0';
  }

  @override
  String get browseNoExtensions => 'Aún no hay extensiones';

  @override
  String get browseNoExtensionsDesc =>
      'Añade un repositorio con el botón de ajustes\nde arriba para explorar extensiones.';

  @override
  String browseUpdatedSources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fuentes actualizadas',
      one: '1 fuente actualizada',
    );
    return '$_temp0';
  }

  @override
  String get browseSourceUpdated => 'Fuente actualizada';

  @override
  String get browseNoUpdateAvailable => 'No hay actualizaciones disponibles';

  @override
  String browseUpdateFailed(Object error) {
    return 'Error al actualizar: $error';
  }

  @override
  String browseRefreshFailed(Object error) {
    return 'Error al recargar: $error';
  }

  @override
  String browseUpdatesAvailable(Object count) {
    return 'ACTUALIZACIONES DISPONIBLES ($count)';
  }

  @override
  String get browseUpdateAll => 'Actualizar todo';

  @override
  String get browseUpdate => 'Actualizar';

  @override
  String get browseSettings => 'Ajustes';

  @override
  String get browseInstall => 'Instalar';

  @override
  String get browseInstalledBadge => 'Instalada';

  @override
  String get browseAbout => 'ACERCA DE';

  @override
  String browseSourceFrom(Object url) {
    return 'Fuente de $url';
  }

  @override
  String browseLanguageLabel(Object lang) {
    return 'Idioma: $lang';
  }

  @override
  String get browseUsesCloudflare => 'Usa protección de Cloudflare';

  @override
  String get browseNoCloudflare => 'Sin Cloudflare';

  @override
  String get browseAdultContent => 'Contenido +18';

  @override
  String get browseSafeForWork => 'Apto para el trabajo';

  @override
  String get browseFeatures => 'CARACTERÍSTICAS';

  @override
  String get browsePopular => 'Popular';

  @override
  String get browseLatest => 'Recientes';

  @override
  String browseSourceAction(Object name) {
    return 'Explorar $name';
  }

  @override
  String get browseRemoving => 'Eliminando...';

  @override
  String get browseInstalling => 'Instalando...';

  @override
  String browseFailed(Object error) {
    return 'Error: $error';
  }

  @override
  String get browseNoLanguagesMatch => 'No languages match';

  @override
  String get browseYourLanguages => 'Your languages';

  @override
  String get browseSearchLanguages => 'Search languages';

  @override
  String get browseUpdating => 'Actualizando...';

  @override
  String get browseUpdateExtensionCode => 'Actualizar código de la extensión';

  @override
  String browseUpdatedSource(Object name) {
    return '$name actualizada';
  }

  @override
  String get browsePinned => 'FIJADAS';

  @override
  String get browseAll => 'Todos';

  @override
  String get browseNoInstalledSources => 'Sin fuentes instaladas';

  @override
  String get browseNoInstalledSourcesDesc =>
      'Instala extensiones desde la pestaña Extensiones\npara ver fuentes aquí.';

  @override
  String get browseUnpin => 'Desfijar';

  @override
  String get browsePin => 'Fijar';

  @override
  String get browseSourceNotInstalledBody => 'Fuente no instalada';

  @override
  String get browseBypassingCloudflare =>
      'Sorteando la protección de Cloudflare...';

  @override
  String get browseOpenInWebView => 'Abrir en WebView';

  @override
  String get browseCloudflareProtection => 'Protección de Cloudflare';

  @override
  String get browseFailedToLoad => 'Error al cargar';

  @override
  String get browseCloudflareChallengeDesc =>
      'Esta fuente requiere resolver primero un desafío de Cloudflare en el navegador.';

  @override
  String get browseSolveCloudflare => 'Resolver Cloudflare';

  @override
  String get browseRetry => 'Reintentar';

  @override
  String get browseContentAnime => 'anime';

  @override
  String get browseContentNovels => 'novelas ligeras';

  @override
  String get browseContentManga => 'manga';

  @override
  String browseNoContentFound(Object noun) {
    return 'No se encontró $noun';
  }

  @override
  String get browseAllCategories => 'Todas las categorías';

  @override
  String get browseNoCategories => 'Sin categorías';

  @override
  String get browseSearchMangaHint => 'Buscar manga...';

  @override
  String get browseUnknown => 'Desconocido';

  @override
  String get browseSearchAllSourcesHint => 'Buscar en todas las fuentes...';

  @override
  String get browseNoSourcesInstalled => 'No hay fuentes instaladas';

  @override
  String get browseNoSourcesInstalledDesc =>
      'Instala extensiones desde la pestaña Explorar.';

  @override
  String get browseSearchAllSources => 'Buscar en todas las fuentes';

  @override
  String browseSearchSourcesAtOnce(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Busca en $count fuentes a la vez.',
      one: 'Busca en 1 fuente a la vez.',
    );
    return '$_temp0';
  }

  @override
  String browseSearchingSources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Buscando en $count fuentes...',
      one: 'Buscando en 1 fuente...',
    );
    return '$_temp0';
  }

  @override
  String get browseSeeAll => 'Ver todo';

  @override
  String get globalSearchSourceNoResults => 'No results';

  @override
  String get globalSearchSourceFailed => 'Couldn\'t search this source';

  @override
  String get browseSectionSources => 'Fuentes';

  @override
  String get browseShowNsfw => 'Mostrar fuentes NSFW';

  @override
  String get browseShowNsfwDesc => 'Mostrar fuentes +18 en explorar y buscar';

  @override
  String get browsePinnedOnly => 'Solo fuentes fijadas';

  @override
  String get browsePinnedOnlyBrowseDesc =>
      'Mostrar solo fuentes fijadas al explorar';

  @override
  String get browseSectionGlobalSearch => 'Búsqueda global';

  @override
  String get browsePinnedOnlyGlobalSearchDesc =>
      'Buscar solo en fuentes fijadas en la búsqueda global';

  @override
  String get browseSectionWebView => 'WebView';

  @override
  String get browseAdBlocker => 'Bloqueador de anuncios';

  @override
  String get browseAdBlockerDesc =>
      'Bloquea anuncios, ventanas emergentes y superposiciones en el navegador';

  @override
  String get browseSectionExtensions => 'Extensiones';

  @override
  String get browseAutoUpdate => 'Actualizar extensiones automáticamente';

  @override
  String get browseAutoUpdateDesc =>
      'Recargar el código de las extensiones instaladas al iniciar la app';

  @override
  String get setxAdvancedTitle => 'Avanzado';

  @override
  String get setxAdvancedSectionLogging => 'Registro';

  @override
  String get setxAdvancedVerboseLoggingTitle => 'Registro detallado';

  @override
  String get setxAdvancedVerboseLoggingSubtitle =>
      'Registrar información de depuración detallada';

  @override
  String get setxAdvancedViewErrorLogsTitle => 'Ver registros de errores';

  @override
  String get setxAdvancedViewErrorLogsSubtitle =>
      'Examinar registros de depuración y errores';

  @override
  String get setxAdvancedSectionNetwork => 'Red';

  @override
  String get setxAdvancedDnsOverHttpsTitle => 'DNS sobre HTTPS';

  @override
  String get setxAdvancedDnsOverHttpsSubtitle => 'Usar resolución DNS segura';

  @override
  String get setxAdvancedDnsProviderTitle => 'Proveedor de DNS';

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
  String get setxAdvancedSectionExtensions => 'Extensiones';

  @override
  String get setxAdvancedThirdPartyTitle => 'Extensiones de terceros';

  @override
  String get setxAdvancedThirdPartySubtitle =>
      'Permitir extensiones de fuentes desconocidas';

  @override
  String get setxAdvancedExtUpdateTitle =>
      'Alertas de actualización de extensiones';

  @override
  String get setxAdvancedExtUpdateSubtitle =>
      'Notificar cuando las extensiones tengan actualizaciones';

  @override
  String get setxAdvancedSectionBrowser => 'Navegador';

  @override
  String get setxAdvancedExternalBrowserTitle => 'Navegador externo';

  @override
  String get setxAdvancedExternalBrowserSubtitle =>
      'Abrir enlaces en el navegador del sistema';

  @override
  String get setxAdvancedSectionData => 'Datos';

  @override
  String get setxAdvancedClearCacheTitle => 'Borrar caché de capítulos';

  @override
  String get setxAdvancedClearCacheSubtitle =>
      'Liberar espacio de almacenamiento';

  @override
  String get setxAdvancedClearDbEntryTitle => 'Borrar base de datos';

  @override
  String get setxAdvancedClearDbEntrySubtitle =>
      'Restablecer biblioteca, categorías e historial de lectura';

  @override
  String get setxAdvancedCacheCleared =>
      'Caché de imágenes de capítulos borrada';

  @override
  String get setxAdvancedClearDbTitle => '¿Borrar base de datos?';

  @override
  String get setxAdvancedClearDbBody =>
      'Esto elimina permanentemente tu biblioteca, categorías e historial de lectura. Las extensiones instaladas y las descargas no se ven afectadas.';

  @override
  String get setxAdvancedCancel => 'Cancelar';

  @override
  String get setxAdvancedClear => 'Borrar';

  @override
  String get setxAdvancedDbCleared =>
      'Base de datos borrada: reinicia la aplicación para restaurar los valores predeterminados';

  @override
  String get setxAdvancedErrorLogsTitle => 'Registros de errores';

  @override
  String get setxAdvancedClearAllLogsTooltip => 'Borrar todos los registros';

  @override
  String get setxAdvancedFilterCategory => 'Categoría';

  @override
  String get setxAdvancedFilterLevel => 'Nivel';

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
  String get setxAdvancedNoLogs => 'Aún no hay registros';

  @override
  String get setxAdvancedNoLogsSubtitle =>
      'Los registros aparecerán aquí a medida que uses la aplicación';

  @override
  String get setxAdvancedClearLogsTitle => '¿Borrar todos los registros?';

  @override
  String get setxAdvancedClearLogsBody =>
      'Esto eliminará permanentemente todas las entradas de registro almacenadas.';

  @override
  String get setxAdvancedLogsCleared => 'Registros borrados';

  @override
  String get setxAdvancedCopiedToClipboard => 'Copiado al portapapeles';

  @override
  String get setxNotifTitle => 'Notificaciones';

  @override
  String get setxNotifSectionChapterUpdates => 'Actualizaciones de capítulos';

  @override
  String get setxNotifNewChaptersTitle => 'Capítulos nuevos';

  @override
  String get setxNotifNewChaptersSubtitle =>
      'Notificar cuando haya nuevos capítulos disponibles';

  @override
  String get setxNotifLibraryUpdatesTitle => 'Actualizaciones de la biblioteca';

  @override
  String get setxNotifLibraryUpdatesSubtitle =>
      'Notificar cuando finalice la actualización de la biblioteca';

  @override
  String get setxNotifSectionDownloads => 'Descargas';

  @override
  String get setxNotifDownloadCompleteTitle => 'Descarga completada';

  @override
  String get setxNotifDownloadCompleteSubtitle =>
      'Notificar cuando los capítulos terminen de descargarse';

  @override
  String get setxNotifDownloadErrorTitle => 'Error de descarga';

  @override
  String get setxNotifDownloadErrorSubtitle =>
      'Notificar cuando falle una descarga';

  @override
  String get setxNotifSectionBehavior => 'Comportamiento';

  @override
  String get setxNotifSoundTitle => 'Sonido';

  @override
  String get setxNotifSoundSubtitle =>
      'Reproducir sonido para las notificaciones';

  @override
  String get setxNotifVibrationTitle => 'Vibración';

  @override
  String get setxNotifVibrationSubtitle => 'Vibrar para las notificaciones';

  @override
  String get setxNotifGroupTitle => 'Agrupar notificaciones';

  @override
  String get setxNotifGroupSubtitle => 'Combinar varias notificaciones';

  @override
  String get setxSecurityTitle => 'Seguridad y privacidad';

  @override
  String get setxSecuritySectionAppLock => 'Bloqueo de la aplicación';

  @override
  String get setxSecurityAppLockTitle => 'Bloqueo de la aplicación';

  @override
  String get setxSecurityAppLockSubtitle =>
      'Requerir autenticación para abrir la aplicación';

  @override
  String get setxSecurityBiometricsTitle => 'Biometría';

  @override
  String get setxSecurityBiometricsSubtitle =>
      'Usar huella dactilar o rostro para desbloquear';

  @override
  String get setxSecuritySectionPrivacy => 'Privacidad';

  @override
  String get setxSecurityIncognitoTitle => 'Incognito mode';

  @override
  String get setxSecurityIncognitoSubtitle =>
      'Don\'t save reading history or update trackers';

  @override
  String get libraryIncognitoActive => 'Incognito mode on';

  @override
  String get setxSecuritySecureScreenTitle => 'Pantalla segura';

  @override
  String get setxSecuritySecureScreenSubtitle =>
      'Ocultar el contenido de la aplicación en aplicaciones recientes';

  @override
  String get setxSecurityHideNotifTitle =>
      'Ocultar contenido de notificaciones';

  @override
  String get setxSecurityHideNotifSubtitle =>
      'Mostrar texto de notificación genérico';

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
  String get setxBackupTitle => 'Copia de seguridad y restauración';

  @override
  String get setxBackupSectionFoxlations => 'Copia de seguridad de Foxlations';

  @override
  String get setxBackupCreateTitle => 'Crear copia de seguridad';

  @override
  String get setxBackupCreateSubtitle =>
      'Guarda tu biblioteca, categorías, progreso de lectura, fuentes y seguimiento';

  @override
  String get setxBackupRestoreTitle => 'Restaurar copia de seguridad';

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
      'Restaurar desde un archivo .fxbackup de Foxlations';

  @override
  String get setxBackupSectionTachiyomi => 'Tachiyomi / Mihon y derivados';

  @override
  String get setxBackupCreateCompatTitle =>
      'Crear copia de seguridad compatible';

  @override
  String get setxBackupCreateCompatSubtitle =>
      'Exporta un .tachibk que puedes importar en Tachiyomi, Mihon y derivados';

  @override
  String get setxBackupRestoreTachiyomiTitle =>
      'Restaurar desde Tachiyomi/Mihon';

  @override
  String get setxBackupRestoreTachiyomiSubtitle =>
      'Importa una copia .tachibk / .tmb / .proto.gz (empareja las fuentes por nombre)';

  @override
  String get setxBackupSectionAutomatic => 'Copia de seguridad automática';

  @override
  String get setxBackupFrequency => 'Frecuencia';

  @override
  String setxBackupAutoSubtitle(Object freq) {
    return 'Crear una copia de seguridad $freq';
  }

  @override
  String setxBackupSectionBackups(Object count) {
    return 'Copias de seguridad ($count)';
  }

  @override
  String get setxBackupNone => 'Aún no hay copias de seguridad.';

  @override
  String get setxBackupMenuRestore => 'Restaurar';

  @override
  String get setxBackupMenuDelete => 'Eliminar';

  @override
  String get setxBackupFreqOff => 'Desactivada';

  @override
  String get setxBackupFreqDaily => 'Diaria';

  @override
  String get setxBackupFreqWeekly => 'Semanal';

  @override
  String get setxBackupFreqMonthly => 'Mensual';

  @override
  String setxBackupImportedManga(Object count) {
    return 'Se importaron $count manga';
  }

  @override
  String get setxBackupRestoreComplete => 'Restauración completada';

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
    return 'Error al restaurar: $error';
  }

  @override
  String get setxAboutTitle => 'Acerca de';

  @override
  String get setxAboutSectionApp => 'Aplicación';

  @override
  String get setxAboutWhatsNewTitle => 'Novedades';

  @override
  String get setxAboutWhatsNewSubtitle =>
      'Registro de cambios y notas de la versión';

  @override
  String get setxAboutCheckUpdatesTitle => 'Buscar actualizaciones';

  @override
  String get setxAboutCheckUpdatesSubtitle =>
      'Comprueba si se ha publicado una compilación más reciente';

  @override
  String get setxAboutSectionLegal => 'Legal';

  @override
  String get setxAboutLicensesTitle => 'Licencias';

  @override
  String get setxAboutLicensesSubtitle => 'Licencias de código abierto';

  @override
  String get setxAboutSectionLinks => 'Enlaces';

  @override
  String get setxAboutSourceCodeTitle => 'Código fuente';

  @override
  String get setxAboutSourceCodeSubtitle => 'Toca para copiar la URL de GitHub';

  @override
  String get setxAboutReportBugTitle => 'Informar de un error';

  @override
  String get setxAboutReportBugSubtitle =>
      'Toca para copiar la URL del rastreador de incidencias';

  @override
  String get setxAboutClose => 'Cerrar';

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
    return 'Novedades en la v$version';
  }

  @override
  String setxAboutLinkCopied(Object label) {
    return 'Enlace de $label copiado al portapapeles';
  }

  @override
  String get setxAboutSourceCodeLabel => 'código fuente';

  @override
  String get setxAboutBugReportLabel => 'informe de errores';

  @override
  String get miscResumePlaybackTitle => '¿Reanudar la reproducción?';

  @override
  String miscStoppedWatchingAt(Object time) {
    return 'Dejaste de ver en $time.';
  }

  @override
  String get miscStartOver => 'Empezar de nuevo';

  @override
  String miscContinueAt(Object time) {
    return 'Continuar ($time)';
  }

  @override
  String get miscQuality => 'Calidad';

  @override
  String miscSourceIndex(Object index) {
    return 'Fuente $index';
  }

  @override
  String get miscSubtitles => 'Subtítulos';

  @override
  String get miscSubtitleOff => 'Desactivados';

  @override
  String get miscUnknownTrack => 'Desconocido';

  @override
  String get miscSubtitleDelay => 'Retraso de subtítulos';

  @override
  String get miscAudio => 'Audio';

  @override
  String get miscPlaybackSpeed => 'Velocidad de reproducción';

  @override
  String get miscSkipOutro => 'Saltar cierre';

  @override
  String get miscSkipIntro => 'Saltar intro';

  @override
  String get miscUnlockControls => 'Desbloquear controles';

  @override
  String get miscUnknownError => 'Error desconocido';

  @override
  String get miscRetry => 'Reintentar';

  @override
  String get miscExtensionRepositories => 'Repositorios de extensiones';

  @override
  String get miscRepositoryUrlHint => 'URL del repositorio (index.json)';

  @override
  String get miscAdd => 'Añadir';

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
  String get miscRepositoriesHeader => 'REPOSITORIOS';

  @override
  String get miscNoReposYet => 'Aún no hay repositorios añadidos';

  @override
  String miscFailedToAddRepo(Object error) {
    return 'No se pudo añadir el repositorio: $error';
  }

  @override
  String get miscVerifyHuman => 'Verifica que eres humano';

  @override
  String get miscCfInstructions =>
      'Completa la verificación del sitio a continuación. Se cierra automáticamente y no volverá a preguntar mientras dure la verificación.';

  @override
  String get trackTitle => 'Seguimiento';

  @override
  String get trackNoTrackerConnected =>
      'Ningún servicio de seguimiento conectado';

  @override
  String get trackConnectHint =>
      'Conecta AniList, MyAnimeList o Kitsu en Ajustes › Seguimiento.';

  @override
  String trackNotLinkedOn(Object name) {
    return 'No vinculado en $name';
  }

  @override
  String get trackLink => 'Vincular';

  @override
  String get trackUnlink => 'Desvincular';

  @override
  String get trackStatus => 'Estado';

  @override
  String get trackChapters => 'Capítulos';

  @override
  String get trackScore => 'Puntuación';

  @override
  String trackLinkedTo(Object name) {
    return 'Vinculado a $name';
  }

  @override
  String trackLinkOn(Object name) {
    return 'Vincular en $name';
  }

  @override
  String get trackSearchTitleHint => 'Buscar título';

  @override
  String get trackSearch => 'Buscar';

  @override
  String get trackNoResults => 'Sin resultados';

  @override
  String trackChaptersShort(Object count) {
    return '$count cap.';
  }

  @override
  String trackConnectTracker(Object name) {
    return 'Conectar $name';
  }

  @override
  String get trackOauthInstructions =>
      'Inicia sesión y pulsa Autorizar. Se te conectará automáticamente.';

  @override
  String get trackServices => 'Servicios';

  @override
  String get trackServicesDescription =>
      'Conecta un servicio de seguimiento para sincronizar tu progreso de lectura. Una vez vinculado un manga, el progreso se actualiza automáticamente mientras lees.';

  @override
  String trackLogInTo(Object name) {
    return 'Inicia sesión en $name';
  }

  @override
  String get trackEmailOrUsername => 'Correo electrónico o nombre de usuario';

  @override
  String get trackPassword => 'Contraseña';

  @override
  String get trackCancel => 'Cancelar';

  @override
  String get trackLogIn => 'Iniciar sesión';

  @override
  String trackConnectedTo(Object name) {
    return 'Conectado a $name';
  }

  @override
  String get trackLoginFailed =>
      'Error de inicio de sesión — comprueba tus credenciales';

  @override
  String get trackSetClientIdFirst => 'Primero configura un ID de cliente';

  @override
  String get trackCouldNotCompleteSignIn =>
      'No se pudo completar el inicio de sesión';

  @override
  String trackClientIdTitle(Object name) {
    return 'ID de cliente de $name (avanzado)';
  }

  @override
  String trackClientIdDescription(Object name) {
    return 'Opcional. Foxlations ya incluye un ID de cliente de $name integrado; solo pulsa Conectar. Configúralo únicamente si registraste tu propia aplicación de desarrollador de $name y quieres usarla en su lugar.';
  }

  @override
  String get trackClientId => 'ID de cliente';

  @override
  String get trackSave => 'Guardar';

  @override
  String get trackPasteAccessToken => 'Pega el token de acceso';

  @override
  String get trackPasteTokenHint =>
      'Pega el token que se muestra tras autorizar';

  @override
  String get trackConnect => 'Conectar';

  @override
  String get trackCouldNotVerifyToken => 'No se pudo verificar el token';

  @override
  String get trackConnected => 'Conectado';

  @override
  String trackConnectedAs(Object username) {
    return 'Conectado como $username';
  }

  @override
  String get trackTapConnectToAuthorize => 'Pulsa Conectar para autorizar';

  @override
  String get trackSignInWithAccount => 'Inicia sesión con tu cuenta';

  @override
  String get trackDisconnect => 'Desconectar';

  @override
  String get trackAiTitle => 'IA y traducción';

  @override
  String get trackTabTranslation => 'Traducción';

  @override
  String get trackTabApiKeys => 'Claves API';

  @override
  String get trackTabModels => 'Modelos';

  @override
  String get trackEnableAiTranslation => 'Activar traducción con IA';

  @override
  String get trackEnableAiTranslationDesc =>
      'Mostrar el botón de traducir en el lector';

  @override
  String get trackProvider => 'Proveedor';

  @override
  String get trackOfflineMode => 'Modo sin conexión';

  @override
  String get trackOfflineModeDesc => 'Usa modelos descargados sin internet';

  @override
  String get trackTranslationSettings => 'Ajustes de traducción';

  @override
  String get trackTargetLanguage => 'Idioma de destino';

  @override
  String get trackTargetLanguageDesc =>
      'Traduce el texto del manga a este idioma';

  @override
  String get trackBubbleDetection => 'Detección de bocadillos';

  @override
  String get trackBubbleDetectionDesc =>
      'Detecta automáticamente los bocadillos en las páginas del manga';

  @override
  String get trackQuality => 'Calidad';

  @override
  String get trackQualityFast => 'Rápida';

  @override
  String get trackQualityBalanced => 'Equilibrada';

  @override
  String get trackQualityHigh => 'Alta calidad';

  @override
  String get trackKoharuServer => 'Servidor Koharu';

  @override
  String get trackServerUrl => 'URL del servidor';

  @override
  String get trackKoharuServerDesc =>
      'Retoque completo del manga mediante un servidor Docker local';

  @override
  String get trackApiKeyRequired => 'Se requiere clave API';

  @override
  String get trackApiKeysNotice =>
      'Las claves se guardan localmente en tu dispositivo y nunca se envían a nuestros servidores.';

  @override
  String get trackModelsPlatformOnly =>
      'Los modelos de traducción en el dispositivo están disponibles en Android e iOS.';

  @override
  String get trackModelsDescription =>
      'Descarga un idioma para traducirlo completamente sin conexión. Cada paquete ocupa unos 30 MB y también se descarga automáticamente la primera vez que traduces ese idioma.';

  @override
  String get trackTranslationLanguages => 'IDIOMAS DE TRADUCCIÓN';

  @override
  String get trackDownloaded => 'Descargado — disponible sin conexión';

  @override
  String get trackNotDownloaded => 'No descargado';

  @override
  String get trackDelete => 'Eliminar';

  @override
  String get trackDownload => 'Descargar';

  @override
  String trackDownloadFailed(Object error) {
    return 'Error al descargar: $error';
  }

  @override
  String trackDeleteFailed(Object error) {
    return 'Error al eliminar: $error';
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
  String get repoCancel => 'Cancelar';

  @override
  String get repoName => 'Nombre';

  @override
  String repoImportedSource(Object id) {
    return 'Fuente importada · $id';
  }

  @override
  String get repoCheckingMatches => 'Comprobando coincidencias';

  @override
  String get repoMigrating => 'Migrando';

  @override
  String get repoMigrateThisSource => '¿Migrar esta fuente?';

  @override
  String repoMatchedByUrl(Object count) {
    return '$count coincidieron por URL';
  }

  @override
  String repoMatchedByTitle(Object count) {
    return '$count coincidieron por título';
  }

  @override
  String repoNotFoundLeftInPlace(Object count) {
    return '$count no encontradas: se dejaron sin cambios';
  }

  @override
  String get repoMigrateCarryOver =>
      'El progreso de lectura, las categorías y el seguimiento se conservan. Los originales se eliminan solo para las entradas que se mueven.';

  @override
  String repoMigrateCount(Object count) {
    return 'Migrar $count';
  }

  @override
  String get repoMigrateASource => 'Migrar una fuente';

  @override
  String get repoMigrateIntro =>
      'Mueve todas las entradas de la biblioteca de una fuente a otra. Los cambios en el mismo sitio coinciden exactamente por URL; las entradas importadas de una copia de seguridad también se pueden reubicar en una fuente real.';

  @override
  String get repoFrom => 'DESDE';

  @override
  String get repoSelectSource => 'Selecciona una fuente…';

  @override
  String get repoTo => 'HACIA';

  @override
  String get repoAlsoMatchByTitle => 'También coincidir por título';

  @override
  String get repoAlsoMatchByTitleHint =>
      'Para movimientos entre sitios: si una entrada no se encuentra por URL, busca en la nueva fuente por título y toma la coincidencia más cercana. Desactivado por defecto para que no pueda vincular la serie equivocada.';

  @override
  String get repoMigrateSource => 'Migrar fuente';

  @override
  String get repoMigrationComplete => 'Migración completa';

  @override
  String repoMovedByUrl(Object count) {
    return '$count movidas por URL';
  }

  @override
  String repoMovedByTitle(Object count) {
    return '$count movidas por título';
  }

  @override
  String repoLeftInPlace(Object count) {
    return '$count sin cambios';
  }

  @override
  String get repoNotMigratedHeader =>
      'No migradas (aún en la fuente anterior):';

  @override
  String get repoUsePerTitleMigrate =>
      'Usa la migración por título para estas.';

  @override
  String get repoDone => 'Listo';

  @override
  String get setdDownloadsTitle => 'Descargas';

  @override
  String get setdDownloadsSectionAutomatic => 'Descargas automáticas';

  @override
  String get setdDownloadsNewChapters => 'Descargar capítulos nuevos';

  @override
  String get setdDownloadsNewChaptersDesc =>
      'Descargar automáticamente los capítulos nuevos';

  @override
  String get setdDownloadsWifiOnly => 'Solo con Wi-Fi';

  @override
  String get setdDownloadsWifiOnlyDesc => 'Descargar solo con Wi-Fi';

  @override
  String get setdDownloadsChargingOnly => 'Solo cargando';

  @override
  String get setdDownloadsChargingOnlyDesc =>
      'Descargar solo mientras está enchufado';

  @override
  String get setdDownloadsAhead => 'Descargar mientras lees';

  @override
  String get setdDownloadsAheadDesc =>
      'Descargar el siguiente capítulo mientras lees';

  @override
  String get setdDownloadsSectionQueue => 'Cola de descargas';

  @override
  String get setdDownloadsSimultaneous => 'Descargas simultáneas';

  @override
  String get setdDownloadsQuality => 'Calidad de descarga';

  @override
  String get setdDownloadsSectionDelete => 'Eliminar capítulos descargados';

  @override
  String get setdDownloadsAfterReading => 'Después de leer';

  @override
  String get setdDownloadsAfterReadingDesc =>
      'Eliminar los capítulos después de leerlos';

  @override
  String get setdDownloadsIncludeBookmarked => 'Incluir capítulos marcados';

  @override
  String get setdDownloadsIncludeBookmarkedDesc =>
      'Eliminar también los capítulos marcados junto con los demás';

  @override
  String get setdDownloadsAutoDelete => 'Autoeliminar capítulos leídos';

  @override
  String get setdDownloadsSectionFormat => 'Formato';

  @override
  String get setdDownloadsSaveCbz => 'Guardar como CBZ';

  @override
  String get setdDownloadsSaveCbzDesc =>
      'Archivar los capítulos como archivos CBZ con metadatos';

  @override
  String get setdDownloadsSavePdf => 'Guardar como PDF';

  @override
  String get setdDownloadsSavePdfDesc =>
      'Empaquetar los capítulos en un solo PDF (una imagen por página)';

  @override
  String get setdDownloadsSectionLocation => 'Ubicación de descarga';

  @override
  String get setdDownloadsDefaultLocation => 'Ubicación predeterminada';

  @override
  String get setdDownloadsCustomLocation => 'Ubicación personalizada';

  @override
  String get setdDownloadsChooseFolder => 'Elegir carpeta';

  @override
  String get setdDownloadsIosFolderWarning =>
      'iOS no permite que las apps mantengan el acceso a una carpeta. Las descargas se quedan en la carpeta de la app, accesible en Archivos › En mi iPhone › Foxlations.';

  @override
  String get setdDownloadsReset => 'Restablecer';

  @override
  String get setdDownloadsSectionStorage => 'Almacenamiento';

  @override
  String setdDownloadsTotalSize(Object size) {
    return 'Total: $size MB';
  }

  @override
  String setdDownloadsLibraryVaultSize(Object lib, Object vault) {
    return 'Biblioteca: $lib MB  |  Bóveda: $vault MB';
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
  String get setdVaultTitle => 'Bóveda';

  @override
  String get setdVaultSectionAccess => 'Acceso';

  @override
  String get setdVaultEnable => 'Activar la bóveda';

  @override
  String get setdVaultEnableDesc =>
      'Permite acceder a la bóveda oculta tocando Biblioteca 8 veces';

  @override
  String get setdVaultSectionSecurity => 'Seguridad';

  @override
  String get setdVaultChangePassword => 'Cambiar contraseña';

  @override
  String get setdVaultSetPassword => 'Establecer contraseña';

  @override
  String get setdVaultPasswordSetDesc =>
      'La contraseña está establecida — toca para cambiarla o quitarla';

  @override
  String get setdVaultPasswordUnsetDesc =>
      'Protege el acceso a la bóveda con una contraseña';

  @override
  String get setdVaultSectionCategories => 'Categorías de la bóveda';

  @override
  String get setdVaultEditCategories => 'Editar categorías de la bóveda';

  @override
  String get setdVaultEditCategoriesDesc =>
      'Añade, elimina y reordena las categorías de la bóveda';

  @override
  String get setdVaultSectionContents => 'Contenido';

  @override
  String get setdVaultManageContents => 'Gestionar contenido de la bóveda';

  @override
  String get setdVaultManageContentsDesc =>
      'Mueve manga, anime o novelas dentro y fuera de la bóveda';

  @override
  String get setdVaultUnlockFirstSnack =>
      'Primero desbloquea la bóveda (entra desde la biblioteca)';

  @override
  String get setdVaultSectionHiddenSources => 'Fuentes ocultas';

  @override
  String get setdVaultOnlySources => 'Fuentes solo de la bóveda';

  @override
  String setdVaultHiddenSourcesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fuentes ocultas',
      one: '1 fuente oculta',
    );
    return '$_temp0';
  }

  @override
  String get setdVaultSectionInfo => 'Información';

  @override
  String get setdVaultInfoText =>
      'La bóveda es una biblioteca oculta con sus propias categorías y manga. Toca la pestaña Biblioteca 8 veces rápidamente para alternar el modo bóveda. El manga de la bóveda se almacena por separado y nunca aparece en tu biblioteca principal.';

  @override
  String get setdVaultCurrentPasswordHint => 'Contraseña actual';

  @override
  String get setdVaultNewPasswordHint =>
      'Nueva contraseña (déjala vacía para quitarla)';

  @override
  String get setdVaultConfirmPasswordHint => 'Confirmar nueva contraseña';

  @override
  String get setdVaultCurrentPasswordWrong =>
      'La contraseña actual es incorrecta';

  @override
  String get setdVaultPasswordsMismatch => 'Las contraseñas no coinciden';

  @override
  String get setdVaultRemovingEncryption => 'Quitando el cifrado…';

  @override
  String get setdVaultEncrypting => 'Cifrando la bóveda…';

  @override
  String get setdVaultPasswordRemoved =>
      'Contraseña eliminada — la bóveda ya no está cifrada';

  @override
  String get setdVaultPasswordSet => 'Contraseña establecida — bóveda cifrada';

  @override
  String get setdVaultNoCategories => 'No hay categorías en la bóveda';

  @override
  String setdVaultDeleteCategoryConfirm(Object name) {
    return '¿Seguro que quieres eliminar \"$name\"? El manga de esta categoría no se eliminará de la bóveda.';
  }

  @override
  String get setdVaultNoInstalledSources => 'No hay fuentes instaladas';

  @override
  String get setdVaultHiddenSourcesToggleHint =>
      'Activa las fuentes para que solo se vean en modo bóveda.';

  @override
  String get setdVaultSearchSourcesHint => 'Buscar fuentes...';

  @override
  String get setdCategoryNameHint => 'Nombre de la categoría';

  @override
  String get setdNewCategory => 'Nueva categoría';

  @override
  String get setdRenameCategory => 'Renombrar categoría';

  @override
  String get setdDeleteCategory => 'Eliminar categoría';

  @override
  String get setdActionCancel => 'Cancelar';

  @override
  String get setdActionSave => 'Guardar';

  @override
  String get setdActionAdd => 'Añadir';

  @override
  String get setdActionDelete => 'Eliminar';

  @override
  String get setdTapToAddCategory => 'Toca + para añadir una categoría';

  @override
  String get setdVaultContentsTitle => 'Contenido de la bóveda';

  @override
  String get setdVaultContentsLockedMessage =>
      'Primero desbloquea la bóveda para gestionar su contenido.';

  @override
  String get setdVaultContentsTabManga => 'Manga';

  @override
  String get setdVaultContentsTabAnime => 'Anime';

  @override
  String get setdVaultContentsTabNovels => 'Novelas';

  @override
  String setdVaultContentsEmptyLibrary(Object type) {
    return 'No hay $type en tu biblioteca';
  }

  @override
  String setdVaultContentsEmptyVault(Object type) {
    return 'No hay $type en la bóveda';
  }

  @override
  String setdVaultContentsMovedIn(Object title) {
    return '\"$title\" movido a la bóveda';
  }

  @override
  String setdVaultContentsMovedOut(Object title) {
    return '\"$title\" sacado de la bóveda';
  }

  @override
  String setdVaultContentsReadProgress(Object read, Object total) {
    return '$read/$total leídos';
  }

  @override
  String get setdLibraryTitle => 'Biblioteca';

  @override
  String get setdLibrarySectionCategories => 'Categorías';

  @override
  String get setdLibraryEditCategories => 'Editar categorías';

  @override
  String get setdLibraryEditCategoriesDesc =>
      'Añade, elimina y reordena las categorías';

  @override
  String get setdLibraryHideEmpty => 'Ocultar categorías vacías';

  @override
  String get setdLibraryHideEmptyDesc =>
      'Mostrar solo las categorías con manga';

  @override
  String get setdLibrarySectionGlobalUpdate => 'Actualización global';

  @override
  String get setdLibraryUpdateFrequency => 'Frecuencia de actualización';

  @override
  String get setdLibraryWifiOnly => 'Solo con Wi-Fi';

  @override
  String get setdLibraryWifiOnlyDesc => 'Actualizar solo con conexiones Wi-Fi';

  @override
  String get setdLibraryChargingOnly => 'Solo mientras carga';

  @override
  String get setdLibraryChargingOnlyDesc =>
      'Actualizar solo cuando el dispositivo está cargando';

  @override
  String get setdLibrarySectionRestrictions => 'Restricciones de actualización';

  @override
  String get setdLibrarySkipNotStarted => 'Omitir no iniciados';

  @override
  String get setdLibrarySkipNotStartedDesc =>
      'Omitir el manga sin progreso de lectura';

  @override
  String get setdLibraryShowUpdateCount =>
      'Mostrar recuento de capítulos nuevos';

  @override
  String get setdLibraryShowUpdateCountDesc =>
      'Mostrar una insignia en las tarjetas de manga de la biblioteca';

  @override
  String get setdLibrarySectionData => 'Datos';

  @override
  String get setdLibraryMigrateSource => 'Migrar una fuente';

  @override
  String get setdLibraryMigrateSourceDesc =>
      'Mover todas las entradas de una fuente a otra';

  @override
  String get setdLibraryNoCategories => 'No hay categorías';

  @override
  String setdLibraryDeleteCategoryConfirm(Object name) {
    return '¿Seguro que quieres eliminar \"$name\"? El manga de esta categoría no se eliminará de tu biblioteca.';
  }

  @override
  String get setdPlayerTitle => 'Reproductor';

  @override
  String get setdPlayerSectionSeek => 'DOBLE TOQUE PARA SALTAR';

  @override
  String get setdPlayerSkipForward => 'Saltar hacia delante';

  @override
  String get setdPlayerSkipBackward => 'Saltar hacia atrás';

  @override
  String get setdPlayerSectionGestures => 'GESTOS';

  @override
  String get setdPlayerHoldToSpeed => 'Mantén para acelerar';

  @override
  String setdPlayerHoldToSpeedDesc(Object speed) {
    return 'Mantén pulsado en cualquier lugar para reproducir a ${speed}x';
  }

  @override
  String get setdPlayerHoldSpeed => 'Velocidad al mantener';

  @override
  String get setdPlayerVolumeSwipe => 'Deslizar para volumen';

  @override
  String get setdPlayerVolumeSwipeDesc =>
      'Desliza arriba/abajo en la mitad derecha para ajustar el volumen';

  @override
  String get setdPlayerBrightnessSwipe => 'Deslizar para brillo';

  @override
  String get setdPlayerBrightnessSwipeDesc =>
      'Desliza arriba/abajo en la mitad izquierda para ajustar el brillo';

  @override
  String get setdPlayerSectionPlayback => 'REPRODUCCIÓN';

  @override
  String get setdPlayerDefaultSpeed => 'Velocidad predeterminada';

  @override
  String get setdPlayerAutoplayNext => 'Reproducir siguiente episodio';

  @override
  String get setdPlayerAutoplayNextDesc =>
      'Iniciar el siguiente episodio automáticamente al terminar uno';

  @override
  String get setdPlayerAutoSkipIntro => 'Saltar intro/outro automáticamente';

  @override
  String get setdPlayerAutoSkipIntroDesc =>
      'Saltar las aperturas/cierres marcados por la fuente sin tocar';

  @override
  String get setdPlayerSkipAmountTitle => 'Cantidad a saltar';

  @override
  String get setdPlayerShowSkipButton => 'Skip-intro button';

  @override
  String get setdPlayerShowSkipButtonDesc =>
      'Show a Skip Intro button near the start, even when the source has no markers';

  @override
  String get setdPlayerSpeedTitle => 'Velocidad';

  @override
  String get setdAppearanceTitle => 'Apariencia';

  @override
  String get setdAppearanceSectionTheme => 'Tema';

  @override
  String get setdAppearanceSectionDisplay => 'Pantalla';

  @override
  String get setdAppearanceInvertColors => 'Invertir colores';

  @override
  String get setdAppearanceInvertColorsDesc =>
      'Invierte toda la interfaz de la app';

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
  String get setdAppearanceDarkMode => 'Modo oscuro';

  @override
  String get setdAppearanceLightMode => 'Modo claro';

  @override
  String get setdAppearanceCurrentlyDark => 'Actualmente oscuro';

  @override
  String get setdAppearanceCurrentlyLight => 'Actualmente claro';

  @override
  String get detailStatusOngoing => 'En curso';

  @override
  String get detailStatusCompleted => 'Completado';

  @override
  String get detailStatusHiatus => 'En pausa';

  @override
  String get detailStatusCanceled => 'Cancelado';

  @override
  String get detailStatusFinished => 'Finalizado';

  @override
  String get detailStatusUnknown => 'Desconocido';

  @override
  String detailChapterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos',
      one: '1 capítulo',
    );
    return '$_temp0';
  }

  @override
  String detailEpisodeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count episodios',
      one: '1 episodio',
    );
    return '$_temp0';
  }

  @override
  String detailDownloadingChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Descargando $count capítulos',
      one: 'Descargando 1 capítulo',
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
