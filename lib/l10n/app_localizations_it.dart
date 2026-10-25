// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Foxlations';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsSectionApp => 'App';

  @override
  String get settingsSectionManga => 'Manga';

  @override
  String get settingsSectionSystem => 'Sistema';

  @override
  String get settingsLanguageTitle => 'Lingua';

  @override
  String get settingsLanguageEntrySubtitle =>
      'Lingua di visualizzazione dell\'app';

  @override
  String get settingsLanguageSubtitle => 'Scegli la lingua dell\'app';

  @override
  String get settingsLanguageSystemDefault => 'Predefinita del sistema';

  @override
  String get settingsLanguageHeader => 'Lingua dell\'app';

  @override
  String get settingsAppearanceTitle => 'Aspetto';

  @override
  String get settingsAppearanceSubtitle =>
      'Tema, modalità scura, visualizzazione';

  @override
  String get settingsNotificationsTitle => 'Notifiche';

  @override
  String get settingsNotificationsSubtitle =>
      'Avvisi push, frequenza, promemoria';

  @override
  String get settingsStorageTitle => 'Archiviazione';

  @override
  String get settingsStorageSubtitle =>
      'Download, percorsi cartelle, sincronizzazione';

  @override
  String get settingsLibraryTitle => 'Libreria';

  @override
  String get settingsLibrarySubtitle =>
      'Categorie, aggiornamento globale, visualizzazione';

  @override
  String get settingsReaderTitle => 'Lettore';

  @override
  String get settingsReaderSubtitle =>
      'Modalità di lettura, visualizzazione, navigazione';

  @override
  String get settingsPlayerTitle => 'Player';

  @override
  String get settingsPlayerSubtitle =>
      'Avanzamento, gesti, velocità, riproduzione automatica';

  @override
  String get settingsDownloadsTitle => 'Download';

  @override
  String get settingsDownloadsSubtitle =>
      'Download automatici, eliminazione capitoli';

  @override
  String get settingsTrackingTitle => 'Tracciamento';

  @override
  String get settingsTrackingSubtitle => 'MAL, AniList, Kitsu e altro';

  @override
  String get settingsAiTitle => 'IA e traduzione';

  @override
  String get settingsAiSubtitle =>
      'Provider, chiavi API, rilevamento nuvolette';

  @override
  String get settingsBrowseTitle => 'Esplora';

  @override
  String get settingsBrowseSubtitle => 'Fonti, estensioni, ricerca globale';

  @override
  String get settingsBackupTitle => 'Backup e ripristino';

  @override
  String get settingsBackupSubtitle =>
      'Crea/ripristina backup, importa, backup automatico';

  @override
  String get settingsSecurityTitle => 'Sicurezza e privacy';

  @override
  String get settingsSecuritySubtitle =>
      'Blocco app, biometria, sicurezza schermo';

  @override
  String get settingsAdvancedTitle => 'Avanzate';

  @override
  String get settingsAdvancedSubtitle => 'Rete, estensioni, registro, dati';

  @override
  String get settingsAboutTitle => 'Informazioni';

  @override
  String get settingsAboutSubtitle => 'Versione, licenze, link';

  @override
  String get libraryAdd => 'Aggiungi';

  @override
  String get libraryAddAnime => 'Aggiungi anime';

  @override
  String get libraryAddLNs => 'Aggiungi LN';

  @override
  String get libraryAddManga => 'Aggiungi manga';

  @override
  String get libraryBadges => 'Badge';

  @override
  String get libraryBatchMigrate => 'Migra';

  @override
  String get libraryBatchMove => 'Sposta';

  @override
  String get libraryBatchRead => 'Letti';

  @override
  String get libraryBatchRemove => 'Rimuovi';

  @override
  String get libraryBatchUnread => 'Non letti';

  @override
  String get libraryCategoryUpdate => 'Aggiorna categoria';

  @override
  String libraryCategoryUpdateDesc(Object category) {
    return 'Controlla \"$category\" per nuovi capitoli';
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
  String get libraryCheckForUpdates => 'Controlla aggiornamenti';

  @override
  String get libraryClose => 'Chiudi';

  @override
  String get libraryCloseSearch => 'Chiudi ricerca';

  @override
  String get libraryCompleted => 'Completato';

  @override
  String get libraryContinueReading => 'Continua a leggere';

  @override
  String get libraryContinueWatching => 'Continua a guardare';

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
    return '$days giorni';
  }

  @override
  String get libraryDeselectAll => 'Deseleziona tutto';

  @override
  String get libraryDisplayMode => 'Modalità di visualizzazione';

  @override
  String get libraryDownloaded => 'Scaricato';

  @override
  String get libraryEmpty => 'La libreria è vuota';

  @override
  String get libraryEmptyDesc =>
      'La tua libreria è vuota. Esplora le fonti per aggiungere manga.';

  @override
  String libraryEmptyStatsLibrary(Object word) {
    return 'Aggiungi $word alla tua libreria e inizia a leggere per vedere qui le tue statistiche.';
  }

  @override
  String libraryEmptyStatsVault(Object word) {
    return 'Aggiungi $word al tuo vault e inizia a leggere per vedere qui le statistiche.';
  }

  @override
  String get libraryFilterSortDisplay => 'Filtra, ordina e visualizza';

  @override
  String get libraryGlobalUpdate => 'Aggiornamento globale';

  @override
  String get libraryGlobalUpdateDesc =>
      'Controlla ogni elemento della tua libreria';

  @override
  String get libraryHeatmapLess => 'Meno';

  @override
  String get libraryHeatmapMore => 'Più';

  @override
  String get libraryItemsPerRow => 'Elementi per riga';

  @override
  String libraryLastChecked(Object when) {
    return 'Ultimo controllo: $when';
  }

  @override
  String get libraryLibrary => 'Libreria';

  @override
  String libraryListChapters(Object read, Object total) {
    return '$read/$total capitoli';
  }

  @override
  String get libraryMore => 'Altro';

  @override
  String get libraryMoveToCategory => 'Sposta in categoria';

  @override
  String get libraryNever => 'mai';

  @override
  String get libraryNoBookmarks => 'Nessun segnalibro';

  @override
  String get libraryNoBookmarksDesc =>
      'Tieni premuto un manga e aggiungilo ai segnalibri per vederlo qui.';

  @override
  String get libraryNoNewChaptersLastCheck =>
      'Nessun nuovo capitolo trovato nell\'ultimo controllo.';

  @override
  String get libraryNoResults => 'Nessun risultato';

  @override
  String libraryNoResultsDesc(Object query) {
    return 'Nessun risultato per \"$query\". Prova una ricerca diversa.';
  }

  @override
  String get libraryNoStatsYet => 'Ancora nessuna statistica';

  @override
  String get libraryOpenRandomEntry => 'Apri elemento casuale';

  @override
  String get libraryResetToDefault => 'Ripristina predefiniti';

  @override
  String get librarySave => 'Salva';

  @override
  String get librarySearchHint => 'Cerca nella libreria...';

  @override
  String get librarySearchLibrary => 'Cerca nella libreria';

  @override
  String get librarySelect => 'Seleziona';

  @override
  String get librarySelectAll => 'Seleziona tutto';

  @override
  String librarySelectedCount(Object n) {
    return '$n selezionati';
  }

  @override
  String get libraryShowNumberOfItems => 'Mostra numero di elementi';

  @override
  String get librarySizeMedium => 'Media';

  @override
  String get librarySources => 'Fonti';

  @override
  String get libraryStats => 'Statistiche';

  @override
  String get libraryStatusAll => 'Tutti';

  @override
  String get libraryStatusCompleted => 'Completato';

  @override
  String get libraryStatusDropped => 'Abbandonato';

  @override
  String get libraryStatusOnHold => 'In sospeso';

  @override
  String get libraryStatusPlanToRead => 'Da leggere';

  @override
  String get libraryStatusReading => 'In lettura';

  @override
  String get libraryStatusUnknown => 'Sconosciuto';

  @override
  String libraryStreakDaysStrong(Object days) {
    return '$days giorni di fila — continua così!';
  }

  @override
  String get libraryTabDisplay => 'Visualizzazione';

  @override
  String get libraryTabFilter => 'Filtro';

  @override
  String get libraryTabSort => 'Ordina';

  @override
  String get libraryTabs => 'Schede';

  @override
  String libraryTotalAbbrev(Object n) {
    return '$n totali';
  }

  @override
  String get libraryTypeMenuBarrier => 'Library type';

  @override
  String libraryTypeBreakdown(Object type) {
    return 'Ripartizione $type';
  }

  @override
  String get libraryUnread => 'Non letti';

  @override
  String get libraryUpdatesSummary => 'Riepilogo aggiornamenti';

  @override
  String get libraryUpdatesSummaryDesc => 'Cosa ha trovato l\'ultimo controllo';

  @override
  String get libraryVault => 'Vault';

  @override
  String get libraryVaultStats => 'Statistiche Vault';

  @override
  String get detailAdd => 'Aggiungi';

  @override
  String get detailAddNoteHint => 'Aggiungi una nota per questo titolo…';

  @override
  String get detailAddToCategory => 'Aggiungi a categoria';

  @override
  String get detailAddToLibrary => 'Aggiungi alla libreria';

  @override
  String get detailAddWithoutCategory => 'Aggiungi senza categoria';

  @override
  String get detailBelowRead => 'Sotto letti';

  @override
  String get detailBelowUnread => 'Sotto non letti';

  @override
  String get detailBookmark => 'Segnalibro';

  @override
  String get detailBookmarked => 'Nei segnalibri';

  @override
  String get detailCancel => 'Annulla';

  @override
  String get detailChapterFallback => 'Capitolo';

  @override
  String detailCopiedTo(Object source) {
    return 'Copiato in $source';
  }

  @override
  String detailCountSelected(Object count) {
    return '$count selezionati';
  }

  @override
  String get detailDeleteDownload => 'Elimina download';

  @override
  String get detailDone => 'Fatto';

  @override
  String get detailDownload => 'Scarica';

  @override
  String get detailDownloadAllChapters => 'Tutti i capitoli';

  @override
  String get detailDownloadAllUnread => 'Tutti i non letti';

  @override
  String get detailDownloaded => 'Scaricato';

  @override
  String get detailDownloadNext10 => 'Prossimi 10 capitoli';

  @override
  String get detailDownloadNext5 => 'Prossimi 5 capitoli';

  @override
  String get detailDownloadNextChapter => 'Prossimo capitolo';

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
  String get detailEditCategories => 'Modifica categorie';

  @override
  String get detailEditCategoriesTitle => 'Modifica categorie';

  @override
  String get detailFilter => 'Filtra';

  @override
  String get detailInProgress => 'In corso';

  @override
  String get detailLogIn => 'Accedi';

  @override
  String get detailMangaNotFound => 'Manga non trovato nella libreria';

  @override
  String get detailMarkAllAsRead => 'Segna tutti come letti';

  @override
  String get detailMarkAllAsUnread => 'Segna tutti come non letti';

  @override
  String get detailMarkAllBelowRead => 'Segna come letti quelli sotto';

  @override
  String get detailMarkAsUnread => 'Segna come non letto';

  @override
  String get detailMarkChapterAsRead => 'Segna capitolo come letto';

  @override
  String get detailMarkRead => 'Segna letto';

  @override
  String get detailMarkUnread => 'Segna non letto';

  @override
  String get detailMigrate => 'Migra';

  @override
  String get detailMigrateCategories => 'Categorie';

  @override
  String get detailMigrateChapters => 'Capitoli';

  @override
  String get detailMigrateCopy => 'Copia';

  @override
  String get detailMigrateDownloadsNoTransfer =>
      'I capitoli scaricati non vengono trasferiti.';

  @override
  String detailMigratedTo(Object source) {
    return 'Migrato in $source';
  }

  @override
  String detailMigrateEntriesToSource(Object count, Object source) {
    return '$count elementi → $source';
  }

  @override
  String get detailMigrateInfo =>
      'Seleziona lo stesso manga da un\'altra fonte. Il progresso di lettura verrà trasferito.';

  @override
  String get detailMigrateRemoveDownloads =>
      'Rimuovi i download dopo la migrazione';

  @override
  String get detailMigrateSelectData => 'Seleziona i dati da includere';

  @override
  String get detailMigrateShowEntry => 'Mostra elemento';

  @override
  String detailMigrateTitleToSource(Object title, Object source) {
    return '$title → $source';
  }

  @override
  String get detailMigrateTracking => 'Tracciamento';

  @override
  String get detailMigrating => 'Migrazione in corso…';

  @override
  String get detailNewestFirst => 'Prima i più recenti';

  @override
  String get detailNoChaptersFound => 'Nessun capitolo trovato';

  @override
  String get detailNoChaptersLoginHint =>
      'Niente caricato per questo titolo. Riprova — oppure, per questa fonte, accedere può a volte sbloccare altri contenuti.';

  @override
  String get detailNoChaptersRetryHint =>
      'Niente caricato per questo titolo. Potrebbe non averne ancora, oppure la fonte ha avuto problemi a caricarli. Riprova.';

  @override
  String get detailNoResults => 'Nessun risultato trovato';

  @override
  String get detailNotes => 'Note';

  @override
  String get detailNothingToDownload => 'Niente da scaricare';

  @override
  String get detailOldestFirst => 'Prima i più vecchi';

  @override
  String get detailOpenInBrowser => 'Apri nel browser';

  @override
  String get webviewOpenFailed => 'Couldn\'t open the browser';

  @override
  String detailPage(Object page) {
    return 'Pagina $page';
  }

  @override
  String get detailRefresh => 'Aggiorna';

  @override
  String get detailRemove => 'Rimuovi';

  @override
  String get detailRemoveBookmark => 'Rimuovi segnalibro';

  @override
  String get detailRemoveFromLibrary => 'Rimuovi dalla libreria';

  @override
  String get detailRemoveFromLibraryTitle => 'Rimuovere dalla libreria?';

  @override
  String get detailResume => 'Riprendi';

  @override
  String get detailRetry => 'Riprova';

  @override
  String get detailSave => 'Salva';

  @override
  String get detailSearchChapters => 'Cerca capitoli';

  @override
  String get detailSearchChaptersHint => 'Cerca capitoli...';

  @override
  String get detailSearchEpisodes => 'Cerca episodi';

  @override
  String get detailSearchHint => 'Cerca titolo manga...';

  @override
  String get detailSearchingSources => 'Ricerca nelle fonti…';

  @override
  String get detailSelectAll => 'Seleziona tutto';

  @override
  String get detailSelectChapters => 'Seleziona capitoli';

  @override
  String get detailTracking => 'Tracciamento';

  @override
  String get detailUnbookmark => 'Rimuovi dai segnalibri';

  @override
  String get detailUnread => 'Non letto';

  @override
  String get detailWebView => 'WebView';

  @override
  String get appNavLibrary => 'Libreria';

  @override
  String get appNavUpdates => 'Aggiornamenti';

  @override
  String get appNavBrowse => 'Esplora';

  @override
  String get appNavDiscover => 'Discover';

  @override
  String get appNavMore => 'Altro';

  @override
  String get appNavVault => 'Vault';

  @override
  String get appUpdatesTitle => 'Aggiornamenti';

  @override
  String get appNoNewChapters => 'Nessun nuovo capitolo';

  @override
  String get appCheckForUpdates => 'Controlla aggiornamenti';

  @override
  String get appClearAll => 'Cancella tutto';

  @override
  String appCheckingProgress(Object checked, Object total) {
    return 'Controllo $checked / $total...';
  }

  @override
  String appLastChecked(Object time) {
    return 'Ultimo controllo: $time';
  }

  @override
  String get appNoUpdatesYet => 'Ancora nessun aggiornamento';

  @override
  String get appTapRefreshForChapters =>
      'Tocca aggiorna per cercare nuovi capitoli';

  @override
  String get appCheckNow => 'Controlla ora';

  @override
  String get appJustNow => 'Adesso';

  @override
  String appMinutesAgo(Object m) {
    return '$m min fa';
  }

  @override
  String appHoursAgo(Object h) {
    return '$h h fa';
  }

  @override
  String appDaysAgo(Object d) {
    return '$d g fa';
  }

  @override
  String get appToday => 'OGGI';

  @override
  String get appYesterday => 'IERI';

  @override
  String get appOnLatestVersion => 'Hai l\'ultima versione';

  @override
  String get appUpdateAvailable => 'Aggiornamento disponibile';

  @override
  String appVersionBuild(Object version, Object build) {
    return 'v$version · build $build';
  }

  @override
  String get appDownloadUpdate => 'Scarica aggiornamento';

  @override
  String appDownloadVersion(Object version) {
    return 'Scarica v$version';
  }

  @override
  String get appApkDownloadHint =>
      'Apre il download dell\'APK. Android ti chiederà di confermare l\'installazione.';

  @override
  String get appIosUpdateHint =>
      'Aggiorna da AltStore o SideStore — aprilo e aggiorna. iOS non può installare un\'app scaricata da un browser.';

  @override
  String get appSourceUrlCopied =>
      'URL della fonte copiato — aggiungilo in AltStore';

  @override
  String get appCopyAltstoreUrl => 'Copia URL fonte AltStore';

  @override
  String get appBack => 'Indietro';

  @override
  String get appForward => 'Avanti';

  @override
  String get appReload => 'Ricarica';

  @override
  String get appDoneSaveCookies => 'Fatto — salva i cookie';

  @override
  String get appVaultPassword => 'Password del Vault';

  @override
  String get appEnterPassword => 'Inserisci la password';

  @override
  String get appWrongPassword => 'Password errata';

  @override
  String get appCancel => 'Annulla';

  @override
  String get appUnlock => 'Sblocca';

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
  String get readerExperimentalOnIos => 'Sperimentale su iOS';

  @override
  String get readerIosVolumeWarning =>
      'iOS non ha una vera API per i tasti del volume, quindi questa funzione si basa sul monitoraggio del volume di sistema — può risultare instabile. Durante la lettura, il volume di ciò che stai ascoltando (musica, podcast) verrà mantenuto al 50% e non potrà essere modificato. Abilitare comunque?';

  @override
  String get readerCancel => 'Annulla';

  @override
  String get readerEnable => 'Abilita';

  @override
  String get readerTitle => 'Lettore';

  @override
  String get readerPreferences => 'Preferenze';

  @override
  String get readerReadingMode => 'Modalità di lettura';

  @override
  String get readerFontSize => 'Dimensione carattere';

  @override
  String get readerAutoPreloadNextChapter => 'Precarica il capitolo successivo';

  @override
  String get readerAutoPreloadNextChapterSubtitle =>
      'Carica il capitolo successivo in background';

  @override
  String get readerGrayscale => 'Scala di grigi';

  @override
  String get readerGrayscaleSubtitle => 'Mostra le pagine in scala di grigi';

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
  String get readerInvertColors => 'Inverti colori';

  @override
  String get readerInvertColorsSubtitle => 'Scambia colori chiari e scuri';

  @override
  String get readerDisplay => 'Visualizzazione';

  @override
  String get readerScaleType => 'Tipo di scala';

  @override
  String get readerBackgroundColor => 'Colore di sfondo';

  @override
  String get readerKeepScreenOn => 'Mantieni schermo acceso';

  @override
  String get readerKeepScreenOnSubtitle =>
      'Impedisci lo spegnimento dello schermo';

  @override
  String get readerShowPageNumber => 'Mostra numero di pagina';

  @override
  String get readerShowPageNumberSubtitle =>
      'Mostra l\'indicatore di pagina in sovrimpressione';

  @override
  String get readerFullscreen => 'Schermo intero';

  @override
  String get readerFullscreenSubtitle =>
      'Nascondi le barre di sistema durante la lettura';

  @override
  String get readerNavigation => 'Navigazione';

  @override
  String get readerNavigationLayout => 'Layout di navigazione';

  @override
  String get readerInvertTapZones => 'Inverti zone di tocco';

  @override
  String get readerInvertTapZonesSubtitle =>
      'Scambia la navigazione con tocco sinistra/destra';

  @override
  String get readerVolumeKeys => 'Tasti del volume';

  @override
  String get readerVolumeKeysSubtitle =>
      'Tocca per girare pagina/scorrere; tieni premuto per scorrere (webtoon)';

  @override
  String get readerHoldScrollSpeed => 'Velocità scorrimento tenendo premuto';

  @override
  String get readerSourceNotInstalled => 'Fonte non installata';

  @override
  String get readerSourceNotInstalledHint =>
      'This title\'s source isn\'t installed — this can happen after restoring a backup. Install it from Extensions, then try again.';

  @override
  String get readerTranslating => 'Traduzione in corso…';

  @override
  String get readerRetry => 'Riprova';

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
  String get readerLoadingNextChapter => 'Caricamento capitolo successivo...';

  @override
  String get readerAllCaughtUp => 'Sei in pari!';

  @override
  String get readerEndOfChapter => 'Fine del capitolo';

  @override
  String get readerLatestChapterAvailable =>
      'Questo è l\'ultimo capitolo disponibile.';

  @override
  String get readerLoadNextChapter => 'Carica capitolo successivo';

  @override
  String get readerBack => 'Indietro';

  @override
  String get readerSettings => 'Impostazioni';

  @override
  String get readerAiTranslate => 'Traduzione IA';

  @override
  String get readerPreviousChapter => 'Capitolo precedente';

  @override
  String get readerBookmark => 'Segnalibro';

  @override
  String get readerNextChapter => 'Capitolo successivo';

  @override
  String readerTranslationFailed(Object error) {
    return 'Traduzione non riuscita: $error';
  }

  @override
  String get readerModeLtrLabel => 'Da sinistra a destra';

  @override
  String get readerModeRtlLabel => 'Da destra a sinistra';

  @override
  String get readerModeVerticalLabel => 'Scorrimento continuo';

  @override
  String get readerModeWebtoonLabel => 'Webtoon';

  @override
  String get readerModeLtrSubtitle =>
      'Tocca a sinistra/destra per girare pagina';

  @override
  String get readerModeRtlSubtitle => 'Stile manga, da destra a sinistra';

  @override
  String get readerModeVerticalSubtitle => 'Scorri le pagine verticalmente';

  @override
  String get readerModeWebtoonSubtitle =>
      'Ottimizzato per lunghe strisce verticali';

  @override
  String get readerChapters => 'Capitoli';

  @override
  String readerPageOf(int current, int total) {
    return 'Pagina $current di $total';
  }

  @override
  String get readerTabProvider => 'Provider';

  @override
  String get readerTabTarget => 'Destinazione';

  @override
  String get readerTabSource => 'Origine';

  @override
  String get readerTabFont => 'Carattere';

  @override
  String get readerFontNormal => 'Normale';

  @override
  String get readerFontManga => 'Manga';

  @override
  String get readerFontNormalDesc => 'Sans-serif pulito';

  @override
  String get readerFontMangaDesc => 'Stile fumetto in grassetto';

  @override
  String get readerFontSample => 'Ciao mondo';

  @override
  String get readerNoChapterText => 'Nessun testo del capitolo trovato';

  @override
  String get readerReadingTitle => 'Lettura';

  @override
  String get readerSmallerText => 'Testo più piccolo';

  @override
  String get readerLargerText => 'Testo più grande';

  @override
  String get readerPrevious => 'Precedente';

  @override
  String get readerNext => 'Successivo';

  @override
  String get browseTitle => 'Esplora';

  @override
  String get browseGlobalSearch => 'Ricerca globale';

  @override
  String get browseRefreshingRepos => 'Aggiornamento repository...';

  @override
  String get browseRefreshRepos => 'Aggiorna repository';

  @override
  String get browseSearch => 'Cerca';

  @override
  String get browseAddRepo => 'Aggiungi repository';

  @override
  String get browseTabSources => 'Fonti';

  @override
  String get browseTabExtensions => 'Estensioni';

  @override
  String get browseTabLocal => 'Locale';

  @override
  String get browseSearchHint => 'Cerca estensioni e fonti...';

  @override
  String browseRemoveSourceConfirm(Object name) {
    return 'Rimuovere $name?';
  }

  @override
  String get browseRemoveSourceDesc =>
      'La fonte verrà disinstallata. Gli elementi della tua libreria provenienti da essa vengono conservati, ma non potrai aprirli finché non la reinstalli.';

  @override
  String get browseCancel => 'Annulla';

  @override
  String get browseRemove => 'Rimuovi';

  @override
  String get browseProvidedByThisSource => 'FORNITO DA QUESTA FONTE';

  @override
  String get browseCouldNotLoadOptions =>
      'Impossibile caricare le opzioni della fonte';

  @override
  String get browseNoSourceOptions =>
      'Questa fonte non definisce opzioni proprie. Le impostazioni qui sopra si applicano comunque.';

  @override
  String get browseBaseUrl => 'URL di base';

  @override
  String get browseUsingSourceDefault =>
      'Uso del valore predefinito della fonte';

  @override
  String browseBaseUrlDefault(Object url) {
    return '$url  (predefinito)';
  }

  @override
  String get browseResetToDefault => 'Ripristina predefinito';

  @override
  String get browsePinToTop => 'Fissa in alto';

  @override
  String get browsePinToTopDesc =>
      'Mostra questa fonte per prima nell\'elenco delle fonti';

  @override
  String get browseSkipGlobalSearch => 'Escludi dalla ricerca globale';

  @override
  String get browseSkipGlobalSearchDesc =>
      'Escludi questa fonte quando cerchi ovunque';

  @override
  String get browseSkipLibraryUpdates =>
      'Escludi dagli aggiornamenti della libreria';

  @override
  String get browseSkipLibraryUpdatesDesc =>
      'Non controllare nuovi capitoli in questa fonte';

  @override
  String get browseRequestDesktopSite => 'Richiedi sito desktop';

  @override
  String get browseRequestDesktopSiteDesc =>
      'Prova questo se la fonte non trova nulla o non mostra capitoli — alcuni siti inviano ai telefoni una pagina ridotta';

  @override
  String get browseSave => 'Salva';

  @override
  String get browseNone => 'Nessuno';

  @override
  String browseSelectedCount(Object count) {
    return '$count selezionati';
  }

  @override
  String get browseNotSet => 'Non impostato';

  @override
  String get browseIosFolderWarning =>
      'iOS non consente alle app di mantenere l\'accesso a una cartella. Usa \"Importa file\" per aggiungere .cbz/.cbr/.zip/.epub/.pdf.';

  @override
  String browseImportedFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importati $count file',
      one: 'Importato 1 file',
    );
    return '$_temp0';
  }

  @override
  String get browseNothingImported =>
      'Nulla importato (non supportato o illeggibile)';

  @override
  String browseFolderCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cartelle',
      one: '1 cartella',
    );
    return '$_temp0';
  }

  @override
  String get browseManageFolders => 'Gestisci cartelle';

  @override
  String get browseImportFileTooltip => 'Importa file (CBZ/ZIP/EPUB/PDF)';

  @override
  String get browseAddFolder => 'Aggiungi cartella';

  @override
  String get browseRescan => 'Riscansiona';

  @override
  String get browseNothingImportedYet => 'Ancora nulla importato';

  @override
  String get browseNoLocalSources => 'Nessuna fonte locale';

  @override
  String get browseLocalSourcesDesc =>
      'Aggiungi una cartella di manga o importa un singolo file.\nSupportati: immagini (JPG, PNG, WebP, GIF), CBZ/ZIP, EPUB e PDF.\n(CBR/RAR solo se il file è effettivamente compresso in ZIP — il vero RAR non è supportato.)';

  @override
  String get browseAddFolderButton => 'Aggiungi cartella';

  @override
  String get browseImportFile => 'Importa file';

  @override
  String get browseLocalSourceFolders => 'Cartelle fonti locali';

  @override
  String get browseNoFoldersAdded => 'Nessuna cartella aggiunta';

  @override
  String browseChaptersAbbrev(Object n) {
    return '$n cap';
  }

  @override
  String get browseInstalled => 'INSTALLATE';

  @override
  String get browseAvailable => 'DISPONIBILI';

  @override
  String get browseSourceNotInstalled => 'La fonte non è installata';

  @override
  String get browseManga => 'Manga';

  @override
  String get browseAnime => 'Anime';

  @override
  String get browseNovels => 'Novel';

  @override
  String get browseAllLanguages => 'Tutte le lingue';

  @override
  String get browseFilter => 'Filtra';

  @override
  String browseLanguagesCount(Object count) {
    return '$count lingue';
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
      other: '$count risultati',
      one: '1 risultato',
    );
    return '$_temp0';
  }

  @override
  String get browseNoExtensions => 'Ancora nessuna estensione';

  @override
  String get browseNoExtensionsDesc =>
      'Aggiungi un repository con il pulsante impostazioni\nqui sopra per esplorare le estensioni.';

  @override
  String browseUpdatedSources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aggiornate $count fonti',
      one: 'Aggiornata 1 fonte',
    );
    return '$_temp0';
  }

  @override
  String get browseSourceUpdated => 'Fonte aggiornata';

  @override
  String get browseNoUpdateAvailable => 'Nessun aggiornamento disponibile';

  @override
  String browseUpdateFailed(Object error) {
    return 'Aggiornamento non riuscito: $error';
  }

  @override
  String browseRefreshFailed(Object error) {
    return 'Ricarica non riuscita: $error';
  }

  @override
  String browseUpdatesAvailable(Object count) {
    return 'AGGIORNAMENTI DISPONIBILI ($count)';
  }

  @override
  String get browseUpdateAll => 'Aggiorna tutto';

  @override
  String get browseUpdate => 'Aggiorna';

  @override
  String get browseSettings => 'Impostazioni';

  @override
  String get browseInstall => 'Installa';

  @override
  String get browseInstalledBadge => 'Installata';

  @override
  String get browseAbout => 'INFORMAZIONI';

  @override
  String browseSourceFrom(Object url) {
    return 'Fonte da $url';
  }

  @override
  String browseLanguageLabel(Object lang) {
    return 'Lingua: $lang';
  }

  @override
  String get browseUsesCloudflare => 'Usa la protezione Cloudflare';

  @override
  String get browseNoCloudflare => 'Nessun Cloudflare';

  @override
  String get browseAdultContent => 'Contenuti 18+';

  @override
  String get browseSafeForWork => 'Adatto al lavoro';

  @override
  String get browseFeatures => 'FUNZIONALITÀ';

  @override
  String get browsePopular => 'Popolari';

  @override
  String get browseLatest => 'Recenti';

  @override
  String browseSourceAction(Object name) {
    return 'Esplora $name';
  }

  @override
  String get browseRemoving => 'Rimozione...';

  @override
  String get browseInstalling => 'Installazione...';

  @override
  String browseFailed(Object error) {
    return 'Non riuscito: $error';
  }

  @override
  String get browseNoLanguagesMatch => 'No languages match';

  @override
  String get browseYourLanguages => 'Your languages';

  @override
  String get browseSearchLanguages => 'Search languages';

  @override
  String get browseUpdating => 'Aggiornamento...';

  @override
  String get browseUpdateExtensionCode => 'Aggiorna il codice dell\'estensione';

  @override
  String browseUpdatedSource(Object name) {
    return 'Aggiornata $name';
  }

  @override
  String get browsePinned => 'FISSATE';

  @override
  String get browseAll => 'Tutte';

  @override
  String get browseNoInstalledSources => 'Nessuna fonte installata';

  @override
  String get browseNoInstalledSourcesDesc =>
      'Installa estensioni dalla scheda Estensioni\nper vedere le fonti qui.';

  @override
  String get browseUnpin => 'Rimuovi da fissate';

  @override
  String get browsePin => 'Fissa';

  @override
  String get browseSourceNotInstalledBody => 'Fonte non installata';

  @override
  String get browseBypassingCloudflare =>
      'Aggiramento della protezione Cloudflare...';

  @override
  String get browseOpenInWebView => 'Apri in WebView';

  @override
  String get browseCloudflareProtection => 'Protezione Cloudflare';

  @override
  String get browseFailedToLoad => 'Caricamento non riuscito';

  @override
  String get browseCloudflareChallengeDesc =>
      'Questa fonte richiede di risolvere prima una verifica Cloudflare nel browser.';

  @override
  String get browseSolveCloudflare => 'Risolvi Cloudflare';

  @override
  String get browseRetry => 'Riprova';

  @override
  String get browseContentAnime => 'anime';

  @override
  String get browseContentNovels => 'light novel';

  @override
  String get browseContentManga => 'manga';

  @override
  String browseNoContentFound(Object noun) {
    return 'Nessun $noun trovato';
  }

  @override
  String get browseAllCategories => 'Tutte le categorie';

  @override
  String get browseNoCategories => 'Nessuna categoria';

  @override
  String get browseSearchMangaHint => 'Cerca manga...';

  @override
  String get browseUnknown => 'Sconosciuto';

  @override
  String get browseSearchAllSourcesHint => 'Cerca in tutte le fonti...';

  @override
  String get browseNoSourcesInstalled => 'Nessuna fonte installata';

  @override
  String get browseNoSourcesInstalledDesc =>
      'Installa estensioni dalla scheda Esplora.';

  @override
  String get browseSearchAllSources => 'Cerca in tutte le fonti';

  @override
  String browseSearchSourcesAtOnce(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cerca in $count fonti contemporaneamente.',
      one: 'Cerca in 1 fonte contemporaneamente.',
    );
    return '$_temp0';
  }

  @override
  String browseSearchingSources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ricerca in $count fonti...',
      one: 'Ricerca in 1 fonte...',
    );
    return '$_temp0';
  }

  @override
  String get browseSeeAll => 'Vedi tutto';

  @override
  String get globalSearchSourceNoResults => 'No results';

  @override
  String get globalSearchSourceFailed => 'Couldn\'t search this source';

  @override
  String get browseSectionSources => 'Fonti';

  @override
  String get browseShowNsfw => 'Mostra fonti NSFW';

  @override
  String get browseShowNsfwDesc => 'Mostra fonti 18+ in esplorazione e ricerca';

  @override
  String get browsePinnedOnly => 'Solo fonti fissate';

  @override
  String get browsePinnedOnlyBrowseDesc =>
      'Mostra solo le fonti fissate in esplorazione';

  @override
  String get browseSectionGlobalSearch => 'Ricerca globale';

  @override
  String get browsePinnedOnlyGlobalSearchDesc =>
      'Cerca solo nelle fonti fissate nella ricerca globale';

  @override
  String get browseSectionWebView => 'WebView';

  @override
  String get browseAdBlocker => 'Ad Blocker';

  @override
  String get browseAdBlockerDesc =>
      'Blocca annunci, popup e overlay nel browser';

  @override
  String get browseSectionExtensions => 'Estensioni';

  @override
  String get browseAutoUpdate => 'Aggiorna automaticamente le estensioni';

  @override
  String get browseAutoUpdateDesc =>
      'Aggiorna il codice delle estensioni installate all\'avvio dell\'app';

  @override
  String get setxAdvancedTitle => 'Avanzate';

  @override
  String get setxAdvancedSectionLogging => 'Registro';

  @override
  String get setxAdvancedVerboseLoggingTitle => 'Registro dettagliato';

  @override
  String get setxAdvancedVerboseLoggingSubtitle =>
      'Registra informazioni di debug dettagliate';

  @override
  String get setxAdvancedViewErrorLogsTitle => 'Visualizza registri errori';

  @override
  String get setxAdvancedViewErrorLogsSubtitle =>
      'Sfoglia i registri di debug ed errori';

  @override
  String get setxAdvancedSectionNetwork => 'Rete';

  @override
  String get setxAdvancedDnsOverHttpsTitle => 'DNS over HTTPS';

  @override
  String get setxAdvancedDnsOverHttpsSubtitle => 'Usa risoluzione DNS sicura';

  @override
  String get setxAdvancedDnsProviderTitle => 'Provider DNS';

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
  String get setxAdvancedSectionExtensions => 'Estensioni';

  @override
  String get setxAdvancedThirdPartyTitle => 'Estensioni di terze parti';

  @override
  String get setxAdvancedThirdPartySubtitle =>
      'Consenti estensioni da fonti sconosciute';

  @override
  String get setxAdvancedExtUpdateTitle => 'Avvisi aggiornamento estensioni';

  @override
  String get setxAdvancedExtUpdateSubtitle =>
      'Avvisa quando le estensioni hanno aggiornamenti';

  @override
  String get setxAdvancedSectionBrowser => 'Browser';

  @override
  String get setxAdvancedExternalBrowserTitle => 'Browser esterno';

  @override
  String get setxAdvancedExternalBrowserSubtitle =>
      'Apri i link nel browser di sistema';

  @override
  String get setxAdvancedSectionData => 'Dati';

  @override
  String get setxAdvancedClearCacheTitle => 'Svuota cache capitoli';

  @override
  String get setxAdvancedClearCacheSubtitle => 'Libera spazio di archiviazione';

  @override
  String get setxAdvancedClearDbEntryTitle => 'Cancella database';

  @override
  String get setxAdvancedClearDbEntrySubtitle =>
      'Reimposta libreria, categorie e cronologia di lettura';

  @override
  String get setxAdvancedCacheCleared => 'Cache immagini capitoli svuotata';

  @override
  String get setxAdvancedClearDbTitle => 'Cancellare il database?';

  @override
  String get setxAdvancedClearDbBody =>
      'Questa operazione elimina definitivamente la libreria, le categorie e la cronologia di lettura. Le estensioni installate e i download non vengono toccati.';

  @override
  String get setxAdvancedCancel => 'Annulla';

  @override
  String get setxAdvancedClear => 'Cancella';

  @override
  String get setxAdvancedDbCleared =>
      'Database cancellato — riavvia l\'app per ripristinare i valori predefiniti';

  @override
  String get setxAdvancedErrorLogsTitle => 'Registri errori';

  @override
  String get setxAdvancedClearAllLogsTooltip => 'Cancella tutti i registri';

  @override
  String get setxAdvancedFilterCategory => 'Categoria';

  @override
  String get setxAdvancedFilterLevel => 'Livello';

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
  String get setxAdvancedNoLogs => 'Ancora nessun registro';

  @override
  String get setxAdvancedNoLogsSubtitle =>
      'I registri appariranno qui man mano che usi l\'app';

  @override
  String get setxAdvancedClearLogsTitle => 'Cancellare tutti i registri?';

  @override
  String get setxAdvancedClearLogsBody =>
      'Questa operazione eliminerà definitivamente tutte le voci di registro memorizzate.';

  @override
  String get setxAdvancedLogsCleared => 'Registri cancellati';

  @override
  String get setxAdvancedCopiedToClipboard => 'Copiato negli appunti';

  @override
  String get setxNotifTitle => 'Notifiche';

  @override
  String get setxNotifSectionChapterUpdates => 'Aggiornamenti capitoli';

  @override
  String get setxNotifNewChaptersTitle => 'Nuovi capitoli';

  @override
  String get setxNotifNewChaptersSubtitle =>
      'Avvisa quando sono disponibili nuovi capitoli';

  @override
  String get setxNotifLibraryUpdatesTitle => 'Aggiornamenti libreria';

  @override
  String get setxNotifLibraryUpdatesSubtitle =>
      'Avvisa al termine dell\'aggiornamento della libreria';

  @override
  String get setxNotifSectionDownloads => 'Download';

  @override
  String get setxNotifDownloadCompleteTitle => 'Download completato';

  @override
  String get setxNotifDownloadCompleteSubtitle =>
      'Avvisa al termine del download dei capitoli';

  @override
  String get setxNotifDownloadErrorTitle => 'Errore di download';

  @override
  String get setxNotifDownloadErrorSubtitle =>
      'Avvisa quando un download non riesce';

  @override
  String get setxNotifSectionBehavior => 'Comportamento';

  @override
  String get setxNotifSoundTitle => 'Suono';

  @override
  String get setxNotifSoundSubtitle => 'Riproduci un suono per le notifiche';

  @override
  String get setxNotifVibrationTitle => 'Vibrazione';

  @override
  String get setxNotifVibrationSubtitle => 'Vibra per le notifiche';

  @override
  String get setxNotifGroupTitle => 'Raggruppa notifiche';

  @override
  String get setxNotifGroupSubtitle => 'Combina più notifiche';

  @override
  String get setxSecurityTitle => 'Sicurezza e privacy';

  @override
  String get setxSecuritySectionAppLock => 'Blocco app';

  @override
  String get setxSecurityAppLockTitle => 'Blocco app';

  @override
  String get setxSecurityAppLockSubtitle =>
      'Richiedi autenticazione per aprire l\'app';

  @override
  String get setxSecurityBiometricsTitle => 'Biometria';

  @override
  String get setxSecurityBiometricsSubtitle =>
      'Usa impronta o volto per sbloccare';

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
  String get setxSecuritySecureScreenTitle => 'Schermo sicuro';

  @override
  String get setxSecuritySecureScreenSubtitle =>
      'Nascondi il contenuto dell\'app nelle app recenti';

  @override
  String get setxSecurityHideNotifTitle => 'Nascondi contenuto notifiche';

  @override
  String get setxSecurityHideNotifSubtitle =>
      'Mostra un testo di notifica generico';

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
  String get setxBackupTitle => 'Backup e ripristino';

  @override
  String get setxBackupSectionFoxlations => 'Backup Foxlations';

  @override
  String get setxBackupCreateTitle => 'Crea backup';

  @override
  String get setxBackupCreateSubtitle =>
      'Salva libreria, categorie, progresso di lettura, fonti e tracciamento';

  @override
  String get setxBackupRestoreTitle => 'Ripristina backup';

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
      'Ripristina da un file .fxbackup di Foxlations';

  @override
  String get setxBackupSectionTachiyomi => 'Tachiyomi / Mihon e fork';

  @override
  String get setxBackupCreateCompatTitle => 'Crea backup compatibile';

  @override
  String get setxBackupCreateCompatSubtitle =>
      'Esporta un .tachibk importabile in Tachiyomi, Mihon e fork';

  @override
  String get setxBackupRestoreTachiyomiTitle => 'Ripristina da Tachiyomi/Mihon';

  @override
  String get setxBackupRestoreTachiyomiSubtitle =>
      'Importa un backup .tachibk / .tmb / .proto.gz (abbina le fonti per nome)';

  @override
  String get setxBackupSectionAutomatic => 'Backup automatico';

  @override
  String get setxBackupFrequency => 'Frequenza';

  @override
  String setxBackupAutoSubtitle(Object freq) {
    return 'Crea automaticamente un backup $freq';
  }

  @override
  String setxBackupSectionBackups(Object count) {
    return 'Backup ($count)';
  }

  @override
  String get setxBackupNone => 'Ancora nessun backup.';

  @override
  String get setxBackupMenuRestore => 'Ripristina';

  @override
  String get setxBackupMenuDelete => 'Elimina';

  @override
  String get setxBackupFreqOff => 'Disattivato';

  @override
  String get setxBackupFreqDaily => 'Ogni giorno';

  @override
  String get setxBackupFreqWeekly => 'Ogni settimana';

  @override
  String get setxBackupFreqMonthly => 'Ogni mese';

  @override
  String setxBackupImportedManga(Object count) {
    return 'Importati $count manga';
  }

  @override
  String get setxBackupRestoreComplete => 'Ripristino completato';

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
    return 'Ripristino non riuscito: $error';
  }

  @override
  String get setxAboutTitle => 'Informazioni';

  @override
  String get setxAboutSectionApp => 'App';

  @override
  String get setxAboutWhatsNewTitle => 'Novità';

  @override
  String get setxAboutWhatsNewSubtitle => 'Changelog e note di rilascio';

  @override
  String get setxAboutCheckUpdatesTitle => 'Controlla aggiornamenti';

  @override
  String get setxAboutCheckUpdatesSubtitle =>
      'Verifica se è stata rilasciata una build più recente';

  @override
  String get setxAboutSectionLegal => 'Note legali';

  @override
  String get setxAboutLicensesTitle => 'Licenze';

  @override
  String get setxAboutLicensesSubtitle => 'Licenze open source';

  @override
  String get setxAboutSectionLinks => 'Link';

  @override
  String get setxAboutSourceCodeTitle => 'Codice sorgente';

  @override
  String get setxAboutSourceCodeSubtitle =>
      'Tocca per copiare l\'URL di GitHub';

  @override
  String get setxAboutReportBugTitle => 'Segnala un bug';

  @override
  String get setxAboutReportBugSubtitle =>
      'Tocca per copiare l\'URL del bug tracker';

  @override
  String get setxAboutClose => 'Chiudi';

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
    return 'Novità nella v$version';
  }

  @override
  String setxAboutLinkCopied(Object label) {
    return 'Link $label copiato negli appunti';
  }

  @override
  String get setxAboutSourceCodeLabel => 'Codice sorgente';

  @override
  String get setxAboutBugReportLabel => 'Segnalazione bug';

  @override
  String get miscResumePlaybackTitle => 'Riprendere la riproduzione?';

  @override
  String miscStoppedWatchingAt(Object time) {
    return 'Hai interrotto la visione a $time.';
  }

  @override
  String get miscStartOver => 'Ricomincia';

  @override
  String miscContinueAt(Object time) {
    return 'Continua ($time)';
  }

  @override
  String get miscQuality => 'Qualità';

  @override
  String miscSourceIndex(Object index) {
    return 'Fonte $index';
  }

  @override
  String get miscSubtitles => 'Sottotitoli';

  @override
  String get miscSubtitleOff => 'Disattivati';

  @override
  String get miscUnknownTrack => 'Sconosciuta';

  @override
  String get miscSubtitleDelay => 'Ritardo sottotitoli';

  @override
  String get miscAudio => 'Audio';

  @override
  String get miscPlaybackSpeed => 'Velocità di riproduzione';

  @override
  String get miscSkipOutro => 'Salta finale';

  @override
  String get miscSkipIntro => 'Salta intro';

  @override
  String get miscUnlockControls => 'Sblocca controlli';

  @override
  String get miscUnknownError => 'Errore sconosciuto';

  @override
  String get miscRetry => 'Riprova';

  @override
  String get miscExtensionRepositories => 'Repository estensioni';

  @override
  String get miscRepositoryUrlHint => 'URL repository (index.json)';

  @override
  String get miscAdd => 'Aggiungi';

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
  String get miscRepositoriesHeader => 'REPOSITORY';

  @override
  String get miscNoReposYet => 'Ancora nessun repository aggiunto';

  @override
  String miscFailedToAddRepo(Object error) {
    return 'Impossibile aggiungere il repository: $error';
  }

  @override
  String get miscVerifyHuman => 'Verifica di essere umano';

  @override
  String get miscCfInstructions =>
      'Completa la verifica del sito qui sotto. Si chiude automaticamente e non verrà richiesta di nuovo finché la verifica è valida.';

  @override
  String get trackTitle => 'Tracciamento';

  @override
  String get trackNoTrackerConnected => 'Nessun tracker connesso';

  @override
  String get trackConnectHint =>
      'Connetti AniList, MyAnimeList o Kitsu in Impostazioni › Tracciamento.';

  @override
  String trackNotLinkedOn(Object name) {
    return 'Non collegato su $name';
  }

  @override
  String get trackLink => 'Collega';

  @override
  String get trackUnlink => 'Scollega';

  @override
  String get trackStatus => 'Stato';

  @override
  String get trackChapters => 'Capitoli';

  @override
  String get trackScore => 'Punteggio';

  @override
  String trackLinkedTo(Object name) {
    return 'Collegato a $name';
  }

  @override
  String trackLinkOn(Object name) {
    return 'Collega su $name';
  }

  @override
  String get trackSearchTitleHint => 'Cerca titolo';

  @override
  String get trackSearch => 'Cerca';

  @override
  String get trackNoResults => 'Nessun risultato';

  @override
  String trackChaptersShort(Object count) {
    return '$count cap';
  }

  @override
  String trackConnectTracker(Object name) {
    return 'Connetti $name';
  }

  @override
  String get trackOauthInstructions =>
      'Accedi e premi Autorizza. Verrai connesso automaticamente.';

  @override
  String get trackServices => 'Servizi';

  @override
  String get trackServicesDescription =>
      'Connetti un servizio di tracciamento per sincronizzare il tuo progresso di lettura. Una volta collegato un manga, il progresso si aggiorna automaticamente mentre leggi.';

  @override
  String trackLogInTo(Object name) {
    return 'Accedi a $name';
  }

  @override
  String get trackEmailOrUsername => 'Email o nome utente';

  @override
  String get trackPassword => 'Password';

  @override
  String get trackCancel => 'Annulla';

  @override
  String get trackLogIn => 'Accedi';

  @override
  String trackConnectedTo(Object name) {
    return 'Connesso a $name';
  }

  @override
  String get trackLoginFailed =>
      'Accesso non riuscito — controlla le tue credenziali';

  @override
  String get trackSetClientIdFirst => 'Imposta prima un client ID';

  @override
  String get trackCouldNotCompleteSignIn => 'Impossibile completare l\'accesso';

  @override
  String trackClientIdTitle(Object name) {
    return 'Client ID di $name (avanzato)';
  }

  @override
  String trackClientIdDescription(Object name) {
    return 'Opzionale. Foxlations ha già un client ID $name integrato — basta toccare Connetti. Imposta questo solo se hai registrato una tua app sviluppatore $name e vuoi usarla al suo posto.';
  }

  @override
  String get trackClientId => 'Client ID';

  @override
  String get trackSave => 'Salva';

  @override
  String get trackPasteAccessToken => 'Incolla il token di accesso';

  @override
  String get trackPasteTokenHint =>
      'Incolla il token mostrato dopo l\'autorizzazione';

  @override
  String get trackConnect => 'Connetti';

  @override
  String get trackCouldNotVerifyToken => 'Impossibile verificare il token';

  @override
  String get trackConnected => 'Connesso';

  @override
  String trackConnectedAs(Object username) {
    return 'Connesso come $username';
  }

  @override
  String get trackTapConnectToAuthorize => 'Tocca Connetti per autorizzare';

  @override
  String get trackSignInWithAccount => 'Accedi con il tuo account';

  @override
  String get trackDisconnect => 'Disconnetti';

  @override
  String get trackAiTitle => 'IA e traduzione';

  @override
  String get trackTabTranslation => 'Traduzione';

  @override
  String get trackTabApiKeys => 'Chiavi API';

  @override
  String get trackTabModels => 'Modelli';

  @override
  String get trackEnableAiTranslation => 'Abilita traduzione IA';

  @override
  String get trackEnableAiTranslationDesc =>
      'Mostra il pulsante di traduzione nel lettore';

  @override
  String get trackProvider => 'Provider';

  @override
  String get trackOfflineMode => 'Modalità offline';

  @override
  String get trackOfflineModeDesc => 'Usa i modelli scaricati senza internet';

  @override
  String get trackTranslationSettings => 'Impostazioni di traduzione';

  @override
  String get trackTargetLanguage => 'Lingua di destinazione';

  @override
  String get trackTargetLanguageDesc =>
      'Traduci il testo del manga in questa lingua';

  @override
  String get trackBubbleDetection => 'Rilevamento nuvolette';

  @override
  String get trackBubbleDetectionDesc =>
      'Rileva automaticamente le nuvolette nelle pagine dei manga';

  @override
  String get trackQuality => 'Qualità';

  @override
  String get trackQualityFast => 'Veloce';

  @override
  String get trackQualityBalanced => 'Bilanciata';

  @override
  String get trackQualityHigh => 'Alta qualità';

  @override
  String get trackKoharuServer => 'Server Koharu';

  @override
  String get trackServerUrl => 'URL del server';

  @override
  String get trackKoharuServerDesc =>
      'Inpainting completo del manga tramite server Docker locale';

  @override
  String get trackApiKeyRequired => 'Chiave API richiesta';

  @override
  String get trackApiKeysNotice =>
      'Le chiavi sono memorizzate localmente sul tuo dispositivo e non vengono mai inviate ai nostri server.';

  @override
  String get trackModelsPlatformOnly =>
      'I modelli di traduzione sul dispositivo sono disponibili su Android e iOS.';

  @override
  String get trackModelsDescription =>
      'Scarica una lingua per tradurla completamente offline. Ogni pacchetto è di circa 30 MB e viene scaricato automaticamente anche la prima volta che traduci quella lingua.';

  @override
  String get trackTranslationLanguages => 'LINGUE DI TRADUZIONE';

  @override
  String get trackDownloaded => 'Scaricato — disponibile offline';

  @override
  String get trackNotDownloaded => 'Non scaricato';

  @override
  String get trackDelete => 'Elimina';

  @override
  String get trackDownload => 'Scarica';

  @override
  String trackDownloadFailed(Object error) {
    return 'Download non riuscito: $error';
  }

  @override
  String trackDeleteFailed(Object error) {
    return 'Eliminazione non riuscita: $error';
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
  String get repoCancel => 'Annulla';

  @override
  String get repoName => 'Nome';

  @override
  String repoImportedSource(Object id) {
    return 'Fonte importata · $id';
  }

  @override
  String get repoCheckingMatches => 'Controllo delle corrispondenze';

  @override
  String get repoMigrating => 'Migrazione in corso';

  @override
  String get repoMigrateThisSource => 'Migrare questa fonte?';

  @override
  String repoMatchedByUrl(Object count) {
    return '$count corrispondenti per URL';
  }

  @override
  String repoMatchedByTitle(Object count) {
    return '$count corrispondenti per titolo';
  }

  @override
  String repoNotFoundLeftInPlace(Object count) {
    return '$count non trovati — lasciati invariati';
  }

  @override
  String get repoMigrateCarryOver =>
      'Progresso di lettura, categorie e tracciamento vengono trasferiti. Gli originali vengono rimossi solo per gli elementi che vengono spostati.';

  @override
  String repoMigrateCount(Object count) {
    return 'Migra $count';
  }

  @override
  String get repoMigrateASource => 'Migra una fonte';

  @override
  String get repoMigrateIntro =>
      'Sposta ogni elemento della libreria da una fonte a un\'altra. Gli scambi sullo stesso sito corrispondono esattamente per URL; anche gli elementi importati da un backup possono essere riassegnati a una fonte reale.';

  @override
  String get repoFrom => 'DA';

  @override
  String get repoSelectSource => 'Seleziona una fonte…';

  @override
  String get repoTo => 'A';

  @override
  String get repoAlsoMatchByTitle => 'Abbina anche per titolo';

  @override
  String get repoAlsoMatchByTitleHint =>
      'Per spostamenti tra siti diversi: se un elemento non viene trovato per URL, cerca nella nuova fonte per titolo e prendi la corrispondenza più simile. Disattivato per impostazione predefinita per evitare di associare la serie sbagliata.';

  @override
  String get repoMigrateSource => 'Migra fonte';

  @override
  String get repoMigrationComplete => 'Migrazione completata';

  @override
  String repoMovedByUrl(Object count) {
    return '$count spostati per URL';
  }

  @override
  String repoMovedByTitle(Object count) {
    return '$count spostati per titolo';
  }

  @override
  String repoLeftInPlace(Object count) {
    return '$count lasciati invariati';
  }

  @override
  String get repoNotMigratedHeader =>
      'Non migrati (ancora sulla vecchia fonte):';

  @override
  String get repoUsePerTitleMigrate =>
      'Usa la migrazione per singolo titolo per questi.';

  @override
  String get repoDone => 'Fatto';

  @override
  String get setdDownloadsTitle => 'Download';

  @override
  String get setdDownloadsSectionAutomatic => 'Download automatici';

  @override
  String get setdDownloadsNewChapters => 'Scarica nuovi capitoli';

  @override
  String get setdDownloadsNewChaptersDesc =>
      'Scarica automaticamente i nuovi capitoli';

  @override
  String get setdDownloadsWifiOnly => 'Solo Wi-Fi';

  @override
  String get setdDownloadsWifiOnlyDesc => 'Scarica solo su Wi-Fi';

  @override
  String get setdDownloadsChargingOnly => 'Solo in carica';

  @override
  String get setdDownloadsChargingOnlyDesc => 'Scarica solo quando è in carica';

  @override
  String get setdDownloadsAhead => 'Scarica in anticipo durante la lettura';

  @override
  String get setdDownloadsAheadDesc =>
      'Pre-scarica il capitolo successivo mentre leggi';

  @override
  String get setdDownloadsSectionQueue => 'Coda di download';

  @override
  String get setdDownloadsSimultaneous => 'Download simultanei';

  @override
  String get setdDownloadsQuality => 'Qualità download';

  @override
  String get setdDownloadsSectionDelete => 'Elimina capitoli scaricati';

  @override
  String get setdDownloadsAfterReading => 'Dopo la lettura';

  @override
  String get setdDownloadsAfterReadingDesc =>
      'Elimina i capitoli dopo averli letti';

  @override
  String get setdDownloadsIncludeBookmarked =>
      'Includi capitoli nei segnalibri';

  @override
  String get setdDownloadsIncludeBookmarkedDesc =>
      'Elimina i capitoli nei segnalibri insieme agli altri';

  @override
  String get setdDownloadsAutoDelete =>
      'Elimina automaticamente i capitoli letti';

  @override
  String get setdDownloadsSectionFormat => 'Formato';

  @override
  String get setdDownloadsSaveCbz => 'Salva come CBZ';

  @override
  String get setdDownloadsSaveCbzDesc =>
      'Archivia i capitoli come file CBZ con metadati';

  @override
  String get setdDownloadsSavePdf => 'Salva come PDF';

  @override
  String get setdDownloadsSavePdfDesc =>
      'Raggruppa i capitoli in un unico PDF (un\'immagine per pagina)';

  @override
  String get setdDownloadsSectionLocation => 'Percorso di download';

  @override
  String get setdDownloadsDefaultLocation => 'Percorso predefinito';

  @override
  String get setdDownloadsCustomLocation => 'Percorso personalizzato';

  @override
  String get setdDownloadsChooseFolder => 'Scegli cartella';

  @override
  String get setdDownloadsIosFolderWarning =>
      'iOS non consente alle app di mantenere l\'accesso a una cartella. I download restano nella cartella dell\'app, raggiungibile tramite File › Sul mio iPhone › Foxlations.';

  @override
  String get setdDownloadsReset => 'Reimposta';

  @override
  String get setdDownloadsSectionStorage => 'Archiviazione';

  @override
  String setdDownloadsTotalSize(Object size) {
    return 'Totale: $size MB';
  }

  @override
  String setdDownloadsLibraryVaultSize(Object lib, Object vault) {
    return 'Libreria: $lib MB  |  Vault: $vault MB';
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
  String get setdVaultSectionAccess => 'Accesso';

  @override
  String get setdVaultEnable => 'Abilita Vault';

  @override
  String get setdVaultEnableDesc =>
      'Consenti l\'accesso al vault nascosto toccando Libreria 8 volte';

  @override
  String get setdVaultSectionSecurity => 'Sicurezza';

  @override
  String get setdVaultChangePassword => 'Cambia password';

  @override
  String get setdVaultSetPassword => 'Imposta password';

  @override
  String get setdVaultPasswordSetDesc =>
      'La password è impostata — tocca per cambiarla o rimuoverla';

  @override
  String get setdVaultPasswordUnsetDesc =>
      'Proteggi l\'accesso al vault con una password';

  @override
  String get setdVaultSectionCategories => 'Categorie del Vault';

  @override
  String get setdVaultEditCategories => 'Modifica categorie del Vault';

  @override
  String get setdVaultEditCategoriesDesc =>
      'Aggiungi, rimuovi e riordina le categorie del vault';

  @override
  String get setdVaultSectionContents => 'Contenuti';

  @override
  String get setdVaultManageContents => 'Gestisci contenuti del Vault';

  @override
  String get setdVaultManageContentsDesc =>
      'Sposta manga, anime o novel dentro e fuori dal vault';

  @override
  String get setdVaultUnlockFirstSnack =>
      'Sblocca prima il vault (accedi dalla libreria)';

  @override
  String get setdVaultSectionHiddenSources => 'Fonti nascoste';

  @override
  String get setdVaultOnlySources => 'Fonti solo del Vault';

  @override
  String setdVaultHiddenSourcesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fonti nascoste',
      one: '1 fonte nascosta',
    );
    return '$_temp0';
  }

  @override
  String get setdVaultSectionInfo => 'Info';

  @override
  String get setdVaultInfoText =>
      'Il vault è una libreria nascosta con categorie e manga propri. Tocca rapidamente la scheda Libreria 8 volte per attivare/disattivare la modalità vault. I manga del vault vengono memorizzati separatamente e non compaiono mai nella tua libreria principale.';

  @override
  String get setdVaultCurrentPasswordHint => 'Password attuale';

  @override
  String get setdVaultNewPasswordHint =>
      'Nuova password (lascia vuoto per rimuovere)';

  @override
  String get setdVaultConfirmPasswordHint => 'Conferma nuova password';

  @override
  String get setdVaultCurrentPasswordWrong => 'La password attuale è errata';

  @override
  String get setdVaultPasswordsMismatch => 'Le password non corrispondono';

  @override
  String get setdVaultRemovingEncryption => 'Rimozione crittografia…';

  @override
  String get setdVaultEncrypting => 'Crittografia del vault…';

  @override
  String get setdVaultPasswordRemoved =>
      'Password rimossa — il vault non è più crittografato';

  @override
  String get setdVaultPasswordSet => 'Password impostata — vault crittografato';

  @override
  String get setdVaultNoCategories => 'Nessuna categoria del vault';

  @override
  String setdVaultDeleteCategoryConfirm(Object name) {
    return 'Vuoi davvero eliminare \"$name\"? I manga in questa categoria non verranno rimossi dal vault.';
  }

  @override
  String get setdVaultNoInstalledSources => 'Nessuna fonte installata';

  @override
  String get setdVaultHiddenSourcesToggleHint =>
      'Attiva/disattiva le fonti per renderle visibili solo in modalità vault.';

  @override
  String get setdVaultSearchSourcesHint => 'Cerca fonti...';

  @override
  String get setdCategoryNameHint => 'Nome categoria';

  @override
  String get setdNewCategory => 'Nuova categoria';

  @override
  String get setdRenameCategory => 'Rinomina categoria';

  @override
  String get setdDeleteCategory => 'Elimina categoria';

  @override
  String get setdActionCancel => 'Annulla';

  @override
  String get setdActionSave => 'Salva';

  @override
  String get setdActionAdd => 'Aggiungi';

  @override
  String get setdActionDelete => 'Elimina';

  @override
  String get setdTapToAddCategory => 'Tocca + per aggiungere una categoria';

  @override
  String get setdVaultContentsTitle => 'Contenuti del Vault';

  @override
  String get setdVaultContentsLockedMessage =>
      'Sblocca prima il vault per gestirne i contenuti.';

  @override
  String get setdVaultContentsTabManga => 'Manga';

  @override
  String get setdVaultContentsTabAnime => 'Anime';

  @override
  String get setdVaultContentsTabNovels => 'Novel';

  @override
  String setdVaultContentsEmptyLibrary(Object type) {
    return 'Nessun $type nella tua libreria';
  }

  @override
  String setdVaultContentsEmptyVault(Object type) {
    return 'Nessun $type nel vault';
  }

  @override
  String setdVaultContentsMovedIn(Object title) {
    return '\"$title\" spostato nel vault';
  }

  @override
  String setdVaultContentsMovedOut(Object title) {
    return '\"$title\" spostato fuori dal vault';
  }

  @override
  String setdVaultContentsReadProgress(Object read, Object total) {
    return '$read/$total letti';
  }

  @override
  String get setdLibraryTitle => 'Libreria';

  @override
  String get setdLibrarySectionCategories => 'Categorie';

  @override
  String get setdLibraryEditCategories => 'Modifica categorie';

  @override
  String get setdLibraryEditCategoriesDesc =>
      'Aggiungi, rimuovi e riordina le categorie';

  @override
  String get setdLibraryHideEmpty => 'Nascondi categorie vuote';

  @override
  String get setdLibraryHideEmptyDesc => 'Mostra solo le categorie con manga';

  @override
  String get setdLibrarySectionGlobalUpdate => 'Aggiornamento globale';

  @override
  String get setdLibraryUpdateFrequency => 'Frequenza di aggiornamento';

  @override
  String get setdLibraryWifiOnly => 'Solo Wi-Fi';

  @override
  String get setdLibraryWifiOnlyDesc => 'Aggiorna solo con connessioni Wi-Fi';

  @override
  String get setdLibraryChargingOnly => 'Solo in carica';

  @override
  String get setdLibraryChargingOnlyDesc =>
      'Aggiorna solo quando il dispositivo è in carica';

  @override
  String get setdLibrarySectionRestrictions => 'Restrizioni di aggiornamento';

  @override
  String get setdLibrarySkipNotStarted => 'Salta i non iniziati';

  @override
  String get setdLibrarySkipNotStartedDesc =>
      'Salta i manga senza progresso di lettura';

  @override
  String get setdLibraryShowUpdateCount => 'Mostra numero di nuovi capitoli';

  @override
  String get setdLibraryShowUpdateCountDesc =>
      'Mostra un badge sulle schede dei manga in libreria';

  @override
  String get setdLibrarySectionData => 'Dati';

  @override
  String get setdLibraryMigrateSource => 'Migra una fonte';

  @override
  String get setdLibraryMigrateSourceDesc =>
      'Sposta ogni elemento da una fonte a un\'altra';

  @override
  String get setdLibraryNoCategories => 'Nessuna categoria';

  @override
  String setdLibraryDeleteCategoryConfirm(Object name) {
    return 'Vuoi davvero eliminare \"$name\"? I manga in questa categoria non verranno rimossi dalla tua libreria.';
  }

  @override
  String get setdPlayerTitle => 'Player';

  @override
  String get setdPlayerSectionSeek => 'DOPPIO TOCCO PER AVANZARE';

  @override
  String get setdPlayerSkipForward => 'Salta avanti';

  @override
  String get setdPlayerSkipBackward => 'Salta indietro';

  @override
  String get setdPlayerSectionGestures => 'GESTI';

  @override
  String get setdPlayerHoldToSpeed => 'Tieni premuto per accelerare';

  @override
  String setdPlayerHoldToSpeedDesc(Object speed) {
    return 'Tieni premuto ovunque per riprodurre a ${speed}x';
  }

  @override
  String get setdPlayerHoldSpeed => 'Velocità con pressione prolungata';

  @override
  String get setdPlayerVolumeSwipe => 'Scorrimento volume';

  @override
  String get setdPlayerVolumeSwipeDesc =>
      'Scorri su/giù sulla metà destra per regolare il volume';

  @override
  String get setdPlayerBrightnessSwipe => 'Scorrimento luminosità';

  @override
  String get setdPlayerBrightnessSwipeDesc =>
      'Scorri su/giù sulla metà sinistra per regolare la luminosità';

  @override
  String get setdPlayerSectionPlayback => 'RIPRODUZIONE';

  @override
  String get setdPlayerDefaultSpeed => 'Velocità predefinita';

  @override
  String get setdPlayerAutoplayNext =>
      'Riproduci automaticamente l\'episodio successivo';

  @override
  String get setdPlayerAutoplayNextDesc =>
      'Avvia automaticamente l\'episodio successivo al termine di uno';

  @override
  String get setdPlayerAutoSkipIntro => 'Salta automaticamente intro/finale';

  @override
  String get setdPlayerAutoSkipIntroDesc =>
      'Salta le sigle di apertura/chiusura contrassegnate dalla fonte senza toccare';

  @override
  String get setdPlayerSkipAmountTitle => 'Durata del salto';

  @override
  String get setdPlayerShowSkipButton => 'Skip-intro button';

  @override
  String get setdPlayerShowSkipButtonDesc =>
      'Show a Skip Intro button near the start, even when the source has no markers';

  @override
  String get setdPlayerSpeedTitle => 'Velocità';

  @override
  String get setdAppearanceTitle => 'Aspetto';

  @override
  String get setdAppearanceSectionTheme => 'Tema';

  @override
  String get setdAppearanceSectionDisplay => 'Visualizzazione';

  @override
  String get setdAppearanceInvertColors => 'Inverti colori';

  @override
  String get setdAppearanceInvertColorsDesc =>
      'Inverte l\'intera interfaccia dell\'app';

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
  String get setdAppearanceDarkMode => 'Modalità scura';

  @override
  String get setdAppearanceLightMode => 'Modalità chiara';

  @override
  String get setdAppearanceCurrentlyDark => 'Attualmente scura';

  @override
  String get setdAppearanceCurrentlyLight => 'Attualmente chiara';

  @override
  String get detailStatusOngoing => 'In corso';

  @override
  String get detailStatusCompleted => 'Completato';

  @override
  String get detailStatusHiatus => 'In pausa';

  @override
  String get detailStatusCanceled => 'Cancellato';

  @override
  String get detailStatusFinished => 'Concluso';

  @override
  String get detailStatusUnknown => 'Sconosciuto';

  @override
  String detailChapterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capitoli',
      one: '1 capitolo',
    );
    return '$_temp0';
  }

  @override
  String detailEpisodeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count episodi',
      one: '1 episodio',
    );
    return '$_temp0';
  }

  @override
  String detailDownloadingChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Download di $count capitoli',
      one: 'Download di 1 capitolo',
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
