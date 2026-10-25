// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Foxlations';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsSectionApp => 'App';

  @override
  String get settingsSectionManga => 'Manga';

  @override
  String get settingsSectionSystem => 'System';

  @override
  String get settingsLanguageTitle => 'Sprache';

  @override
  String get settingsLanguageEntrySubtitle => 'Anzeigesprache der App';

  @override
  String get settingsLanguageSubtitle => 'Wähle deine App-Sprache';

  @override
  String get settingsLanguageSystemDefault => 'Systemstandard';

  @override
  String get settingsLanguageHeader => 'App-Sprache';

  @override
  String get settingsAppearanceTitle => 'Darstellung';

  @override
  String get settingsAppearanceSubtitle => 'Design, Dunkelmodus, Anzeige';

  @override
  String get settingsNotificationsTitle => 'Benachrichtigungen';

  @override
  String get settingsNotificationsSubtitle =>
      'Push-Hinweise, Häufigkeit, Erinnerungen';

  @override
  String get settingsStorageTitle => 'Speicher';

  @override
  String get settingsStorageSubtitle =>
      'Downloads, Ordnerpfade, Synchronisierung';

  @override
  String get settingsLibraryTitle => 'Bibliothek';

  @override
  String get settingsLibrarySubtitle => 'Kategorien, globales Update, Anzeige';

  @override
  String get settingsReaderTitle => 'Reader';

  @override
  String get settingsReaderSubtitle => 'Lesemodus, Anzeige, Navigation';

  @override
  String get settingsPlayerTitle => 'Player';

  @override
  String get settingsPlayerSubtitle =>
      'Spulen, Gesten, Geschwindigkeit, Autoplay';

  @override
  String get settingsDownloadsTitle => 'Downloads';

  @override
  String get settingsDownloadsSubtitle =>
      'Automatische Downloads, Kapitel löschen';

  @override
  String get settingsTrackingTitle => 'Tracking';

  @override
  String get settingsTrackingSubtitle => 'MAL, AniList, Kitsu und mehr';

  @override
  String get settingsAiTitle => 'KI & Übersetzung';

  @override
  String get settingsAiSubtitle =>
      'Anbieter, API-Schlüssel, Sprechblasenerkennung';

  @override
  String get settingsBrowseTitle => 'Durchsuchen';

  @override
  String get settingsBrowseSubtitle => 'Quellen, Erweiterungen, globale Suche';

  @override
  String get settingsBackupTitle => 'Sichern & Wiederherstellen';

  @override
  String get settingsBackupSubtitle =>
      'Backups erstellen/wiederherstellen, importieren, Auto-Backup';

  @override
  String get settingsSecurityTitle => 'Sicherheit & Datenschutz';

  @override
  String get settingsSecuritySubtitle =>
      'App-Sperre, Biometrie, Bildschirmschutz';

  @override
  String get settingsAdvancedTitle => 'Erweitert';

  @override
  String get settingsAdvancedSubtitle =>
      'Netzwerk, Erweiterungen, Protokollierung, Daten';

  @override
  String get settingsAboutTitle => 'Über';

  @override
  String get settingsAboutSubtitle => 'Version, Lizenzen, Links';

  @override
  String get libraryAdd => 'Hinzufügen';

  @override
  String get libraryAddAnime => 'Anime hinzufügen';

  @override
  String get libraryAddLNs => 'LNs hinzufügen';

  @override
  String get libraryAddManga => 'Manga hinzufügen';

  @override
  String get libraryBadges => 'Badges';

  @override
  String get libraryBatchMigrate => 'Migrieren';

  @override
  String get libraryBatchMove => 'Verschieben';

  @override
  String get libraryBatchRead => 'Gelesen';

  @override
  String get libraryBatchRemove => 'Entfernen';

  @override
  String get libraryBatchUnread => 'Ungelesen';

  @override
  String get libraryCategoryUpdate => 'Kategorie aktualisieren';

  @override
  String libraryCategoryUpdateDesc(Object category) {
    return '„$category“ auf neue Kapitel prüfen';
  }

  @override
  String libraryChapterProgress(Object read, Object total) {
    return 'Kap. $read/$total';
  }

  @override
  String libraryEpisodeProgress(Object read, Object total) {
    return 'Ep. $read/$total';
  }

  @override
  String libraryChaptersAbbrev(Object n) {
    return '$n Kap.';
  }

  @override
  String get libraryCheckForUpdates => 'Nach Updates suchen';

  @override
  String get libraryClose => 'Schließen';

  @override
  String get libraryCloseSearch => 'Suche schließen';

  @override
  String get libraryCompleted => 'Abgeschlossen';

  @override
  String get libraryContinueReading => 'Weiterlesen';

  @override
  String get libraryContinueWatching => 'Weiterschauen';

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
    return '$days Tage';
  }

  @override
  String get libraryDeselectAll => 'Auswahl aufheben';

  @override
  String get libraryDisplayMode => 'Anzeigemodus';

  @override
  String get libraryDownloaded => 'Heruntergeladen';

  @override
  String get libraryEmpty => 'Bibliothek ist leer';

  @override
  String get libraryEmptyDesc =>
      'Deine Bibliothek ist leer. Durchsuche Quellen, um Manga hinzuzufügen.';

  @override
  String libraryEmptyStatsLibrary(Object word) {
    return 'Füge $word zu deiner Bibliothek hinzu und beginne zu lesen, um hier deine Statistiken zu sehen.';
  }

  @override
  String libraryEmptyStatsVault(Object word) {
    return 'Füge $word zu deinem Tresor hinzu und beginne zu lesen, um hier Statistiken zu sehen.';
  }

  @override
  String get libraryFilterSortDisplay => 'Filtern, sortieren & anzeigen';

  @override
  String get libraryGlobalUpdate => 'Globales Update';

  @override
  String get libraryGlobalUpdateDesc =>
      'Jeden Eintrag in deiner Bibliothek prüfen';

  @override
  String get libraryHeatmapLess => 'Weniger';

  @override
  String get libraryHeatmapMore => 'Mehr';

  @override
  String get libraryItemsPerRow => 'Einträge pro Zeile';

  @override
  String libraryLastChecked(Object when) {
    return 'Zuletzt geprüft: $when';
  }

  @override
  String get libraryLibrary => 'Bibliothek';

  @override
  String libraryListChapters(Object read, Object total) {
    return '$read/$total Kapitel';
  }

  @override
  String get libraryMore => 'Mehr';

  @override
  String get libraryMoveToCategory => 'In Kategorie verschieben';

  @override
  String get libraryNever => 'nie';

  @override
  String get libraryNoBookmarks => 'Noch keine Lesezeichen';

  @override
  String get libraryNoBookmarksDesc =>
      'Halte einen Manga gedrückt und setze ein Lesezeichen, um ihn hier zu sehen.';

  @override
  String get libraryNoNewChaptersLastCheck =>
      'Bei der letzten Prüfung wurden keine neuen Kapitel gefunden.';

  @override
  String get libraryNoResults => 'Keine Ergebnisse';

  @override
  String libraryNoResultsDesc(Object query) {
    return 'Keine Ergebnisse für „$query“. Versuche eine andere Suche.';
  }

  @override
  String get libraryNoStatsYet => 'Noch keine Statistiken';

  @override
  String get libraryOpenRandomEntry => 'Zufälligen Eintrag öffnen';

  @override
  String get libraryResetToDefault => 'Auf Standard zurücksetzen';

  @override
  String get librarySave => 'Speichern';

  @override
  String get librarySearchHint => 'In Bibliothek suchen...';

  @override
  String get librarySearchLibrary => 'Bibliothek durchsuchen';

  @override
  String get librarySelect => 'Auswählen';

  @override
  String get librarySelectAll => 'Alle auswählen';

  @override
  String librarySelectedCount(Object n) {
    return '$n ausgewählt';
  }

  @override
  String get libraryShowNumberOfItems => 'Anzahl der Einträge anzeigen';

  @override
  String get librarySizeMedium => 'Mittel';

  @override
  String get librarySources => 'Quellen';

  @override
  String get libraryStats => 'Statistiken';

  @override
  String get libraryStatusAll => 'Alle';

  @override
  String get libraryStatusCompleted => 'Abgeschlossen';

  @override
  String get libraryStatusDropped => 'Abgebrochen';

  @override
  String get libraryStatusOnHold => 'Pausiert';

  @override
  String get libraryStatusPlanToRead => 'Geplant';

  @override
  String get libraryStatusReading => 'Wird gelesen';

  @override
  String get libraryStatusUnknown => 'Unbekannt';

  @override
  String libraryStreakDaysStrong(Object days) {
    return '$days Tage in Folge — weiter so!';
  }

  @override
  String get libraryTabDisplay => 'Anzeige';

  @override
  String get libraryTabFilter => 'Filter';

  @override
  String get libraryTabSort => 'Sortieren';

  @override
  String get libraryTabs => 'Tabs';

  @override
  String libraryTotalAbbrev(Object n) {
    return '$n gesamt';
  }

  @override
  String get libraryTypeMenuBarrier => 'Library type';

  @override
  String libraryTypeBreakdown(Object type) {
    return '$type-Aufschlüsselung';
  }

  @override
  String get libraryUnread => 'Ungelesen';

  @override
  String get libraryUpdatesSummary => 'Update-Zusammenfassung';

  @override
  String get libraryUpdatesSummaryDesc => 'Was die letzte Prüfung ergeben hat';

  @override
  String get libraryVault => 'Tresor';

  @override
  String get libraryVaultStats => 'Tresor-Statistiken';

  @override
  String get detailAdd => 'Hinzufügen';

  @override
  String get detailAddNoteHint => 'Notiz für diesen Titel hinzufügen…';

  @override
  String get detailAddToCategory => 'Zu Kategorie hinzufügen';

  @override
  String get detailAddToLibrary => 'Zur Bibliothek hinzufügen';

  @override
  String get detailAddWithoutCategory => 'Ohne Kategorie hinzufügen';

  @override
  String get detailBelowRead => 'Darunter gelesen';

  @override
  String get detailBelowUnread => 'Darunter ungelesen';

  @override
  String get detailBookmark => 'Lesezeichen';

  @override
  String get detailBookmarked => 'Mit Lesezeichen';

  @override
  String get detailCancel => 'Abbrechen';

  @override
  String get detailChapterFallback => 'Kapitel';

  @override
  String detailCopiedTo(Object source) {
    return 'Nach $source kopiert';
  }

  @override
  String detailCountSelected(Object count) {
    return '$count ausgewählt';
  }

  @override
  String get detailDeleteDownload => 'Download löschen';

  @override
  String get detailDone => 'Fertig';

  @override
  String get detailDownload => 'Herunterladen';

  @override
  String get detailDownloadAllChapters => 'Alle Kapitel';

  @override
  String get detailDownloadAllUnread => 'Alle ungelesenen';

  @override
  String get detailDownloaded => 'Heruntergeladen';

  @override
  String get detailDownloadNext10 => 'Nächste 10 Kapitel';

  @override
  String get detailDownloadNext5 => 'Nächste 5 Kapitel';

  @override
  String get detailDownloadNextChapter => 'Nächstes Kapitel';

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
  String get detailEditCategories => 'Kategorien bearbeiten';

  @override
  String get detailEditCategoriesTitle => 'Kategorien bearbeiten';

  @override
  String get detailFilter => 'Filter';

  @override
  String get detailInProgress => 'Angefangen';

  @override
  String get detailLogIn => 'Anmelden';

  @override
  String get detailMangaNotFound => 'Manga nicht in der Bibliothek gefunden';

  @override
  String get detailMarkAllAsRead => 'Alle als gelesen markieren';

  @override
  String get detailMarkAllAsUnread => 'Alle als ungelesen markieren';

  @override
  String get detailMarkAllBelowRead => 'Alle darunter als gelesen markieren';

  @override
  String get detailMarkAsUnread => 'Als ungelesen markieren';

  @override
  String get detailMarkChapterAsRead => 'Kapitel als gelesen markieren';

  @override
  String get detailMarkRead => 'Als gelesen markieren';

  @override
  String get detailMarkUnread => 'Als ungelesen markieren';

  @override
  String get detailMigrate => 'Migrieren';

  @override
  String get detailMigrateCategories => 'Kategorien';

  @override
  String get detailMigrateChapters => 'Kapitel';

  @override
  String get detailMigrateCopy => 'Kopieren';

  @override
  String get detailMigrateDownloadsNoTransfer =>
      'Heruntergeladene Kapitel werden nicht übertragen.';

  @override
  String detailMigratedTo(Object source) {
    return 'Nach $source migriert';
  }

  @override
  String detailMigrateEntriesToSource(Object count, Object source) {
    return '$count Einträge → $source';
  }

  @override
  String get detailMigrateInfo =>
      'Wähle denselben Manga aus einer anderen Quelle. Der Lesefortschritt wird übertragen.';

  @override
  String get detailMigrateRemoveDownloads =>
      'Downloads beim Migrieren entfernen';

  @override
  String get detailMigrateSelectData => 'Zu übernehmende Daten auswählen';

  @override
  String get detailMigrateShowEntry => 'Eintrag anzeigen';

  @override
  String detailMigrateTitleToSource(Object title, Object source) {
    return '$title → $source';
  }

  @override
  String get detailMigrateTracking => 'Tracking';

  @override
  String get detailMigrating => 'Wird migriert…';

  @override
  String get detailNewestFirst => 'Neueste zuerst';

  @override
  String get detailNoChaptersFound => 'Keine Kapitel gefunden';

  @override
  String get detailNoChaptersLoginHint =>
      'Für diesen Titel wurde nichts geladen. Versuche es erneut – bei dieser Quelle kann eine Anmeldung manchmal mehr freischalten.';

  @override
  String get detailNoChaptersRetryHint =>
      'Für diesen Titel wurde nichts geladen. Vielleicht gibt es noch keine, oder die Quelle hatte Probleme beim Laden. Versuche es erneut.';

  @override
  String get detailNoResults => 'Keine Ergebnisse gefunden';

  @override
  String get detailNotes => 'Notizen';

  @override
  String get detailNothingToDownload => 'Nichts zum Herunterladen';

  @override
  String get detailOldestFirst => 'Älteste zuerst';

  @override
  String get detailOpenInBrowser => 'Im Browser öffnen';

  @override
  String get webviewOpenFailed => 'Couldn\'t open the browser';

  @override
  String detailPage(Object page) {
    return 'Seite $page';
  }

  @override
  String get detailRefresh => 'Aktualisieren';

  @override
  String get detailRemove => 'Entfernen';

  @override
  String get detailRemoveBookmark => 'Lesezeichen entfernen';

  @override
  String get detailRemoveFromLibrary => 'Aus Bibliothek entfernen';

  @override
  String get detailRemoveFromLibraryTitle => 'Aus Bibliothek entfernen?';

  @override
  String get detailResume => 'Fortsetzen';

  @override
  String get detailRetry => 'Erneut versuchen';

  @override
  String get detailSave => 'Speichern';

  @override
  String get detailSearchChapters => 'Kapitel durchsuchen';

  @override
  String get detailSearchChaptersHint => 'Kapitel durchsuchen...';

  @override
  String get detailSearchEpisodes => 'Episoden durchsuchen';

  @override
  String get detailSearchHint => 'Manga-Titel suchen...';

  @override
  String get detailSearchingSources => 'Quellen werden durchsucht…';

  @override
  String get detailSelectAll => 'Alle auswählen';

  @override
  String get detailSelectChapters => 'Kapitel auswählen';

  @override
  String get detailTracking => 'Tracking';

  @override
  String get detailUnbookmark => 'Lesezeichen entfernen';

  @override
  String get detailUnread => 'Ungelesen';

  @override
  String get detailWebView => 'WebView';

  @override
  String get appNavLibrary => 'Bibliothek';

  @override
  String get appNavUpdates => 'Updates';

  @override
  String get appNavBrowse => 'Durchsuchen';

  @override
  String get appNavDiscover => 'Discover';

  @override
  String get appNavMore => 'Mehr';

  @override
  String get appNavVault => 'Tresor';

  @override
  String get appUpdatesTitle => 'Updates';

  @override
  String get appNoNewChapters => 'Keine neuen Kapitel';

  @override
  String get appCheckForUpdates => 'Nach Updates suchen';

  @override
  String get appClearAll => 'Alle löschen';

  @override
  String appCheckingProgress(Object checked, Object total) {
    return 'Prüfe $checked / $total...';
  }

  @override
  String appLastChecked(Object time) {
    return 'Zuletzt geprüft: $time';
  }

  @override
  String get appNoUpdatesYet => 'Noch keine Updates';

  @override
  String get appTapRefreshForChapters =>
      'Tippe auf Aktualisieren, um nach neuen Kapiteln zu suchen';

  @override
  String get appCheckNow => 'Jetzt prüfen';

  @override
  String get appJustNow => 'Gerade eben';

  @override
  String appMinutesAgo(Object m) {
    return 'vor $m Min.';
  }

  @override
  String appHoursAgo(Object h) {
    return 'vor $h Std.';
  }

  @override
  String appDaysAgo(Object d) {
    return 'vor $d T.';
  }

  @override
  String get appToday => 'HEUTE';

  @override
  String get appYesterday => 'GESTERN';

  @override
  String get appOnLatestVersion => 'Du hast die neueste Version';

  @override
  String get appUpdateAvailable => 'Update verfügbar';

  @override
  String appVersionBuild(Object version, Object build) {
    return 'v$version · Build $build';
  }

  @override
  String get appDownloadUpdate => 'Update herunterladen';

  @override
  String appDownloadVersion(Object version) {
    return 'v$version herunterladen';
  }

  @override
  String get appApkDownloadHint =>
      'Öffnet den APK-Download. Android fragt dich, ob du die Installation bestätigst.';

  @override
  String get appIosUpdateHint =>
      'Aktualisiere über AltStore oder SideStore – öffne die App und aktualisiere. iOS kann keine im Browser heruntergeladene App installieren.';

  @override
  String get appSourceUrlCopied =>
      'Quell-URL kopiert – füge sie in AltStore hinzu';

  @override
  String get appCopyAltstoreUrl => 'AltStore-Quell-URL kopieren';

  @override
  String get appBack => 'Zurück';

  @override
  String get appForward => 'Vorwärts';

  @override
  String get appReload => 'Neu laden';

  @override
  String get appDoneSaveCookies => 'Fertig – Cookies speichern';

  @override
  String get appVaultPassword => 'Tresor-Passwort';

  @override
  String get appEnterPassword => 'Passwort eingeben';

  @override
  String get appWrongPassword => 'Falsches Passwort';

  @override
  String get appCancel => 'Abbrechen';

  @override
  String get appUnlock => 'Entsperren';

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
  String get readerExperimentalOnIos => 'Experimentell unter iOS';

  @override
  String get readerIosVolumeWarning =>
      'iOS bietet keine echte Lautstärketasten-API, daher funktioniert dies über die Beobachtung der Systemlautstärke – das kann fehleranfällig sein. Während des Lesens wird die Lautstärke von allem, was du hörst (Musik, Podcast), bei 50 % gehalten und kann nicht geändert werden. Trotzdem aktivieren?';

  @override
  String get readerCancel => 'Abbrechen';

  @override
  String get readerEnable => 'Aktivieren';

  @override
  String get readerTitle => 'Reader';

  @override
  String get readerPreferences => 'Einstellungen';

  @override
  String get readerReadingMode => 'Lesemodus';

  @override
  String get readerFontSize => 'Schriftgröße';

  @override
  String get readerAutoPreloadNextChapter =>
      'Nächstes Kapitel automatisch vorladen';

  @override
  String get readerAutoPreloadNextChapterSubtitle =>
      'Nächstes Kapitel im Hintergrund laden';

  @override
  String get readerGrayscale => 'Graustufen';

  @override
  String get readerGrayscaleSubtitle => 'Seiten in Graustufen anzeigen';

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
  String get readerInvertColors => 'Farben invertieren';

  @override
  String get readerInvertColorsSubtitle => 'Helle und dunkle Farben tauschen';

  @override
  String get readerDisplay => 'Anzeige';

  @override
  String get readerScaleType => 'Skalierungstyp';

  @override
  String get readerBackgroundColor => 'Hintergrundfarbe';

  @override
  String get readerKeepScreenOn => 'Bildschirm anlassen';

  @override
  String get readerKeepScreenOnSubtitle =>
      'Verhindert, dass der Bildschirm in den Ruhezustand geht';

  @override
  String get readerShowPageNumber => 'Seitenzahl anzeigen';

  @override
  String get readerShowPageNumberSubtitle => 'Seitenanzeige einblenden';

  @override
  String get readerFullscreen => 'Vollbild';

  @override
  String get readerFullscreenSubtitle => 'Systemleisten beim Lesen ausblenden';

  @override
  String get readerNavigation => 'Navigation';

  @override
  String get readerNavigationLayout => 'Navigations-Layout';

  @override
  String get readerInvertTapZones => 'Tippzonen invertieren';

  @override
  String get readerInvertTapZonesSubtitle =>
      'Links/rechts-Tippnavigation tauschen';

  @override
  String get readerVolumeKeys => 'Lautstärketasten';

  @override
  String get readerVolumeKeysSubtitle =>
      'Tippen zum Umblättern/Scrollen; Halten zum Scrollen (Webtoon)';

  @override
  String get readerHoldScrollSpeed => 'Halte-Scroll-Geschwindigkeit';

  @override
  String get readerSourceNotInstalled => 'Quelle nicht installiert';

  @override
  String get readerSourceNotInstalledHint =>
      'This title\'s source isn\'t installed — this can happen after restoring a backup. Install it from Extensions, then try again.';

  @override
  String get readerTranslating => 'Wird übersetzt…';

  @override
  String get readerRetry => 'Erneut versuchen';

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
  String get readerLoadingNextChapter => 'Nächstes Kapitel wird geladen...';

  @override
  String get readerAllCaughtUp => 'Du bist auf dem neuesten Stand!';

  @override
  String get readerEndOfChapter => 'Ende des Kapitels';

  @override
  String get readerLatestChapterAvailable =>
      'Dies ist das neueste verfügbare Kapitel.';

  @override
  String get readerLoadNextChapter => 'Nächstes Kapitel laden';

  @override
  String get readerBack => 'Zurück';

  @override
  String get readerSettings => 'Einstellungen';

  @override
  String get readerAiTranslate => 'KI-Übersetzung';

  @override
  String get readerPreviousChapter => 'Vorheriges Kapitel';

  @override
  String get readerBookmark => 'Lesezeichen';

  @override
  String get readerNextChapter => 'Nächstes Kapitel';

  @override
  String readerTranslationFailed(Object error) {
    return 'Übersetzung fehlgeschlagen: $error';
  }

  @override
  String get readerModeLtrLabel => 'Links nach rechts';

  @override
  String get readerModeRtlLabel => 'Rechts nach links';

  @override
  String get readerModeVerticalLabel => 'Fortlaufendes Scrollen';

  @override
  String get readerModeWebtoonLabel => 'Webtoon';

  @override
  String get readerModeLtrSubtitle => 'Zum Umblättern links/rechts tippen';

  @override
  String get readerModeRtlSubtitle => 'Manga-Stil, rechts nach links';

  @override
  String get readerModeVerticalSubtitle => 'Vertikal durch die Seiten scrollen';

  @override
  String get readerModeWebtoonSubtitle =>
      'Optimiert für lange vertikale Streifen';

  @override
  String get readerChapters => 'Kapitel';

  @override
  String readerPageOf(int current, int total) {
    return 'Seite $current von $total';
  }

  @override
  String get readerTabProvider => 'Anbieter';

  @override
  String get readerTabTarget => 'Ziel';

  @override
  String get readerTabSource => 'Quelle';

  @override
  String get readerTabFont => 'Schrift';

  @override
  String get readerFontNormal => 'Normal';

  @override
  String get readerFontManga => 'Manga';

  @override
  String get readerFontNormalDesc => 'Klare serifenlose Schrift';

  @override
  String get readerFontMangaDesc => 'Fetter Comic-Stil';

  @override
  String get readerFontSample => 'Hallo Welt';

  @override
  String get readerNoChapterText => 'Kein Kapiteltext gefunden';

  @override
  String get readerReadingTitle => 'Wird gelesen';

  @override
  String get readerSmallerText => 'Kleinerer Text';

  @override
  String get readerLargerText => 'Größerer Text';

  @override
  String get readerPrevious => 'Zurück';

  @override
  String get readerNext => 'Weiter';

  @override
  String get browseTitle => 'Durchsuchen';

  @override
  String get browseGlobalSearch => 'Globale Suche';

  @override
  String get browseRefreshingRepos => 'Repos werden aktualisiert...';

  @override
  String get browseRefreshRepos => 'Repos aktualisieren';

  @override
  String get browseSearch => 'Suchen';

  @override
  String get browseAddRepo => 'Repo hinzufügen';

  @override
  String get browseTabSources => 'Quellen';

  @override
  String get browseTabExtensions => 'Erweiterungen';

  @override
  String get browseTabLocal => 'Lokal';

  @override
  String get browseSearchHint => 'Erweiterungen & Quellen suchen...';

  @override
  String browseRemoveSourceConfirm(Object name) {
    return '$name entfernen?';
  }

  @override
  String get browseRemoveSourceDesc =>
      'Die Quelle wird deinstalliert. Deine Bibliothekseinträge daraus bleiben erhalten, aber du kannst sie erst wieder öffnen, wenn du sie neu installierst.';

  @override
  String get browseCancel => 'Abbrechen';

  @override
  String get browseRemove => 'Entfernen';

  @override
  String get browseProvidedByThisSource => 'VON DIESER QUELLE BEREITGESTELLT';

  @override
  String get browseCouldNotLoadOptions =>
      'Die Optionen der Quelle konnten nicht geladen werden';

  @override
  String get browseNoSourceOptions =>
      'Diese Quelle definiert keine eigenen Optionen. Die obigen Einstellungen gelten dennoch für sie.';

  @override
  String get browseBaseUrl => 'Basis-URL';

  @override
  String get browseUsingSourceDefault => 'Standard der Quelle wird verwendet';

  @override
  String browseBaseUrlDefault(Object url) {
    return '$url  (Standard)';
  }

  @override
  String get browseResetToDefault => 'Auf Standard zurücksetzen';

  @override
  String get browsePinToTop => 'Nach oben anheften';

  @override
  String get browsePinToTopDesc =>
      'Diese Quelle zuerst in der Quellenliste anzeigen';

  @override
  String get browseSkipGlobalSearch => 'Bei globaler Suche überspringen';

  @override
  String get browseSkipGlobalSearchDesc =>
      'Diese Quelle bei der Suche über alles auslassen';

  @override
  String get browseSkipLibraryUpdates => 'Bei Bibliotheks-Updates überspringen';

  @override
  String get browseSkipLibraryUpdatesDesc =>
      'Diese Quelle nicht auf neue Kapitel prüfen';

  @override
  String get browseRequestDesktopSite => 'Desktop-Website anfordern';

  @override
  String get browseRequestDesktopSiteDesc =>
      'Versuche dies, wenn die Quelle nichts findet oder keine Kapitel anzeigt – manche Websites senden Handys eine abgespeckte Seite';

  @override
  String get browseSave => 'Speichern';

  @override
  String get browseNone => 'Keine';

  @override
  String browseSelectedCount(Object count) {
    return '$count ausgewählt';
  }

  @override
  String get browseNotSet => 'Nicht festgelegt';

  @override
  String get browseIosFolderWarning =>
      'iOS erlaubt Apps nicht, den Zugriff auf einen Ordner zu behalten. Verwende stattdessen „Datei importieren“, um .cbz/.cbr/.zip/.epub/.pdf hinzuzufügen.';

  @override
  String browseImportedFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dateien importiert',
      one: '1 Datei importiert',
    );
    return '$_temp0';
  }

  @override
  String get browseNothingImported =>
      'Nichts importiert (nicht unterstützt oder nicht lesbar)';

  @override
  String browseFolderCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ordner',
      one: '1 Ordner',
    );
    return '$_temp0';
  }

  @override
  String get browseManageFolders => 'Ordner verwalten';

  @override
  String get browseImportFileTooltip => 'Datei importieren (CBZ/ZIP/EPUB/PDF)';

  @override
  String get browseAddFolder => 'Ordner hinzufügen';

  @override
  String get browseRescan => 'Neu scannen';

  @override
  String get browseNothingImportedYet => 'Noch nichts importiert';

  @override
  String get browseNoLocalSources => 'Keine lokalen Quellen';

  @override
  String get browseLocalSourcesDesc =>
      'Füge einen Manga-Ordner hinzu oder importiere eine einzelne Datei.\nUnterstützt: Bilder (JPG, PNG, WebP, GIF), CBZ/ZIP, EPUB und PDF.\n(CBR/RAR nur, wenn die Datei tatsächlich ZIP-gepackt ist – echtes RAR wird nicht unterstützt.)';

  @override
  String get browseAddFolderButton => 'Ordner hinzufügen';

  @override
  String get browseImportFile => 'Datei importieren';

  @override
  String get browseLocalSourceFolders => 'Lokale Quellordner';

  @override
  String get browseNoFoldersAdded => 'Keine Ordner hinzugefügt';

  @override
  String browseChaptersAbbrev(Object n) {
    return '$n Kap.';
  }

  @override
  String get browseInstalled => 'INSTALLIERT';

  @override
  String get browseAvailable => 'VERFÜGBAR';

  @override
  String get browseSourceNotInstalled => 'Quelle ist nicht installiert';

  @override
  String get browseManga => 'Manga';

  @override
  String get browseAnime => 'Anime';

  @override
  String get browseNovels => 'Novels';

  @override
  String get browseAllLanguages => 'Alle Sprachen';

  @override
  String get browseFilter => 'Filter';

  @override
  String browseLanguagesCount(Object count) {
    return '$count Sprachen';
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
      other: '$count Ergebnisse',
      one: '1 Ergebnis',
    );
    return '$_temp0';
  }

  @override
  String get browseNoExtensions => 'Noch keine Erweiterungen';

  @override
  String get browseNoExtensionsDesc =>
      'Füge über den Einstellungsknopf oben\nein Repository hinzu, um Erweiterungen zu durchsuchen.';

  @override
  String browseUpdatedSources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Quellen aktualisiert',
      one: '1 Quelle aktualisiert',
    );
    return '$_temp0';
  }

  @override
  String get browseSourceUpdated => 'Quelle aktualisiert';

  @override
  String get browseNoUpdateAvailable => 'Kein Update verfügbar';

  @override
  String browseUpdateFailed(Object error) {
    return 'Update fehlgeschlagen: $error';
  }

  @override
  String browseRefreshFailed(Object error) {
    return 'Aktualisierung fehlgeschlagen: $error';
  }

  @override
  String browseUpdatesAvailable(Object count) {
    return 'UPDATES VERFÜGBAR ($count)';
  }

  @override
  String get browseUpdateAll => 'Alle aktualisieren';

  @override
  String get browseUpdate => 'Aktualisieren';

  @override
  String get browseSettings => 'Einstellungen';

  @override
  String get browseInstall => 'Installieren';

  @override
  String get browseInstalledBadge => 'Installiert';

  @override
  String get browseAbout => 'ÜBER';

  @override
  String browseSourceFrom(Object url) {
    return 'Quelle von $url';
  }

  @override
  String browseLanguageLabel(Object lang) {
    return 'Sprache: $lang';
  }

  @override
  String get browseUsesCloudflare => 'Nutzt Cloudflare-Schutz';

  @override
  String get browseNoCloudflare => 'Kein Cloudflare';

  @override
  String get browseAdultContent => '18+ Inhalte';

  @override
  String get browseSafeForWork => 'Jugendfrei';

  @override
  String get browseFeatures => 'FUNKTIONEN';

  @override
  String get browsePopular => 'Beliebt';

  @override
  String get browseLatest => 'Neueste';

  @override
  String browseSourceAction(Object name) {
    return '$name durchsuchen';
  }

  @override
  String get browseRemoving => 'Wird entfernt...';

  @override
  String get browseInstalling => 'Wird installiert...';

  @override
  String browseFailed(Object error) {
    return 'Fehlgeschlagen: $error';
  }

  @override
  String get browseNoLanguagesMatch => 'No languages match';

  @override
  String get browseYourLanguages => 'Your languages';

  @override
  String get browseSearchLanguages => 'Search languages';

  @override
  String get browseUpdating => 'Wird aktualisiert...';

  @override
  String get browseUpdateExtensionCode => 'Erweiterungscode aktualisieren';

  @override
  String browseUpdatedSource(Object name) {
    return '$name aktualisiert';
  }

  @override
  String get browsePinned => 'ANGEHEFTET';

  @override
  String get browseAll => 'Alle';

  @override
  String get browseNoInstalledSources => 'Keine installierten Quellen';

  @override
  String get browseNoInstalledSourcesDesc =>
      'Installiere Erweiterungen über den Tab „Erweiterungen“,\num hier Quellen zu sehen.';

  @override
  String get browseUnpin => 'Lösen';

  @override
  String get browsePin => 'Anheften';

  @override
  String get browseSourceNotInstalledBody => 'Quelle nicht installiert';

  @override
  String get browseBypassingCloudflare => 'Cloudflare-Schutz wird umgangen...';

  @override
  String get browseOpenInWebView => 'In WebView öffnen';

  @override
  String get browseCloudflareProtection => 'Cloudflare-Schutz';

  @override
  String get browseFailedToLoad => 'Laden fehlgeschlagen';

  @override
  String get browseCloudflareChallengeDesc =>
      'Diese Quelle erfordert zunächst das Lösen einer Cloudflare-Prüfung im Browser.';

  @override
  String get browseSolveCloudflare => 'Cloudflare lösen';

  @override
  String get browseRetry => 'Erneut versuchen';

  @override
  String get browseContentAnime => 'Anime';

  @override
  String get browseContentNovels => 'Light Novels';

  @override
  String get browseContentManga => 'Manga';

  @override
  String browseNoContentFound(Object noun) {
    return 'Keine $noun gefunden';
  }

  @override
  String get browseAllCategories => 'Alle Kategorien';

  @override
  String get browseNoCategories => 'Keine Kategorien';

  @override
  String get browseSearchMangaHint => 'Manga suchen...';

  @override
  String get browseUnknown => 'Unbekannt';

  @override
  String get browseSearchAllSourcesHint => 'In allen Quellen suchen...';

  @override
  String get browseNoSourcesInstalled => 'Keine Quellen installiert';

  @override
  String get browseNoSourcesInstalledDesc =>
      'Installiere Erweiterungen über den Durchsuchen-Tab.';

  @override
  String get browseSearchAllSources => 'Alle Quellen durchsuchen';

  @override
  String browseSearchSourcesAtOnce(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Quellen gleichzeitig durchsuchen.',
      one: '1 Quelle gleichzeitig durchsuchen.',
    );
    return '$_temp0';
  }

  @override
  String browseSearchingSources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Quellen werden durchsucht...',
      one: '1 Quelle wird durchsucht...',
    );
    return '$_temp0';
  }

  @override
  String get browseSeeAll => 'Alle anzeigen';

  @override
  String get globalSearchSourceNoResults => 'No results';

  @override
  String get globalSearchSourceFailed => 'Couldn\'t search this source';

  @override
  String get browseSectionSources => 'Quellen';

  @override
  String get browseShowNsfw => 'NSFW-Quellen anzeigen';

  @override
  String get browseShowNsfwDesc =>
      '18+ Quellen beim Durchsuchen und Suchen anzeigen';

  @override
  String get browsePinnedOnly => 'Nur angeheftete Quellen';

  @override
  String get browsePinnedOnlyBrowseDesc =>
      'Beim Durchsuchen nur angeheftete Quellen anzeigen';

  @override
  String get browseSectionGlobalSearch => 'Globale Suche';

  @override
  String get browsePinnedOnlyGlobalSearchDesc =>
      'Bei der globalen Suche nur angeheftete Quellen durchsuchen';

  @override
  String get browseSectionWebView => 'WebView';

  @override
  String get browseAdBlocker => 'Werbeblocker';

  @override
  String get browseAdBlockerDesc =>
      'Werbung, Pop-ups und Overlays im Browser blockieren';

  @override
  String get browseSectionExtensions => 'Erweiterungen';

  @override
  String get browseAutoUpdate => 'Erweiterungen automatisch aktualisieren';

  @override
  String get browseAutoUpdateDesc =>
      'Installierten Erweiterungscode beim App-Start aktualisieren';

  @override
  String get setxAdvancedTitle => 'Erweitert';

  @override
  String get setxAdvancedSectionLogging => 'Protokollierung';

  @override
  String get setxAdvancedVerboseLoggingTitle => 'Ausführliche Protokollierung';

  @override
  String get setxAdvancedVerboseLoggingSubtitle =>
      'Detaillierte Debug-Informationen protokollieren';

  @override
  String get setxAdvancedViewErrorLogsTitle => 'Fehlerprotokolle anzeigen';

  @override
  String get setxAdvancedViewErrorLogsSubtitle =>
      'Debug- und Fehlerprotokolle durchsuchen';

  @override
  String get setxAdvancedSectionNetwork => 'Netzwerk';

  @override
  String get setxAdvancedDnsOverHttpsTitle => 'DNS über HTTPS';

  @override
  String get setxAdvancedDnsOverHttpsSubtitle =>
      'Sichere DNS-Auflösung verwenden';

  @override
  String get setxAdvancedDnsProviderTitle => 'DNS-Anbieter';

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
  String get setxAdvancedSectionExtensions => 'Erweiterungen';

  @override
  String get setxAdvancedThirdPartyTitle => 'Drittanbieter-Erweiterungen';

  @override
  String get setxAdvancedThirdPartySubtitle =>
      'Erweiterungen aus unbekannten Quellen zulassen';

  @override
  String get setxAdvancedExtUpdateTitle => 'Update-Hinweise für Erweiterungen';

  @override
  String get setxAdvancedExtUpdateSubtitle =>
      'Benachrichtigen, wenn Erweiterungen Updates haben';

  @override
  String get setxAdvancedSectionBrowser => 'Browser';

  @override
  String get setxAdvancedExternalBrowserTitle => 'Externer Browser';

  @override
  String get setxAdvancedExternalBrowserSubtitle =>
      'Links im System-Browser öffnen';

  @override
  String get setxAdvancedSectionData => 'Daten';

  @override
  String get setxAdvancedClearCacheTitle => 'Kapitel-Cache leeren';

  @override
  String get setxAdvancedClearCacheSubtitle => 'Speicherplatz freigeben';

  @override
  String get setxAdvancedClearDbEntryTitle => 'Datenbank leeren';

  @override
  String get setxAdvancedClearDbEntrySubtitle =>
      'Bibliothek, Kategorien und Leseverlauf zurücksetzen';

  @override
  String get setxAdvancedCacheCleared => 'Kapitel-Bild-Cache geleert';

  @override
  String get setxAdvancedClearDbTitle => 'Datenbank leeren?';

  @override
  String get setxAdvancedClearDbBody =>
      'Dies löscht dauerhaft deine Bibliothek, Kategorien und deinen Leseverlauf. Installierte Erweiterungen und Downloads sind nicht betroffen.';

  @override
  String get setxAdvancedCancel => 'Abbrechen';

  @override
  String get setxAdvancedClear => 'Leeren';

  @override
  String get setxAdvancedDbCleared =>
      'Datenbank geleert – starte die App neu, um Standardwerte neu zu laden';

  @override
  String get setxAdvancedErrorLogsTitle => 'Fehlerprotokolle';

  @override
  String get setxAdvancedClearAllLogsTooltip => 'Alle Protokolle löschen';

  @override
  String get setxAdvancedFilterCategory => 'Kategorie';

  @override
  String get setxAdvancedFilterLevel => 'Stufe';

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
  String get setxAdvancedNoLogs => 'Noch keine Protokolle';

  @override
  String get setxAdvancedNoLogsSubtitle =>
      'Protokolle erscheinen hier, während du die App nutzt';

  @override
  String get setxAdvancedClearLogsTitle => 'Alle Protokolle löschen?';

  @override
  String get setxAdvancedClearLogsBody =>
      'Dies löscht dauerhaft alle gespeicherten Protokolleinträge.';

  @override
  String get setxAdvancedLogsCleared => 'Protokolle gelöscht';

  @override
  String get setxAdvancedCopiedToClipboard => 'In die Zwischenablage kopiert';

  @override
  String get setxNotifTitle => 'Benachrichtigungen';

  @override
  String get setxNotifSectionChapterUpdates => 'Kapitel-Updates';

  @override
  String get setxNotifNewChaptersTitle => 'Neue Kapitel';

  @override
  String get setxNotifNewChaptersSubtitle =>
      'Benachrichtigen, wenn neue Kapitel verfügbar sind';

  @override
  String get setxNotifLibraryUpdatesTitle => 'Bibliotheks-Updates';

  @override
  String get setxNotifLibraryUpdatesSubtitle =>
      'Benachrichtigen, wenn das Bibliotheks-Update abgeschlossen ist';

  @override
  String get setxNotifSectionDownloads => 'Downloads';

  @override
  String get setxNotifDownloadCompleteTitle => 'Download abgeschlossen';

  @override
  String get setxNotifDownloadCompleteSubtitle =>
      'Benachrichtigen, wenn Kapitel fertig heruntergeladen sind';

  @override
  String get setxNotifDownloadErrorTitle => 'Download-Fehler';

  @override
  String get setxNotifDownloadErrorSubtitle =>
      'Benachrichtigen, wenn ein Download fehlschlägt';

  @override
  String get setxNotifSectionBehavior => 'Verhalten';

  @override
  String get setxNotifSoundTitle => 'Ton';

  @override
  String get setxNotifSoundSubtitle => 'Ton für Benachrichtigungen abspielen';

  @override
  String get setxNotifVibrationTitle => 'Vibration';

  @override
  String get setxNotifVibrationSubtitle => 'Bei Benachrichtigungen vibrieren';

  @override
  String get setxNotifGroupTitle => 'Benachrichtigungen gruppieren';

  @override
  String get setxNotifGroupSubtitle =>
      'Mehrere Benachrichtigungen zusammenfassen';

  @override
  String get setxSecurityTitle => 'Sicherheit & Datenschutz';

  @override
  String get setxSecuritySectionAppLock => 'App-Sperre';

  @override
  String get setxSecurityAppLockTitle => 'App-Sperre';

  @override
  String get setxSecurityAppLockSubtitle =>
      'Authentifizierung zum Öffnen der App erforderlich';

  @override
  String get setxSecurityBiometricsTitle => 'Biometrie';

  @override
  String get setxSecurityBiometricsSubtitle =>
      'Fingerabdruck oder Gesicht zum Entsperren verwenden';

  @override
  String get setxSecuritySectionPrivacy => 'Datenschutz';

  @override
  String get setxSecurityIncognitoTitle => 'Incognito mode';

  @override
  String get setxSecurityIncognitoSubtitle =>
      'Don\'t save reading history or update trackers';

  @override
  String get libraryIncognitoActive => 'Incognito mode on';

  @override
  String get setxSecuritySecureScreenTitle => 'Sicherer Bildschirm';

  @override
  String get setxSecuritySecureScreenSubtitle =>
      'App-Inhalt in der App-Übersicht verbergen';

  @override
  String get setxSecurityHideNotifTitle => 'Benachrichtigungsinhalt verbergen';

  @override
  String get setxSecurityHideNotifSubtitle =>
      'Generischen Benachrichtigungstext anzeigen';

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
  String get setxBackupTitle => 'Sichern & Wiederherstellen';

  @override
  String get setxBackupSectionFoxlations => 'Foxlations-Backup';

  @override
  String get setxBackupCreateTitle => 'Backup erstellen';

  @override
  String get setxBackupCreateSubtitle =>
      'Speichere deine Bibliothek, Kategorien, deinen Lesefortschritt, Quellen und Tracking';

  @override
  String get setxBackupRestoreTitle => 'Backup wiederherstellen';

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
      'Aus einer Foxlations-.fxbackup-Datei wiederherstellen';

  @override
  String get setxBackupSectionTachiyomi => 'Tachiyomi / Mihon & Forks';

  @override
  String get setxBackupCreateCompatTitle => 'Kompatibles Backup erstellen';

  @override
  String get setxBackupCreateCompatSubtitle =>
      'Exportiere eine .tachibk, die du in Tachiyomi, Mihon und Forks importieren kannst';

  @override
  String get setxBackupRestoreTachiyomiTitle =>
      'Aus Tachiyomi/Mihon wiederherstellen';

  @override
  String get setxBackupRestoreTachiyomiSubtitle =>
      'Importiere ein .tachibk-/.tmb-/.proto.gz-Backup (ordnet Quellen nach Namen zu)';

  @override
  String get setxBackupSectionAutomatic => 'Automatisches Backup';

  @override
  String get setxBackupFrequency => 'Häufigkeit';

  @override
  String setxBackupAutoSubtitle(Object freq) {
    return 'Automatisch ein Backup erstellen ($freq)';
  }

  @override
  String setxBackupSectionBackups(Object count) {
    return 'Backups ($count)';
  }

  @override
  String get setxBackupNone => 'Noch keine Backups.';

  @override
  String get setxBackupMenuRestore => 'Wiederherstellen';

  @override
  String get setxBackupMenuDelete => 'Löschen';

  @override
  String get setxBackupFreqOff => 'Aus';

  @override
  String get setxBackupFreqDaily => 'Täglich';

  @override
  String get setxBackupFreqWeekly => 'Wöchentlich';

  @override
  String get setxBackupFreqMonthly => 'Monatlich';

  @override
  String setxBackupImportedManga(Object count) {
    return '$count Manga importiert';
  }

  @override
  String get setxBackupRestoreComplete => 'Wiederherstellung abgeschlossen';

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
    return 'Wiederherstellung fehlgeschlagen: $error';
  }

  @override
  String get setxAboutTitle => 'Über';

  @override
  String get setxAboutSectionApp => 'App';

  @override
  String get setxAboutWhatsNewTitle => 'Neuigkeiten';

  @override
  String get setxAboutWhatsNewSubtitle =>
      'Änderungsprotokoll und Versionshinweise';

  @override
  String get setxAboutCheckUpdatesTitle => 'Nach Updates suchen';

  @override
  String get setxAboutCheckUpdatesSubtitle =>
      'Prüfen, ob ein neuerer Build veröffentlicht wurde';

  @override
  String get setxAboutSectionLegal => 'Rechtliches';

  @override
  String get setxAboutLicensesTitle => 'Lizenzen';

  @override
  String get setxAboutLicensesSubtitle => 'Open-Source-Lizenzen';

  @override
  String get setxAboutSectionLinks => 'Links';

  @override
  String get setxAboutSourceCodeTitle => 'Quellcode';

  @override
  String get setxAboutSourceCodeSubtitle => 'Tippen, um GitHub-URL zu kopieren';

  @override
  String get setxAboutReportBugTitle => 'Fehler melden';

  @override
  String get setxAboutReportBugSubtitle =>
      'Tippen, um Issue-Tracker-URL zu kopieren';

  @override
  String get setxAboutClose => 'Schließen';

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
    return 'Neuigkeiten in v$version';
  }

  @override
  String setxAboutLinkCopied(Object label) {
    return '$label-Link in die Zwischenablage kopiert';
  }

  @override
  String get setxAboutSourceCodeLabel => 'Quellcode';

  @override
  String get setxAboutBugReportLabel => 'Fehlerbericht';

  @override
  String get miscResumePlaybackTitle => 'Wiedergabe fortsetzen?';

  @override
  String miscStoppedWatchingAt(Object time) {
    return 'Du hast bei $time aufgehört zu schauen.';
  }

  @override
  String get miscStartOver => 'Von vorne beginnen';

  @override
  String miscContinueAt(Object time) {
    return 'Fortsetzen ($time)';
  }

  @override
  String get miscQuality => 'Qualität';

  @override
  String miscSourceIndex(Object index) {
    return 'Quelle $index';
  }

  @override
  String get miscSubtitles => 'Untertitel';

  @override
  String get miscSubtitleOff => 'Aus';

  @override
  String get miscUnknownTrack => 'Unbekannt';

  @override
  String get miscSubtitleDelay => 'Untertitel-Verzögerung';

  @override
  String get miscAudio => 'Audio';

  @override
  String get miscPlaybackSpeed => 'Wiedergabegeschwindigkeit';

  @override
  String get miscSkipOutro => 'Outro überspringen';

  @override
  String get miscSkipIntro => 'Intro überspringen';

  @override
  String get miscUnlockControls => 'Steuerung entsperren';

  @override
  String get miscUnknownError => 'Unbekannter Fehler';

  @override
  String get miscRetry => 'Erneut versuchen';

  @override
  String get miscExtensionRepositories => 'Erweiterungs-Repositorys';

  @override
  String get miscRepositoryUrlHint => 'Repository-URL (index.json)';

  @override
  String get miscAdd => 'Hinzufügen';

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
  String get miscRepositoriesHeader => 'REPOSITORYS';

  @override
  String get miscNoReposYet => 'Noch keine Repos hinzugefügt';

  @override
  String miscFailedToAddRepo(Object error) {
    return 'Repo konnte nicht hinzugefügt werden: $error';
  }

  @override
  String get miscVerifyHuman => 'Bestätige, dass du ein Mensch bist';

  @override
  String get miscCfInstructions =>
      'Schließe die Prüfung der Website unten ab. Sie schließt sich automatisch und fragt nicht erneut, solange die Verifizierung gültig ist.';

  @override
  String get trackTitle => 'Tracking';

  @override
  String get trackNoTrackerConnected => 'Kein Tracker verbunden';

  @override
  String get trackConnectHint =>
      'Verbinde AniList, MyAnimeList oder Kitsu unter Einstellungen › Tracking.';

  @override
  String trackNotLinkedOn(Object name) {
    return 'Nicht verknüpft auf $name';
  }

  @override
  String get trackLink => 'Verknüpfen';

  @override
  String get trackUnlink => 'Verknüpfung aufheben';

  @override
  String get trackStatus => 'Status';

  @override
  String get trackChapters => 'Kapitel';

  @override
  String get trackScore => 'Bewertung';

  @override
  String trackLinkedTo(Object name) {
    return 'Verknüpft mit $name';
  }

  @override
  String trackLinkOn(Object name) {
    return 'Auf $name verknüpfen';
  }

  @override
  String get trackSearchTitleHint => 'Titel suchen';

  @override
  String get trackSearch => 'Suchen';

  @override
  String get trackNoResults => 'Keine Ergebnisse';

  @override
  String trackChaptersShort(Object count) {
    return '$count Kap.';
  }

  @override
  String trackConnectTracker(Object name) {
    return '$name verbinden';
  }

  @override
  String get trackOauthInstructions =>
      'Melde dich an und drücke auf Autorisieren. Du wirst automatisch angemeldet.';

  @override
  String get trackServices => 'Dienste';

  @override
  String get trackServicesDescription =>
      'Verbinde einen Tracking-Dienst, um deinen Lesefortschritt zu synchronisieren. Sobald ein Manga verknüpft ist, wird der Fortschritt beim Lesen automatisch aktualisiert.';

  @override
  String trackLogInTo(Object name) {
    return 'Bei $name anmelden';
  }

  @override
  String get trackEmailOrUsername => 'E-Mail oder Benutzername';

  @override
  String get trackPassword => 'Passwort';

  @override
  String get trackCancel => 'Abbrechen';

  @override
  String get trackLogIn => 'Anmelden';

  @override
  String trackConnectedTo(Object name) {
    return 'Verbunden mit $name';
  }

  @override
  String get trackLoginFailed =>
      'Anmeldung fehlgeschlagen – überprüfe deine Zugangsdaten';

  @override
  String get trackSetClientIdFirst => 'Lege zuerst eine Client-ID fest';

  @override
  String get trackCouldNotCompleteSignIn =>
      'Anmeldung konnte nicht abgeschlossen werden';

  @override
  String trackClientIdTitle(Object name) {
    return '$name Client-ID (erweitert)';
  }

  @override
  String trackClientIdDescription(Object name) {
    return 'Optional. Foxlations hat bereits eine integrierte $name-Client-ID – tippe einfach auf Verbinden. Lege dies nur fest, wenn du deine eigene $name-Entwickler-App registriert hast und diese stattdessen verwenden möchtest.';
  }

  @override
  String get trackClientId => 'Client-ID';

  @override
  String get trackSave => 'Speichern';

  @override
  String get trackPasteAccessToken => 'Zugriffstoken einfügen';

  @override
  String get trackPasteTokenHint =>
      'Füge das nach der Autorisierung angezeigte Token ein';

  @override
  String get trackConnect => 'Verbinden';

  @override
  String get trackCouldNotVerifyToken =>
      'Token konnte nicht verifiziert werden';

  @override
  String get trackConnected => 'Verbunden';

  @override
  String trackConnectedAs(Object username) {
    return 'Verbunden als $username';
  }

  @override
  String get trackTapConnectToAuthorize =>
      'Tippe auf Verbinden, um zu autorisieren';

  @override
  String get trackSignInWithAccount => 'Mit deinem Konto anmelden';

  @override
  String get trackDisconnect => 'Trennen';

  @override
  String get trackAiTitle => 'KI & Übersetzung';

  @override
  String get trackTabTranslation => 'Übersetzung';

  @override
  String get trackTabApiKeys => 'API-Schlüssel';

  @override
  String get trackTabModels => 'Modelle';

  @override
  String get trackEnableAiTranslation => 'KI-Übersetzung aktivieren';

  @override
  String get trackEnableAiTranslationDesc =>
      'Übersetzen-Schaltfläche im Reader anzeigen';

  @override
  String get trackProvider => 'Anbieter';

  @override
  String get trackOfflineMode => 'Offline-Modus';

  @override
  String get trackOfflineModeDesc =>
      'Heruntergeladene Modelle ohne Internet verwenden';

  @override
  String get trackTranslationSettings => 'Übersetzungseinstellungen';

  @override
  String get trackTargetLanguage => 'Zielsprache';

  @override
  String get trackTargetLanguageDesc =>
      'Manga-Text in diese Sprache übersetzen';

  @override
  String get trackBubbleDetection => 'Sprechblasenerkennung';

  @override
  String get trackBubbleDetectionDesc =>
      'Sprechblasen in Manga-Seiten automatisch erkennen';

  @override
  String get trackQuality => 'Qualität';

  @override
  String get trackQualityFast => 'Schnell';

  @override
  String get trackQualityBalanced => 'Ausgewogen';

  @override
  String get trackQualityHigh => 'Hohe Qualität';

  @override
  String get trackKoharuServer => 'Koharu-Server';

  @override
  String get trackServerUrl => 'Server-URL';

  @override
  String get trackKoharuServerDesc =>
      'Vollständiges Manga-Inpainting über lokalen Docker-Server';

  @override
  String get trackApiKeyRequired => 'API-Schlüssel erforderlich';

  @override
  String get trackApiKeysNotice =>
      'Schlüssel werden lokal auf deinem Gerät gespeichert und niemals an unsere Server gesendet.';

  @override
  String get trackModelsPlatformOnly =>
      'On-Device-Übersetzungsmodelle sind unter Android und iOS verfügbar.';

  @override
  String get trackModelsDescription =>
      'Lade eine Sprache herunter, um sie vollständig offline zu übersetzen. Jedes Paket ist etwa 30 MB groß und wird auch automatisch abgerufen, wenn du diese Sprache zum ersten Mal übersetzt.';

  @override
  String get trackTranslationLanguages => 'ÜBERSETZUNGSSPRACHEN';

  @override
  String get trackDownloaded => 'Heruntergeladen – offline verfügbar';

  @override
  String get trackNotDownloaded => 'Nicht heruntergeladen';

  @override
  String get trackDelete => 'Löschen';

  @override
  String get trackDownload => 'Herunterladen';

  @override
  String trackDownloadFailed(Object error) {
    return 'Download fehlgeschlagen: $error';
  }

  @override
  String trackDeleteFailed(Object error) {
    return 'Löschen fehlgeschlagen: $error';
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
  String get repoCancel => 'Abbrechen';

  @override
  String get repoName => 'Name';

  @override
  String repoImportedSource(Object id) {
    return 'Importierte Quelle · $id';
  }

  @override
  String get repoCheckingMatches => 'Treffer werden geprüft';

  @override
  String get repoMigrating => 'Wird migriert';

  @override
  String get repoMigrateThisSource => 'Diese Quelle migrieren?';

  @override
  String repoMatchedByUrl(Object count) {
    return '$count über URL zugeordnet';
  }

  @override
  String repoMatchedByTitle(Object count) {
    return '$count über Titel zugeordnet';
  }

  @override
  String repoNotFoundLeftInPlace(Object count) {
    return '$count nicht gefunden – belassen';
  }

  @override
  String get repoMigrateCarryOver =>
      'Lesefortschritt, Kategorien und Tracking werden übernommen. Die Originale werden nur für Einträge entfernt, die verschoben werden.';

  @override
  String repoMigrateCount(Object count) {
    return '$count migrieren';
  }

  @override
  String get repoMigrateASource => 'Eine Quelle migrieren';

  @override
  String get repoMigrateIntro =>
      'Verschiebe jeden Bibliothekseintrag von einer Quelle zu einer anderen. Bei Wechseln auf derselben Website erfolgt die Zuordnung exakt über die URL; importierte Einträge aus einem Backup können ebenfalls einer echten Quelle zugeordnet werden.';

  @override
  String get repoFrom => 'VON';

  @override
  String get repoSelectSource => 'Quelle auswählen…';

  @override
  String get repoTo => 'NACH';

  @override
  String get repoAlsoMatchByTitle => 'Auch über Titel zuordnen';

  @override
  String get repoAlsoMatchByTitleHint =>
      'Für websiteübergreifende Wechsel: Wird ein Eintrag nicht über die URL gefunden, durchsuche die neue Quelle nach Titel und nimm den nächstbesten Treffer. Standardmäßig aus, damit nicht die falsche Serie angehängt wird.';

  @override
  String get repoMigrateSource => 'Quelle migrieren';

  @override
  String get repoMigrationComplete => 'Migration abgeschlossen';

  @override
  String repoMovedByUrl(Object count) {
    return '$count über URL verschoben';
  }

  @override
  String repoMovedByTitle(Object count) {
    return '$count über Titel verschoben';
  }

  @override
  String repoLeftInPlace(Object count) {
    return '$count belassen';
  }

  @override
  String get repoNotMigratedHeader =>
      'Nicht migriert (noch in der alten Quelle):';

  @override
  String get repoUsePerTitleMigrate => 'Nutze dafür die Migration pro Titel.';

  @override
  String get repoDone => 'Fertig';

  @override
  String get setdDownloadsTitle => 'Downloads';

  @override
  String get setdDownloadsSectionAutomatic => 'Automatische Downloads';

  @override
  String get setdDownloadsNewChapters => 'Neue Kapitel herunterladen';

  @override
  String get setdDownloadsNewChaptersDesc =>
      'Neue Kapitel automatisch herunterladen';

  @override
  String get setdDownloadsWifiOnly => 'Nur WLAN';

  @override
  String get setdDownloadsWifiOnlyDesc => 'Nur über WLAN herunterladen';

  @override
  String get setdDownloadsChargingOnly => 'Nur beim Laden';

  @override
  String get setdDownloadsChargingOnlyDesc =>
      'Nur herunterladen, wenn angeschlossen';

  @override
  String get setdDownloadsAhead => 'Beim Lesen vorausladen';

  @override
  String get setdDownloadsAheadDesc =>
      'Nächstes Kapitel beim Lesen vorab herunterladen';

  @override
  String get setdDownloadsSectionQueue => 'Download-Warteschlange';

  @override
  String get setdDownloadsSimultaneous => 'Gleichzeitige Downloads';

  @override
  String get setdDownloadsQuality => 'Download-Qualität';

  @override
  String get setdDownloadsSectionDelete => 'Heruntergeladene Kapitel löschen';

  @override
  String get setdDownloadsAfterReading => 'Nach dem Lesen';

  @override
  String get setdDownloadsAfterReadingDesc => 'Kapitel nach dem Lesen löschen';

  @override
  String get setdDownloadsIncludeBookmarked =>
      'Kapitel mit Lesezeichen einbeziehen';

  @override
  String get setdDownloadsIncludeBookmarkedDesc =>
      'Kapitel mit Lesezeichen zusammen mit den übrigen löschen';

  @override
  String get setdDownloadsAutoDelete => 'Gelesene Kapitel automatisch löschen';

  @override
  String get setdDownloadsSectionFormat => 'Format';

  @override
  String get setdDownloadsSaveCbz => 'Als CBZ speichern';

  @override
  String get setdDownloadsSaveCbzDesc =>
      'Kapitel als CBZ-Dateien mit Metadaten archivieren';

  @override
  String get setdDownloadsSavePdf => 'Als PDF speichern';

  @override
  String get setdDownloadsSavePdfDesc =>
      'Kapitel als einzelne PDF zusammenfassen (ein Bild pro Seite)';

  @override
  String get setdDownloadsSectionLocation => 'Download-Speicherort';

  @override
  String get setdDownloadsDefaultLocation => 'Standard-Speicherort';

  @override
  String get setdDownloadsCustomLocation => 'Benutzerdefinierter Speicherort';

  @override
  String get setdDownloadsChooseFolder => 'Ordner auswählen';

  @override
  String get setdDownloadsIosFolderWarning =>
      'iOS erlaubt Apps nicht, den Zugriff auf einen Ordner zu behalten. Downloads bleiben im App-Ordner, erreichbar über Dateien › Auf meinem iPhone › Foxlations.';

  @override
  String get setdDownloadsReset => 'Zurücksetzen';

  @override
  String get setdDownloadsSectionStorage => 'Speicher';

  @override
  String setdDownloadsTotalSize(Object size) {
    return 'Gesamt: $size MB';
  }

  @override
  String setdDownloadsLibraryVaultSize(Object lib, Object vault) {
    return 'Bibliothek: $lib MB  |  Tresor: $vault MB';
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
  String get setdVaultTitle => 'Tresor';

  @override
  String get setdVaultSectionAccess => 'Zugriff';

  @override
  String get setdVaultEnable => 'Tresor aktivieren';

  @override
  String get setdVaultEnableDesc =>
      'Zugriff auf den versteckten Tresor durch 8-maliges Tippen auf Bibliothek erlauben';

  @override
  String get setdVaultSectionSecurity => 'Sicherheit';

  @override
  String get setdVaultChangePassword => 'Passwort ändern';

  @override
  String get setdVaultSetPassword => 'Passwort festlegen';

  @override
  String get setdVaultPasswordSetDesc =>
      'Passwort ist festgelegt – tippen zum Ändern oder Entfernen';

  @override
  String get setdVaultPasswordUnsetDesc =>
      'Tresor-Zugriff mit einem Passwort schützen';

  @override
  String get setdVaultSectionCategories => 'Tresor-Kategorien';

  @override
  String get setdVaultEditCategories => 'Tresor-Kategorien bearbeiten';

  @override
  String get setdVaultEditCategoriesDesc =>
      'Tresor-Kategorien hinzufügen, entfernen und neu anordnen';

  @override
  String get setdVaultSectionContents => 'Inhalte';

  @override
  String get setdVaultManageContents => 'Tresor-Inhalte verwalten';

  @override
  String get setdVaultManageContentsDesc =>
      'Manga, Anime oder Novels in den Tresor hinein- und herausbewegen';

  @override
  String get setdVaultUnlockFirstSnack =>
      'Entsperre zuerst den Tresor (aus der Bibliothek hineintippen)';

  @override
  String get setdVaultSectionHiddenSources => 'Versteckte Quellen';

  @override
  String get setdVaultOnlySources => 'Nur-Tresor-Quellen';

  @override
  String setdVaultHiddenSourcesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Quellen versteckt',
      one: '1 Quelle versteckt',
    );
    return '$_temp0';
  }

  @override
  String get setdVaultSectionInfo => 'Info';

  @override
  String get setdVaultInfoText =>
      'Der Tresor ist eine versteckte Bibliothek mit eigenen Kategorien und Manga. Tippe 8-mal schnell auf den Bibliothek-Tab, um den Tresor-Modus umzuschalten. Tresor-Manga werden separat gespeichert und erscheinen nie in deiner Hauptbibliothek.';

  @override
  String get setdVaultCurrentPasswordHint => 'Aktuelles Passwort';

  @override
  String get setdVaultNewPasswordHint =>
      'Neues Passwort (zum Entfernen leer lassen)';

  @override
  String get setdVaultConfirmPasswordHint => 'Neues Passwort bestätigen';

  @override
  String get setdVaultCurrentPasswordWrong => 'Aktuelles Passwort ist falsch';

  @override
  String get setdVaultPasswordsMismatch => 'Passwörter stimmen nicht überein';

  @override
  String get setdVaultRemovingEncryption => 'Verschlüsselung wird entfernt…';

  @override
  String get setdVaultEncrypting => 'Tresor wird verschlüsselt…';

  @override
  String get setdVaultPasswordRemoved =>
      'Passwort entfernt – Tresor ist nicht mehr verschlüsselt';

  @override
  String get setdVaultPasswordSet =>
      'Passwort festgelegt – Tresor verschlüsselt';

  @override
  String get setdVaultNoCategories => 'Keine Tresor-Kategorien';

  @override
  String setdVaultDeleteCategoryConfirm(Object name) {
    return 'Möchtest du „$name“ wirklich löschen? Manga in dieser Kategorie werden nicht aus dem Tresor entfernt.';
  }

  @override
  String get setdVaultNoInstalledSources => 'Keine installierten Quellen';

  @override
  String get setdVaultHiddenSourcesToggleHint =>
      'Schalte Quellen um, damit sie nur im Tresor-Modus sichtbar sind.';

  @override
  String get setdVaultSearchSourcesHint => 'Quellen suchen...';

  @override
  String get setdCategoryNameHint => 'Kategoriename';

  @override
  String get setdNewCategory => 'Neue Kategorie';

  @override
  String get setdRenameCategory => 'Kategorie umbenennen';

  @override
  String get setdDeleteCategory => 'Kategorie löschen';

  @override
  String get setdActionCancel => 'Abbrechen';

  @override
  String get setdActionSave => 'Speichern';

  @override
  String get setdActionAdd => 'Hinzufügen';

  @override
  String get setdActionDelete => 'Löschen';

  @override
  String get setdTapToAddCategory =>
      'Tippe auf +, um eine Kategorie hinzuzufügen';

  @override
  String get setdVaultContentsTitle => 'Tresor-Inhalte';

  @override
  String get setdVaultContentsLockedMessage =>
      'Entsperre zuerst den Tresor, um seine Inhalte zu verwalten.';

  @override
  String get setdVaultContentsTabManga => 'Manga';

  @override
  String get setdVaultContentsTabAnime => 'Anime';

  @override
  String get setdVaultContentsTabNovels => 'Novels';

  @override
  String setdVaultContentsEmptyLibrary(Object type) {
    return 'Keine $type in deiner Bibliothek';
  }

  @override
  String setdVaultContentsEmptyVault(Object type) {
    return 'Keine $type im Tresor';
  }

  @override
  String setdVaultContentsMovedIn(Object title) {
    return '„$title“ in den Tresor verschoben';
  }

  @override
  String setdVaultContentsMovedOut(Object title) {
    return '„$title“ aus dem Tresor verschoben';
  }

  @override
  String setdVaultContentsReadProgress(Object read, Object total) {
    return '$read/$total gelesen';
  }

  @override
  String get setdLibraryTitle => 'Bibliothek';

  @override
  String get setdLibrarySectionCategories => 'Kategorien';

  @override
  String get setdLibraryEditCategories => 'Kategorien bearbeiten';

  @override
  String get setdLibraryEditCategoriesDesc =>
      'Kategorien hinzufügen, entfernen und neu anordnen';

  @override
  String get setdLibraryHideEmpty => 'Leere Kategorien ausblenden';

  @override
  String get setdLibraryHideEmptyDesc => 'Nur Kategorien mit Manga anzeigen';

  @override
  String get setdLibrarySectionGlobalUpdate => 'Globales Update';

  @override
  String get setdLibraryUpdateFrequency => 'Update-Häufigkeit';

  @override
  String get setdLibraryWifiOnly => 'Nur WLAN';

  @override
  String get setdLibraryWifiOnlyDesc =>
      'Nur über WLAN-Verbindungen aktualisieren';

  @override
  String get setdLibraryChargingOnly => 'Nur beim Laden';

  @override
  String get setdLibraryChargingOnlyDesc =>
      'Nur aktualisieren, wenn das Gerät lädt';

  @override
  String get setdLibrarySectionRestrictions => 'Update-Einschränkungen';

  @override
  String get setdLibrarySkipNotStarted => 'Nicht begonnene überspringen';

  @override
  String get setdLibrarySkipNotStartedDesc =>
      'Manga ohne Lesefortschritt überspringen';

  @override
  String get setdLibraryShowUpdateCount => 'Anzahl neuer Kapitel anzeigen';

  @override
  String get setdLibraryShowUpdateCountDesc =>
      'Badge auf Bibliotheks-Manga-Karten anzeigen';

  @override
  String get setdLibrarySectionData => 'Daten';

  @override
  String get setdLibraryMigrateSource => 'Eine Quelle migrieren';

  @override
  String get setdLibraryMigrateSourceDesc =>
      'Jeden Eintrag von einer Quelle zu einer anderen verschieben';

  @override
  String get setdLibraryNoCategories => 'Keine Kategorien';

  @override
  String setdLibraryDeleteCategoryConfirm(Object name) {
    return 'Möchtest du „$name“ wirklich löschen? Manga in dieser Kategorie werden nicht aus deiner Bibliothek entfernt.';
  }

  @override
  String get setdPlayerTitle => 'Player';

  @override
  String get setdPlayerSectionSeek => 'ZUM SPULEN DOPPELT TIPPEN';

  @override
  String get setdPlayerSkipForward => 'Vorwärts springen';

  @override
  String get setdPlayerSkipBackward => 'Rückwärts springen';

  @override
  String get setdPlayerSectionGestures => 'GESTEN';

  @override
  String get setdPlayerHoldToSpeed => 'Halten zum Beschleunigen';

  @override
  String setdPlayerHoldToSpeedDesc(Object speed) {
    return 'Halte irgendwo gedrückt, um mit ${speed}x abzuspielen';
  }

  @override
  String get setdPlayerHoldSpeed => 'Halte-Geschwindigkeit';

  @override
  String get setdPlayerVolumeSwipe => 'Lautstärke-Wischen';

  @override
  String get setdPlayerVolumeSwipeDesc =>
      'Auf der rechten Hälfte nach oben/unten wischen, um die Lautstärke anzupassen';

  @override
  String get setdPlayerBrightnessSwipe => 'Helligkeits-Wischen';

  @override
  String get setdPlayerBrightnessSwipeDesc =>
      'Auf der linken Hälfte nach oben/unten wischen, um die Helligkeit anzupassen';

  @override
  String get setdPlayerSectionPlayback => 'WIEDERGABE';

  @override
  String get setdPlayerDefaultSpeed => 'Standardgeschwindigkeit';

  @override
  String get setdPlayerAutoplayNext => 'Nächste Episode automatisch abspielen';

  @override
  String get setdPlayerAutoplayNextDesc =>
      'Die nächste Episode automatisch starten, wenn eine endet';

  @override
  String get setdPlayerAutoSkipIntro => 'Intro/Outro automatisch überspringen';

  @override
  String get setdPlayerAutoSkipIntroDesc =>
      'Von der Quelle markierte Openings/Endings ohne Tippen überspringen';

  @override
  String get setdPlayerSkipAmountTitle => 'Sprungweite';

  @override
  String get setdPlayerShowSkipButton => 'Skip-intro button';

  @override
  String get setdPlayerShowSkipButtonDesc =>
      'Show a Skip Intro button near the start, even when the source has no markers';

  @override
  String get setdPlayerSpeedTitle => 'Geschwindigkeit';

  @override
  String get setdAppearanceTitle => 'Darstellung';

  @override
  String get setdAppearanceSectionTheme => 'Design';

  @override
  String get setdAppearanceSectionDisplay => 'Anzeige';

  @override
  String get setdAppearanceInvertColors => 'Farben invertieren';

  @override
  String get setdAppearanceInvertColorsDesc =>
      'Invertiert die gesamte App-Oberfläche';

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
  String get setdAppearanceDarkMode => 'Dunkelmodus';

  @override
  String get setdAppearanceLightMode => 'Hellmodus';

  @override
  String get setdAppearanceCurrentlyDark => 'Derzeit dunkel';

  @override
  String get setdAppearanceCurrentlyLight => 'Derzeit hell';

  @override
  String get detailStatusOngoing => 'Laufend';

  @override
  String get detailStatusCompleted => 'Abgeschlossen';

  @override
  String get detailStatusHiatus => 'Pausiert';

  @override
  String get detailStatusCanceled => 'Abgebrochen';

  @override
  String get detailStatusFinished => 'Beendet';

  @override
  String get detailStatusUnknown => 'Unbekannt';

  @override
  String detailChapterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kapitel',
      one: '1 Kapitel',
    );
    return '$_temp0';
  }

  @override
  String detailEpisodeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Episoden',
      one: '1 Episode',
    );
    return '$_temp0';
  }

  @override
  String detailDownloadingChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kapitel werden heruntergeladen',
      one: '1 Kapitel wird heruntergeladen',
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
