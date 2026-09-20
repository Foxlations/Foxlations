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
  String get settingsRepoForgeTitle => 'RepoForge';

  @override
  String get settingsRepoForgeSubtitle =>
      'Crea y gestiona fuentes desde cualquier URL';

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
  String get libraryApply => 'Aplicar';

  @override
  String get libraryAscending => 'Ascendente';

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
  String libraryChaptersAbbrev(Object n) {
    return '$n cap';
  }

  @override
  String get libraryChaptersRead => 'Capítulos leídos';

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
  String get libraryCoverSize => 'Tamaño de portada';

  @override
  String libraryDaysCount(Object days) {
    return '$days días';
  }

  @override
  String get libraryDescending => 'Descendente';

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
  String get libraryMonthlyActivity => 'Actividad mensual';

  @override
  String get libraryMore => 'Más';

  @override
  String get libraryMostReadSeries => 'Series más leídas';

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
  String get libraryNoNewChapters => 'No hay capítulos nuevos';

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
  String get libraryReadingStreak => 'Racha de lectura';

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
  String get librarySeries => 'Series';

  @override
  String get libraryShowNumberOfItems => 'Mostrar número de elementos';

  @override
  String get librarySizeLarge => 'Grande';

  @override
  String get librarySizeMedium => 'Mediano';

  @override
  String get librarySizeSmall => 'Pequeño';

  @override
  String get librarySortLastUpdated => 'Última actualización';

  @override
  String get librarySortRating => 'Valoración';

  @override
  String get librarySortTitle => 'Título';

  @override
  String get librarySortUnreadCount => 'Número sin leer';

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
  String get libraryStreakBest => 'Mejor';

  @override
  String get libraryStreakCurrent => 'Actual';

  @override
  String libraryStreakDaysStrong(Object days) {
    return '¡$days días seguidos, sigue así!';
  }

  @override
  String get libraryStreakKeepGoing => '¡Lee mañana para mantener la racha!';

  @override
  String get libraryStreakStart => '¡Empieza una racha leyendo hoy!';

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
  String get libraryTotalChapters => 'Capítulos totales';

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
  String get libraryVaultBreakdown => 'Desglose de la bóveda';

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
  String get readerImageZoom => 'Zoom de imagen';

  @override
  String get readerAutoPreloadNextChapter => 'Precargar el siguiente capítulo';

  @override
  String get readerAutoPreloadNextChapterSubtitle =>
      'Cargar el siguiente capítulo en segundo plano';

  @override
  String get readerCropBorders => 'Recortar bordes';

  @override
  String get readerCropBordersSubtitle =>
      'Quitar los bordes blancos de las páginas';

  @override
  String get readerGrayscale => 'Escala de grises';

  @override
  String get readerGrayscaleSubtitle =>
      'Mostrar las páginas en escala de grises';

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
  String get readerZoomStartPosition => 'Posición inicial del zoom';

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
  String get readerTransitions => 'Transiciones';

  @override
  String get readerPageTransition => 'Transición de página';

  @override
  String get readerSourceNotInstalled => 'Fuente no instalada';

  @override
  String get readerTranslating => 'Traduciendo…';

  @override
  String get readerRetry => 'Reintentar';

  @override
  String get readerLoadingNextChapter => 'Cargando el siguiente capítulo...';

  @override
  String readerFinishedChapter(Object name) {
    return 'Terminado: $name';
  }

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
  String get browseRepoForgeTooltip => 'RepoForge: crea y gestiona fuentes';

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
  String get browseNoResultsFound => 'No se encontraron resultados';

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
  String get repoDeleteSourceTitle => '¿Eliminar fuente?';

  @override
  String repoDeleteSourceBody(Object name) {
    return '\"$name\" se eliminará de Mis fuentes.';
  }

  @override
  String get repoCancel => 'Cancelar';

  @override
  String get repoDelete => 'Eliminar';

  @override
  String repoDeletedSource(Object name) {
    return 'Se eliminó \"$name\"';
  }

  @override
  String get repoNoSourcesToExport => 'No hay fuentes para exportar';

  @override
  String get repoExportDialogTitle => 'Exportar fuentes de RepoForge';

  @override
  String repoExportedSources(Object count) {
    return 'Se exportaron $count fuentes';
  }

  @override
  String repoExportFailed(Object error) {
    return 'Error al exportar: $error';
  }

  @override
  String repoImportedSources(Object count) {
    return 'Se importaron $count fuente(s)';
  }

  @override
  String repoImportFailed(Object error) {
    return 'Error al importar: $error';
  }

  @override
  String get repoBuildFromUrl => 'Crea fuentes desde cualquier URL';

  @override
  String get repoBeta => 'BETA';

  @override
  String get repoHeroDescription =>
      'Detecta el framework de un sitio, ajusta los selectores e instala una fuente de manga / anime / novela que funcione: sin servidor, todo en el dispositivo. RepoForge está en beta, así que no siempre acertará con una fuente; revisa el resultado y ajusta los selectores si un sitio no sale correcto.';

  @override
  String repoCoverageSummary(Object frameworks, Object manga, Object novel) {
    return '$frameworks frameworks · $manga sitios de manga + $novel de novela conocidos';
  }

  @override
  String get repoNewSource => 'Nueva fuente';

  @override
  String get repoImport => 'Importar';

  @override
  String get repoMySources => 'MIS FUENTES';

  @override
  String get repoExportAll => 'Exportar todo';

  @override
  String get repoNoSourcesYet => 'Aún no hay fuentes';

  @override
  String get repoEmptyStateHint =>
      'Toca \"Nueva fuente\" para generar una desde la URL de un sitio.';

  @override
  String get repoNotInstalled => 'no instalada';

  @override
  String get repoOpenInBrowse => 'Abrir en explorar';

  @override
  String get repoEditRedetect => 'Editar / volver a detectar';

  @override
  String get repoKnownNovelSite => 'Sitio de novela ligera conocido';

  @override
  String get repoNovelGenericDetail =>
      'Reconocido como sitio de novela: generado con el cuerpo genérico de novela (explorar puede requerir ajustar los selectores).';

  @override
  String repoNovelFrameworkDetail(Object framework) {
    return 'Generado como fuente de novela usando el cuerpo $framework: explorar y el lector funcionan de inmediato.';
  }

  @override
  String get repoKnownMangaSite => 'Sitio de manga conocido';

  @override
  String get repoMangaApiDetail =>
      'Fuente de API verificada por la comunidad: RepoForge la construye desde la API del sitio.';

  @override
  String repoMangaThemeDetail(Object theme) {
    return 'Tema verificado por la comunidad: $theme: los selectores son conocidos.';
  }

  @override
  String get repoMangaCustomDetail =>
      'Hay selectores personalizados verificados por la comunidad registrados para este sitio.';

  @override
  String get repoNotInKb => 'No está en la base de conocimiento';

  @override
  String get repoNotInKbDetail =>
      'RepoForge detectará su framework en vivo cuando lo agregues y, si es a medida, recurrirá al scraping heurístico de \"qué es qué\".';

  @override
  String get repoCoverage => 'Cobertura';

  @override
  String get repoCheckASite => 'Comprobar un sitio';

  @override
  String get repoPasteSiteUrlHint => 'pega la URL de un sitio';

  @override
  String get repoCheck => 'Comprobar';

  @override
  String get repoSupportedFrameworks => 'Frameworks compatibles';

  @override
  String get repoMangaSites => 'sitios de manga';

  @override
  String get repoNovelSites => 'sitios de novela';

  @override
  String get repoFrameworks => 'frameworks';

  @override
  String get repoRoleItem => 'Elemento de lista (cada tarjeta)';

  @override
  String get repoRoleTitle => 'Título';

  @override
  String get repoRoleCover => 'Imagen de portada';

  @override
  String get repoRoleNextPage => 'Enlace de página siguiente';

  @override
  String get repoRoleDetailTitle => 'Detalle — título';

  @override
  String get repoRoleChapters => 'Elemento de lista de capítulos';

  @override
  String get repoRolePageImages => 'Imágenes de página del lector';

  @override
  String get repoRoleEpisodes => 'Lista de episodios (anime)';

  @override
  String get repoStepFetching => 'Obteniendo página…';

  @override
  String get repoStepMatching => 'Comparando firmas de frameworks…';

  @override
  String get repoStepExtracting => 'Extrayendo selectores…';

  @override
  String get repoStepFinalizing => 'Finalizando…';

  @override
  String get repoEnterUrlFirst => 'Primero ingresa la URL de un sitio.';

  @override
  String repoDetectionFailed(Object error) {
    return 'Error de detección: $error';
  }

  @override
  String get repoFetchFailed => 'Error al obtener';

  @override
  String repoFetchedChars(Object count) {
    return 'Se obtuvieron $count caracteres: ahora prueba los selectores';
  }

  @override
  String get repoFetchPageFirst => 'Primero obtén una página';

  @override
  String repoGenerationFailed(Object error) {
    return 'Error de generación: $error';
  }

  @override
  String get repoDetectSiteFirst => 'Primero detecta un sitio';

  @override
  String repoCreatedInstalled(Object name) {
    return 'Se creó e instaló \"$name\"';
  }

  @override
  String repoSaveFailed(Object error) {
    return 'Error al guardar: $error';
  }

  @override
  String get repoCreateSource => 'Crear fuente';

  @override
  String get repoSiteUrl => 'URL del sitio';

  @override
  String get repoDetect => 'Detectar';

  @override
  String repoConfidence(Object pct) {
    return 'confianza $pct%';
  }

  @override
  String get repoApiSource => 'fuente API';

  @override
  String get repoDetails => 'Detalles';

  @override
  String get repoSourceNameHint => 'Nombre de la fuente';

  @override
  String get repoName => 'Nombre';

  @override
  String get repoLang => 'Idioma';

  @override
  String get repoManga => 'Manga';

  @override
  String get repoAnime => 'Anime';

  @override
  String get repoNovel => 'Novela';

  @override
  String get repoNsfw => 'NSFW';

  @override
  String get repoScrapingStudio => 'Estudio de scraping';

  @override
  String get repoScrapingStudioHint =>
      'Obtén una página y luego prueba cada selector para ver cuántos elementos coincide.';

  @override
  String get repoUrlToTestHint => 'URL para probar';

  @override
  String get repoFetch => 'Obtener';

  @override
  String get repoFetchFailedBlocked =>
      'Error al obtener: el sitio puede bloquear el acceso automatizado.';

  @override
  String repoLoadedChars(Object count) {
    return 'Se cargaron $count caracteres.';
  }

  @override
  String get repoPreviewJs => 'Vista previa JS';

  @override
  String get repoCreateInstall => 'Crear e instalar';

  @override
  String get repoPickKnownSelector => 'Elegir un selector conocido';

  @override
  String get repoTest => 'Probar';

  @override
  String repoNoCatalogedSelectors(Object label) {
    return 'No hay selectores catalogados para \"$label\"';
  }

  @override
  String get repoInvalid => 'no válido';

  @override
  String get repoNoMatch => 'sin coincidencias';

  @override
  String get repoGeneratedSource => 'Fuente generada';

  @override
  String get repoCopy => 'Copiar';

  @override
  String get repoCopiedToClipboard => 'Fuente copiada al portapapeles';

  @override
  String repoSelectorFor(Object field) {
    return 'Selector para $field';
  }

  @override
  String get repoSearchSelectors => 'Buscar selectores…';

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
  String get setdVaultContentsInLibrary => 'En tu biblioteca';

  @override
  String get setdVaultContentsMoveIntoHint => '→ mover a la bóveda';

  @override
  String get setdVaultContentsInVault => 'En la bóveda';

  @override
  String get setdVaultContentsMoveOutHint => '← sacar de la bóveda';

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
}
