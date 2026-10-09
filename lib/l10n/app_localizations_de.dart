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
  String get settingsRepoForgeTitle => 'RepoForge';

  @override
  String get settingsRepoForgeSubtitle =>
      'Quellen aus beliebiger URL erstellen & verwalten';

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
  String get libraryApply => 'Anwenden';

  @override
  String get libraryAscending => 'Aufsteigend';

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
  String get libraryChaptersRead => 'Gelesene Kapitel';

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
  String get libraryCoverSize => 'Covergröße';

  @override
  String libraryDaysCount(Object days) {
    return '$days Tage';
  }

  @override
  String get libraryDescending => 'Absteigend';

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
  String get libraryMonthlyActivity => 'Monatliche Aktivität';

  @override
  String get libraryMore => 'Mehr';

  @override
  String get libraryMostReadSeries => 'Meistgelesene Serien';

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
  String get libraryNoNewChapters => 'Keine neuen Kapitel';

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
  String get libraryReadingStreak => 'Lesestreak';

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
  String get librarySeries => 'Serien';

  @override
  String get libraryShowNumberOfItems => 'Anzahl der Einträge anzeigen';

  @override
  String get librarySizeLarge => 'Groß';

  @override
  String get librarySizeMedium => 'Mittel';

  @override
  String get librarySizeSmall => 'Klein';

  @override
  String get librarySortLastUpdated => 'Zuletzt aktualisiert';

  @override
  String get librarySortRating => 'Bewertung';

  @override
  String get librarySortTitle => 'Titel';

  @override
  String get librarySortUnreadCount => 'Ungelesene Anzahl';

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
  String get libraryStreakBest => 'Beste';

  @override
  String get libraryStreakCurrent => 'Aktuell';

  @override
  String libraryStreakDaysStrong(Object days) {
    return '$days Tage in Folge — weiter so!';
  }

  @override
  String get libraryStreakKeepGoing =>
      'Lies morgen weiter, um deinen Streak zu halten!';

  @override
  String get libraryStreakStart =>
      'Starte deinen Streak, indem du heute liest!';

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
  String get libraryTotalChapters => 'Kapitel insgesamt';

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
  String get libraryVaultBreakdown => 'Tresor-Aufschlüsselung';

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
  String get readerImageZoom => 'Bild-Zoom';

  @override
  String get readerAutoPreloadNextChapter =>
      'Nächstes Kapitel automatisch vorladen';

  @override
  String get readerAutoPreloadNextChapterSubtitle =>
      'Nächstes Kapitel im Hintergrund laden';

  @override
  String get readerCropBorders => 'Ränder zuschneiden';

  @override
  String get readerCropBordersSubtitle => 'Weiße Ränder von Seiten entfernen';

  @override
  String get readerGrayscale => 'Graustufen';

  @override
  String get readerGrayscaleSubtitle => 'Seiten in Graustufen anzeigen';

  @override
  String get readerAutoCrop => 'Auto-crop borders';

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
  String get readerZoomStartPosition => 'Zoom-Startposition';

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
  String get readerTransitions => 'Übergänge';

  @override
  String get readerPageTransition => 'Seitenübergang';

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
  String readerFinishedChapter(Object name) {
    return 'Beendet: $name';
  }

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
  String get browseRepoForgeTooltip =>
      'RepoForge – Quellen erstellen & verwalten';

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
  String get browseNoResultsFound => 'Keine Ergebnisse gefunden';

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
  String get commonBeta => 'BETA';

  @override
  String get setxAdvancedSectionBeta => 'Experimental';

  @override
  String get setxAdvancedBeta => 'Beta features';

  @override
  String get setxAdvancedBetaDesc =>
      'Show experimental features — hands-free & volume-key scrolling, RepoForge, AI translation and auto-crop. They may be unstable or change.';

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
  String get repoDeleteSourceTitle => 'Quelle löschen?';

  @override
  String repoDeleteSourceBody(Object name) {
    return '„$name“ wird aus „Meine Quellen“ entfernt.';
  }

  @override
  String get repoCancel => 'Abbrechen';

  @override
  String get repoDelete => 'Löschen';

  @override
  String repoDeletedSource(Object name) {
    return '„$name“ gelöscht';
  }

  @override
  String get repoNoSourcesToExport => 'Keine Quellen zum Exportieren';

  @override
  String get repoExportDialogTitle => 'RepoForge-Quellen exportieren';

  @override
  String repoExportedSources(Object count) {
    return '$count Quellen exportiert';
  }

  @override
  String repoExportFailed(Object error) {
    return 'Export fehlgeschlagen: $error';
  }

  @override
  String repoImportedSources(Object count) {
    return '$count Quelle(n) importiert';
  }

  @override
  String repoImportFailed(Object error) {
    return 'Import fehlgeschlagen: $error';
  }

  @override
  String get repoBuildFromUrl => 'Quellen aus beliebiger URL erstellen';

  @override
  String get repoBeta => 'BETA';

  @override
  String get repoHeroDescription =>
      'Erkenne das Framework einer Website, passe Selektoren an und installiere eine funktionierende Manga-/Anime-/Novel-Quelle – ohne Server, komplett auf dem Gerät. RepoForge ist in der Beta-Phase und trifft daher nicht immer alles richtig – überprüfe das Ergebnis und passe die Selektoren an, falls eine Website nicht korrekt herauskommt.';

  @override
  String repoCoverageSummary(Object frameworks, Object manga, Object novel) {
    return '$frameworks Frameworks · $manga Manga- + $novel Novel-Websites bekannt';
  }

  @override
  String get repoNewSource => 'Neue Quelle';

  @override
  String get repoImport => 'Importieren';

  @override
  String get repoMySources => 'MEINE QUELLEN';

  @override
  String get repoExportAll => 'Alle exportieren';

  @override
  String get repoNoSourcesYet => 'Noch keine Quellen';

  @override
  String get repoEmptyStateHint =>
      'Tippe auf „Neue Quelle“, um eine aus einer Website-URL zu erzeugen.';

  @override
  String get repoNotInstalled => 'nicht installiert';

  @override
  String get repoOpenInBrowse => 'Im Durchsuchen öffnen';

  @override
  String get repoEditRedetect => 'Bearbeiten / erneut erkennen';

  @override
  String get repoKnownNovelSite => 'Bekannte Light-Novel-Website';

  @override
  String get repoNovelGenericDetail =>
      'Als Novel-Website erkannt – mit dem generischen Novel-Body erzeugt (das Durchsuchen benötigt evtl. eine Selektor-Anpassung).';

  @override
  String repoNovelFrameworkDetail(Object framework) {
    return 'Als Novel-Quelle mit dem $framework-Body erzeugt – Durchsuchen + Reader funktionieren sofort.';
  }

  @override
  String get repoKnownMangaSite => 'Bekannte Manga-Website';

  @override
  String get repoMangaApiDetail =>
      'Community-verifizierte API-Quelle – RepoForge erstellt sie aus der API der Website.';

  @override
  String repoMangaThemeDetail(Object theme) {
    return 'Community-verifiziertes Theme: $theme – Selektoren sind bekannt.';
  }

  @override
  String get repoMangaCustomDetail =>
      'Für diese Website liegen community-verifizierte benutzerdefinierte Selektoren vor.';

  @override
  String get repoNotInKb => 'Nicht in der Wissensdatenbank';

  @override
  String get repoNotInKbDetail =>
      'RepoForge erkennt das Framework live, wenn du sie hinzufügst, und greift dann auf heuristisches „Was-ist-was“-Scraping zurück, falls sie maßgeschneidert ist.';

  @override
  String get repoCoverage => 'Abdeckung';

  @override
  String get repoCheckASite => 'Website prüfen';

  @override
  String get repoPasteSiteUrlHint => 'Website-URL einfügen';

  @override
  String get repoCheck => 'Prüfen';

  @override
  String get repoSupportedFrameworks => 'Unterstützte Frameworks';

  @override
  String get repoMangaSites => 'Manga-Websites';

  @override
  String get repoNovelSites => 'Novel-Websites';

  @override
  String get repoFrameworks => 'Frameworks';

  @override
  String get repoRoleItem => 'Listenelement (jede Karte)';

  @override
  String get repoRoleTitle => 'Titel';

  @override
  String get repoRoleCover => 'Coverbild';

  @override
  String get repoRoleNextPage => 'Link zur nächsten Seite';

  @override
  String get repoRoleDetailTitle => 'Detail – Titel';

  @override
  String get repoRoleChapters => 'Kapitellisten-Element';

  @override
  String get repoRolePageImages => 'Reader-Seitenbilder';

  @override
  String get repoRoleEpisodes => 'Episodenliste (Anime)';

  @override
  String get repoStepFetching => 'Seite wird abgerufen…';

  @override
  String get repoStepMatching => 'Framework-Signaturen werden abgeglichen…';

  @override
  String get repoStepExtracting => 'Selektoren werden extrahiert…';

  @override
  String get repoStepFinalizing => 'Wird abgeschlossen…';

  @override
  String get repoEnterUrlFirst => 'Gib zuerst eine Website-URL ein.';

  @override
  String repoDetectionFailed(Object error) {
    return 'Erkennung fehlgeschlagen: $error';
  }

  @override
  String get repoFetchFailed => 'Abruf fehlgeschlagen';

  @override
  String repoFetchedChars(Object count) {
    return '$count Zeichen abgerufen – teste jetzt die Selektoren';
  }

  @override
  String get repoFetchPageFirst => 'Rufe zuerst eine Seite ab';

  @override
  String repoGenerationFailed(Object error) {
    return 'Erzeugung fehlgeschlagen: $error';
  }

  @override
  String get repoDetectSiteFirst => 'Erkenne zuerst eine Website';

  @override
  String repoCreatedInstalled(Object name) {
    return '„$name“ erstellt & installiert';
  }

  @override
  String repoSaveFailed(Object error) {
    return 'Speichern fehlgeschlagen: $error';
  }

  @override
  String get repoCreateSource => 'Quelle erstellen';

  @override
  String get repoSiteUrl => 'Website-URL';

  @override
  String get repoDetect => 'Erkennen';

  @override
  String repoConfidence(Object pct) {
    return 'Konfidenz $pct%';
  }

  @override
  String get repoApiSource => 'API-Quelle';

  @override
  String get repoDetails => 'Details';

  @override
  String get repoSourceNameHint => 'Quellenname';

  @override
  String get repoName => 'Name';

  @override
  String get repoLang => 'Sprache';

  @override
  String get repoManga => 'Manga';

  @override
  String get repoAnime => 'Anime';

  @override
  String get repoNovel => 'Novel';

  @override
  String get repoNsfw => 'NSFW';

  @override
  String get repoScrapingStudio => 'Scraping-Studio';

  @override
  String get repoScrapingStudioHint =>
      'Rufe eine Seite ab und teste dann jeden Selektor, um zu sehen, wie viele Elemente er trifft.';

  @override
  String get repoUrlToTestHint => 'Zu testende URL';

  @override
  String get repoFetch => 'Abrufen';

  @override
  String get repoFetchFailedBlocked =>
      'Abruf fehlgeschlagen – die Website blockiert möglicherweise automatisierten Zugriff.';

  @override
  String repoLoadedChars(Object count) {
    return '$count Zeichen geladen.';
  }

  @override
  String get repoPreviewJs => 'JS-Vorschau';

  @override
  String get repoCreateInstall => 'Erstellen & Installieren';

  @override
  String get repoPickKnownSelector => 'Bekannten Selektor auswählen';

  @override
  String get repoTest => 'Testen';

  @override
  String repoNoCatalogedSelectors(Object label) {
    return 'Keine katalogisierten Selektoren für „$label“';
  }

  @override
  String get repoInvalid => 'ungültig';

  @override
  String get repoNoMatch => 'kein Treffer';

  @override
  String get repoGeneratedSource => 'Erzeugte Quelle';

  @override
  String get repoCopy => 'Kopieren';

  @override
  String get repoCopiedToClipboard => 'Quelle in die Zwischenablage kopiert';

  @override
  String repoSelectorFor(Object field) {
    return 'Selektor für $field';
  }

  @override
  String get repoSearchSelectors => 'Selektoren suchen…';

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
  String get setdVaultContentsInLibrary => 'In deiner Bibliothek';

  @override
  String get setdVaultContentsMoveIntoHint => '→ in den Tresor verschieben';

  @override
  String get setdVaultContentsInVault => 'Im Tresor';

  @override
  String get setdVaultContentsMoveOutHint => '← wieder heraus verschieben';

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
