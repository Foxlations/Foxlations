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
  String libraryDaysCount(Object days) {
    return '$days jours';
  }

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
  String get libraryMore => 'Plus';

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
  String get libraryShowNumberOfItems => 'Afficher le nombre d’éléments';

  @override
  String get librarySizeMedium => 'Moyenne';

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
  String libraryStreakDaysStrong(Object days) {
    return '$days jours d’affilée — continuez comme ça !';
  }

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
  String get readerAutoPreloadNextChapter => 'Précharger le chapitre suivant';

  @override
  String get readerAutoPreloadNextChapterSubtitle =>
      'Charger le chapitre suivant en arrière-plan';

  @override
  String get readerGrayscale => 'Niveaux de gris';

  @override
  String get readerGrayscaleSubtitle => 'Afficher les pages en niveaux de gris';

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
  String get readerInvertColors => 'Inverser les couleurs';

  @override
  String get readerInvertColorsSubtitle =>
      'Échanger les couleurs claires et sombres';

  @override
  String get readerDisplay => 'Affichage';

  @override
  String get readerScaleType => 'Type de mise à l’échelle';

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
  String get browseNoLanguagesMatch => 'No languages match';

  @override
  String get browseYourLanguages => 'Your languages';

  @override
  String get browseSearchLanguages => 'Search languages';

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
  String get repoCancel => 'Annuler';

  @override
  String get repoName => 'Nom';

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
  String get setdAppearanceStartTab => 'Open to';

  @override
  String get setdAppearanceStartTabDesc =>
      'Which screen the app opens on at launch';

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
