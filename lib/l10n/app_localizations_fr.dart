// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Foxlations';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsSectionApp => 'Application';

  @override
  String get settingsSectionManga => 'Manga';

  @override
  String get settingsSectionSystem => 'Système';

  @override
  String get settingsLanguageTitle => 'Langue';

  @override
  String get settingsLanguageEntrySubtitle =>
      'Langue d’affichage de l’application';

  @override
  String get settingsLanguageSubtitle =>
      'Choisissez la langue de l’application';

  @override
  String get settingsLanguageSystemDefault => 'Paramètre système';

  @override
  String get settingsLanguageHeader => 'Langue de l’application';

  @override
  String get settingsAppearanceTitle => 'Apparence';

  @override
  String get settingsAppearanceSubtitle => 'Thème, mode sombre, affichage';

  @override
  String get settingsNotificationsTitle => 'Notifications';

  @override
  String get settingsNotificationsSubtitle =>
      'Alertes push, fréquence, rappels';

  @override
  String get settingsStorageTitle => 'Stockage';

  @override
  String get settingsStorageSubtitle =>
      'Téléchargements, emplacements des dossiers, synchronisation';

  @override
  String get settingsLibraryTitle => 'Bibliothèque';

  @override
  String get settingsLibrarySubtitle =>
      'Catégories, mise à jour globale, affichage';

  @override
  String get settingsReaderTitle => 'Lecteur';

  @override
  String get settingsReaderSubtitle => 'Mode de lecture, affichage, navigation';

  @override
  String get settingsPlayerTitle => 'Lecteur vidéo';

  @override
  String get settingsPlayerSubtitle =>
      'Avance, gestes, vitesse, lecture automatique';

  @override
  String get settingsDownloadsTitle => 'Téléchargements';

  @override
  String get settingsDownloadsSubtitle =>
      'Téléchargements automatiques, suppression des chapitres';

  @override
  String get settingsTrackingTitle => 'Suivi';

  @override
  String get settingsTrackingSubtitle => 'MAL, AniList, Kitsu et plus';

  @override
  String get settingsAiTitle => 'IA et traduction';

  @override
  String get settingsAiSubtitle =>
      'Fournisseur, clés API, détection des bulles';

  @override
  String get settingsBrowseTitle => 'Explorer';

  @override
  String get settingsBrowseSubtitle => 'Sources, extensions, recherche globale';

  @override
  String get settingsRepoForgeTitle => 'RepoForge';

  @override
  String get settingsRepoForgeSubtitle =>
      'Créez et gérez des sources depuis n’importe quelle URL';

  @override
  String get settingsBackupTitle => 'Sauvegarde et restauration';

  @override
  String get settingsBackupSubtitle =>
      'Créer/restaurer des sauvegardes, importer, sauvegarde auto';

  @override
  String get settingsSecurityTitle => 'Sécurité et confidentialité';

  @override
  String get settingsSecuritySubtitle =>
      'Verrouillage, biométrie, sécurité de l’écran';

  @override
  String get settingsAdvancedTitle => 'Avancé';

  @override
  String get settingsAdvancedSubtitle =>
      'Réseau, extensions, journalisation, données';

  @override
  String get settingsAboutTitle => 'À propos';

  @override
  String get settingsAboutSubtitle => 'Version, licences, liens';

  @override
  String get libraryAdd => 'Ajouter';

  @override
  String get libraryAddAnime => 'Ajouter un anime';

  @override
  String get libraryAddLNs => 'Ajouter des LN';

  @override
  String get libraryAddManga => 'Ajouter un manga';

  @override
  String get libraryApply => 'Appliquer';

  @override
  String get libraryAscending => 'Croissant';

  @override
  String get libraryBadges => 'Badges';

  @override
  String get libraryBatchMigrate => 'Migrer';

  @override
  String get libraryBatchMove => 'Déplacer';

  @override
  String get libraryBatchRead => 'Lu';

  @override
  String get libraryBatchRemove => 'Supprimer';

  @override
  String get libraryBatchUnread => 'Non lu';

  @override
  String get libraryCategoryUpdate => 'Mise à jour de la catégorie';

  @override
  String libraryCategoryUpdateDesc(Object category) {
    return 'Vérifier « $category » pour de nouveaux chapitres';
  }

  @override
  String libraryChapterProgress(Object read, Object total) {
    return 'Ch. $read/$total';
  }

  @override
  String libraryEpisodeProgress(Object read, Object total) {
    return 'Ép. $read/$total';
  }

  @override
  String libraryChaptersAbbrev(Object n) {
    return '$n ch';
  }

  @override
  String get libraryChaptersRead => 'Chapitres lus';

  @override
  String get libraryCheckForUpdates => 'Rechercher des mises à jour';

  @override
  String get libraryClose => 'Fermer';

  @override
  String get libraryCloseSearch => 'Fermer la recherche';

  @override
  String get libraryCompleted => 'Terminé';

  @override
  String get libraryContinueReading => 'Continuer la lecture';

  @override
  String get libraryContinueWatching => 'Continuer le visionnage';

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
  String get libraryCoverSize => 'Taille des couvertures';

  @override
  String libraryDaysCount(Object days) {
    return '$days jours';
  }

  @override
  String get libraryDescending => 'Décroissant';

  @override
  String get libraryDeselectAll => 'Tout désélectionner';

  @override
  String get libraryDisplayMode => 'Mode d’affichage';

  @override
  String get libraryDownloaded => 'Téléchargé';

  @override
  String get libraryEmpty => 'La bibliothèque est vide';

  @override
  String get libraryEmptyDesc =>
      'Votre bibliothèque est vide. Explorez les sources pour ajouter des mangas.';

  @override
  String libraryEmptyStatsLibrary(Object word) {
    return 'Ajoutez $word à votre bibliothèque et commencez à lire pour voir vos statistiques ici.';
  }

  @override
  String libraryEmptyStatsVault(Object word) {
    return 'Ajoutez $word à votre coffre et commencez à lire pour voir les statistiques ici.';
  }

  @override
  String get libraryFilterSortDisplay => 'Filtrer, trier et afficher';

  @override
  String get libraryGlobalUpdate => 'Mise à jour globale';

  @override
  String get libraryGlobalUpdateDesc =>
      'Vérifier chaque entrée de votre bibliothèque';

  @override
  String get libraryHeatmapLess => 'Moins';

  @override
  String get libraryHeatmapMore => 'Plus';

  @override
  String get libraryItemsPerRow => 'Éléments par ligne';

  @override
  String libraryLastChecked(Object when) {
    return 'Dernière vérification : $when';
  }

  @override
  String get libraryLibrary => 'Bibliothèque';

  @override
  String libraryListChapters(Object read, Object total) {
    return '$read/$total chapitres';
  }

  @override
  String get libraryMonthlyActivity => 'Activité mensuelle';

  @override
  String get libraryMore => 'Plus';

  @override
  String get libraryMostReadSeries => 'Séries les plus lues';

  @override
  String get libraryMoveToCategory => 'Déplacer vers la catégorie';

  @override
  String get libraryNever => 'jamais';

  @override
  String get libraryNoBookmarks => 'Aucun favori pour l’instant';

  @override
  String get libraryNoBookmarksDesc =>
      'Appuyez longuement sur un manga et ajoutez-le aux favoris pour le voir ici.';

  @override
  String get libraryNoNewChapters => 'Aucun nouveau chapitre';

  @override
  String get libraryNoNewChaptersLastCheck =>
      'Aucun nouveau chapitre n’a été trouvé lors de la dernière vérification.';

  @override
  String get libraryNoResults => 'Aucun résultat';

  @override
  String libraryNoResultsDesc(Object query) {
    return 'Aucun résultat pour « $query ». Essayez une autre recherche.';
  }

  @override
  String get libraryNoStatsYet => 'Aucune statistique pour l’instant';

  @override
  String get libraryOpenRandomEntry => 'Ouvrir une entrée au hasard';

  @override
  String get libraryReadingStreak => 'Série de lecture';

  @override
  String get libraryResetToDefault => 'Réinitialiser';

  @override
  String get librarySave => 'Enregistrer';

  @override
  String get librarySearchHint => 'Rechercher dans la bibliothèque...';

  @override
  String get librarySearchLibrary => 'Rechercher dans la bibliothèque';

  @override
  String get librarySelect => 'Sélectionner';

  @override
  String get librarySelectAll => 'Tout sélectionner';

  @override
  String librarySelectedCount(Object n) {
    return '$n sélectionné(s)';
  }

  @override
  String get librarySeries => 'Séries';

  @override
  String get libraryShowNumberOfItems => 'Afficher le nombre d’éléments';

  @override
  String get librarySizeLarge => 'Grande';

  @override
  String get librarySizeMedium => 'Moyenne';

  @override
  String get librarySizeSmall => 'Petite';

  @override
  String get librarySortLastUpdated => 'Dernière mise à jour';

  @override
  String get librarySortRating => 'Note';

  @override
  String get librarySortTitle => 'Titre';

  @override
  String get librarySortUnreadCount => 'Nombre de non lus';

  @override
  String get librarySources => 'Sources';

  @override
  String get libraryStats => 'Statistiques';

  @override
  String get libraryStatusAll => 'Tous';

  @override
  String get libraryStatusCompleted => 'Terminé';

  @override
  String get libraryStatusDropped => 'Abandonné';

  @override
  String get libraryStatusOnHold => 'En pause';

  @override
  String get libraryStatusPlanToRead => 'À lire';

  @override
  String get libraryStatusReading => 'En cours de lecture';

  @override
  String get libraryStatusUnknown => 'Inconnu';

  @override
  String get libraryStreakBest => 'Meilleure';

  @override
  String get libraryStreakCurrent => 'Actuelle';

  @override
  String libraryStreakDaysStrong(Object days) {
    return '$days jours d’affilée — continuez comme ça !';
  }

  @override
  String get libraryStreakKeepGoing =>
      'Lisez demain pour maintenir votre série !';

  @override
  String get libraryStreakStart =>
      'Commencez une série en lisant aujourd’hui !';

  @override
  String get libraryTabDisplay => 'Affichage';

  @override
  String get libraryTabFilter => 'Filtrer';

  @override
  String get libraryTabSort => 'Trier';

  @override
  String get libraryTabs => 'Onglets';

  @override
  String libraryTotalAbbrev(Object n) {
    return '$n au total';
  }

  @override
  String get libraryTotalChapters => 'Total des chapitres';

  @override
  String get libraryTypeMenuBarrier => 'Library type';

  @override
  String libraryTypeBreakdown(Object type) {
    return 'Répartition des $type';
  }

  @override
  String get libraryUnread => 'Non lus';

  @override
  String get libraryUpdatesSummary => 'Résumé des mises à jour';

  @override
  String get libraryUpdatesSummaryDesc =>
      'Ce que la dernière vérification a trouvé';

  @override
  String get libraryVault => 'Coffre';

  @override
  String get libraryVaultBreakdown => 'Répartition du coffre';

  @override
  String get libraryVaultStats => 'Statistiques du coffre';

  @override
  String get detailAdd => 'Ajouter';

  @override
  String get detailAddNoteHint => 'Ajouter une note pour ce titre…';

  @override
  String get detailAddToCategory => 'Ajouter à la catégorie';

  @override
  String get detailAddToLibrary => 'Ajouter à la bibliothèque';

  @override
  String get detailAddWithoutCategory => 'Ajouter sans catégorie';

  @override
  String get detailBelowRead => 'En dessous lus';

  @override
  String get detailBelowUnread => 'En dessous non lus';

  @override
  String get detailBookmark => 'Ajouter aux favoris';

  @override
  String get detailBookmarked => 'En favori';

  @override
  String get detailCancel => 'Annuler';

  @override
  String get detailChapterFallback => 'Chapitre';

  @override
  String detailCopiedTo(Object source) {
    return 'Copié vers $source';
  }

  @override
  String detailCountSelected(Object count) {
    return '$count sélectionné(s)';
  }

  @override
  String get detailDeleteDownload => 'Supprimer le téléchargement';

  @override
  String get detailDone => 'Terminé';

  @override
  String get detailDownload => 'Télécharger';

  @override
  String get detailDownloadAllChapters => 'Tous les chapitres';

  @override
  String get detailDownloadAllUnread => 'Tous les non lus';

  @override
  String get detailDownloaded => 'Téléchargé';

  @override
  String get detailDownloadNext10 => '10 chapitres suivants';

  @override
  String get detailDownloadNext5 => '5 chapitres suivants';

  @override
  String get detailDownloadNextChapter => 'Chapitre suivant';

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
  String get detailEditCategories => 'Modifier les catégories';

  @override
  String get detailEditCategoriesTitle => 'Modifier les catégories';

  @override
  String get detailFilter => 'Filtrer';

  @override
  String get detailInProgress => 'En cours';

  @override
  String get detailLogIn => 'Se connecter';

  @override
  String get detailMangaNotFound => 'Manga introuvable dans la bibliothèque';

  @override
  String get detailMarkAllAsRead => 'Tout marquer comme lu';

  @override
  String get detailMarkAllAsUnread => 'Tout marquer comme non lu';

  @override
  String get detailMarkAllBelowRead => 'Marquer tout en dessous comme lu';

  @override
  String get detailMarkAsUnread => 'Marquer comme non lu';

  @override
  String get detailMarkChapterAsRead => 'Marquer le chapitre comme lu';

  @override
  String get detailMarkRead => 'Marquer comme lu';

  @override
  String get detailMarkUnread => 'Marquer comme non lu';

  @override
  String get detailMigrate => 'Migrer';

  @override
  String get detailMigrateCategories => 'Catégories';

  @override
  String get detailMigrateChapters => 'Chapitres';

  @override
  String get detailMigrateCopy => 'Copier';

  @override
  String get detailMigrateDownloadsNoTransfer =>
      'Les chapitres téléchargés ne sont pas transférés.';

  @override
  String detailMigratedTo(Object source) {
    return 'Migré vers $source';
  }

  @override
  String detailMigrateEntriesToSource(Object count, Object source) {
    return '$count entrées → $source';
  }

  @override
  String get detailMigrateInfo =>
      'Sélectionnez le même manga depuis une autre source. La progression de lecture sera transférée.';

  @override
  String get detailMigrateRemoveDownloads =>
      'Supprimer les téléchargements après migration';

  @override
  String get detailMigrateSelectData => 'Sélectionnez les données à inclure';

  @override
  String get detailMigrateShowEntry => 'Afficher l’entrée';

  @override
  String detailMigrateTitleToSource(Object title, Object source) {
    return '$title → $source';
  }

  @override
  String get detailMigrateTracking => 'Suivi';

  @override
  String get detailMigrating => 'Migration…';

  @override
  String get detailNewestFirst => 'Plus récents d’abord';

  @override
  String get detailNoChaptersFound => 'Aucun chapitre trouvé';

  @override
  String get detailNoChaptersLoginHint =>
      'Rien n’a été chargé pour ce titre. Réessayez — ou, pour cette source, vous connecter peut parfois débloquer davantage de contenu.';

  @override
  String get detailNoChaptersRetryHint =>
      'Rien n’a été chargé pour ce titre. Il n’en a peut-être pas encore, ou la source a eu du mal à les charger. Réessayez.';

  @override
  String get detailNoResults => 'Aucun résultat trouvé';

  @override
  String get detailNotes => 'Notes';

  @override
  String get detailNothingToDownload => 'Rien à télécharger';

  @override
  String get detailOldestFirst => 'Plus anciens d’abord';

  @override
  String get detailOpenInBrowser => 'Ouvrir dans le navigateur';

  @override
  String get webviewOpenFailed => 'Couldn\'t open the browser';

  @override
  String detailPage(Object page) {
    return 'Page $page';
  }

  @override
  String get detailRefresh => 'Actualiser';

  @override
  String get detailRemove => 'Supprimer';

  @override
  String get detailRemoveBookmark => 'Retirer des favoris';

  @override
  String get detailRemoveFromLibrary => 'Retirer de la bibliothèque';

  @override
  String get detailRemoveFromLibraryTitle => 'Retirer de la bibliothèque ?';

  @override
  String get detailResume => 'Reprendre';

  @override
  String get detailRetry => 'Réessayer';

  @override
  String get detailSave => 'Enregistrer';

  @override
  String get detailSearchChapters => 'Rechercher des chapitres';

  @override
  String get detailSearchChaptersHint => 'Rechercher des chapitres...';

  @override
  String get detailSearchEpisodes => 'Rechercher des épisodes';

  @override
  String get detailSearchHint => 'Rechercher un titre de manga...';

  @override
  String get detailSearchingSources => 'Recherche dans les sources…';

  @override
  String get detailSelectAll => 'Tout sélectionner';

  @override
  String get detailSelectChapters => 'Sélectionner des chapitres';

  @override
  String get detailTracking => 'Suivi';

  @override
  String get detailUnbookmark => 'Retirer des favoris';

  @override
  String get detailUnread => 'Non lu';

  @override
  String get detailWebView => 'WebView';

  @override
  String get appNavLibrary => 'Bibliothèque';

  @override
  String get appNavUpdates => 'Mises à jour';

  @override
  String get appNavBrowse => 'Explorer';

  @override
  String get appNavDiscover => 'Discover';

  @override
  String get appNavMore => 'Plus';

  @override
  String get appNavVault => 'Coffre';

  @override
  String get appUpdatesTitle => 'Mises à jour';

  @override
  String get appNoNewChapters => 'Aucun nouveau chapitre';

  @override
  String get appCheckForUpdates => 'Rechercher des mises à jour';

  @override
  String get appClearAll => 'Tout effacer';

  @override
  String appCheckingProgress(Object checked, Object total) {
    return 'Vérification $checked / $total...';
  }

  @override
  String appLastChecked(Object time) {
    return 'Dernière vérification : $time';
  }

  @override
  String get appNoUpdatesYet => 'Aucune mise à jour pour l’instant';

  @override
  String get appTapRefreshForChapters =>
      'Appuyez sur actualiser pour rechercher de nouveaux chapitres';

  @override
  String get appCheckNow => 'Vérifier maintenant';

  @override
  String get appJustNow => 'À l’instant';

  @override
  String appMinutesAgo(Object m) {
    return 'il y a $m min';
  }

  @override
  String appHoursAgo(Object h) {
    return 'il y a $h h';
  }

  @override
  String appDaysAgo(Object d) {
    return 'il y a $d j';
  }

  @override
  String get appToday => 'AUJOURD’HUI';

  @override
  String get appYesterday => 'HIER';

  @override
  String get appOnLatestVersion => 'Vous utilisez la dernière version';

  @override
  String get appUpdateAvailable => 'Mise à jour disponible';

  @override
  String appVersionBuild(Object version, Object build) {
    return 'v$version · build $build';
  }

  @override
  String get appDownloadUpdate => 'Télécharger la mise à jour';

  @override
  String appDownloadVersion(Object version) {
    return 'Télécharger la v$version';
  }

  @override
  String get appApkDownloadHint =>
      'Ouvre le téléchargement de l’APK. Android vous demandera de confirmer l’installation.';

  @override
  String get appIosUpdateHint =>
      'Mettez à jour depuis AltStore ou SideStore — ouvrez l’app et actualisez. iOS ne peut pas installer une app téléchargée dans un navigateur.';

  @override
  String get appSourceUrlCopied =>
      'URL de la source copiée — ajoutez-la dans AltStore';

  @override
  String get appCopyAltstoreUrl => 'Copier l’URL de source AltStore';

  @override
  String get appBack => 'Retour';

  @override
  String get appForward => 'Suivant';

  @override
  String get appReload => 'Recharger';

  @override
  String get appDoneSaveCookies => 'Terminé — enregistrer les cookies';

  @override
  String get appVaultPassword => 'Mot de passe du coffre';

  @override
  String get appEnterPassword => 'Entrez le mot de passe';

  @override
  String get appWrongPassword => 'Mot de passe incorrect';

  @override
  String get appCancel => 'Annuler';

  @override
  String get appUnlock => 'Déverrouiller';

  @override
  String get readerExperimentalOnIos => 'Expérimental sur iOS';

  @override
  String get readerIosVolumeWarning =>
      'iOS n’a pas de véritable API pour les boutons de volume, donc cette fonction surveille le volume du système — elle peut être capricieuse. Pendant la lecture, le volume de ce que vous écoutez (musique, podcast) sera maintenu à 50 % et ne pourra pas être modifié. Activer quand même ?';

  @override
  String get readerCancel => 'Annuler';

  @override
  String get readerEnable => 'Activer';

  @override
  String get readerTitle => 'Lecteur';

  @override
  String get readerPreferences => 'Préférences';

  @override
  String get readerReadingMode => 'Mode de lecture';

  @override
  String get readerFontSize => 'Taille de police';

  @override
  String get readerImageZoom => 'Zoom de l’image';

  @override
  String get readerAutoPreloadNextChapter => 'Précharger le chapitre suivant';

  @override
  String get readerAutoPreloadNextChapterSubtitle =>
      'Charger le chapitre suivant en arrière-plan';

  @override
  String get readerCropBorders => 'Rogner les bordures';

  @override
  String get readerCropBordersSubtitle =>
      'Supprimer les bordures blanches des pages';

  @override
  String get readerGrayscale => 'Niveaux de gris';

  @override
  String get readerGrayscaleSubtitle => 'Afficher les pages en niveaux de gris';

  @override
  String get readerAutoCrop => 'Auto-crop borders';

  @override
  String get readerAutoCropSubtitle =>
      'Trim solid white/black margins so pages fill the screen';

  @override
  String get readerInvertColors => 'Inverser les couleurs';

  @override
  String get readerInvertColorsSubtitle =>
      'Échanger les couleurs claires et sombres';

  @override
  String get readerDisplay => 'Affichage';

  @override
  String get readerScaleType => 'Type de mise à l’échelle';

  @override
  String get readerZoomStartPosition => 'Position de départ du zoom';

  @override
  String get readerBackgroundColor => 'Couleur d’arrière-plan';

  @override
  String get readerKeepScreenOn => 'Garder l’écran allumé';

  @override
  String get readerKeepScreenOnSubtitle =>
      'Empêcher la mise en veille de l’écran';

  @override
  String get readerShowPageNumber => 'Afficher le numéro de page';

  @override
  String get readerShowPageNumberSubtitle =>
      'Afficher l’indicateur de page en superposition';

  @override
  String get readerFullscreen => 'Plein écran';

  @override
  String get readerFullscreenSubtitle =>
      'Masquer les barres système pendant la lecture';

  @override
  String get readerNavigation => 'Navigation';

  @override
  String get readerNavigationLayout => 'Disposition de navigation';

  @override
  String get readerInvertTapZones => 'Inverser les zones de toucher';

  @override
  String get readerInvertTapZonesSubtitle =>
      'Échanger la navigation par toucher gauche/droite';

  @override
  String get readerVolumeKeys => 'Touches de volume';

  @override
  String get readerVolumeKeysSubtitle =>
      'Appuyez pour tourner une page/défiler ; maintenez pour défiler (webtoon)';

  @override
  String get readerHoldScrollSpeed => 'Vitesse de défilement maintenu';

  @override
  String get readerTransitions => 'Transitions';

  @override
  String get readerPageTransition => 'Transition de page';

  @override
  String get readerSourceNotInstalled => 'Source non installée';

  @override
  String get readerSourceNotInstalledHint =>
      'This title\'s source isn\'t installed — this can happen after restoring a backup. Install it from Extensions, then try again.';

  @override
  String get readerTranslating => 'Traduction…';

  @override
  String get readerRetry => 'Réessayer';

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
  String get readerLoadingNextChapter => 'Chargement du chapitre suivant...';

  @override
  String readerFinishedChapter(Object name) {
    return 'Terminé : $name';
  }

  @override
  String get readerAllCaughtUp => 'Vous êtes à jour !';

  @override
  String get readerEndOfChapter => 'Fin du chapitre';

  @override
  String get readerLatestChapterAvailable =>
      'C’est le dernier chapitre disponible.';

  @override
  String get readerLoadNextChapter => 'Charger le chapitre suivant';

  @override
  String get readerBack => 'Retour';

  @override
  String get readerSettings => 'Paramètres';

  @override
  String get readerAiTranslate => 'Traduire par IA';

  @override
  String get readerPreviousChapter => 'Chapitre précédent';

  @override
  String get readerBookmark => 'Favori';

  @override
  String get readerNextChapter => 'Chapitre suivant';

  @override
  String readerTranslationFailed(Object error) {
    return 'Échec de la traduction : $error';
  }

  @override
  String get readerModeLtrLabel => 'De gauche à droite';

  @override
  String get readerModeRtlLabel => 'De droite à gauche';

  @override
  String get readerModeVerticalLabel => 'Défilement continu';

  @override
  String get readerModeWebtoonLabel => 'Webtoon';

  @override
  String get readerModeLtrSubtitle =>
      'Appuyez à gauche/droite pour tourner les pages';

  @override
  String get readerModeRtlSubtitle => 'Style manga, de droite à gauche';

  @override
  String get readerModeVerticalSubtitle =>
      'Faites défiler les pages verticalement';

  @override
  String get readerModeWebtoonSubtitle =>
      'Optimisé pour les longues bandes verticales';

  @override
  String get readerChapters => 'Chapitres';

  @override
  String readerPageOf(int current, int total) {
    return 'Page $current sur $total';
  }

  @override
  String get readerTabProvider => 'Fournisseur';

  @override
  String get readerTabTarget => 'Cible';

  @override
  String get readerTabSource => 'Source';

  @override
  String get readerTabFont => 'Police';

  @override
  String get readerFontNormal => 'Normale';

  @override
  String get readerFontManga => 'Manga';

  @override
  String get readerFontNormalDesc => 'Sans-serif épurée';

  @override
  String get readerFontMangaDesc => 'Style BD gras';

  @override
  String get readerFontSample => 'Bonjour le monde';

  @override
  String get readerNoChapterText => 'Aucun texte de chapitre trouvé';

  @override
  String get readerReadingTitle => 'Lecture';

  @override
  String get readerSmallerText => 'Texte plus petit';

  @override
  String get readerLargerText => 'Texte plus grand';

  @override
  String get readerPrevious => 'Précédent';

  @override
  String get readerNext => 'Suivant';

  @override
  String get browseTitle => 'Explorer';

  @override
  String get browseGlobalSearch => 'Recherche globale';

  @override
  String get browseRefreshingRepos => 'Actualisation des dépôts...';

  @override
  String get browseRefreshRepos => 'Actualiser les dépôts';

  @override
  String get browseSearch => 'Rechercher';

  @override
  String get browseRepoForgeTooltip => 'RepoForge — créez et gérez des sources';

  @override
  String get browseAddRepo => 'Ajouter un dépôt';

  @override
  String get browseTabSources => 'Sources';

  @override
  String get browseTabExtensions => 'Extensions';

  @override
  String get browseTabLocal => 'Local';

  @override
  String get browseSearchHint => 'Rechercher des extensions et des sources...';

  @override
  String browseRemoveSourceConfirm(Object name) {
    return 'Supprimer $name ?';
  }

  @override
  String get browseRemoveSourceDesc =>
      'La source sera désinstallée. Les entrées de votre bibliothèque qui en proviennent sont conservées, mais vous ne pourrez pas les ouvrir tant que vous ne l’aurez pas réinstallée.';

  @override
  String get browseCancel => 'Annuler';

  @override
  String get browseRemove => 'Supprimer';

  @override
  String get browseProvidedByThisSource => 'FOURNI PAR CETTE SOURCE';

  @override
  String get browseCouldNotLoadOptions =>
      'Impossible de charger les options de la source';

  @override
  String get browseNoSourceOptions =>
      'Cette source ne définit aucune option propre. Les paramètres ci-dessus s’y appliquent tout de même.';

  @override
  String get browseBaseUrl => 'URL de base';

  @override
  String get browseUsingSourceDefault =>
      'Utilise la valeur par défaut de la source';

  @override
  String browseBaseUrlDefault(Object url) {
    return '$url  (par défaut)';
  }

  @override
  String get browseResetToDefault => 'Réinitialiser';

  @override
  String get browsePinToTop => 'Épingler en haut';

  @override
  String get browsePinToTopDesc =>
      'Afficher cette source en premier dans la liste des sources';

  @override
  String get browseSkipGlobalSearch => 'Ignorer dans la recherche globale';

  @override
  String get browseSkipGlobalSearchDesc =>
      'Exclure cette source lors d’une recherche globale';

  @override
  String get browseSkipLibraryUpdates => 'Ignorer dans les mises à jour';

  @override
  String get browseSkipLibraryUpdatesDesc =>
      'Ne pas vérifier les nouveaux chapitres de cette source';

  @override
  String get browseRequestDesktopSite => 'Demander la version bureau';

  @override
  String get browseRequestDesktopSiteDesc =>
      'Essayez ceci si la source ne trouve rien ou n’affiche aucun chapitre — certains sites envoient une version allégée aux téléphones';

  @override
  String get browseSave => 'Enregistrer';

  @override
  String get browseNone => 'Aucune';

  @override
  String browseSelectedCount(Object count) {
    return '$count sélectionné(s)';
  }

  @override
  String get browseNotSet => 'Non défini';

  @override
  String get browseIosFolderWarning =>
      'iOS n’autorise pas les apps à conserver l’accès à un dossier. Utilisez « Importer un fichier » pour ajouter des .cbz/.cbr/.zip/.epub/.pdf à la place.';

  @override
  String browseImportedFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers importés',
      one: '1 fichier importé',
    );
    return '$_temp0';
  }

  @override
  String get browseNothingImported =>
      'Rien d’importé (non pris en charge ou illisible)';

  @override
  String browseFolderCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dossiers',
      one: '1 dossier',
    );
    return '$_temp0';
  }

  @override
  String get browseManageFolders => 'Gérer les dossiers';

  @override
  String get browseImportFileTooltip =>
      'Importer un fichier (CBZ/ZIP/EPUB/PDF)';

  @override
  String get browseAddFolder => 'Ajouter un dossier';

  @override
  String get browseRescan => 'Réanalyser';

  @override
  String get browseNothingImportedYet => 'Rien d’importé pour l’instant';

  @override
  String get browseNoLocalSources => 'Aucune source locale';

  @override
  String get browseLocalSourcesDesc =>
      'Ajoutez un dossier de mangas ou importez un seul fichier.\nPris en charge : images (JPG, PNG, WebP, GIF), CBZ/ZIP, EPUB et PDF.\n(CBR/RAR uniquement si le fichier est réellement au format ZIP — le vrai RAR n’est pas pris en charge.)';

  @override
  String get browseAddFolderButton => 'Ajouter un dossier';

  @override
  String get browseImportFile => 'Importer un fichier';

  @override
  String get browseLocalSourceFolders => 'Dossiers de sources locales';

  @override
  String get browseNoFoldersAdded => 'Aucun dossier ajouté';

  @override
  String browseChaptersAbbrev(Object n) {
    return '$n ch';
  }

  @override
  String get browseInstalled => 'INSTALLÉES';

  @override
  String get browseAvailable => 'DISPONIBLES';

  @override
  String get browseSourceNotInstalled => 'La source n’est pas installée';

  @override
  String get browseManga => 'Manga';

  @override
  String get browseAnime => 'Anime';

  @override
  String get browseNovels => 'Romans';

  @override
  String get browseAllLanguages => 'Toutes les langues';

  @override
  String get browseFilter => 'Filtrer';

  @override
  String browseLanguagesCount(Object count) {
    return '$count langues';
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
      other: '$count résultats',
      one: '1 résultat',
    );
    return '$_temp0';
  }

  @override
  String get browseNoExtensions => 'Aucune extension pour l’instant';

  @override
  String get browseNoExtensionsDesc =>
      'Ajoutez un dépôt à l’aide du bouton\nde paramètres ci-dessus pour parcourir les extensions.';

  @override
  String browseUpdatedSources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources mises à jour',
      one: '1 source mise à jour',
    );
    return '$_temp0';
  }

  @override
  String get browseSourceUpdated => 'Source mise à jour';

  @override
  String get browseNoUpdateAvailable => 'Aucune mise à jour disponible';

  @override
  String browseUpdateFailed(Object error) {
    return 'Échec de la mise à jour : $error';
  }

  @override
  String browseRefreshFailed(Object error) {
    return 'Échec de l’actualisation : $error';
  }

  @override
  String browseUpdatesAvailable(Object count) {
    return 'MISES À JOUR DISPONIBLES ($count)';
  }

  @override
  String get browseUpdateAll => 'Tout mettre à jour';

  @override
  String get browseUpdate => 'Mettre à jour';

  @override
  String get browseSettings => 'Paramètres';

  @override
  String get browseInstall => 'Installer';

  @override
  String get browseInstalledBadge => 'Installée';

  @override
  String get browseAbout => 'À PROPOS';

  @override
  String browseSourceFrom(Object url) {
    return 'Source depuis $url';
  }

  @override
  String browseLanguageLabel(Object lang) {
    return 'Langue : $lang';
  }

  @override
  String get browseUsesCloudflare => 'Utilise la protection Cloudflare';

  @override
  String get browseNoCloudflare => 'Pas de Cloudflare';

  @override
  String get browseAdultContent => 'Contenu 18+';

  @override
  String get browseSafeForWork => 'Tout public';

  @override
  String get browseFeatures => 'FONCTIONNALITÉS';

  @override
  String get browsePopular => 'Populaires';

  @override
  String get browseLatest => 'Récents';

  @override
  String browseSourceAction(Object name) {
    return 'Parcourir $name';
  }

  @override
  String get browseRemoving => 'Suppression...';

  @override
  String get browseInstalling => 'Installation...';

  @override
  String browseFailed(Object error) {
    return 'Échec : $error';
  }

  @override
  String get browseUpdating => 'Mise à jour...';

  @override
  String get browseUpdateExtensionCode =>
      'Mettre à jour le code de l’extension';

  @override
  String browseUpdatedSource(Object name) {
    return '$name mise à jour';
  }

  @override
  String get browsePinned => 'ÉPINGLÉES';

  @override
  String get browseAll => 'Toutes';

  @override
  String get browseNoInstalledSources => 'Aucune source installée';

  @override
  String get browseNoInstalledSourcesDesc =>
      'Installez des extensions depuis l’onglet Extensions\npour voir les sources ici.';

  @override
  String get browseUnpin => 'Détacher';

  @override
  String get browsePin => 'Épingler';

  @override
  String get browseSourceNotInstalledBody => 'Source non installée';

  @override
  String get browseBypassingCloudflare =>
      'Contournement de la protection Cloudflare...';

  @override
  String get browseOpenInWebView => 'Ouvrir dans WebView';

  @override
  String get browseCloudflareProtection => 'Protection Cloudflare';

  @override
  String get browseFailedToLoad => 'Échec du chargement';

  @override
  String get browseCloudflareChallengeDesc =>
      'Cette source nécessite d’abord de résoudre un défi Cloudflare dans le navigateur.';

  @override
  String get browseSolveCloudflare => 'Résoudre Cloudflare';

  @override
  String get browseRetry => 'Réessayer';

  @override
  String get browseContentAnime => 'anime';

  @override
  String get browseContentNovels => 'light novels';

  @override
  String get browseContentManga => 'manga';

  @override
  String browseNoContentFound(Object noun) {
    return 'Aucun $noun trouvé';
  }

  @override
  String get browseAllCategories => 'Toutes les catégories';

  @override
  String get browseNoCategories => 'Aucune catégorie';

  @override
  String get browseSearchMangaHint => 'Rechercher un manga...';

  @override
  String get browseUnknown => 'Inconnu';

  @override
  String get browseSearchAllSourcesHint =>
      'Rechercher dans toutes les sources...';

  @override
  String get browseNoSourcesInstalled => 'Aucune source installée';

  @override
  String get browseNoSourcesInstalledDesc =>
      'Installez des extensions depuis l’onglet Explorer.';

  @override
  String get browseSearchAllSources => 'Rechercher dans toutes les sources';

  @override
  String browseSearchSourcesAtOnce(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rechercher dans $count sources à la fois.',
      one: 'Rechercher dans 1 source à la fois.',
    );
    return '$_temp0';
  }

  @override
  String browseSearchingSources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Recherche dans $count sources...',
      one: 'Recherche dans 1 source...',
    );
    return '$_temp0';
  }

  @override
  String get browseSeeAll => 'Tout voir';

  @override
  String get browseNoResultsFound => 'Aucun résultat trouvé';

  @override
  String get globalSearchSourceNoResults => 'No results';

  @override
  String get globalSearchSourceFailed => 'Couldn\'t search this source';

  @override
  String get browseSectionSources => 'Sources';

  @override
  String get browseShowNsfw => 'Afficher les sources NSFW';

  @override
  String get browseShowNsfwDesc =>
      'Afficher les sources 18+ dans l’exploration et la recherche';

  @override
  String get browsePinnedOnly => 'Sources épinglées uniquement';

  @override
  String get browsePinnedOnlyBrowseDesc =>
      'N’afficher que les sources épinglées dans l’exploration';

  @override
  String get browseSectionGlobalSearch => 'Recherche globale';

  @override
  String get browsePinnedOnlyGlobalSearchDesc =>
      'Ne rechercher que dans les sources épinglées lors de la recherche globale';

  @override
  String get browseSectionWebView => 'WebView';

  @override
  String get browseAdBlocker => 'Bloqueur de publicités';

  @override
  String get browseAdBlockerDesc =>
      'Bloquer les publicités, pop-ups et superpositions dans le navigateur';

  @override
  String get browseSectionExtensions => 'Extensions';

  @override
  String get browseAutoUpdate => 'Mettre à jour automatiquement les extensions';

  @override
  String get browseAutoUpdateDesc =>
      'Actualiser le code des extensions installées au lancement de l’app';

  @override
  String get setxAdvancedTitle => 'Avancé';

  @override
  String get setxAdvancedSectionLogging => 'Journalisation';

  @override
  String get setxAdvancedVerboseLoggingTitle => 'Journalisation détaillée';

  @override
  String get setxAdvancedVerboseLoggingSubtitle =>
      'Enregistrer des informations de débogage détaillées';

  @override
  String get setxAdvancedViewErrorLogsTitle => 'Voir les journaux d’erreurs';

  @override
  String get setxAdvancedViewErrorLogsSubtitle =>
      'Parcourir les journaux de débogage et d’erreurs';

  @override
  String get setxAdvancedSectionNetwork => 'Réseau';

  @override
  String get setxAdvancedDnsOverHttpsTitle => 'DNS over HTTPS';

  @override
  String get setxAdvancedDnsOverHttpsSubtitle =>
      'Utiliser une résolution DNS sécurisée';

  @override
  String get setxAdvancedDnsProviderTitle => 'Fournisseur DNS';

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
  String get setxAdvancedSectionExtensions => 'Extensions';

  @override
  String get setxAdvancedThirdPartyTitle => 'Extensions tierces';

  @override
  String get setxAdvancedThirdPartySubtitle =>
      'Autoriser les extensions de sources inconnues';

  @override
  String get setxAdvancedExtUpdateTitle =>
      'Alertes de mise à jour des extensions';

  @override
  String get setxAdvancedExtUpdateSubtitle =>
      'Notifier lorsque des extensions ont des mises à jour';

  @override
  String get setxAdvancedSectionBrowser => 'Navigateur';

  @override
  String get setxAdvancedExternalBrowserTitle => 'Navigateur externe';

  @override
  String get setxAdvancedExternalBrowserSubtitle =>
      'Ouvrir les liens dans le navigateur du système';

  @override
  String get setxAdvancedSectionData => 'Données';

  @override
  String get setxAdvancedClearCacheTitle => 'Vider le cache des chapitres';

  @override
  String get setxAdvancedClearCacheSubtitle =>
      'Libérer de l’espace de stockage';

  @override
  String get setxAdvancedClearDbEntryTitle => 'Effacer la base de données';

  @override
  String get setxAdvancedClearDbEntrySubtitle =>
      'Réinitialiser la bibliothèque, les catégories et l’historique de lecture';

  @override
  String get setxAdvancedCacheCleared => 'Cache des images de chapitres vidé';

  @override
  String get setxAdvancedClearDbTitle => 'Effacer la base de données ?';

  @override
  String get setxAdvancedClearDbBody =>
      'Cela supprime définitivement votre bibliothèque, vos catégories et votre historique de lecture. Les extensions installées et les téléchargements ne sont pas affectés.';

  @override
  String get setxAdvancedCancel => 'Annuler';

  @override
  String get setxAdvancedClear => 'Effacer';

  @override
  String get setxAdvancedDbCleared =>
      'Base de données effacée — redémarrez l’app pour recréer les valeurs par défaut';

  @override
  String get setxAdvancedErrorLogsTitle => 'Journaux d’erreurs';

  @override
  String get setxAdvancedClearAllLogsTooltip => 'Effacer tous les journaux';

  @override
  String get setxAdvancedFilterCategory => 'Catégorie';

  @override
  String get setxAdvancedFilterLevel => 'Niveau';

  @override
  String get setxAdvancedNoLogs => 'Aucun journal pour l’instant';

  @override
  String get setxAdvancedNoLogsSubtitle =>
      'Les journaux apparaîtront ici au fur et à mesure que vous utilisez l’app';

  @override
  String get setxAdvancedClearLogsTitle => 'Effacer tous les journaux ?';

  @override
  String get setxAdvancedClearLogsBody =>
      'Cela supprimera définitivement toutes les entrées de journal stockées.';

  @override
  String get setxAdvancedLogsCleared => 'Journaux effacés';

  @override
  String get setxAdvancedCopiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get setxNotifTitle => 'Notifications';

  @override
  String get setxNotifSectionChapterUpdates => 'Mises à jour des chapitres';

  @override
  String get setxNotifNewChaptersTitle => 'Nouveaux chapitres';

  @override
  String get setxNotifNewChaptersSubtitle =>
      'Notifier lorsque de nouveaux chapitres sont disponibles';

  @override
  String get setxNotifLibraryUpdatesTitle => 'Mises à jour de la bibliothèque';

  @override
  String get setxNotifLibraryUpdatesSubtitle =>
      'Notifier une fois la mise à jour de la bibliothèque terminée';

  @override
  String get setxNotifSectionDownloads => 'Téléchargements';

  @override
  String get setxNotifDownloadCompleteTitle => 'Téléchargement terminé';

  @override
  String get setxNotifDownloadCompleteSubtitle =>
      'Notifier lorsque les chapitres ont fini de se télécharger';

  @override
  String get setxNotifDownloadErrorTitle => 'Erreur de téléchargement';

  @override
  String get setxNotifDownloadErrorSubtitle =>
      'Notifier lorsqu’un téléchargement échoue';

  @override
  String get setxNotifSectionBehavior => 'Comportement';

  @override
  String get setxNotifSoundTitle => 'Son';

  @override
  String get setxNotifSoundSubtitle => 'Émettre un son pour les notifications';

  @override
  String get setxNotifVibrationTitle => 'Vibration';

  @override
  String get setxNotifVibrationSubtitle => 'Vibrer pour les notifications';

  @override
  String get setxNotifGroupTitle => 'Regrouper les notifications';

  @override
  String get setxNotifGroupSubtitle => 'Combiner plusieurs notifications';

  @override
  String get setxSecurityTitle => 'Sécurité et confidentialité';

  @override
  String get setxSecuritySectionAppLock => 'Verrouillage de l’app';

  @override
  String get setxSecurityAppLockTitle => 'Verrouillage de l’app';

  @override
  String get setxSecurityAppLockSubtitle =>
      'Exiger une authentification pour ouvrir l’app';

  @override
  String get setxSecurityBiometricsTitle => 'Biométrie';

  @override
  String get setxSecurityBiometricsSubtitle =>
      'Utiliser l’empreinte digitale ou le visage pour déverrouiller';

  @override
  String get setxSecuritySectionPrivacy => 'Confidentialité';

  @override
  String get setxSecurityIncognitoTitle => 'Incognito mode';

  @override
  String get setxSecurityIncognitoSubtitle =>
      'Don\'t save reading history or update trackers';

  @override
  String get libraryIncognitoActive => 'Incognito mode on';

  @override
  String get setxSecuritySecureScreenTitle => 'Écran sécurisé';

  @override
  String get setxSecuritySecureScreenSubtitle =>
      'Masquer le contenu de l’app dans les apps récentes';

  @override
  String get setxSecurityHideNotifTitle =>
      'Masquer le contenu des notifications';

  @override
  String get setxSecurityHideNotifSubtitle =>
      'Afficher un texte de notification générique';

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
  String get setxBackupTitle => 'Sauvegarde et restauration';

  @override
  String get setxBackupSectionFoxlations => 'Sauvegarde Foxlations';

  @override
  String get setxBackupCreateTitle => 'Créer une sauvegarde';

  @override
  String get setxBackupCreateSubtitle =>
      'Enregistrez votre bibliothèque, vos catégories, votre progression de lecture, vos sources et votre suivi';

  @override
  String get setxBackupRestoreTitle => 'Restaurer une sauvegarde';

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
      'Restaurer depuis un fichier .fxbackup de Foxlations';

  @override
  String get setxBackupSectionTachiyomi => 'Tachiyomi / Mihon et forks';

  @override
  String get setxBackupCreateCompatTitle => 'Créer une sauvegarde compatible';

  @override
  String get setxBackupCreateCompatSubtitle =>
      'Exporter un .tachibk importable dans Tachiyomi, Mihon et leurs forks';

  @override
  String get setxBackupRestoreTachiyomiTitle =>
      'Restaurer depuis Tachiyomi/Mihon';

  @override
  String get setxBackupRestoreTachiyomiSubtitle =>
      'Importer une sauvegarde .tachibk / .tmb / .proto.gz (associe les sources par nom)';

  @override
  String get setxBackupSectionAutomatic => 'Sauvegarde automatique';

  @override
  String get setxBackupFrequency => 'Fréquence';

  @override
  String setxBackupAutoSubtitle(Object freq) {
    return 'Créer automatiquement une sauvegarde $freq';
  }

  @override
  String setxBackupSectionBackups(Object count) {
    return 'Sauvegardes ($count)';
  }

  @override
  String get setxBackupNone => 'Aucune sauvegarde pour l’instant.';

  @override
  String get setxBackupMenuRestore => 'Restaurer';

  @override
  String get setxBackupMenuDelete => 'Supprimer';

  @override
  String get setxBackupFreqOff => 'Désactivée';

  @override
  String get setxBackupFreqDaily => 'Quotidienne';

  @override
  String get setxBackupFreqWeekly => 'Hebdomadaire';

  @override
  String get setxBackupFreqMonthly => 'Mensuelle';

  @override
  String setxBackupImportedManga(Object count) {
    return '$count mangas importés';
  }

  @override
  String get setxBackupRestoreComplete => 'Restauration terminée';

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
    return 'Échec de la restauration : $error';
  }

  @override
  String get setxAboutTitle => 'À propos';

  @override
  String get setxAboutSectionApp => 'Application';

  @override
  String get setxAboutWhatsNewTitle => 'Nouveautés';

  @override
  String get setxAboutWhatsNewSubtitle =>
      'Journal des modifications et notes de version';

  @override
  String get setxAboutCheckUpdatesTitle => 'Rechercher des mises à jour';

  @override
  String get setxAboutCheckUpdatesSubtitle =>
      'Voir si une version plus récente est disponible';

  @override
  String get setxAboutSectionLegal => 'Mentions légales';

  @override
  String get setxAboutLicensesTitle => 'Licences';

  @override
  String get setxAboutLicensesSubtitle => 'Licences open source';

  @override
  String get setxAboutSectionLinks => 'Liens';

  @override
  String get setxAboutSourceCodeTitle => 'Code source';

  @override
  String get setxAboutSourceCodeSubtitle => 'Appuyez pour copier l’URL GitHub';

  @override
  String get setxAboutReportBugTitle => 'Signaler un bug';

  @override
  String get setxAboutReportBugSubtitle =>
      'Appuyez pour copier l’URL du suivi des problèmes';

  @override
  String get setxAboutClose => 'Fermer';

  @override
  String setxAboutWhatsNewVersioned(Object version) {
    return 'Nouveautés de la v$version';
  }

  @override
  String setxAboutLinkCopied(Object label) {
    return 'Lien $label copié dans le presse-papiers';
  }

  @override
  String get setxAboutSourceCodeLabel => 'Code source';

  @override
  String get setxAboutBugReportLabel => 'Rapport de bug';

  @override
  String get miscResumePlaybackTitle => 'Reprendre la lecture ?';

  @override
  String miscStoppedWatchingAt(Object time) {
    return 'Vous avez arrêté de regarder à $time.';
  }

  @override
  String get miscStartOver => 'Recommencer';

  @override
  String miscContinueAt(Object time) {
    return 'Continuer ($time)';
  }

  @override
  String get miscQuality => 'Qualité';

  @override
  String miscSourceIndex(Object index) {
    return 'Source $index';
  }

  @override
  String get miscSubtitles => 'Sous-titres';

  @override
  String get miscSubtitleOff => 'Désactivés';

  @override
  String get miscUnknownTrack => 'Inconnue';

  @override
  String get miscSubtitleDelay => 'Décalage des sous-titres';

  @override
  String get miscAudio => 'Audio';

  @override
  String get miscPlaybackSpeed => 'Vitesse de lecture';

  @override
  String get miscSkipOutro => 'Passer l’outro';

  @override
  String get miscSkipIntro => 'Passer l’intro';

  @override
  String get miscUnlockControls => 'Déverrouiller les commandes';

  @override
  String get miscUnknownError => 'Erreur inconnue';

  @override
  String get miscRetry => 'Réessayer';

  @override
  String get miscExtensionRepositories => 'Dépôts d’extensions';

  @override
  String get miscRepositoryUrlHint => 'URL du dépôt (index.json)';

  @override
  String get miscAdd => 'Ajouter';

  @override
  String get miscRepositoriesHeader => 'DÉPÔTS';

  @override
  String get miscNoReposYet => 'Aucun dépôt ajouté pour l’instant';

  @override
  String miscFailedToAddRepo(Object error) {
    return 'Échec de l’ajout du dépôt : $error';
  }

  @override
  String get miscVerifyHuman => 'Vérifiez que vous êtes humain';

  @override
  String get miscCfInstructions =>
      'Complétez la vérification du site ci-dessous. Elle se ferme automatiquement et ne vous sera plus demandée tant que la vérification reste valide.';

  @override
  String get trackTitle => 'Suivi';

  @override
  String get trackNoTrackerConnected => 'Aucun service de suivi connecté';

  @override
  String get trackConnectHint =>
      'Connectez AniList, MyAnimeList ou Kitsu dans Paramètres › Suivi.';

  @override
  String trackNotLinkedOn(Object name) {
    return 'Non lié sur $name';
  }

  @override
  String get trackLink => 'Lier';

  @override
  String get trackUnlink => 'Délier';

  @override
  String get trackStatus => 'Statut';

  @override
  String get trackChapters => 'Chapitres';

  @override
  String get trackScore => 'Note';

  @override
  String trackLinkedTo(Object name) {
    return 'Lié à $name';
  }

  @override
  String trackLinkOn(Object name) {
    return 'Lier sur $name';
  }

  @override
  String get trackSearchTitleHint => 'Rechercher un titre';

  @override
  String get trackSearch => 'Rechercher';

  @override
  String get trackNoResults => 'Aucun résultat';

  @override
  String trackChaptersShort(Object count) {
    return '$count ch';
  }

  @override
  String trackConnectTracker(Object name) {
    return 'Connecter $name';
  }

  @override
  String get trackOauthInstructions =>
      'Connectez-vous et appuyez sur Autoriser. Vous serez connecté automatiquement.';

  @override
  String get trackServices => 'Services';

  @override
  String get trackServicesDescription =>
      'Connectez un service de suivi pour synchroniser votre progression de lecture. Une fois un manga lié, la progression se met à jour automatiquement au fil de votre lecture.';

  @override
  String trackLogInTo(Object name) {
    return 'Se connecter à $name';
  }

  @override
  String get trackEmailOrUsername => 'E-mail ou nom d’utilisateur';

  @override
  String get trackPassword => 'Mot de passe';

  @override
  String get trackCancel => 'Annuler';

  @override
  String get trackLogIn => 'Se connecter';

  @override
  String trackConnectedTo(Object name) {
    return 'Connecté à $name';
  }

  @override
  String get trackLoginFailed =>
      'Échec de la connexion — vérifiez vos identifiants';

  @override
  String get trackSetClientIdFirst => 'Définissez d’abord un ID client';

  @override
  String get trackCouldNotCompleteSignIn =>
      'Impossible de finaliser la connexion';

  @override
  String trackClientIdTitle(Object name) {
    return 'ID client $name (avancé)';
  }

  @override
  String trackClientIdDescription(Object name) {
    return 'Facultatif. Foxlations possède déjà un ID client $name intégré — appuyez simplement sur Connecter. Ne le définissez que si vous avez enregistré votre propre app développeur $name et souhaitez l’utiliser à la place.';
  }

  @override
  String get trackClientId => 'ID client';

  @override
  String get trackSave => 'Enregistrer';

  @override
  String get trackPasteAccessToken => 'Coller le jeton d’accès';

  @override
  String get trackPasteTokenHint =>
      'Collez le jeton affiché après l’autorisation';

  @override
  String get trackConnect => 'Connecter';

  @override
  String get trackCouldNotVerifyToken => 'Impossible de vérifier le jeton';

  @override
  String get trackConnected => 'Connecté';

  @override
  String trackConnectedAs(Object username) {
    return 'Connecté en tant que $username';
  }

  @override
  String get trackTapConnectToAuthorize =>
      'Appuyez sur Connecter pour autoriser';

  @override
  String get trackSignInWithAccount => 'Connectez-vous avec votre compte';

  @override
  String get trackDisconnect => 'Déconnecter';

  @override
  String get trackAiTitle => 'IA et traduction';

  @override
  String get trackTabTranslation => 'Traduction';

  @override
  String get trackTabApiKeys => 'Clés API';

  @override
  String get trackTabModels => 'Modèles';

  @override
  String get trackEnableAiTranslation => 'Activer la traduction par IA';

  @override
  String get trackEnableAiTranslationDesc =>
      'Afficher le bouton de traduction dans le lecteur';

  @override
  String get trackProvider => 'Fournisseur';

  @override
  String get trackOfflineMode => 'Mode hors ligne';

  @override
  String get trackOfflineModeDesc =>
      'Utiliser les modèles téléchargés sans connexion Internet';

  @override
  String get trackTranslationSettings => 'Paramètres de traduction';

  @override
  String get trackTargetLanguage => 'Langue cible';

  @override
  String get trackTargetLanguageDesc =>
      'Traduire le texte des mangas dans cette langue';

  @override
  String get trackBubbleDetection => 'Détection des bulles';

  @override
  String get trackBubbleDetectionDesc =>
      'Détecter automatiquement les bulles de dialogue dans les pages de manga';

  @override
  String get trackQuality => 'Qualité';

  @override
  String get trackQualityFast => 'Rapide';

  @override
  String get trackQualityBalanced => 'Équilibrée';

  @override
  String get trackQualityHigh => 'Haute qualité';

  @override
  String get trackKoharuServer => 'Serveur Koharu';

  @override
  String get trackServerUrl => 'URL du serveur';

  @override
  String get trackKoharuServerDesc =>
      'Retouche complète des mangas via un serveur Docker local';

  @override
  String get trackApiKeyRequired => 'Clé API requise';

  @override
  String get trackApiKeysNotice =>
      'Les clés sont stockées localement sur votre appareil et ne sont jamais envoyées à nos serveurs.';

  @override
  String get trackModelsPlatformOnly =>
      'Les modèles de traduction sur l’appareil sont disponibles sur Android et iOS.';

  @override
  String get trackModelsDescription =>
      'Téléchargez une langue pour la traduire entièrement hors ligne. Chaque pack fait environ 30 MB et est aussi récupéré automatiquement la première fois que vous traduisez cette langue.';

  @override
  String get trackTranslationLanguages => 'LANGUES DE TRADUCTION';

  @override
  String get trackDownloaded => 'Téléchargée — disponible hors ligne';

  @override
  String get trackNotDownloaded => 'Non téléchargée';

  @override
  String get trackDelete => 'Supprimer';

  @override
  String get trackDownload => 'Télécharger';

  @override
  String trackDownloadFailed(Object error) {
    return 'Échec du téléchargement : $error';
  }

  @override
  String trackDeleteFailed(Object error) {
    return 'Échec de la suppression : $error';
  }

  @override
  String get repoDeleteSourceTitle => 'Supprimer la source ?';

  @override
  String repoDeleteSourceBody(Object name) {
    return '« $name » sera retirée de Mes sources.';
  }

  @override
  String get repoCancel => 'Annuler';

  @override
  String get repoDelete => 'Supprimer';

  @override
  String repoDeletedSource(Object name) {
    return '« $name » supprimée';
  }

  @override
  String get repoNoSourcesToExport => 'Aucune source à exporter';

  @override
  String get repoExportDialogTitle => 'Exporter les sources RepoForge';

  @override
  String repoExportedSources(Object count) {
    return '$count sources exportées';
  }

  @override
  String repoExportFailed(Object error) {
    return 'Échec de l’exportation : $error';
  }

  @override
  String repoImportedSources(Object count) {
    return '$count source(s) importée(s)';
  }

  @override
  String repoImportFailed(Object error) {
    return 'Échec de l’importation : $error';
  }

  @override
  String get repoBuildFromUrl =>
      'Créez des sources depuis n’importe quelle URL';

  @override
  String get repoBeta => 'BÊTA';

  @override
  String get repoHeroDescription =>
      'Détectez le framework d’un site, ajustez les sélecteurs et installez une source manga / anime / roman fonctionnelle — sans serveur, tout sur l’appareil. RepoForge est en bêta, il ne réussira donc pas toujours une source — vérifiez le résultat et ajustez les sélecteurs si un site ne sort pas correctement.';

  @override
  String repoCoverageSummary(Object frameworks, Object manga, Object novel) {
    return '$frameworks frameworks · $manga sites de manga + $novel de romans connus';
  }

  @override
  String get repoNewSource => 'Nouvelle source';

  @override
  String get repoImport => 'Importer';

  @override
  String get repoMySources => 'MES SOURCES';

  @override
  String get repoExportAll => 'Tout exporter';

  @override
  String get repoNoSourcesYet => 'Aucune source pour l’instant';

  @override
  String get repoEmptyStateHint =>
      'Appuyez sur « Nouvelle source » pour en générer une à partir de l’URL d’un site.';

  @override
  String get repoNotInstalled => 'non installée';

  @override
  String get repoOpenInBrowse => 'Ouvrir dans Explorer';

  @override
  String get repoEditRedetect => 'Modifier / redétecter';

  @override
  String get repoKnownNovelSite => 'Site de romans connu';

  @override
  String get repoNovelGenericDetail =>
      'Reconnu comme un site de romans — généré avec le corps de roman générique (l’exploration peut nécessiter un ajustement des sélecteurs).';

  @override
  String repoNovelFrameworkDetail(Object framework) {
    return 'Généré comme source Roman à l’aide du corps $framework — l’exploration et le lecteur fonctionnent d’emblée.';
  }

  @override
  String get repoKnownMangaSite => 'Site de manga connu';

  @override
  String get repoMangaApiDetail =>
      'Source API vérifiée par la communauté — RepoForge la construit à partir de l’API du site.';

  @override
  String repoMangaThemeDetail(Object theme) {
    return 'Thème vérifié par la communauté : $theme — les sélecteurs sont connus.';
  }

  @override
  String get repoMangaCustomDetail =>
      'Des sélecteurs personnalisés vérifiés par la communauté sont enregistrés pour ce site.';

  @override
  String get repoNotInKb => 'Absent de la base de connaissances';

  @override
  String get repoNotInKbDetail =>
      'RepoForge détectera son framework en direct lorsque vous l’ajouterez, puis se rabattra sur une analyse heuristique « quoi-est-quoi » s’il est sur mesure.';

  @override
  String get repoCoverage => 'Couverture';

  @override
  String get repoCheckASite => 'Vérifier un site';

  @override
  String get repoPasteSiteUrlHint => 'collez l’URL d’un site';

  @override
  String get repoCheck => 'Vérifier';

  @override
  String get repoSupportedFrameworks => 'Frameworks pris en charge';

  @override
  String get repoMangaSites => 'sites de manga';

  @override
  String get repoNovelSites => 'sites de romans';

  @override
  String get repoFrameworks => 'frameworks';

  @override
  String get repoRoleItem => 'Élément de liste (chaque carte)';

  @override
  String get repoRoleTitle => 'Titre';

  @override
  String get repoRoleCover => 'Image de couverture';

  @override
  String get repoRoleNextPage => 'Lien page suivante';

  @override
  String get repoRoleDetailTitle => 'Détail — titre';

  @override
  String get repoRoleChapters => 'Élément de liste de chapitres';

  @override
  String get repoRolePageImages => 'Images des pages du lecteur';

  @override
  String get repoRoleEpisodes => 'Liste des épisodes (anime)';

  @override
  String get repoStepFetching => 'Récupération de la page…';

  @override
  String get repoStepMatching => 'Correspondance des signatures de framework…';

  @override
  String get repoStepExtracting => 'Extraction des sélecteurs…';

  @override
  String get repoStepFinalizing => 'Finalisation…';

  @override
  String get repoEnterUrlFirst => 'Entrez d’abord l’URL d’un site.';

  @override
  String repoDetectionFailed(Object error) {
    return 'Échec de la détection : $error';
  }

  @override
  String get repoFetchFailed => 'Échec de la récupération';

  @override
  String repoFetchedChars(Object count) {
    return '$count caractères récupérés — testez maintenant les sélecteurs';
  }

  @override
  String get repoFetchPageFirst => 'Récupérez d’abord une page';

  @override
  String repoGenerationFailed(Object error) {
    return 'Échec de la génération : $error';
  }

  @override
  String get repoDetectSiteFirst => 'Détectez d’abord un site';

  @override
  String repoCreatedInstalled(Object name) {
    return '« $name » créée et installée';
  }

  @override
  String repoSaveFailed(Object error) {
    return 'Échec de l’enregistrement : $error';
  }

  @override
  String get repoCreateSource => 'Créer la source';

  @override
  String get repoSiteUrl => 'URL du site';

  @override
  String get repoDetect => 'Détecter';

  @override
  String repoConfidence(Object pct) {
    return 'confiance $pct %';
  }

  @override
  String get repoApiSource => 'Source API';

  @override
  String get repoDetails => 'Détails';

  @override
  String get repoSourceNameHint => 'Nom de la source';

  @override
  String get repoName => 'Nom';

  @override
  String get repoLang => 'Langue';

  @override
  String get repoManga => 'Manga';

  @override
  String get repoAnime => 'Anime';

  @override
  String get repoNovel => 'Roman';

  @override
  String get repoNsfw => 'NSFW';

  @override
  String get repoScrapingStudio => 'Studio de scraping';

  @override
  String get repoScrapingStudioHint =>
      'Récupérez une page, puis testez chaque sélecteur pour voir combien d’éléments il sélectionne.';

  @override
  String get repoUrlToTestHint => 'URL à tester';

  @override
  String get repoFetch => 'Récupérer';

  @override
  String get repoFetchFailedBlocked =>
      'Échec de la récupération — le site bloque peut-être les accès automatisés.';

  @override
  String repoLoadedChars(Object count) {
    return '$count caractères chargés.';
  }

  @override
  String get repoPreviewJs => 'Aperçu JS';

  @override
  String get repoCreateInstall => 'Créer et installer';

  @override
  String get repoPickKnownSelector => 'Choisir un sélecteur connu';

  @override
  String get repoTest => 'Tester';

  @override
  String repoNoCatalogedSelectors(Object label) {
    return 'Aucun sélecteur catalogué pour « $label »';
  }

  @override
  String get repoInvalid => 'non valide';

  @override
  String get repoNoMatch => 'aucune correspondance';

  @override
  String get repoGeneratedSource => 'Source générée';

  @override
  String get repoCopy => 'Copier';

  @override
  String get repoCopiedToClipboard => 'Source copiée dans le presse-papiers';

  @override
  String repoSelectorFor(Object field) {
    return 'Sélecteur pour $field';
  }

  @override
  String get repoSearchSelectors => 'Rechercher des sélecteurs…';

  @override
  String repoImportedSource(Object id) {
    return 'Source importée · $id';
  }

  @override
  String get repoCheckingMatches => 'Vérification des correspondances';

  @override
  String get repoMigrating => 'Migration';

  @override
  String get repoMigrateThisSource => 'Migrer cette source ?';

  @override
  String repoMatchedByUrl(Object count) {
    return '$count correspondance(s) par URL';
  }

  @override
  String repoMatchedByTitle(Object count) {
    return '$count correspondance(s) par titre';
  }

  @override
  String repoNotFoundLeftInPlace(Object count) {
    return '$count introuvable(s) — laissé(s) en place';
  }

  @override
  String get repoMigrateCarryOver =>
      'La progression de lecture, les catégories et le suivi sont conservés. Les originaux ne sont supprimés que pour les entrées déplacées.';

  @override
  String repoMigrateCount(Object count) {
    return 'Migrer $count';
  }

  @override
  String get repoMigrateASource => 'Migrer une source';

  @override
  String get repoMigrateIntro =>
      'Déplacez toutes les entrées de bibliothèque d’une source vers une autre. Les échanges au sein d’un même site correspondent exactement par URL ; les entrées importées depuis une sauvegarde peuvent aussi être rattachées à une vraie source.';

  @override
  String get repoFrom => 'DE';

  @override
  String get repoSelectSource => 'Sélectionnez une source…';

  @override
  String get repoTo => 'VERS';

  @override
  String get repoAlsoMatchByTitle => 'Faire aussi correspondre par titre';

  @override
  String get repoAlsoMatchByTitleHint =>
      'Pour les déplacements entre sites : si une entrée n’est pas trouvée par URL, rechercher dans la nouvelle source par titre et prendre la correspondance la plus proche. Désactivé par défaut pour éviter d’associer la mauvaise série.';

  @override
  String get repoMigrateSource => 'Migrer la source';

  @override
  String get repoMigrationComplete => 'Migration terminée';

  @override
  String repoMovedByUrl(Object count) {
    return '$count déplacé(s) par URL';
  }

  @override
  String repoMovedByTitle(Object count) {
    return '$count déplacé(s) par titre';
  }

  @override
  String repoLeftInPlace(Object count) {
    return '$count laissé(s) en place';
  }

  @override
  String get repoNotMigratedHeader =>
      'Non migré(s) (toujours sur l’ancienne source) :';

  @override
  String get repoUsePerTitleMigrate =>
      'Utilisez la migration par titre pour ceux-ci.';

  @override
  String get repoDone => 'Terminé';

  @override
  String get setdDownloadsTitle => 'Téléchargements';

  @override
  String get setdDownloadsSectionAutomatic => 'Téléchargements automatiques';

  @override
  String get setdDownloadsNewChapters => 'Télécharger les nouveaux chapitres';

  @override
  String get setdDownloadsNewChaptersDesc =>
      'Télécharger automatiquement les nouveaux chapitres';

  @override
  String get setdDownloadsWifiOnly => 'Wi-Fi uniquement';

  @override
  String get setdDownloadsWifiOnlyDesc => 'Télécharger uniquement en Wi-Fi';

  @override
  String get setdDownloadsChargingOnly => 'En charge uniquement';

  @override
  String get setdDownloadsChargingOnlyDesc =>
      'Télécharger uniquement lorsque l’appareil est branché';

  @override
  String get setdDownloadsAhead => 'Télécharger en avance pendant la lecture';

  @override
  String get setdDownloadsAheadDesc =>
      'Pré-télécharger le chapitre suivant pendant que vous lisez';

  @override
  String get setdDownloadsSectionQueue => 'File de téléchargement';

  @override
  String get setdDownloadsSimultaneous => 'Téléchargements simultanés';

  @override
  String get setdDownloadsQuality => 'Qualité de téléchargement';

  @override
  String get setdDownloadsSectionDelete =>
      'Supprimer les chapitres téléchargés';

  @override
  String get setdDownloadsAfterReading => 'Après la lecture';

  @override
  String get setdDownloadsAfterReadingDesc =>
      'Supprimer les chapitres une fois lus';

  @override
  String get setdDownloadsIncludeBookmarked =>
      'Inclure les chapitres en favori';

  @override
  String get setdDownloadsIncludeBookmarkedDesc =>
      'Supprimer les chapitres en favori avec les autres';

  @override
  String get setdDownloadsAutoDelete =>
      'Supprimer automatiquement les chapitres lus';

  @override
  String get setdDownloadsSectionFormat => 'Format';

  @override
  String get setdDownloadsSaveCbz => 'Enregistrer en CBZ';

  @override
  String get setdDownloadsSaveCbzDesc =>
      'Archiver les chapitres en fichiers CBZ avec métadonnées';

  @override
  String get setdDownloadsSavePdf => 'Enregistrer en PDF';

  @override
  String get setdDownloadsSavePdfDesc =>
      'Regrouper les chapitres en un seul PDF (une image par page)';

  @override
  String get setdDownloadsSectionLocation => 'Emplacement de téléchargement';

  @override
  String get setdDownloadsDefaultLocation => 'Emplacement par défaut';

  @override
  String get setdDownloadsCustomLocation => 'Emplacement personnalisé';

  @override
  String get setdDownloadsChooseFolder => 'Choisir un dossier';

  @override
  String get setdDownloadsIosFolderWarning =>
      'iOS n’autorise pas les apps à conserver l’accès à un dossier. Les téléchargements restent dans le dossier de l’app, accessible via Fichiers › Sur mon iPhone › Foxlations.';

  @override
  String get setdDownloadsReset => 'Réinitialiser';

  @override
  String get setdDownloadsSectionStorage => 'Stockage';

  @override
  String setdDownloadsTotalSize(Object size) {
    return 'Total : $size MB';
  }

  @override
  String setdDownloadsLibraryVaultSize(Object lib, Object vault) {
    return 'Bibliothèque : $lib MB  |  Coffre : $vault MB';
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
  String get setdVaultTitle => 'Coffre';

  @override
  String get setdVaultSectionAccess => 'Accès';

  @override
  String get setdVaultEnable => 'Activer le coffre';

  @override
  String get setdVaultEnableDesc =>
      'Autoriser l’accès au coffre caché en appuyant 8 fois sur Bibliothèque';

  @override
  String get setdVaultSectionSecurity => 'Sécurité';

  @override
  String get setdVaultChangePassword => 'Changer le mot de passe';

  @override
  String get setdVaultSetPassword => 'Définir un mot de passe';

  @override
  String get setdVaultPasswordSetDesc =>
      'Le mot de passe est défini — appuyez pour le changer ou le supprimer';

  @override
  String get setdVaultPasswordUnsetDesc =>
      'Protéger l’accès au coffre avec un mot de passe';

  @override
  String get setdVaultSectionCategories => 'Catégories du coffre';

  @override
  String get setdVaultEditCategories => 'Modifier les catégories du coffre';

  @override
  String get setdVaultEditCategoriesDesc =>
      'Ajouter, supprimer et réorganiser les catégories du coffre';

  @override
  String get setdVaultSectionContents => 'Contenu';

  @override
  String get setdVaultManageContents => 'Gérer le contenu du coffre';

  @override
  String get setdVaultManageContentsDesc =>
      'Déplacer des mangas, animes ou romans dans et hors du coffre';

  @override
  String get setdVaultUnlockFirstSnack =>
      'Déverrouillez d’abord le coffre (accédez-y depuis la bibliothèque)';

  @override
  String get setdVaultSectionHiddenSources => 'Sources cachées';

  @override
  String get setdVaultOnlySources => 'Sources réservées au coffre';

  @override
  String setdVaultHiddenSourcesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources cachées',
      one: '1 source cachée',
    );
    return '$_temp0';
  }

  @override
  String get setdVaultSectionInfo => 'Infos';

  @override
  String get setdVaultInfoText =>
      'Le coffre est une bibliothèque cachée avec ses propres catégories et mangas. Appuyez rapidement 8 fois sur l’onglet Bibliothèque pour basculer en mode coffre. Les mangas du coffre sont stockés séparément et n’apparaissent jamais dans votre bibliothèque principale.';

  @override
  String get setdVaultCurrentPasswordHint => 'Mot de passe actuel';

  @override
  String get setdVaultNewPasswordHint =>
      'Nouveau mot de passe (laissez vide pour supprimer)';

  @override
  String get setdVaultConfirmPasswordHint =>
      'Confirmer le nouveau mot de passe';

  @override
  String get setdVaultCurrentPasswordWrong =>
      'Le mot de passe actuel est incorrect';

  @override
  String get setdVaultPasswordsMismatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get setdVaultRemovingEncryption => 'Suppression du chiffrement…';

  @override
  String get setdVaultEncrypting => 'Chiffrement du coffre…';

  @override
  String get setdVaultPasswordRemoved =>
      'Mot de passe supprimé — le coffre n’est plus chiffré';

  @override
  String get setdVaultPasswordSet => 'Mot de passe défini — coffre chiffré';

  @override
  String get setdVaultNoCategories => 'Aucune catégorie de coffre';

  @override
  String setdVaultDeleteCategoryConfirm(Object name) {
    return 'Voulez-vous vraiment supprimer « $name » ? Les mangas de cette catégorie ne seront pas retirés du coffre.';
  }

  @override
  String get setdVaultNoInstalledSources => 'Aucune source installée';

  @override
  String get setdVaultHiddenSourcesToggleHint =>
      'Activez des sources pour ne les rendre visibles qu’en mode coffre.';

  @override
  String get setdVaultSearchSourcesHint => 'Rechercher des sources...';

  @override
  String get setdCategoryNameHint => 'Nom de la catégorie';

  @override
  String get setdNewCategory => 'Nouvelle catégorie';

  @override
  String get setdRenameCategory => 'Renommer la catégorie';

  @override
  String get setdDeleteCategory => 'Supprimer la catégorie';

  @override
  String get setdActionCancel => 'Annuler';

  @override
  String get setdActionSave => 'Enregistrer';

  @override
  String get setdActionAdd => 'Ajouter';

  @override
  String get setdActionDelete => 'Supprimer';

  @override
  String get setdTapToAddCategory => 'Appuyez sur + pour ajouter une catégorie';

  @override
  String get setdVaultContentsTitle => 'Contenu du coffre';

  @override
  String get setdVaultContentsLockedMessage =>
      'Déverrouillez d’abord le coffre pour gérer son contenu.';

  @override
  String get setdVaultContentsTabManga => 'Manga';

  @override
  String get setdVaultContentsTabAnime => 'Anime';

  @override
  String get setdVaultContentsTabNovels => 'Romans';

  @override
  String get setdVaultContentsInLibrary => 'Dans votre bibliothèque';

  @override
  String get setdVaultContentsMoveIntoHint => '→ déplacer vers le coffre';

  @override
  String get setdVaultContentsInVault => 'Dans le coffre';

  @override
  String get setdVaultContentsMoveOutHint => '← ressortir';

  @override
  String setdVaultContentsEmptyLibrary(Object type) {
    return 'Aucun $type dans votre bibliothèque';
  }

  @override
  String setdVaultContentsEmptyVault(Object type) {
    return 'Aucun $type dans le coffre';
  }

  @override
  String setdVaultContentsMovedIn(Object title) {
    return '« $title » déplacé vers le coffre';
  }

  @override
  String setdVaultContentsMovedOut(Object title) {
    return '« $title » retiré du coffre';
  }

  @override
  String setdVaultContentsReadProgress(Object read, Object total) {
    return '$read/$total lus';
  }

  @override
  String get setdLibraryTitle => 'Bibliothèque';

  @override
  String get setdLibrarySectionCategories => 'Catégories';

  @override
  String get setdLibraryEditCategories => 'Modifier les catégories';

  @override
  String get setdLibraryEditCategoriesDesc =>
      'Ajouter, supprimer et réorganiser les catégories';

  @override
  String get setdLibraryHideEmpty => 'Masquer les catégories vides';

  @override
  String get setdLibraryHideEmptyDesc =>
      'N’afficher que les catégories contenant des mangas';

  @override
  String get setdLibrarySectionGlobalUpdate => 'Mise à jour globale';

  @override
  String get setdLibraryUpdateFrequency => 'Fréquence de mise à jour';

  @override
  String get setdLibraryWifiOnly => 'Wi-Fi uniquement';

  @override
  String get setdLibraryWifiOnlyDesc => 'Mettre à jour uniquement en Wi-Fi';

  @override
  String get setdLibraryChargingOnly => 'En charge uniquement';

  @override
  String get setdLibraryChargingOnlyDesc =>
      'Mettre à jour uniquement lorsque l’appareil est en charge';

  @override
  String get setdLibrarySectionRestrictions => 'Restrictions de mise à jour';

  @override
  String get setdLibrarySkipNotStarted => 'Ignorer les non commencés';

  @override
  String get setdLibrarySkipNotStartedDesc =>
      'Ignorer les mangas sans progression de lecture';

  @override
  String get setdLibraryShowUpdateCount =>
      'Afficher le nombre de nouveaux chapitres';

  @override
  String get setdLibraryShowUpdateCountDesc =>
      'Afficher un badge sur les cartes de manga de la bibliothèque';

  @override
  String get setdLibrarySectionData => 'Données';

  @override
  String get setdLibraryMigrateSource => 'Migrer une source';

  @override
  String get setdLibraryMigrateSourceDesc =>
      'Déplacer toutes les entrées d’une source vers une autre';

  @override
  String get setdLibraryNoCategories => 'Aucune catégorie';

  @override
  String setdLibraryDeleteCategoryConfirm(Object name) {
    return 'Voulez-vous vraiment supprimer « $name » ? Les mangas de cette catégorie ne seront pas retirés de votre bibliothèque.';
  }

  @override
  String get setdPlayerTitle => 'Lecteur vidéo';

  @override
  String get setdPlayerSectionSeek => 'DOUBLE-TOUCHER POUR AVANCER';

  @override
  String get setdPlayerSkipForward => 'Avancer';

  @override
  String get setdPlayerSkipBackward => 'Reculer';

  @override
  String get setdPlayerSectionGestures => 'GESTES';

  @override
  String get setdPlayerHoldToSpeed => 'Maintenir pour accélérer';

  @override
  String setdPlayerHoldToSpeedDesc(Object speed) {
    return 'Appuyez et maintenez n’importe où pour lire à ${speed}x';
  }

  @override
  String get setdPlayerHoldSpeed => 'Vitesse maintenue';

  @override
  String get setdPlayerVolumeSwipe => 'Glissement du volume';

  @override
  String get setdPlayerVolumeSwipeDesc =>
      'Faites glisser vers le haut/bas sur la moitié droite pour régler le volume';

  @override
  String get setdPlayerBrightnessSwipe => 'Glissement de la luminosité';

  @override
  String get setdPlayerBrightnessSwipeDesc =>
      'Faites glisser vers le haut/bas sur la moitié gauche pour régler la luminosité';

  @override
  String get setdPlayerSectionPlayback => 'LECTURE';

  @override
  String get setdPlayerDefaultSpeed => 'Vitesse par défaut';

  @override
  String get setdPlayerAutoplayNext => 'Lire automatiquement l’épisode suivant';

  @override
  String get setdPlayerAutoplayNextDesc =>
      'Lancer automatiquement l’épisode suivant à la fin d’un épisode';

  @override
  String get setdPlayerAutoSkipIntro =>
      'Passer automatiquement l’intro/l’outro';

  @override
  String get setdPlayerAutoSkipIntroDesc =>
      'Passer les génériques de début/fin marqués par la source sans appuyer';

  @override
  String get setdPlayerSkipAmountTitle => 'Durée de saut';

  @override
  String get setdPlayerShowSkipButton => 'Skip-intro button';

  @override
  String get setdPlayerShowSkipButtonDesc =>
      'Show a Skip Intro button near the start, even when the source has no markers';

  @override
  String get setdPlayerSpeedTitle => 'Vitesse';

  @override
  String get setdAppearanceTitle => 'Apparence';

  @override
  String get setdAppearanceSectionTheme => 'Thème';

  @override
  String get setdAppearanceSectionDisplay => 'Affichage';

  @override
  String get setdAppearanceInvertColors => 'Inverser les couleurs';

  @override
  String get setdAppearanceInvertColorsDesc =>
      'Inverse toute l’interface de l’app';

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
  String get setdAppearanceDarkMode => 'Mode sombre';

  @override
  String get setdAppearanceLightMode => 'Mode clair';

  @override
  String get setdAppearanceCurrentlyDark => 'Actuellement sombre';

  @override
  String get setdAppearanceCurrentlyLight => 'Actuellement clair';

  @override
  String get detailStatusOngoing => 'En cours';

  @override
  String get detailStatusCompleted => 'Terminé';

  @override
  String get detailStatusHiatus => 'En pause';

  @override
  String get detailStatusCanceled => 'Annulé';

  @override
  String get detailStatusFinished => 'Achevé';

  @override
  String get detailStatusUnknown => 'Inconnu';

  @override
  String detailChapterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapitres',
      one: '1 chapitre',
    );
    return '$_temp0';
  }

  @override
  String detailEpisodeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count épisodes',
      one: '1 épisode',
    );
    return '$_temp0';
  }

  @override
  String detailDownloadingChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Téléchargement de $count chapitres',
      one: 'Téléchargement de 1 chapitre',
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
