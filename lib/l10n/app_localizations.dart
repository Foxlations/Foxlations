import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('pt'),
    Locale('zh'),
  ];

  /// The app's name, shown in the app bar and launcher; keep as-is, do not translate.
  ///
  /// In en, this message translates to:
  /// **'Foxlations'**
  String get appTitle;

  /// Title at the top of the main Settings screen.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Section header grouping app-wide settings entries.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get settingsSectionApp;

  /// Section header grouping manga/content-related settings entries.
  ///
  /// In en, this message translates to:
  /// **'Manga'**
  String get settingsSectionManga;

  /// Section header grouping system/device-level settings entries.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsSectionSystem;

  /// Settings entry title and header for choosing the app's language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// Subtitle under the Language entry in the settings list.
  ///
  /// In en, this message translates to:
  /// **'App display language'**
  String get settingsLanguageEntrySubtitle;

  /// Subtitle shown on the Language picker screen.
  ///
  /// In en, this message translates to:
  /// **'Choose your app language'**
  String get settingsLanguageSubtitle;

  /// Language option that follows the device's system language.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsLanguageSystemDefault;

  /// Section header above the list of selectable app languages.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get settingsLanguageHeader;

  /// Settings entry title for theme/appearance options.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceTitle;

  /// Subtitle listing what the Appearance settings cover.
  ///
  /// In en, this message translates to:
  /// **'Theme, dark mode, display'**
  String get settingsAppearanceSubtitle;

  /// Settings entry title for notification options.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsTitle;

  /// Subtitle listing what the Notifications settings cover.
  ///
  /// In en, this message translates to:
  /// **'Push alerts, frequency, reminders'**
  String get settingsNotificationsSubtitle;

  /// Settings entry title for storage options.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get settingsStorageTitle;

  /// Subtitle listing what the Storage settings cover.
  ///
  /// In en, this message translates to:
  /// **'Downloads, folder locations, sync'**
  String get settingsStorageSubtitle;

  /// Settings entry title for library options.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get settingsLibraryTitle;

  /// Subtitle listing what the Library settings cover.
  ///
  /// In en, this message translates to:
  /// **'Categories, global update, display'**
  String get settingsLibrarySubtitle;

  /// Settings entry title for the manga/novel reader options.
  ///
  /// In en, this message translates to:
  /// **'Reader'**
  String get settingsReaderTitle;

  /// Subtitle listing what the Reader settings cover.
  ///
  /// In en, this message translates to:
  /// **'Reading mode, display, navigation'**
  String get settingsReaderSubtitle;

  /// Settings entry title for the video/anime player options.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get settingsPlayerTitle;

  /// Subtitle listing what the Player settings cover.
  ///
  /// In en, this message translates to:
  /// **'Seek, gestures, speed, autoplay'**
  String get settingsPlayerSubtitle;

  /// Settings entry title for download options.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get settingsDownloadsTitle;

  /// Subtitle listing what the Downloads settings cover.
  ///
  /// In en, this message translates to:
  /// **'Automatic downloads, delete chapters'**
  String get settingsDownloadsSubtitle;

  /// Settings entry title for progress-tracking services.
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get settingsTrackingTitle;

  /// Subtitle naming tracking services (MyAnimeList, AniList, Kitsu, etc.); keep service names as-is.
  ///
  /// In en, this message translates to:
  /// **'MAL, AniList, Kitsu, and more'**
  String get settingsTrackingSubtitle;

  /// Settings entry title for AI and translation options.
  ///
  /// In en, this message translates to:
  /// **'AI & Translation'**
  String get settingsAiTitle;

  /// Subtitle listing what the AI & Translation settings cover.
  ///
  /// In en, this message translates to:
  /// **'Provider, API keys, speech bubble detection'**
  String get settingsAiSubtitle;

  /// Settings entry title for browse/source options.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get settingsBrowseTitle;

  /// Subtitle listing what the Browse settings cover.
  ///
  /// In en, this message translates to:
  /// **'Sources, extensions, global search'**
  String get settingsBrowseSubtitle;

  /// Settings entry title for backup and restore options.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get settingsBackupTitle;

  /// Subtitle listing what the Backup & Restore settings cover.
  ///
  /// In en, this message translates to:
  /// **'Create/restore backups, import, auto-backup'**
  String get settingsBackupSubtitle;

  /// Settings entry title for security and privacy options.
  ///
  /// In en, this message translates to:
  /// **'Security & Privacy'**
  String get settingsSecurityTitle;

  /// Subtitle listing what the Security & Privacy settings cover.
  ///
  /// In en, this message translates to:
  /// **'App lock, biometrics, screen security'**
  String get settingsSecuritySubtitle;

  /// Settings entry title for advanced options.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get settingsAdvancedTitle;

  /// Subtitle listing what the Advanced settings cover.
  ///
  /// In en, this message translates to:
  /// **'Network, extensions, logging, data'**
  String get settingsAdvancedSubtitle;

  /// Settings entry title for the About screen.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutTitle;

  /// Subtitle listing what the About screen shows (version, licenses, links).
  ///
  /// In en, this message translates to:
  /// **'Version, licenses, links'**
  String get settingsAboutSubtitle;

  /// Label on the button/menu that adds a new title to the library.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get libraryAdd;

  /// Menu item to add an anime series to the library.
  ///
  /// In en, this message translates to:
  /// **'Add Anime'**
  String get libraryAddAnime;

  /// Menu item to add light novels (LNs) to the library.
  ///
  /// In en, this message translates to:
  /// **'Add LNs'**
  String get libraryAddLNs;

  /// Menu item to add a manga to the library.
  ///
  /// In en, this message translates to:
  /// **'Add Manga'**
  String get libraryAddManga;

  /// Section heading for toggles controlling cover overlay badges (unread/downloaded counts).
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get libraryBadges;

  /// Multi-select action button: migrate selected titles to another source.
  ///
  /// In en, this message translates to:
  /// **'Migrate'**
  String get libraryBatchMigrate;

  /// Multi-select action button: move selected titles to another category.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get libraryBatchMove;

  /// Multi-select action button: mark selected titles as read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get libraryBatchRead;

  /// Multi-select action button: remove selected titles from the library.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get libraryBatchRemove;

  /// Multi-select action button: mark selected titles as unread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get libraryBatchUnread;

  /// Title of the update-scope option that checks only one category.
  ///
  /// In en, this message translates to:
  /// **'Category Update'**
  String get libraryCategoryUpdate;

  /// Subtitle for the single-category update option; {category} is the category name.
  ///
  /// In en, this message translates to:
  /// **'Check \"{category}\" for new chapters'**
  String libraryCategoryUpdateDesc(Object category);

  /// Compact chapter-progress badge on a cover; {read}=chapters read, {total}=total chapters.
  ///
  /// In en, this message translates to:
  /// **'Ch. {read}/{total}'**
  String libraryChapterProgress(Object read, Object total);

  /// Compact episode-progress badge for anime; {read}=episodes watched, {total}=total episodes.
  ///
  /// In en, this message translates to:
  /// **'Ep. {read}/{total}'**
  String libraryEpisodeProgress(Object read, Object total);

  /// Abbreviated chapter count, e.g. in stats; {n} is the number of chapters.
  ///
  /// In en, this message translates to:
  /// **'{n} ch'**
  String libraryChaptersAbbrev(Object n);

  /// Menu/button label to check library entries for new chapters.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get libraryCheckForUpdates;

  /// Generic Close button for a dialog or sheet.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get libraryClose;

  /// Tooltip/label for the button that closes the library search bar.
  ///
  /// In en, this message translates to:
  /// **'Close search'**
  String get libraryCloseSearch;

  /// Filter/status label for titles that are fully completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get libraryCompleted;

  /// Section header or button to resume the last-read title.
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get libraryContinueReading;

  /// Continue Reading variant shown when the last-touched item is anime (video).
  ///
  /// In en, this message translates to:
  /// **'Continue Watching'**
  String get libraryContinueWatching;

  /// Button to start text-to-speech reading of a light novel aloud.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get readerListen;

  /// Stop the text-to-speech reading.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get readerTtsStop;

  /// Label for the text-to-speech playback speed control.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get readerTtsSpeed;

  /// Title for the text-to-speech voice picker (device voices).
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get readerTtsVoice;

  /// Shown when the device has no selectable TTS voices.
  ///
  /// In en, this message translates to:
  /// **'No voices available on this device'**
  String get readerTtsNoVoices;

  /// Voice-picker option to use the device's default TTS voice.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get readerTtsSystemVoice;

  /// Duration text; {days} is a number of days.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String libraryDaysCount(Object days);

  /// Action to clear the current multi-select selection.
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get libraryDeselectAll;

  /// Setting label for how the library grid is laid out (grid, list, etc.).
  ///
  /// In en, this message translates to:
  /// **'Display Mode'**
  String get libraryDisplayMode;

  /// Filter/badge label for titles with downloaded chapters.
  ///
  /// In en, this message translates to:
  /// **'Downloaded'**
  String get libraryDownloaded;

  /// Empty-state title shown when the library has no titles.
  ///
  /// In en, this message translates to:
  /// **'Library is empty'**
  String get libraryEmpty;

  /// Empty-state body prompting the user to browse sources to add manga.
  ///
  /// In en, this message translates to:
  /// **'Your library is empty. Browse sources to add manga.'**
  String get libraryEmptyDesc;

  /// Empty stats prompt for the library; {word} is the content-type noun (e.g. manga/anime).
  ///
  /// In en, this message translates to:
  /// **'Add {word} to your library and start reading to see your stats here.'**
  String libraryEmptyStatsLibrary(Object word);

  /// Empty stats prompt for the vault; {word} is the content-type noun.
  ///
  /// In en, this message translates to:
  /// **'Add {word} to your vault and start reading to see stats here.'**
  String libraryEmptyStatsVault(Object word);

  /// Tooltip/label for the button opening filter, sort and display options.
  ///
  /// In en, this message translates to:
  /// **'Filter, sort & display'**
  String get libraryFilterSortDisplay;

  /// Title of the update-scope option that checks the whole library.
  ///
  /// In en, this message translates to:
  /// **'Global Update'**
  String get libraryGlobalUpdate;

  /// Subtitle explaining the global update option checks every library entry.
  ///
  /// In en, this message translates to:
  /// **'Check every entry in your library'**
  String get libraryGlobalUpdateDesc;

  /// Legend label at the low end of the activity heatmap color scale.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get libraryHeatmapLess;

  /// Legend label at the high end of the activity heatmap color scale.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get libraryHeatmapMore;

  /// Setting label for the number of covers shown per grid row.
  ///
  /// In en, this message translates to:
  /// **'Items per row'**
  String get libraryItemsPerRow;

  /// Status text showing when updates were last checked; {when} is a time/date.
  ///
  /// In en, this message translates to:
  /// **'Last checked: {when}'**
  String libraryLastChecked(Object when);

  /// Name of the Library screen/tab.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get libraryLibrary;

  /// Chapter progress in list display mode; {read}=read chapters, {total}=total chapters.
  ///
  /// In en, this message translates to:
  /// **'{read}/{total} chapters'**
  String libraryListChapters(Object read, Object total);

  /// Label for a More menu or overflow button.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get libraryMore;

  /// Dialog title/action for moving a title into a category.
  ///
  /// In en, this message translates to:
  /// **'Move to Category'**
  String get libraryMoveToCategory;

  /// Value meaning updates have never been checked (e.g. shown for {when}).
  ///
  /// In en, this message translates to:
  /// **'never'**
  String get libraryNever;

  /// Empty-state title for the bookmarks view when none exist.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet'**
  String get libraryNoBookmarks;

  /// Empty-state body explaining how to bookmark a manga via long-press.
  ///
  /// In en, this message translates to:
  /// **'Long-press a manga and bookmark it to see it here.'**
  String get libraryNoBookmarksDesc;

  /// Longer message stating the last update check found no new chapters.
  ///
  /// In en, this message translates to:
  /// **'No new chapters were found in the last check.'**
  String get libraryNoNewChaptersLastCheck;

  /// Empty-state title when a library search returns nothing.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get libraryNoResults;

  /// Empty-state body for no search results; {query} is the search text entered.
  ///
  /// In en, this message translates to:
  /// **'No results for \"{query}\". Try a different search.'**
  String libraryNoResultsDesc(Object query);

  /// Empty-state title shown when no reading stats are available yet.
  ///
  /// In en, this message translates to:
  /// **'No stats yet'**
  String get libraryNoStatsYet;

  /// Tooltip/menu action to open a random title from the library.
  ///
  /// In en, this message translates to:
  /// **'Open random entry'**
  String get libraryOpenRandomEntry;

  /// Button restoring filter/sort/display settings to defaults.
  ///
  /// In en, this message translates to:
  /// **'Reset to default'**
  String get libraryResetToDefault;

  /// Generic Save button in a dialog or settings sheet.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get librarySave;

  /// Placeholder text inside the library search input field.
  ///
  /// In en, this message translates to:
  /// **'Search in library...'**
  String get librarySearchHint;

  /// Tooltip/label for the button that opens library search.
  ///
  /// In en, this message translates to:
  /// **'Search library'**
  String get librarySearchLibrary;

  /// Action to enter multi-select mode.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get librarySelect;

  /// Action to select every title in the current view.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get librarySelectAll;

  /// Selection-mode counter in the app bar; {n} is the number selected.
  ///
  /// In en, this message translates to:
  /// **'{n} selected'**
  String librarySelectedCount(Object n);

  /// Toggle label to show the item count on category tabs.
  ///
  /// In en, this message translates to:
  /// **'Show number of items'**
  String get libraryShowNumberOfItems;

  /// Cover-size option: medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get librarySizeMedium;

  /// Stats/label word for a count of distinct sources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get librarySources;

  /// Name of the Stats tab/section within the library.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get libraryStats;

  /// Reading-status filter: show all statuses.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get libraryStatusAll;

  /// Reading-status filter: titles marked completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get libraryStatusCompleted;

  /// Reading-status filter: titles marked dropped.
  ///
  /// In en, this message translates to:
  /// **'Dropped'**
  String get libraryStatusDropped;

  /// Reading-status filter: titles marked on hold.
  ///
  /// In en, this message translates to:
  /// **'On Hold'**
  String get libraryStatusOnHold;

  /// Reading-status filter: titles marked plan to read.
  ///
  /// In en, this message translates to:
  /// **'Plan to Read'**
  String get libraryStatusPlanToRead;

  /// Reading-status filter: titles currently being read.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get libraryStatusReading;

  /// Reading-status filter: titles with no set status.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get libraryStatusUnknown;

  /// Encouragement under the streak; {days} is the current streak length in days.
  ///
  /// In en, this message translates to:
  /// **'{days} days strong — keep it up!'**
  String libraryStreakDaysStrong(Object days);

  /// Tab label for the Display options page in the filter/sort/display sheet.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get libraryTabDisplay;

  /// Tab label for the Filter options page in the filter/sort/display sheet.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get libraryTabFilter;

  /// Tab label for the Sort options page in the filter/sort/display sheet.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get libraryTabSort;

  /// Section heading for settings related to category tabs.
  ///
  /// In en, this message translates to:
  /// **'Tabs'**
  String get libraryTabs;

  /// Abbreviated total count in stats; {n} is the total number.
  ///
  /// In en, this message translates to:
  /// **'{n} total'**
  String libraryTotalAbbrev(Object n);

  /// Accessibility label for the library-type (manga/anime/novel) picker's dismiss barrier
  ///
  /// In en, this message translates to:
  /// **'Library type'**
  String get libraryTypeMenuBarrier;

  /// Stats section heading; {type} is the content type (Manga/Anime/Novel).
  ///
  /// In en, this message translates to:
  /// **'{type} Breakdown'**
  String libraryTypeBreakdown(Object type);

  /// Filter/badge label for titles with unread chapters.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get libraryUnread;

  /// Heading of the panel summarizing the latest update check results.
  ///
  /// In en, this message translates to:
  /// **'Updates Summary'**
  String get libraryUpdatesSummary;

  /// Subtitle describing the updates summary as what the last check found.
  ///
  /// In en, this message translates to:
  /// **'What the last check found'**
  String get libraryUpdatesSummaryDesc;

  /// Name of the Vault tab/section (private or archived titles).
  ///
  /// In en, this message translates to:
  /// **'Vault'**
  String get libraryVault;

  /// Heading for the statistics view of the vault.
  ///
  /// In en, this message translates to:
  /// **'Vault Stats'**
  String get libraryVaultStats;

  /// Button that confirms adding this title to the library/a category
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get detailAdd;

  /// Placeholder text in the empty notes text field for this title
  ///
  /// In en, this message translates to:
  /// **'Add a note for this title…'**
  String get detailAddNoteHint;

  /// Menu option to add this title to a chosen library category
  ///
  /// In en, this message translates to:
  /// **'Add to Category'**
  String get detailAddToCategory;

  /// Primary button that saves this title into the user's library
  ///
  /// In en, this message translates to:
  /// **'Add to Library'**
  String get detailAddToLibrary;

  /// Option to add the title to the library with no category assigned
  ///
  /// In en, this message translates to:
  /// **'Add without Category'**
  String get detailAddWithoutCategory;

  /// Filter/action label targeting chapters below this one that are read
  ///
  /// In en, this message translates to:
  /// **'Below read'**
  String get detailBelowRead;

  /// Filter/action label targeting chapters below this one that are unread
  ///
  /// In en, this message translates to:
  /// **'Below unread'**
  String get detailBelowUnread;

  /// Action to bookmark a chapter/episode row
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get detailBookmark;

  /// Status label shown on a chapter/episode that is bookmarked
  ///
  /// In en, this message translates to:
  /// **'Bookmarked'**
  String get detailBookmarked;

  /// Generic cancel button in dialogs on the detail screen
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get detailCancel;

  /// Default label for an unnamed chapter (episode for anime)
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get detailChapterFallback;

  /// Snackbar after copying the title to another source; {source} is source name
  ///
  /// In en, this message translates to:
  /// **'Copied to {source}'**
  String detailCopiedTo(Object source);

  /// Selection-mode header count; {count} is number of selected chapters/episodes
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String detailCountSelected(Object count);

  /// Chapter/episode row action to delete its downloaded files
  ///
  /// In en, this message translates to:
  /// **'Delete download'**
  String get detailDeleteDownload;

  /// Button confirming/closing a selection or edit dialog
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get detailDone;

  /// Button or row action to download a chapter/episode
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get detailDownload;

  /// Download-menu option: download every chapter (episode for anime)
  ///
  /// In en, this message translates to:
  /// **'All chapters'**
  String get detailDownloadAllChapters;

  /// Download-menu option: download all unread chapters/episodes
  ///
  /// In en, this message translates to:
  /// **'All unread'**
  String get detailDownloadAllUnread;

  /// Status label on a chapter/episode already downloaded
  ///
  /// In en, this message translates to:
  /// **'Downloaded'**
  String get detailDownloaded;

  /// Download-menu option: download the next 10 chapters/episodes
  ///
  /// In en, this message translates to:
  /// **'Next 10 chapters'**
  String get detailDownloadNext10;

  /// Download-menu option: download the next 5 chapters/episodes
  ///
  /// In en, this message translates to:
  /// **'Next 5 chapters'**
  String get detailDownloadNext5;

  /// Download-menu option: download the next single chapter/episode
  ///
  /// In en, this message translates to:
  /// **'Next chapter'**
  String get detailDownloadNextChapter;

  /// Download-menu option (anime): download the next single episode
  ///
  /// In en, this message translates to:
  /// **'Next episode'**
  String get detailDownloadNextEpisode;

  /// Download-menu option (anime): download the next 5 episodes
  ///
  /// In en, this message translates to:
  /// **'Next 5 episodes'**
  String get detailDownloadNext5Episodes;

  /// Download-menu option (anime): download the next 10 episodes
  ///
  /// In en, this message translates to:
  /// **'Next 10 episodes'**
  String get detailDownloadNext10Episodes;

  /// Download-menu option (anime): download every episode
  ///
  /// In en, this message translates to:
  /// **'All episodes'**
  String get detailDownloadAllEpisodes;

  /// Overflow-menu option (anime): enter multi-select to pick episodes
  ///
  /// In en, this message translates to:
  /// **'Select episodes'**
  String get detailSelectEpisodes;

  /// Menu/button to change which categories this title belongs to
  ///
  /// In en, this message translates to:
  /// **'Edit categories'**
  String get detailEditCategories;

  /// Title of the edit-categories dialog
  ///
  /// In en, this message translates to:
  /// **'Edit Categories'**
  String get detailEditCategoriesTitle;

  /// Button/tooltip opening the chapter-list filter options
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get detailFilter;

  /// Status label on a chapter/episode partially read or watched
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get detailInProgress;

  /// Button prompting the user to sign in to the source
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get detailLogIn;

  /// Error message when the title cannot be found in the library
  ///
  /// In en, this message translates to:
  /// **'Manga not found in library'**
  String get detailMangaNotFound;

  /// Action to mark every chapter/episode as read (watched)
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get detailMarkAllAsRead;

  /// Action to mark every chapter/episode as unread
  ///
  /// In en, this message translates to:
  /// **'Mark all as unread'**
  String get detailMarkAllAsUnread;

  /// Action to mark this chapter and all below it as read
  ///
  /// In en, this message translates to:
  /// **'Mark all below as read'**
  String get detailMarkAllBelowRead;

  /// Chapter/episode row action to set it back to unread
  ///
  /// In en, this message translates to:
  /// **'Mark as unread'**
  String get detailMarkAsUnread;

  /// Chapter row action to mark that chapter read (episode for anime)
  ///
  /// In en, this message translates to:
  /// **'Mark chapter as read'**
  String get detailMarkChapterAsRead;

  /// Short button/label to mark a chapter/episode as read
  ///
  /// In en, this message translates to:
  /// **'Mark read'**
  String get detailMarkRead;

  /// Short button/label to mark a chapter/episode as unread
  ///
  /// In en, this message translates to:
  /// **'Mark unread'**
  String get detailMarkUnread;

  /// Button to migrate this title to a different source
  ///
  /// In en, this message translates to:
  /// **'Migrate'**
  String get detailMigrate;

  /// Migrate dialog toggle: carry over category assignments
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get detailMigrateCategories;

  /// Migrate dialog toggle: carry over chapter/episode read progress
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get detailMigrateChapters;

  /// Migrate dialog option: copy to the new source instead of moving
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get detailMigrateCopy;

  /// Migrate dialog note warning downloaded files won't move
  ///
  /// In en, this message translates to:
  /// **'Downloaded chapters do not transfer.'**
  String get detailMigrateDownloadsNoTransfer;

  /// Snackbar after migrating; {source} is the destination source name
  ///
  /// In en, this message translates to:
  /// **'Migrated to {source}'**
  String detailMigratedTo(Object source);

  /// Bulk-migrate summary; {count} titles moved to source {source}
  ///
  /// In en, this message translates to:
  /// **'{count} entries → {source}'**
  String detailMigrateEntriesToSource(Object count, Object source);

  /// Explanatory text in the migrate flow about picking the same title elsewhere
  ///
  /// In en, this message translates to:
  /// **'Select the same manga from a different source. Read progress will be transferred.'**
  String get detailMigrateInfo;

  /// Migrate dialog toggle: delete downloads after migrating
  ///
  /// In en, this message translates to:
  /// **'Remove downloads if migrate'**
  String get detailMigrateRemoveDownloads;

  /// Migrate dialog header: choose which data to include
  ///
  /// In en, this message translates to:
  /// **'Select data to include'**
  String get detailMigrateSelectData;

  /// Migrate action to open/preview the matched entry
  ///
  /// In en, this message translates to:
  /// **'Show entry'**
  String get detailMigrateShowEntry;

  /// Migrate confirmation; {title} is title name, {source} is destination source
  ///
  /// In en, this message translates to:
  /// **'{title} → {source}'**
  String detailMigrateTitleToSource(Object title, Object source);

  /// Migrate dialog toggle: carry over tracking links
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get detailMigrateTracking;

  /// Progress label shown while migration is running
  ///
  /// In en, this message translates to:
  /// **'Migrating…'**
  String get detailMigrating;

  /// Sort option: list chapters/episodes newest first
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get detailNewestFirst;

  /// Empty-state message when no chapters/episodes loaded
  ///
  /// In en, this message translates to:
  /// **'No chapters found'**
  String get detailNoChaptersFound;

  /// Empty-state hint suggesting retry or logging in to unlock chapters
  ///
  /// In en, this message translates to:
  /// **'Nothing loaded for this title. Try again — or, for this source, logging in can sometimes unlock more.'**
  String get detailNoChaptersLoginHint;

  /// Empty-state hint suggesting retry when chapters failed to load
  ///
  /// In en, this message translates to:
  /// **'Nothing loaded for this title. It may have none yet, or the source had trouble loading them. Try again.'**
  String get detailNoChaptersRetryHint;

  /// Empty-state message for a search with no matches
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get detailNoResults;

  /// Section header/label for user notes on this title
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get detailNotes;

  /// Snackbar when a download action finds nothing to fetch
  ///
  /// In en, this message translates to:
  /// **'Nothing to download'**
  String get detailNothingToDownload;

  /// Sort option: list chapters/episodes oldest first
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get detailOldestFirst;

  /// Menu action to open the title's page in an external browser
  ///
  /// In en, this message translates to:
  /// **'Open in browser'**
  String get detailOpenInBrowser;

  /// Snackbar shown when opening the current page in the device's default browser fails.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the browser'**
  String get webviewOpenFailed;

  /// Reading-progress label on a chapter row; {page} is current page number
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String detailPage(Object page);

  /// Button/tooltip to reload the title's metadata and chapter list
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get detailRefresh;

  /// Button confirming removal (e.g. from library or a category)
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get detailRemove;

  /// Action to remove a bookmark from a chapter/episode
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get detailRemoveBookmark;

  /// Menu action to take this title out of the library
  ///
  /// In en, this message translates to:
  /// **'Remove from library'**
  String get detailRemoveFromLibrary;

  /// Title of the confirm-remove-from-library dialog
  ///
  /// In en, this message translates to:
  /// **'Remove from library?'**
  String get detailRemoveFromLibraryTitle;

  /// Button to continue reading/watching from last position
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get detailResume;

  /// Button to retry loading after a failure
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get detailRetry;

  /// Button to save changes (e.g. notes or categories)
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get detailSave;

  /// Tooltip/button opening chapter-list search
  ///
  /// In en, this message translates to:
  /// **'Search chapters'**
  String get detailSearchChapters;

  /// Placeholder in the chapter search field
  ///
  /// In en, this message translates to:
  /// **'Search chapters...'**
  String get detailSearchChaptersHint;

  /// Tooltip/button opening episode-list search (anime equivalent of chapters)
  ///
  /// In en, this message translates to:
  /// **'Search episodes'**
  String get detailSearchEpisodes;

  /// Placeholder in the source-search field for finding a manga title
  ///
  /// In en, this message translates to:
  /// **'Search manga title...'**
  String get detailSearchHint;

  /// Progress label while searching across sources (e.g. during migration)
  ///
  /// In en, this message translates to:
  /// **'Searching sources…'**
  String get detailSearchingSources;

  /// Selection-mode action to select every chapter/episode
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get detailSelectAll;

  /// Action to enter multi-select mode for chapters/episodes
  ///
  /// In en, this message translates to:
  /// **'Select chapters'**
  String get detailSelectChapters;

  /// Section header/button for external tracking services
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get detailTracking;

  /// Action to remove a bookmark from a chapter/episode
  ///
  /// In en, this message translates to:
  /// **'Unbookmark'**
  String get detailUnbookmark;

  /// Filter/label for unread chapters/episodes
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get detailUnread;

  /// Menu action to open the source page in an in-app WebView
  ///
  /// In en, this message translates to:
  /// **'WebView'**
  String get detailWebView;

  /// Bottom navigation bar label for the user's saved manga/anime/novel collection.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get appNavLibrary;

  /// Bottom navigation bar label for the tab listing newly released chapters/episodes.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get appNavUpdates;

  /// Bottom navigation bar label for the tab to discover/search sources and extensions.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get appNavBrowse;

  /// Bottom navigation bar label for the recommendations/discovery tab that suggests new series.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get appNavDiscover;

  /// Bottom navigation bar label opening extra options and settings.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get appNavMore;

  /// Bottom navigation bar label for the password-protected private collection.
  ///
  /// In en, this message translates to:
  /// **'Vault'**
  String get appNavVault;

  /// Title at the top of the Updates screen.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get appUpdatesTitle;

  /// Message shown when an update check finds no new chapters.
  ///
  /// In en, this message translates to:
  /// **'No new chapters'**
  String get appNoNewChapters;

  /// Button/action that starts checking sources for new chapters.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get appCheckForUpdates;

  /// Button to clear/dismiss all items in the updates list.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get appClearAll;

  /// Progress text while checking for updates; {checked} = items done, {total} = total items.
  ///
  /// In en, this message translates to:
  /// **'Checking {checked} / {total}...'**
  String appCheckingProgress(Object checked, Object total);

  /// Timestamp label of the last update check; {time} = formatted time or relative age.
  ///
  /// In en, this message translates to:
  /// **'Last checked: {time}'**
  String appLastChecked(Object time);

  /// Empty-state heading on the Updates screen when nothing has been checked yet.
  ///
  /// In en, this message translates to:
  /// **'No updates yet'**
  String get appNoUpdatesYet;

  /// Empty-state hint telling the user to tap refresh to look for new chapters.
  ///
  /// In en, this message translates to:
  /// **'Tap refresh to check for new chapters'**
  String get appTapRefreshForChapters;

  /// Button on the empty Updates screen to trigger an immediate update check.
  ///
  /// In en, this message translates to:
  /// **'Check Now'**
  String get appCheckNow;

  /// Relative time label meaning an event happened moments ago.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get appJustNow;

  /// Relative time label; {m} = number of minutes elapsed.
  ///
  /// In en, this message translates to:
  /// **'{m}m ago'**
  String appMinutesAgo(Object m);

  /// Relative time label; {h} = number of hours elapsed.
  ///
  /// In en, this message translates to:
  /// **'{h}h ago'**
  String appHoursAgo(Object h);

  /// Relative time label; {d} = number of days elapsed.
  ///
  /// In en, this message translates to:
  /// **'{d}d ago'**
  String appDaysAgo(Object d);

  /// Date section header grouping today's items; often shown uppercase.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get appToday;

  /// Date section header grouping yesterday's items; often shown uppercase.
  ///
  /// In en, this message translates to:
  /// **'YESTERDAY'**
  String get appYesterday;

  /// Message confirming the app is already up to date.
  ///
  /// In en, this message translates to:
  /// **'You\'re on the latest version'**
  String get appOnLatestVersion;

  /// Label/heading indicating a newer app version can be installed.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get appUpdateAvailable;

  /// Version display; {version} = version name, {build} = build number.
  ///
  /// In en, this message translates to:
  /// **'v{version} · build {build}'**
  String appVersionBuild(Object version, Object build);

  /// Button to download the available app update.
  ///
  /// In en, this message translates to:
  /// **'Download update'**
  String get appDownloadUpdate;

  /// Button to download a specific app version; {version} = version name.
  ///
  /// In en, this message translates to:
  /// **'Download v{version}'**
  String appDownloadVersion(Object version);

  /// Hint under the download button explaining the Android APK install confirmation.
  ///
  /// In en, this message translates to:
  /// **'Opens the APK download. Android will ask you to confirm the install.'**
  String get appApkDownloadHint;

  /// Hint for iOS users to update via AltStore/SideStore instead of a browser download.
  ///
  /// In en, this message translates to:
  /// **'Update from AltStore or SideStore — open it and refresh. iOS can\'t install an app downloaded in a browser.'**
  String get appIosUpdateHint;

  /// Snackbar confirming the AltStore source URL was copied to clipboard.
  ///
  /// In en, this message translates to:
  /// **'Source URL copied — add it in AltStore'**
  String get appSourceUrlCopied;

  /// Button to copy the app's AltStore source URL for iOS installs.
  ///
  /// In en, this message translates to:
  /// **'Copy AltStore source URL'**
  String get appCopyAltstoreUrl;

  /// Navigation button to go back (in-app browser/webview).
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get appBack;

  /// Navigation button to go forward (in-app browser/webview).
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get appForward;

  /// Button to reload the current page in the in-app browser/webview.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get appReload;

  /// Button in the webview to finish and save the site's login cookies.
  ///
  /// In en, this message translates to:
  /// **'Done — save cookies'**
  String get appDoneSaveCookies;

  /// Title of the dialog prompting for the Vault password.
  ///
  /// In en, this message translates to:
  /// **'Vault Password'**
  String get appVaultPassword;

  /// Placeholder text in the Vault password input field.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get appEnterPassword;

  /// Error shown when the entered Vault password is incorrect.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get appWrongPassword;

  /// Generic Cancel button in the Vault password dialog.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get appCancel;

  /// Button to unlock the Vault after entering the password.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get appUnlock;

  /// Button in the Vault unlock dialog that triggers fingerprint/face unlock
  ///
  /// In en, this message translates to:
  /// **'Biometrics'**
  String get appBiometrics;

  /// Brief hint while tapping the Library tab the secret number of times to enter the Vault
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 more tap to enter vault} other{{count} more taps to enter vault}}'**
  String appVaultTapsToEnter(int count);

  /// Brief hint while tapping the Library tab the secret number of times to exit the Vault
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 more tap to exit vault} other{{count} more taps to exit vault}}'**
  String appVaultTapsToExit(int count);

  /// Body of the confirm dialog shown before removing a title from the library
  ///
  /// In en, this message translates to:
  /// **'Remove \"{title}\" from your library?'**
  String detailRemoveFromLibraryBody(String title);

  /// Generic fallback used in place of a missing title name in the remove-confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'this title'**
  String get detailThisTitle;

  /// Snackbar shown after tapping the manga title to copy it to the clipboard
  ///
  /// In en, this message translates to:
  /// **'Title copied'**
  String get detailTitleCopied;

  /// Tooltip for the chapter-list sort menu button
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get detailSortBy;

  /// Chapter sort option: keep the source's own ordering
  ///
  /// In en, this message translates to:
  /// **'Source order'**
  String get detailSortSourceOrder;

  /// Chapter sort option: order by chapter number
  ///
  /// In en, this message translates to:
  /// **'Chapter number'**
  String get detailSortChapterNumber;

  /// Chapter sort option: order by upload date
  ///
  /// In en, this message translates to:
  /// **'Upload date'**
  String get detailSortUploadDate;

  /// App-bar title of the in-app WebView opened to log in to a source
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get detailLoginPageTitle;

  /// Snackbar confirming a title was removed from the library
  ///
  /// In en, this message translates to:
  /// **'Removed from library'**
  String get detailRemovedFromLibrary;

  /// Snackbar action to undo removing a title from the library
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get detailUndo;

  /// Bulk-migrate queue position shown in the migrate app bar (current of total)
  ///
  /// In en, this message translates to:
  /// **'{position} of {total}'**
  String detailQueuePosition(int position, int total);

  /// App-bar title of the Reading Insights (Podium) screen
  ///
  /// In en, this message translates to:
  /// **'Reading Insights'**
  String get insightsTitle;

  /// Empty-state title on the Reading Insights screen
  ///
  /// In en, this message translates to:
  /// **'Nothing to rank yet'**
  String get insightsEmptyTitle;

  /// Empty-state body on the Reading Insights screen
  ///
  /// In en, this message translates to:
  /// **'Read a little and your most-read titles show up here.'**
  String get insightsEmptyBody;

  /// Subtitle under total time when no tracking start date is known
  ///
  /// In en, this message translates to:
  /// **'Estimated from your history'**
  String get insightsEstimatedFromHistory;

  /// Subtitle showing the month/year when time tracking began
  ///
  /// In en, this message translates to:
  /// **'Tracked since {month} {year}'**
  String insightsTrackedSince(String month, String year);

  /// Month name used in the 'Tracked since' label
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get insightsMonthJanuary;

  /// Month name used in the 'Tracked since' label
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get insightsMonthFebruary;

  /// Month name used in the 'Tracked since' label
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get insightsMonthMarch;

  /// Month name used in the 'Tracked since' label
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get insightsMonthApril;

  /// Month name used in the 'Tracked since' label
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get insightsMonthMay;

  /// Month name used in the 'Tracked since' label
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get insightsMonthJune;

  /// Month name used in the 'Tracked since' label
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get insightsMonthJuly;

  /// Month name used in the 'Tracked since' label
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get insightsMonthAugust;

  /// Month name used in the 'Tracked since' label
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get insightsMonthSeptember;

  /// Month name used in the 'Tracked since' label
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get insightsMonthOctober;

  /// Month name used in the 'Tracked since' label
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get insightsMonthNovember;

  /// Month name used in the 'Tracked since' label
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get insightsMonthDecember;

  /// Hint shown when the bulk source-migrate FROM list is empty
  ///
  /// In en, this message translates to:
  /// **'No titles in this library to migrate.'**
  String get repoNoTitlesToMigrate;

  /// Hint under the bulk source-migrate TO picker before a FROM source is chosen
  ///
  /// In en, this message translates to:
  /// **'Choose a source to migrate from first.'**
  String get repoChooseSourceFirst;

  /// AI translation provider blurb for Claude (Anthropic)
  ///
  /// In en, this message translates to:
  /// **'Best for nuanced translation'**
  String get trackProviderClaudeDesc;

  /// AI translation provider blurb for OpenAI GPT-4o
  ///
  /// In en, this message translates to:
  /// **'Fast & accurate'**
  String get trackProviderOpenaiDesc;

  /// AI translation provider blurb for Google Gemini
  ///
  /// In en, this message translates to:
  /// **'Multilingual specialist'**
  String get trackProviderGeminiDesc;

  /// AI translation provider blurb for DeepL
  ///
  /// In en, this message translates to:
  /// **'High-quality European languages'**
  String get trackProviderDeeplDesc;

  /// AI translation provider blurb for Hugging Face
  ///
  /// In en, this message translates to:
  /// **'Open-source - Offline capable'**
  String get trackProviderHuggingfaceDesc;

  /// AI translation provider blurb for OpenRouter
  ///
  /// In en, this message translates to:
  /// **'One key, many models - free tier available'**
  String get trackProviderOpenrouterDesc;

  /// Badge shown on the recommended AI translation provider
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get trackBadgeRecommended;

  /// Badge marking an AI provider that works offline
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get trackBadgeOffline;

  /// Badge marking an AI provider that offers free models
  ///
  /// In en, this message translates to:
  /// **'Free models'**
  String get trackBadgeFree;

  /// Appearance settings section header for theme-color palette controls
  ///
  /// In en, this message translates to:
  /// **'Palette'**
  String get setdAppearanceSectionPalette;

  /// Slider title controlling how strongly the theme color tints the app
  ///
  /// In en, this message translates to:
  /// **'Theme color strength'**
  String get setdAppearanceThemeStrength;

  /// Explanation under the Theme color strength slider
  ///
  /// In en, this message translates to:
  /// **'How much the theme color takes over the app. 0 keeps the usual dark or light background; higher tints the whole app with the theme color.'**
  String get setdAppearanceThemeStrengthDesc;

  /// Snackbar shown after a backup is created successfully
  ///
  /// In en, this message translates to:
  /// **'Backup complete'**
  String get setxBackupCreateComplete;

  /// Snackbar shown when creating a backup fails
  ///
  /// In en, this message translates to:
  /// **'Backup failed: {error}'**
  String setxBackupCreateFailed(String error);

  /// Snackbar shown after a compatible-backup export succeeds
  ///
  /// In en, this message translates to:
  /// **'Export complete'**
  String get setxBackupExportComplete;

  /// Snackbar shown when a compatible-backup export fails
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String setxBackupExportFailed(String error);

  /// Dropdown label: which app the compatible backup is made for
  ///
  /// In en, this message translates to:
  /// **'Target app'**
  String get setxBackupTargetApp;

  /// Label above the content-type checkboxes in the export dialog
  ///
  /// In en, this message translates to:
  /// **'Include'**
  String get setxBackupIncludeLabel;

  /// Content-type checkbox label for light novels in the export dialog
  ///
  /// In en, this message translates to:
  /// **'Light novels'**
  String get setxBackupTypeNovels;

  /// Short tag in a backup row marking an automatically-created backup
  ///
  /// In en, this message translates to:
  /// **'auto'**
  String get setxBackupAutoTag;

  /// Setting title: how many chapters to pre-download while reading
  ///
  /// In en, this message translates to:
  /// **'Chapters ahead'**
  String get setdDownloadsChaptersAhead;

  /// Snackbar when cover refresh is tapped with an empty library
  ///
  /// In en, this message translates to:
  /// **'No library items to refresh'**
  String get setdLibraryNoItemsToRefresh;

  /// Progress dialog title while re-fetching library covers
  ///
  /// In en, this message translates to:
  /// **'Refreshing covers'**
  String get setdLibraryRefreshingCovers;

  /// Snackbar when the user cancels the cover refresh
  ///
  /// In en, this message translates to:
  /// **'Cover refresh stopped'**
  String get setdLibraryCoverRefreshStopped;

  /// Snackbar reporting how many covers were refreshed
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Refreshed 1 cover} other{Refreshed {count} covers}}'**
  String setdLibraryCoversRefreshed(int count);

  /// Library settings section header for the continue-reading control
  ///
  /// In en, this message translates to:
  /// **'Continue reading'**
  String get setdLibrarySectionContinueReading;

  /// Choice tile title for how the continue-reading entry is displayed
  ///
  /// In en, this message translates to:
  /// **'Show as'**
  String get setdLibraryContinueShowAs;

  /// Choice tile title for the default category new titles go into
  ///
  /// In en, this message translates to:
  /// **'Default category'**
  String get setdLibraryDefaultCategory;

  /// Default-category option meaning the app asks each time (maps to no fixed category)
  ///
  /// In en, this message translates to:
  /// **'Always ask'**
  String get setdLibraryAlwaysAsk;

  /// Library-update restriction switch title
  ///
  /// In en, this message translates to:
  /// **'Skip titles with unread chapters'**
  String get setdLibrarySkipHasUnread;

  /// Subtitle for the skip-unread restriction switch
  ///
  /// In en, this message translates to:
  /// **'Don\'t check titles you haven\'t caught up on yet'**
  String get setdLibrarySkipHasUnreadDesc;

  /// Library-update restriction switch title
  ///
  /// In en, this message translates to:
  /// **'Skip completed series'**
  String get setdLibrarySkipCompleted;

  /// Subtitle for the skip-completed restriction switch
  ///
  /// In en, this message translates to:
  /// **'Finished series won\'t get new chapters'**
  String get setdLibrarySkipCompletedDesc;

  /// Nav tile title to re-fetch all library covers
  ///
  /// In en, this message translates to:
  /// **'Refresh library covers'**
  String get setdLibraryRefreshCovers;

  /// Subtitle for the refresh-library-covers nav tile
  ///
  /// In en, this message translates to:
  /// **'Fetch covers again from source'**
  String get setdLibraryRefreshCoversDesc;

  /// Generic Move button in dialogs.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get setdActionMove;

  /// Generic Confirm button in dialogs.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get setdActionConfirm;

  /// Generic Remove button in dialogs.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get setdActionRemove;

  /// Generic Undo action on a snackbar.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get setdActionUndo;

  /// Title of the idle-timeout selector controlling how long before the app re-locks.
  ///
  /// In en, this message translates to:
  /// **'Lock after'**
  String get setxSecurityLockAfterTitle;

  /// Subtitle explaining the lock-after delay.
  ///
  /// In en, this message translates to:
  /// **'Wait this long before re-locking on reopen'**
  String get setxSecurityLockAfterSubtitle;

  /// Lock-after option: re-lock with no delay.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get setxSecurityLockAfterImmediately;

  /// Lock-after delay option in minutes; {count} is the number of minutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute} other{{count} minutes}}'**
  String setxSecurityLockAfterMinutes(int count);

  /// Nav tile title to change the existing decoy password.
  ///
  /// In en, this message translates to:
  /// **'Change decoy password'**
  String get setdVaultChangeDecoyPassword;

  /// Nav tile / dialog title to set a decoy password (used when none exists).
  ///
  /// In en, this message translates to:
  /// **'Set decoy password'**
  String get setdVaultSetDecoyPassword;

  /// Subtitle under the decoy-password tile.
  ///
  /// In en, this message translates to:
  /// **'A second password that opens a separate, empty-looking vault'**
  String get setdVaultDecoyPasswordDesc;

  /// Toggle title for biometric vault unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock with biometrics'**
  String get setdVaultBiometricUnlock;

  /// Subtitle under the biometric-unlock toggle.
  ///
  /// In en, this message translates to:
  /// **'Use Face ID / fingerprint to open the vault'**
  String get setdVaultBiometricDesc;

  /// Dialog title prompting the user to re-enter the vault password.
  ///
  /// In en, this message translates to:
  /// **'Confirm vault password'**
  String get setdVaultConfirmPasswordTitle;

  /// Snackbar after enabling biometric unlock.
  ///
  /// In en, this message translates to:
  /// **'Biometric unlock enabled'**
  String get setdVaultBiometricEnabled;

  /// Toggle title for shake-to-exit-the-vault.
  ///
  /// In en, this message translates to:
  /// **'Shake to exit'**
  String get setdVaultShakeToExit;

  /// Subtitle under the shake-to-exit toggle.
  ///
  /// In en, this message translates to:
  /// **'While in the vault, shake the phone to instantly leave it'**
  String get setdVaultShakeToExitDesc;

  /// Toggle title to add a move-to-vault action in the library.
  ///
  /// In en, this message translates to:
  /// **'Move-to-vault in library'**
  String get setdVaultLibraryMoveAction;

  /// Subtitle under the library move-to-vault toggle.
  ///
  /// In en, this message translates to:
  /// **'Add a \"Move to vault\" action when selecting titles in your library'**
  String get setdVaultLibraryMoveActionDesc;

  /// Hint text in the vault password field.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get setdVaultPasswordHint;

  /// Title of the decoy-password dialog when a decoy already exists.
  ///
  /// In en, this message translates to:
  /// **'Decoy password'**
  String get setdVaultDecoyPasswordDialogTitle;

  /// Explanatory body text in the decoy-password dialog.
  ///
  /// In en, this message translates to:
  /// **'Entering this instead of your real password opens a separate, isolated vault - so you can hand over the phone without revealing your real content.'**
  String get setdVaultDecoyPasswordExplain;

  /// Hint text in the decoy-password field.
  ///
  /// In en, this message translates to:
  /// **'Decoy password'**
  String get setdVaultDecoyPasswordHint;

  /// Validation error when the decoy password field is empty.
  ///
  /// In en, this message translates to:
  /// **'Enter a password'**
  String get setdVaultEnterPassword;

  /// Snackbar after saving the decoy password.
  ///
  /// In en, this message translates to:
  /// **'Decoy password set'**
  String get setdVaultDecoyPasswordSet;

  /// Validation error when the decoy password equals the real password.
  ///
  /// In en, this message translates to:
  /// **'Must differ from your real password'**
  String get setdVaultDecoyMustDiffer;

  /// Snackbar after moving items into the vault; {count} is how many moved.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Moved 1 to vault} other{Moved {count} to vault}}'**
  String setdVaultContentsMovedInCount(int count);

  /// Snackbar after moving items out of the vault; {count} is how many moved.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Moved 1 out of vault} other{Moved {count} out of vault}}'**
  String setdVaultContentsMovedOutCount(int count);

  /// Move-confirmation dialog title; {what} describes the selection being moved (e.g. 'all 5 shown').
  ///
  /// In en, this message translates to:
  /// **'Move {what}?'**
  String setdVaultContentsMoveConfirmTitle(String what);

  /// Move-confirmation dialog body; {count} titles, {dest} destination phrase (the vault / your library), {into} optional category suffix.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Move 1 title to {dest}{into}?} other{Move {count} titles to {dest}{into}?}}'**
  String setdVaultContentsMoveConfirmBody(int count, String dest, String into);

  /// Destination phrase (into the vault) used in the move-confirmation body.
  ///
  /// In en, this message translates to:
  /// **'the vault'**
  String get setdVaultContentsDestVault;

  /// Destination phrase (into the library) used in the move-confirmation body.
  ///
  /// In en, this message translates to:
  /// **'your library'**
  String get setdVaultContentsDestLibrary;

  /// Optional category suffix appended to the move destination; {name} is the destination category. Leading space + arrow are UI punctuation.
  ///
  /// In en, this message translates to:
  /// **' → \"{name}\"'**
  String setdVaultContentsIntoCategory(String name);

  /// Describes moving every shown title; used as the {what} in the confirm title. {count} is how many are shown.
  ///
  /// In en, this message translates to:
  /// **'all {count} shown'**
  String setdVaultContentsMoveAllShown(int count);

  /// Describes moving every title in a category; used as the {what} in the confirm title. {name} is the category.
  ///
  /// In en, this message translates to:
  /// **'everything in \"{name}\"'**
  String setdVaultContentsMoveEverythingIn(String name);

  /// Empty-state shown when a title search yields nothing.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get setdVaultContentsNoMatches;

  /// App-bar tooltip to leave selection mode.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get setdVaultContentsDone;

  /// App-bar tooltip to enter selection mode.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get setdVaultContentsSelect;

  /// Direction toggle: move titles into the vault.
  ///
  /// In en, this message translates to:
  /// **'To Vault'**
  String get setdVaultContentsDirToVault;

  /// Direction toggle: move titles out of the vault.
  ///
  /// In en, this message translates to:
  /// **'From Vault'**
  String get setdVaultContentsDirFromVault;

  /// Hint text in the title search field.
  ///
  /// In en, this message translates to:
  /// **'Search titles'**
  String get setdVaultContentsSearchHint;

  /// Tooltip for the move-a-whole-category button.
  ///
  /// In en, this message translates to:
  /// **'Move a category'**
  String get setdVaultContentsMoveCategoryTooltip;

  /// Tooltip for the move-all button when moving into the vault.
  ///
  /// In en, this message translates to:
  /// **'Move all to vault'**
  String get setdVaultContentsMoveAllToVault;

  /// Tooltip for the move-all button when moving out of the vault.
  ///
  /// In en, this message translates to:
  /// **'Move all out'**
  String get setdVaultContentsMoveAllOut;

  /// Selection-bar button to deselect all.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get setdVaultContentsSelectNone;

  /// Selection-bar button to select all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get setdVaultContentsSelectAll;

  /// Count of selected items in the selection bar.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 selected} other{{count} selected}}'**
  String setdVaultContentsSelectedCount(int count);

  /// Button/tooltip to move the selection or an item into the vault.
  ///
  /// In en, this message translates to:
  /// **'Move to vault'**
  String get setdVaultContentsMoveToVault;

  /// Button/tooltip to move the selection or an item out of the vault.
  ///
  /// In en, this message translates to:
  /// **'Move out'**
  String get setdVaultContentsMoveOut;

  /// Category-picker title when choosing which library category to move.
  ///
  /// In en, this message translates to:
  /// **'Move which library category?'**
  String get setdVaultContentsPickSourceLibrary;

  /// Category-picker title when choosing which vault category to move.
  ///
  /// In en, this message translates to:
  /// **'Move which vault category?'**
  String get setdVaultContentsPickSourceVault;

  /// Category-picker title when choosing the destination vault category.
  ///
  /// In en, this message translates to:
  /// **'Into which vault category?'**
  String get setdVaultContentsPickDestVault;

  /// Category-picker title when choosing the destination library category.
  ///
  /// In en, this message translates to:
  /// **'Into which library category?'**
  String get setdVaultContentsPickDestLibrary;

  /// Empty state in the category picker.
  ///
  /// In en, this message translates to:
  /// **'No categories to pick from.'**
  String get setdVaultContentsNoCategoriesToPick;

  /// Category-picker option to pick no category.
  ///
  /// In en, this message translates to:
  /// **'No category'**
  String get setdVaultContentsNoCategory;

  /// Snackbar when a chosen category has no titles; {name} is the category.
  ///
  /// In en, this message translates to:
  /// **'Nothing in \"{name}\"'**
  String setdVaultContentsNothingIn(String name);

  /// Subtitle for the Help & Tips entry on the main settings screen.
  ///
  /// In en, this message translates to:
  /// **'Tutorial, Discord & quick tips'**
  String get settingsHelpSubtitle;

  /// Shown in the dictionary sheet when no lookup source could be reached.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the dictionary. Check your connection and try again.'**
  String get dictNetworkError;

  /// Dictionary sheet message when the word has no entry.
  ///
  /// In en, this message translates to:
  /// **'No definition found for \"{word}\".'**
  String dictNoDefinition(String word);

  /// Novel reader text alignment setting title.
  ///
  /// In en, this message translates to:
  /// **'Alignment'**
  String get readerAlignment;

  /// Reader eye-comfort brightness slider title.
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get readerBrightness;

  /// Filler line shown in the gaze-calibration scroll test.
  ///
  /// In en, this message translates to:
  /// **'Sample line {n}'**
  String readerCalibrateSampleLine(int n);

  /// Subtitle for the radial-menu chapter-arrows toggle.
  ///
  /// In en, this message translates to:
  /// **'Prev / next chapter beside the page slider'**
  String get readerChapterArrowsSubtitle;

  /// Title for the radial-menu chapter-arrows toggle (manga).
  ///
  /// In en, this message translates to:
  /// **'Chapter arrows on the slider'**
  String get readerChapterArrowsTitle;

  /// Nav tile title opening the radial-menu action editor.
  ///
  /// In en, this message translates to:
  /// **'Customize menu'**
  String get readerCustomizeMenu;

  /// Subtitle for the manga radial-menu customize tile.
  ///
  /// In en, this message translates to:
  /// **'Choose and reorder the manga actions'**
  String get readerCustomizeMenuMangaSubtitle;

  /// Subtitle for the light-novel radial-menu customize tile.
  ///
  /// In en, this message translates to:
  /// **'Choose and reorder the light novel actions'**
  String get readerCustomizeMenuNovelSubtitle;

  /// Reader display toggle: show two pages side by side in landscape.
  ///
  /// In en, this message translates to:
  /// **'Double pages'**
  String get readerDoublePages;

  /// Subtitle for the double-pages toggle.
  ///
  /// In en, this message translates to:
  /// **'Show two pages side-by-side when the phone is in landscape (page-by-page modes only)'**
  String get readerDoublePagesSubtitle;

  /// Intro paragraph on the Hands-free & motion settings page.
  ///
  /// In en, this message translates to:
  /// **'Scroll or turn pages without touching the screen. These share one scroll input, so turning one on turns the others off.'**
  String get readerHandsFreeIntro;

  /// Title of the Hands-free & motion settings page / nav tile.
  ///
  /// In en, this message translates to:
  /// **'Hands-free & motion'**
  String get readerHandsFreeMotion;

  /// Subtitle for the Hands-free & motion nav tile.
  ///
  /// In en, this message translates to:
  /// **'Volume buttons, tilt and gaze scrolling'**
  String get readerHandsFreeMotionSubtitle;

  /// Novel reader hyphenation toggle title.
  ///
  /// In en, this message translates to:
  /// **'Hyphenation'**
  String get readerHyphenation;

  /// Subtitle for the hyphenation toggle.
  ///
  /// In en, this message translates to:
  /// **'Break long words to even out justified lines'**
  String get readerHyphenationSubtitle;

  /// Label for the light-novel reader (segmented control / tab).
  ///
  /// In en, this message translates to:
  /// **'Light novel'**
  String get readerLightNovel;

  /// App bar title of the light-novel radial-menu editor.
  ///
  /// In en, this message translates to:
  /// **'Light novel menu'**
  String get readerLightNovelMenu;

  /// Novel reader line-spacing slider title.
  ///
  /// In en, this message translates to:
  /// **'Line spacing'**
  String get readerLineSpacing;

  /// Label for the manga reader (segmented control / tab).
  ///
  /// In en, this message translates to:
  /// **'Manga'**
  String get readerManga;

  /// App bar title of the manga radial-menu editor.
  ///
  /// In en, this message translates to:
  /// **'Manga menu'**
  String get readerMangaMenu;

  /// Novel reader margins slider title.
  ///
  /// In en, this message translates to:
  /// **'Margins'**
  String get readerMargins;

  /// Radial-menu style choice title (wheel vs tail).
  ///
  /// In en, this message translates to:
  /// **'Menu style'**
  String get readerMenuStyle;

  /// Radial-menu style option: tail.
  ///
  /// In en, this message translates to:
  /// **'Tail'**
  String get readerMenuStyleTail;

  /// Radial-menu style option: wheel.
  ///
  /// In en, this message translates to:
  /// **'Wheel'**
  String get readerMenuStyleWheel;

  /// Compact reading-mode label: left-to-right.
  ///
  /// In en, this message translates to:
  /// **'LTR'**
  String get readerModeLtrShort;

  /// Compact reading-mode label: right-to-left.
  ///
  /// In en, this message translates to:
  /// **'RTL'**
  String get readerModeRtlShort;

  /// Compact reading-mode label: vertical/continuous.
  ///
  /// In en, this message translates to:
  /// **'Vertical'**
  String get readerModeVerticalShort;

  /// Novel reading-mode option: paged.
  ///
  /// In en, this message translates to:
  /// **'Paged'**
  String get readerNovelLayoutPaged;

  /// Novel reading-mode option: scroll.
  ///
  /// In en, this message translates to:
  /// **'Scroll'**
  String get readerNovelLayoutScroll;

  /// Subtitle for the novel radial-menu toggle.
  ///
  /// In en, this message translates to:
  /// **'Use the wheel in the novel reader (off = classic bars)'**
  String get readerNovelRadialMenuSubtitle;

  /// Novel reader TTS pitch slider title.
  ///
  /// In en, this message translates to:
  /// **'Pitch'**
  String get readerPitch;

  /// Hint above the radial-menu action reorder list.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder the wheel; toggle to show or hide. {count} shown.'**
  String readerRadialReorderHint(int count);

  /// Novel reader theme choice title.
  ///
  /// In en, this message translates to:
  /// **'Reader theme'**
  String get readerReaderTheme;

  /// Reset button in the radial-menu editor.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get readerReset;

  /// Reader settings section header.
  ///
  /// In en, this message translates to:
  /// **'Eye comfort'**
  String get readerSectionEyeComfort;

  /// Reader settings section header.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get readerSectionImage;

  /// Novel reader settings section header.
  ///
  /// In en, this message translates to:
  /// **'Layout'**
  String get readerSectionLayout;

  /// Novel reader settings section header for TTS.
  ///
  /// In en, this message translates to:
  /// **'Listen (text to speech)'**
  String get readerSectionListen;

  /// Novel reader settings section header.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get readerSectionText;

  /// TTS sentence highlight colour picker title.
  ///
  /// In en, this message translates to:
  /// **'Sentence highlight'**
  String get readerSentenceHighlight;

  /// Segmented control title choosing which reader's settings to show.
  ///
  /// In en, this message translates to:
  /// **'Settings for'**
  String get readerSettingsFor;

  /// Radial-menu wheel corner option: left.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get readerSideLeft;

  /// Radial-menu wheel corner option: right.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get readerSideRight;

  /// Reader toggle to give wide spreads their own screen.
  ///
  /// In en, this message translates to:
  /// **'Split wide pages'**
  String get readerSplitWidePages;

  /// Subtitle for the split-wide-pages toggle.
  ///
  /// In en, this message translates to:
  /// **'Give a wide double-page spread its own screen instead of pairing it with another page'**
  String get readerSplitWidePagesSubtitle;

  /// Novel reader text-size slider title.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get readerTextSize;

  /// iOS-only volume-buttons toggle title on Hands-free page.
  ///
  /// In en, this message translates to:
  /// **'Volume sets auto-scroll speed'**
  String get readerVolumeAutoScroll;

  /// Subtitle for the iOS volume auto-scroll toggle.
  ///
  /// In en, this message translates to:
  /// **'While the manga reader auto-scrolls, the volume buttons speed it up or slow it down. They do not turn pages.'**
  String get readerVolumeAutoScrollSubtitle;

  /// Hands-free page section header for volume-button controls.
  ///
  /// In en, this message translates to:
  /// **'Volume buttons'**
  String get readerVolumeButtons;

  /// Reader eye-comfort warm-tint slider title.
  ///
  /// In en, this message translates to:
  /// **'Warm filter'**
  String get readerWarmFilter;

  /// TTS word highlight colour picker title.
  ///
  /// In en, this message translates to:
  /// **'Word highlight'**
  String get readerWordHighlight;

  /// Title of the library-update summary bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Library update'**
  String get libraryUpdateTitle;

  /// Summary line of a library update run (also used in the drop-down banner).
  ///
  /// In en, this message translates to:
  /// **'{completed} completed · {skipped} skipped · {failed} failed'**
  String libraryUpdateCounts(int completed, int skipped, int failed);

  /// How many new chapters a title gained in an update.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 new chapter} other{{count} new chapters}}'**
  String libraryNewChaptersCount(int count);

  /// Subtitle for an updated title that gained no new chapters.
  ///
  /// In en, this message translates to:
  /// **'Up to date'**
  String get libraryUpToDate;

  /// Header for titles skipped during a library update.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get librarySkipped;

  /// Button to force-update the N skipped titles.
  ///
  /// In en, this message translates to:
  /// **'Update {count}'**
  String libraryUpdateCount(int count);

  /// Subtitle for a skipped title that can still be force-updated; status is the publication status.
  ///
  /// In en, this message translates to:
  /// **'{status} · tap Update to force'**
  String libraryStatusTapUpdate(String status);

  /// Subtitle for a skipped title not expected to gain chapters; status is the publication status.
  ///
  /// In en, this message translates to:
  /// **'{status} · no new chapters expected'**
  String libraryStatusNoNewChapters(String status);

  /// Tooltip on the per-title force-update icon button.
  ///
  /// In en, this message translates to:
  /// **'Update this title'**
  String get libraryUpdateThisTitle;

  /// Header for titles that failed to update.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get libraryFailed;

  /// Action to retry every failed title.
  ///
  /// In en, this message translates to:
  /// **'Retry all'**
  String get libraryRetryAll;

  /// Subtitle for a title whose update failed.
  ///
  /// In en, this message translates to:
  /// **'Update failed · tap to open'**
  String get libraryUpdateFailedTapOpen;

  /// Tooltip on the per-title retry icon button.
  ///
  /// In en, this message translates to:
  /// **'Retry this title'**
  String get libraryRetryThisTitle;

  /// Shown when an update run checked nothing.
  ///
  /// In en, this message translates to:
  /// **'No titles were checked.'**
  String get libraryNoTitlesChecked;

  /// A section header followed by its item count, e.g. 'Completed (3)'.
  ///
  /// In en, this message translates to:
  /// **'{label} ({count})'**
  String libraryCategoryWithCount(String label, int count);

  /// Updates-summary dialog line counting entries with new chapters.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 entry has new chapters.} other{{count} entries have new chapters.}}'**
  String libraryEntriesWithNewChapters(int count);

  /// Snackbar shown when trying to move titles into a locked vault.
  ///
  /// In en, this message translates to:
  /// **'Unlock the vault first to move titles into it'**
  String get libraryUnlockVaultFirst;

  /// Snackbar on a failed move into the vault.
  ///
  /// In en, this message translates to:
  /// **'Could not move to vault'**
  String get libraryCouldNotMoveToVault;

  /// Snackbar on a failed move out of the vault.
  ///
  /// In en, this message translates to:
  /// **'Could not move out of vault'**
  String get libraryCouldNotMoveOutOfVault;

  /// Snackbar confirming N titles moved into the vault.
  ///
  /// In en, this message translates to:
  /// **'Moved {count} to vault'**
  String libraryMovedToVault(int count);

  /// Snackbar confirming N titles moved out of the vault.
  ///
  /// In en, this message translates to:
  /// **'Moved {count} out of vault'**
  String libraryMovedOutOfVault(int count);

  /// Batch-action label: move selected titles out of the vault.
  ///
  /// In en, this message translates to:
  /// **'Move out'**
  String get libraryMoveOut;

  /// Batch-action label: move selected titles into the vault.
  ///
  /// In en, this message translates to:
  /// **'To vault'**
  String get libraryToVault;

  /// Banner text when a library update finishes with no detail.
  ///
  /// In en, this message translates to:
  /// **'Update complete'**
  String get libraryUpdateComplete;

  /// Live progress banner during a library update (title may be empty).
  ///
  /// In en, this message translates to:
  /// **'Updating {title}  {checked}/{total}'**
  String libraryUpdatingProgress(String title, int checked, int total);

  /// Banner text while a library update is starting.
  ///
  /// In en, this message translates to:
  /// **'Updating…'**
  String get libraryUpdating;

  /// Hint under the update banner when retry/force actions are available.
  ///
  /// In en, this message translates to:
  /// **'Tap to retry / update skipped'**
  String get libraryTapRetryUpdateSkipped;

  /// Section header for the library sort options (shown uppercased).
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get librarySortBy;

  /// Section header for how a title is shown on a library card (shown uppercased).
  ///
  /// In en, this message translates to:
  /// **'Cover title'**
  String get libraryCoverTitle;

  /// Section header for where badges sit on a library card (shown uppercased).
  ///
  /// In en, this message translates to:
  /// **'Badge placement'**
  String get libraryBadgePlacement;

  /// Section header for the reading-progress display style on cards (shown uppercased).
  ///
  /// In en, this message translates to:
  /// **'Reading progress'**
  String get libraryReadingProgress;

  /// Label for the source-language card badge (toggle and legend).
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get libraryLanguage;

  /// Label for the local-source card badge (toggle and legend).
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get libraryLocal;

  /// Filter legend: a check mark means show only matching entries.
  ///
  /// In en, this message translates to:
  /// **'show only'**
  String get libraryFilterShowOnly;

  /// Filter legend: a cross mark means hide matching entries.
  ///
  /// In en, this message translates to:
  /// **'hide'**
  String get libraryFilterHide;

  /// Reading-personality archetype name for a user who hasn't started reading.
  ///
  /// In en, this message translates to:
  /// **'The Newcomer'**
  String get libraryArchetypeNewcomer;

  /// Description of The Newcomer archetype.
  ///
  /// In en, this message translates to:
  /// **'Just getting started - your type sharpens as you read.'**
  String get libraryArchetypeNewcomerDesc;

  /// Reading-personality archetype name for someone reading all formats.
  ///
  /// In en, this message translates to:
  /// **'The Omnivore'**
  String get libraryArchetypeOmnivore;

  /// Description of The Omnivore archetype.
  ///
  /// In en, this message translates to:
  /// **'A bit of everything - manga, anime and novels all in rotation.'**
  String get libraryArchetypeOmnivoreDesc;

  /// Reading-personality archetype name for high-volume reading.
  ///
  /// In en, this message translates to:
  /// **'The Binger'**
  String get libraryArchetypeBinger;

  /// Description of The Binger archetype.
  ///
  /// In en, this message translates to:
  /// **'You tear through chapters in long sittings.'**
  String get libraryArchetypeBingerDesc;

  /// Reading-personality archetype name for deep reading of few series.
  ///
  /// In en, this message translates to:
  /// **'The Completionist'**
  String get libraryArchetypeCompletionist;

  /// Description of The Completionist archetype.
  ///
  /// In en, this message translates to:
  /// **'You go deep - few series at a time, read to the end.'**
  String get libraryArchetypeCompletionistDesc;

  /// Reading-personality archetype name for a consistent daily habit.
  ///
  /// In en, this message translates to:
  /// **'The Devoted'**
  String get libraryArchetypeDevoted;

  /// Description of The Devoted archetype.
  ///
  /// In en, this message translates to:
  /// **'Day after day - you keep a steady habit.'**
  String get libraryArchetypeDevotedDesc;

  /// Reading-personality archetype name for spreading across many series.
  ///
  /// In en, this message translates to:
  /// **'The Explorer'**
  String get libraryArchetypeExplorer;

  /// Description of The Explorer archetype.
  ///
  /// In en, this message translates to:
  /// **'Always something new - you spread across many series.'**
  String get libraryArchetypeExplorerDesc;

  /// Chapters-read chip on the reading-personality card.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 chapter} other{{count} chapters}}'**
  String libraryChaptersCount(int count);

  /// Best reading-streak chip on the personality card.
  ///
  /// In en, this message translates to:
  /// **'{days}-day best streak'**
  String libraryBestStreakDays(int days);

  /// Series-started chip on the personality card (shown when there is no streak).
  ///
  /// In en, this message translates to:
  /// **'{count} series'**
  String librarySeriesCount(int count);

  /// Stats section header for the activity heatmap.
  ///
  /// In en, this message translates to:
  /// **'Reading activity'**
  String get libraryReadingActivity;

  /// Caption under the activity heatmap explaining cell brightness.
  ///
  /// In en, this message translates to:
  /// **'Chapters read each day - brighter = more.'**
  String get libraryChaptersPerDayHint;

  /// Stats section header for the manga/anime/novels breakdown.
  ///
  /// In en, this message translates to:
  /// **'Library by type'**
  String get libraryByType;

  /// Stats section header for the reading-status breakdown.
  ///
  /// In en, this message translates to:
  /// **'Library by status'**
  String get libraryByStatus;

  /// Stats section header for titles added but never started.
  ///
  /// In en, this message translates to:
  /// **'Backlog'**
  String get libraryBacklog;

  /// Pill badge: number of titles in the backlog.
  ///
  /// In en, this message translates to:
  /// **'{count} waiting'**
  String libraryWaitingCount(int count);

  /// Caption under the Backlog section header.
  ///
  /// In en, this message translates to:
  /// **'Added but never started'**
  String get libraryAddedNeverStarted;

  /// Shown when the backlog is empty.
  ///
  /// In en, this message translates to:
  /// **'Nothing waiting - you\'ve started everything.'**
  String get libraryNothingWaiting;

  /// Stats section header for the achievement badges.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get libraryMilestones;

  /// Stats section header for the archetype/radar card.
  ///
  /// In en, this message translates to:
  /// **'Reading personality'**
  String get libraryReadingPersonality;

  /// Caption under the total-time hero tile; tapping opens the podium.
  ///
  /// In en, this message translates to:
  /// **'Total time read · tap for breakdown'**
  String get libraryTotalTimeRead;

  /// Stat tile label: number of titles in the library.
  ///
  /// In en, this message translates to:
  /// **'Titles'**
  String get libraryStatTitles;

  /// Stat tile label: total chapters actively read.
  ///
  /// In en, this message translates to:
  /// **'Chapters read'**
  String get libraryStatChaptersRead;

  /// Stat tile label: current consecutive-day reading streak.
  ///
  /// In en, this message translates to:
  /// **'Day streak'**
  String get libraryStatDayStreak;

  /// Summary sentence under the activity heatmap.
  ///
  /// In en, this message translates to:
  /// **'You read on {activeDays} of the last 35 days · {chapters} chapters this week.'**
  String libraryActivitySummary(int activeDays, int chapters);

  /// This week's reading change versus last week (magnitude only; an arrow shows direction).
  ///
  /// In en, this message translates to:
  /// **'{pct}% vs last week'**
  String libraryTrendVsLastWeek(int pct);

  /// Status-breakdown bucket for titles not Reading/Completed/On Hold.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get libraryStatusOther;

  /// Chip naming the user's most-read genre.
  ///
  /// In en, this message translates to:
  /// **'Most-read genre · {genre}'**
  String libraryMostReadGenre(String genre);

  /// Lowercase content noun inserted mid-sentence in the empty-stats message.
  ///
  /// In en, this message translates to:
  /// **'manga'**
  String get libraryContentWordManga;

  /// Lowercase content noun inserted mid-sentence in the empty-stats message.
  ///
  /// In en, this message translates to:
  /// **'anime'**
  String get libraryContentWordAnime;

  /// Lowercase content noun inserted mid-sentence in the empty-stats message.
  ///
  /// In en, this message translates to:
  /// **'light novels'**
  String get libraryContentWordLightNovels;

  /// Backlog row subtitle: relative time since the title was added, plus its content type.
  ///
  /// In en, this message translates to:
  /// **'Added {age} · {type}'**
  String libraryBacklogAddedAge(String age, String type);

  /// Pill button to start reading a backlog title.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get libraryStart;

  /// Shown on the milestones card when every badge is earned.
  ///
  /// In en, this message translates to:
  /// **'All milestones unlocked 🎉'**
  String get libraryAllMilestonesUnlocked;

  /// Label above the next milestone to earn (shown uppercased).
  ///
  /// In en, this message translates to:
  /// **'NEXT UP'**
  String get libraryNextUp;

  /// Label above the reading-personality archetype (shown uppercased).
  ///
  /// In en, this message translates to:
  /// **'YOUR READING TYPE'**
  String get libraryYourReadingType;

  /// Reading-personality radar axis label.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get libraryAxisVolume;

  /// Reading-personality radar axis label.
  ///
  /// In en, this message translates to:
  /// **'Depth'**
  String get libraryAxisDepth;

  /// Reading-personality radar axis label, abbreviation of 'Consistency' (keep short to fit).
  ///
  /// In en, this message translates to:
  /// **'Consist.'**
  String get libraryAxisConsistency;

  /// Reading-personality radar axis label.
  ///
  /// In en, this message translates to:
  /// **'Breadth'**
  String get libraryAxisBreadth;

  /// Reading-personality radar axis label.
  ///
  /// In en, this message translates to:
  /// **'Variety'**
  String get libraryAxisVariety;

  /// Short unit for chapters in milestone captions, e.g. '500 ch'.
  ///
  /// In en, this message translates to:
  /// **'ch'**
  String get libraryUnitChapters;

  /// Short unit for hours in milestone captions, e.g. '100 h'.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get libraryUnitHours;

  /// Unit for day-streak milestone captions, e.g. '30 days'.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get libraryUnitDays;

  /// Unit for collection milestone captions, e.g. '100 titles'.
  ///
  /// In en, this message translates to:
  /// **'titles'**
  String get libraryUnitTitles;

  /// Unit for source-breadth milestone captions, e.g. '15 sources'.
  ///
  /// In en, this message translates to:
  /// **'sources'**
  String get libraryUnitSources;

  /// Unit for format-variety milestone captions, e.g. '3 formats'.
  ///
  /// In en, this message translates to:
  /// **'formats'**
  String get libraryUnitFormats;

  /// Short unit for anime episodes in milestone captions, e.g. '250 ep'.
  ///
  /// In en, this message translates to:
  /// **'ep'**
  String get libraryUnitEpisodes;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'First Steps'**
  String get libraryBadgeFirstSteps;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Read your first chapter.'**
  String get libraryBadgeFirstStepsDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get libraryBadgeGettingStarted;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Read 10 chapters.'**
  String get libraryBadgeGettingStartedDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Bookworm'**
  String get libraryBadgeBookworm;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Read 50 chapters.'**
  String get libraryBadgeBookwormDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Centurion'**
  String get libraryBadgeCenturion;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Read 100 chapters.'**
  String get libraryBadgeCenturionDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Devourer'**
  String get libraryBadgeDevourer;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Read 250 chapters.'**
  String get libraryBadgeDevourerDesc;

  /// Milestone badge name (500).
  ///
  /// In en, this message translates to:
  /// **'Quincentenary'**
  String get libraryBadgeQuincentenary;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Read 500 chapters.'**
  String get libraryBadgeQuincentenaryDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Marathoner'**
  String get libraryBadgeMarathoner;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Read 1,000 chapters.'**
  String get libraryBadgeMarathonerDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Chapter Fiend'**
  String get libraryBadgeChapterFiend;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Read 2,500 chapters.'**
  String get libraryBadgeChapterFiendDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Loremaster'**
  String get libraryBadgeLoremaster;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Read 5,000 chapters.'**
  String get libraryBadgeLoremasterDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Ten-Thousand Club'**
  String get libraryBadgeTenThousandClub;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Read 10,000 chapters.'**
  String get libraryBadgeTenThousandClubDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'First Hour'**
  String get libraryBadgeFirstHour;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Spend 1 hour reading.'**
  String get libraryBadgeFirstHourDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Getting Comfortable'**
  String get libraryBadgeGettingComfortable;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Spend 10 hours reading.'**
  String get libraryBadgeGettingComfortableDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Weekend Lost'**
  String get libraryBadgeWeekendLost;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Spend 50 hours reading.'**
  String get libraryBadgeWeekendLostDesc;

  /// Milestone badge name (hours).
  ///
  /// In en, this message translates to:
  /// **'Dedicated'**
  String get libraryBadgeDedicated;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Spend 100 hours reading.'**
  String get libraryBadgeDedicatedDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Time Sink'**
  String get libraryBadgeTimeSink;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Spend 250 hours reading.'**
  String get libraryBadgeTimeSinkDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Immersed'**
  String get libraryBadgeImmersed;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Spend 500 hours reading.'**
  String get libraryBadgeImmersedDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Eternal'**
  String get libraryBadgeEternal;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Spend 1,000 hours reading.'**
  String get libraryBadgeEternalDesc;

  /// Milestone badge name (streak).
  ///
  /// In en, this message translates to:
  /// **'Warming Up'**
  String get libraryBadgeWarmingUp;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Read 3 days in a row.'**
  String get libraryBadgeWarmingUpDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Hot Streak'**
  String get libraryBadgeHotStreak;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Read 7 days in a row.'**
  String get libraryBadgeHotStreakDesc;

  /// Milestone badge name (14-day streak).
  ///
  /// In en, this message translates to:
  /// **'Fortnight'**
  String get libraryBadgeFortnight;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Read 14 days in a row.'**
  String get libraryBadgeFortnightDesc;

  /// Milestone badge name (30-day streak). Distinct from the 'The Devoted' personality archetype.
  ///
  /// In en, this message translates to:
  /// **'Devoted'**
  String get libraryBadgeDevoted;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Read 30 days in a row.'**
  String get libraryBadgeDevotedDesc;

  /// Milestone badge name (collection).
  ///
  /// In en, this message translates to:
  /// **'Starter Shelf'**
  String get libraryBadgeStarterShelf;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Collect 10 titles.'**
  String get libraryBadgeStarterShelfDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Bibliophile'**
  String get libraryBadgeBibliophile;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Collect 50 titles.'**
  String get libraryBadgeBibliophileDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Curator'**
  String get libraryBadgeCurator;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Collect 100 titles.'**
  String get libraryBadgeCuratorDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Archivist'**
  String get libraryBadgeArchivist;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Collect 250 titles.'**
  String get libraryBadgeArchivistDesc;

  /// Milestone badge name (sources). Distinct from the 'The Explorer' personality archetype.
  ///
  /// In en, this message translates to:
  /// **'Explorer'**
  String get libraryBadgeExplorer;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Read from 5 sources.'**
  String get libraryBadgeExplorerDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Globetrotter'**
  String get libraryBadgeGlobetrotter;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Read from 15 sources.'**
  String get libraryBadgeGlobetrotterDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Boundless'**
  String get libraryBadgeBoundless;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Read from 30 sources.'**
  String get libraryBadgeBoundlessDesc;

  /// Milestone badge name (formats).
  ///
  /// In en, this message translates to:
  /// **'Dabbler'**
  String get libraryBadgeDabbler;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Read 2 different formats.'**
  String get libraryBadgeDabblerDesc;

  /// Milestone badge name. Distinct from the 'The Omnivore' personality archetype.
  ///
  /// In en, this message translates to:
  /// **'Omnivore'**
  String get libraryBadgeOmnivore;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Read all 3 formats.'**
  String get libraryBadgeOmnivoreDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Manga Devotee'**
  String get libraryBadgeMangaDevotee;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Read 500 manga chapters.'**
  String get libraryBadgeMangaDevoteeDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Binge Watcher'**
  String get libraryBadgeBingeWatcher;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Watch 250 anime episodes.'**
  String get libraryBadgeBingeWatcherDesc;

  /// Milestone badge name.
  ///
  /// In en, this message translates to:
  /// **'Novel Nerd'**
  String get libraryBadgeNovelNerd;

  /// Milestone badge tooltip.
  ///
  /// In en, this message translates to:
  /// **'Read 250 novel chapters.'**
  String get libraryBadgeNovelNerdDesc;

  /// Collapsed label of the Discover genre-filter pill.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get discoverGenres;

  /// Snackbar after removing a saved item from the wishlist.
  ///
  /// In en, this message translates to:
  /// **'Removed from wishlist'**
  String get discoverRemovedFromWishlist;

  /// Tooltip on the remove-from-wishlist icon button.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get discoverRemove;

  /// Novel reader text-selection action: look up the word in the dictionary.
  ///
  /// In en, this message translates to:
  /// **'Define'**
  String get novelDefine;

  /// Title of the novel reader's Listen (TTS) tuning sheet.
  ///
  /// In en, this message translates to:
  /// **'Text-to-speech'**
  String get novelTts;

  /// Row title that opens the TTS voice picker.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get novelVoice;

  /// Shown as the voice name when no specific TTS voice is chosen.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get novelVoiceSystemDefault;

  /// Header for the experimental device-vs-neural TTS engine picker.
  ///
  /// In en, this message translates to:
  /// **'Voice engine (experimental)'**
  String get novelVoiceEngine;

  /// TTS engine option: the device's built-in voices.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get novelVoiceDevice;

  /// Hint text in the TTS voice-picker search field.
  ///
  /// In en, this message translates to:
  /// **'Search voices'**
  String get novelSearchVoices;

  /// Button that moves the floating Listen pill back to its default spot.
  ///
  /// In en, this message translates to:
  /// **'Reset pill position'**
  String get novelResetPill;

  /// Link opening the full TTS tuning sheet from the Listen panel.
  ///
  /// In en, this message translates to:
  /// **'More voices & tuning →'**
  String get novelMoreVoices;

  /// Novel reader wheel action: text size panel.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get novelActionSize;

  /// Novel reader wheel action: reader theme panel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get novelActionTheme;

  /// Novel reader wheel action: text alignment panel.
  ///
  /// In en, this message translates to:
  /// **'Align'**
  String get novelActionAlign;

  /// Novel reader wheel action: line/paragraph spacing panel.
  ///
  /// In en, this message translates to:
  /// **'Spacing'**
  String get novelActionSpacing;

  /// Novel reader wheel action: text-to-speech (Listen) panel.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get novelActionListen;

  /// Title of the TTS highlight-colour picker sheet.
  ///
  /// In en, this message translates to:
  /// **'Highlight colours'**
  String get novelHighlightColours;

  /// Label for the current-sentence TTS highlight colour.
  ///
  /// In en, this message translates to:
  /// **'Sentence'**
  String get novelHighlightSentence;

  /// Label for the current-word TTS highlight colour.
  ///
  /// In en, this message translates to:
  /// **'Word'**
  String get novelHighlightWord;

  /// Small badge/label marking the volume-key feature as experimental on iOS, in reader settings
  ///
  /// In en, this message translates to:
  /// **'Experimental on iOS'**
  String get readerExperimentalOnIos;

  /// Confirmation dialog body warning that iOS lacks a real volume-button API before enabling volume-key navigation
  ///
  /// In en, this message translates to:
  /// **'iOS has no proper volume-button API, so this works by watching the system volume — it can be glitchy. While reading, the volume of anything you\'re listening to (music, a podcast) will be held at 50% and can\'t be changed. Enable anyway?'**
  String get readerIosVolumeWarning;

  /// Button dismissing the iOS volume-key warning dialog without enabling
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get readerCancel;

  /// Button confirming the iOS volume-key warning dialog to enable the feature
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get readerEnable;

  /// Title of the Reader settings screen/section
  ///
  /// In en, this message translates to:
  /// **'Reader'**
  String get readerTitle;

  /// Section header grouping general reader preference options
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get readerPreferences;

  /// Setting label for choosing the page reading mode/direction
  ///
  /// In en, this message translates to:
  /// **'Reading Mode'**
  String get readerReadingMode;

  /// Setting label for reader text/font size
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get readerFontSize;

  /// Toggle label for preloading the next chapter automatically
  ///
  /// In en, this message translates to:
  /// **'Auto-Preload Next Chapter'**
  String get readerAutoPreloadNextChapter;

  /// Subtitle under the auto-preload toggle explaining it loads the next chapter in the background
  ///
  /// In en, this message translates to:
  /// **'Load next chapter in background'**
  String get readerAutoPreloadNextChapterSubtitle;

  /// Toggle label for showing pages in grayscale
  ///
  /// In en, this message translates to:
  /// **'Grayscale'**
  String get readerGrayscale;

  /// Subtitle explaining the grayscale toggle
  ///
  /// In en, this message translates to:
  /// **'Display pages in grayscale'**
  String get readerGrayscaleSubtitle;

  /// Reader toggle: trim solid page margins.
  ///
  /// In en, this message translates to:
  /// **'Auto-crop borders'**
  String get readerAutoCrop;

  /// Label/toggle for the reader's automatic scrolling
  ///
  /// In en, this message translates to:
  /// **'Auto-scroll'**
  String get readerAutoScroll;

  /// Label for the auto-scroll speed stepper in the reader controls
  ///
  /// In en, this message translates to:
  /// **'Auto-scroll speed'**
  String get readerAutoScrollSpeed;

  /// Chip that resets the reader's colour filter to default
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get readerFilterReset;

  /// Colour-filter preset name: a warm, paper-like tone
  ///
  /// In en, this message translates to:
  /// **'Paper'**
  String get readerFilterPaper;

  /// Colour-filter preset name: a warm, dim night tone
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get readerFilterNight;

  /// Colour-filter preset name: boosted contrast and saturation
  ///
  /// In en, this message translates to:
  /// **'Vivid'**
  String get readerFilterVivid;

  /// Colour-filter slider label: sepia amount
  ///
  /// In en, this message translates to:
  /// **'Sepia'**
  String get readerFilterSepia;

  /// Colour-filter slider label: contrast amount
  ///
  /// In en, this message translates to:
  /// **'Contrast'**
  String get readerFilterContrast;

  /// Colour-filter slider label: saturation amount
  ///
  /// In en, this message translates to:
  /// **'Saturation'**
  String get readerFilterSaturation;

  /// Section header for the reader's warm-tint and brightness controls
  ///
  /// In en, this message translates to:
  /// **'Eye comfort'**
  String get readerEyeComfort;

  /// Slider label for the reader's warm-tint (blue-light reduction) amount
  ///
  /// In en, this message translates to:
  /// **'Warm'**
  String get readerEyeComfortWarm;

  /// Slider label for the reader's in-app brightness dimming
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get readerEyeComfortBrightness;

  /// Hands-free gaze mode option: track the eyes only
  ///
  /// In en, this message translates to:
  /// **'Eyes'**
  String get readerGazeModeEyes;

  /// Hands-free gaze mode option: track head tilt only
  ///
  /// In en, this message translates to:
  /// **'Head'**
  String get readerGazeModeHead;

  /// Hands-free gaze mode option: track both eyes and head
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get readerGazeModeBoth;

  /// Subtitle explaining the auto-crop toggle
  ///
  /// In en, this message translates to:
  /// **'Trim solid white/black margins so pages fill the screen'**
  String get readerAutoCropSubtitle;

  /// Toggle label for inverting page colors
  ///
  /// In en, this message translates to:
  /// **'Invert Colors'**
  String get readerInvertColors;

  /// Subtitle explaining the invert-colors toggle swaps light and dark
  ///
  /// In en, this message translates to:
  /// **'Swap light and dark colors'**
  String get readerInvertColorsSubtitle;

  /// Section header grouping display-related reader options
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get readerDisplay;

  /// Setting label for how pages are scaled/fitted to the screen
  ///
  /// In en, this message translates to:
  /// **'Scale Type'**
  String get readerScaleType;

  /// Setting label for the reader page background color
  ///
  /// In en, this message translates to:
  /// **'Background Color'**
  String get readerBackgroundColor;

  /// Toggle label for keeping the screen awake while reading
  ///
  /// In en, this message translates to:
  /// **'Keep Screen On'**
  String get readerKeepScreenOn;

  /// Subtitle explaining keep-screen-on prevents sleep
  ///
  /// In en, this message translates to:
  /// **'Prevent screen from sleeping'**
  String get readerKeepScreenOnSubtitle;

  /// Toggle label for showing the page-number indicator
  ///
  /// In en, this message translates to:
  /// **'Show Page Number'**
  String get readerShowPageNumber;

  /// Subtitle explaining the page-number overlay
  ///
  /// In en, this message translates to:
  /// **'Display page indicator overlay'**
  String get readerShowPageNumberSubtitle;

  /// Toggle label for fullscreen reading
  ///
  /// In en, this message translates to:
  /// **'Fullscreen'**
  String get readerFullscreen;

  /// Subtitle explaining fullscreen hides the system bars
  ///
  /// In en, this message translates to:
  /// **'Hide system bars while reading'**
  String get readerFullscreenSubtitle;

  /// Section header grouping reader navigation options
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get readerNavigation;

  /// Setting label for the tap-zone navigation layout scheme
  ///
  /// In en, this message translates to:
  /// **'Navigation Layout'**
  String get readerNavigationLayout;

  /// Toggle label for inverting the left/right tap navigation zones
  ///
  /// In en, this message translates to:
  /// **'Invert Tap Zones'**
  String get readerInvertTapZones;

  /// Subtitle explaining invert-tap-zones swaps left/right page turning
  ///
  /// In en, this message translates to:
  /// **'Swap left/right tap navigation'**
  String get readerInvertTapZonesSubtitle;

  /// Toggle label for using volume buttons to navigate pages
  ///
  /// In en, this message translates to:
  /// **'Volume Keys'**
  String get readerVolumeKeys;

  /// Subtitle explaining volume-key behavior: tap to turn/scroll, hold to scroll in webtoon mode
  ///
  /// In en, this message translates to:
  /// **'Tap to turn a page/scroll; hold to scroll (webtoon)'**
  String get readerVolumeKeysSubtitle;

  /// Setting label for the scroll speed when holding a volume key
  ///
  /// In en, this message translates to:
  /// **'Hold-scroll Speed'**
  String get readerHoldScrollSpeed;

  /// Error/snackbar shown when the content source extension is missing
  ///
  /// In en, this message translates to:
  /// **'Source not installed'**
  String get readerSourceNotInstalled;

  /// Explanatory subtitle on the reader's 'source not installed' screen, pointing the user to Extensions
  ///
  /// In en, this message translates to:
  /// **'This title\'s source isn\'t installed — this can happen after restoring a backup. Install it from Extensions, then try again.'**
  String get readerSourceNotInstalledHint;

  /// Transient status shown while a page is being AI-translated
  ///
  /// In en, this message translates to:
  /// **'Translating…'**
  String get readerTranslating;

  /// Button to retry a failed page load or translation
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get readerRetry;

  /// Reader page long-press menu: share the page image
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get readerPageShare;

  /// Reader page long-press menu: save the page to the gallery
  ///
  /// In en, this message translates to:
  /// **'Save image'**
  String get readerPageSave;

  /// Reader page long-press menu: use this page as the manga cover
  ///
  /// In en, this message translates to:
  /// **'Set as cover'**
  String get readerPageSetCover;

  /// Reader page long-press menu: OCR the page text
  ///
  /// In en, this message translates to:
  /// **'Recognize text'**
  String get readerPageRecognizeText;

  /// Snackbar after saving a page image
  ///
  /// In en, this message translates to:
  /// **'Saved to gallery'**
  String get readerPageSaved;

  /// Snackbar when saving a page image fails
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the image'**
  String get readerPageSaveFailed;

  /// Snackbar after setting a page as the cover
  ///
  /// In en, this message translates to:
  /// **'Cover updated'**
  String get readerPageCoverSet;

  /// Snackbar when set-as-cover is used on a non-library title
  ///
  /// In en, this message translates to:
  /// **'Add this title to your library first'**
  String get readerPageCoverNeedsLibrary;

  /// Snackbar when the page image bytes can't be obtained
  ///
  /// In en, this message translates to:
  /// **'Image isn\'t available yet'**
  String get readerPageImageUnavailable;

  /// Title of the OCR result dialog
  ///
  /// In en, this message translates to:
  /// **'Recognized text'**
  String get readerPageOcrTitle;

  /// Shown when OCR finds no text
  ///
  /// In en, this message translates to:
  /// **'No text found on this page'**
  String get readerPageOcrEmpty;

  /// Button to copy the recognized text
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get readerPageOcrCopy;

  /// Status shown while the next chapter is loading
  ///
  /// In en, this message translates to:
  /// **'Loading next chapter...'**
  String get readerLoadingNextChapter;

  /// End-of-chapter message when no newer chapter exists
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up!'**
  String get readerAllCaughtUp;

  /// Heading on the end-of-chapter screen shown after the last page
  ///
  /// In en, this message translates to:
  /// **'End of Chapter'**
  String get readerEndOfChapter;

  /// End-of-chapter note that this is the newest chapter available
  ///
  /// In en, this message translates to:
  /// **'This is the latest chapter available.'**
  String get readerLatestChapterAvailable;

  /// Button on the end-of-chapter screen to open the next chapter
  ///
  /// In en, this message translates to:
  /// **'Load Next Chapter'**
  String get readerLoadNextChapter;

  /// Button to go back/exit the reader
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get readerBack;

  /// Button/label opening the reader settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get readerSettings;

  /// Button to AI-translate the current page(s)
  ///
  /// In en, this message translates to:
  /// **'AI Translate'**
  String get readerAiTranslate;

  /// Tooltip/button for jumping to the previous chapter
  ///
  /// In en, this message translates to:
  /// **'Previous chapter'**
  String get readerPreviousChapter;

  /// Button/tooltip for bookmarking the current page
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get readerBookmark;

  /// Tooltip/button for jumping to the next chapter
  ///
  /// In en, this message translates to:
  /// **'Next chapter'**
  String get readerNextChapter;

  /// Error snackbar when translation fails; {error} holds the failure message
  ///
  /// In en, this message translates to:
  /// **'Translation failed: {error}'**
  String readerTranslationFailed(Object error);

  /// Reading-mode option name: paged left-to-right
  ///
  /// In en, this message translates to:
  /// **'Left to Right'**
  String get readerModeLtrLabel;

  /// Reading-mode option name: paged right-to-left
  ///
  /// In en, this message translates to:
  /// **'Right to Left'**
  String get readerModeRtlLabel;

  /// Reading-mode option name: continuous vertical scroll
  ///
  /// In en, this message translates to:
  /// **'Continuous Scroll'**
  String get readerModeVerticalLabel;

  /// Reading-mode option name: webtoon (long vertical strip)
  ///
  /// In en, this message translates to:
  /// **'Webtoon'**
  String get readerModeWebtoonLabel;

  /// Subtitle for the left-to-right mode: tap sides to turn pages
  ///
  /// In en, this message translates to:
  /// **'Tap left/right to turn pages'**
  String get readerModeLtrSubtitle;

  /// Subtitle for the right-to-left mode (manga-style)
  ///
  /// In en, this message translates to:
  /// **'Manga-style right to left'**
  String get readerModeRtlSubtitle;

  /// Subtitle for the vertical mode: scroll through pages
  ///
  /// In en, this message translates to:
  /// **'Scroll vertically through pages'**
  String get readerModeVerticalSubtitle;

  /// Subtitle for the webtoon mode: long vertical strips
  ///
  /// In en, this message translates to:
  /// **'Optimized for long vertical strips'**
  String get readerModeWebtoonSubtitle;

  /// Button/label opening the chapter list from the reader
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get readerChapters;

  /// Page indicator; {current} is the current page number, {total} the page count
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String readerPageOf(int current, int total);

  /// Tab in the AI-translate sheet for choosing the translation provider/service
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get readerTabProvider;

  /// Tab in the AI-translate sheet for choosing the target (translated-into) language
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get readerTabTarget;

  /// Tab in the AI-translate sheet for choosing the source (original) language
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get readerTabSource;

  /// Tab in the AI-translate sheet for choosing the translated-text font
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get readerTabFont;

  /// Font option name for the normal/default typeface
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get readerFontNormal;

  /// Font option name for the manga/comic-style typeface
  ///
  /// In en, this message translates to:
  /// **'Manga'**
  String get readerFontManga;

  /// Description under the Normal font option (clean sans-serif)
  ///
  /// In en, this message translates to:
  /// **'Clean sans-serif'**
  String get readerFontNormalDesc;

  /// Description under the Manga font option (bold comic style)
  ///
  /// In en, this message translates to:
  /// **'Bold comic style'**
  String get readerFontMangaDesc;

  /// Preview sample text shown next to a font option
  ///
  /// In en, this message translates to:
  /// **'Hello World'**
  String get readerFontSample;

  /// Empty-state message in the novel reader when no chapter text was found
  ///
  /// In en, this message translates to:
  /// **'No chapter text found'**
  String get readerNoChapterText;

  /// Fallback app-bar title in the novel reader when no title is known
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get readerReadingTitle;

  /// Button/tooltip in the novel reader to decrease text size
  ///
  /// In en, this message translates to:
  /// **'Smaller text'**
  String get readerSmallerText;

  /// Button/tooltip in the novel reader to increase text size
  ///
  /// In en, this message translates to:
  /// **'Larger text'**
  String get readerLargerText;

  /// Navigation button for the previous page/chapter
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get readerPrevious;

  /// Navigation button for the next page/chapter
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get readerNext;

  /// App bar title of the Browse tab
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get browseTitle;

  /// Tooltip/label for the button that searches all sources at once
  ///
  /// In en, this message translates to:
  /// **'Global search'**
  String get browseGlobalSearch;

  /// Transient status shown while repositories reload
  ///
  /// In en, this message translates to:
  /// **'Refreshing repos...'**
  String get browseRefreshingRepos;

  /// Menu action to reload the configured repositories
  ///
  /// In en, this message translates to:
  /// **'Refresh repos'**
  String get browseRefreshRepos;

  /// Tooltip/label for the search icon button
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get browseSearch;

  /// Button/menu action to add a new extension repository
  ///
  /// In en, this message translates to:
  /// **'Add repo'**
  String get browseAddRepo;

  /// Tab label for the installed sources list
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get browseTabSources;

  /// Tab label for browsable extensions to install
  ///
  /// In en, this message translates to:
  /// **'Extensions'**
  String get browseTabExtensions;

  /// Tab label for locally imported/offline content
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get browseTabLocal;

  /// Placeholder text in the search field over extensions and sources
  ///
  /// In en, this message translates to:
  /// **'Search extensions & sources...'**
  String get browseSearchHint;

  /// Confirmation dialog title before uninstalling a source; {name} is the source name
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String browseRemoveSourceConfirm(Object name);

  /// Explanatory body text in the remove-source confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'The source will be uninstalled. Your library entries from it are kept, but you won\'t be able to open them until you reinstall it.'**
  String get browseRemoveSourceDesc;

  /// Cancel button in dialogs
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get browseCancel;

  /// Confirm button to uninstall the source
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get browseRemove;

  /// Section header above settings that belong to this specific source
  ///
  /// In en, this message translates to:
  /// **'PROVIDED BY THIS SOURCE'**
  String get browseProvidedByThisSource;

  /// Error shown when a source's own settings cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Could not load the source\'s options'**
  String get browseCouldNotLoadOptions;

  /// Empty-state note when a source defines no custom settings
  ///
  /// In en, this message translates to:
  /// **'This source doesn\'t define any options of its own. The settings above still apply to it.'**
  String get browseNoSourceOptions;

  /// Label for the source's base URL setting field
  ///
  /// In en, this message translates to:
  /// **'Base URL'**
  String get browseBaseUrl;

  /// Subtitle noting the base URL is at the source's default value
  ///
  /// In en, this message translates to:
  /// **'Using the source default'**
  String get browseUsingSourceDefault;

  /// Shows the default base URL; {url} is that address, marked as the default
  ///
  /// In en, this message translates to:
  /// **'{url}  (default)'**
  String browseBaseUrlDefault(Object url);

  /// Action to restore a setting to its default value
  ///
  /// In en, this message translates to:
  /// **'Reset to default'**
  String get browseResetToDefault;

  /// Toggle title to pin this source at the top of the list
  ///
  /// In en, this message translates to:
  /// **'Pin to top'**
  String get browsePinToTop;

  /// Subtitle explaining the pin-to-top toggle
  ///
  /// In en, this message translates to:
  /// **'Show this source first in the sources list'**
  String get browsePinToTopDesc;

  /// Toggle title to exclude this source from global search
  ///
  /// In en, this message translates to:
  /// **'Skip in global search'**
  String get browseSkipGlobalSearch;

  /// Subtitle explaining the skip-in-global-search toggle
  ///
  /// In en, this message translates to:
  /// **'Leave this source out when searching everything'**
  String get browseSkipGlobalSearchDesc;

  /// Toggle title to exclude this source from library update checks
  ///
  /// In en, this message translates to:
  /// **'Skip in library updates'**
  String get browseSkipLibraryUpdates;

  /// Subtitle explaining the skip-library-updates toggle
  ///
  /// In en, this message translates to:
  /// **'Don\'t check this source for new chapters'**
  String get browseSkipLibraryUpdatesDesc;

  /// Toggle title to request the desktop version of the site
  ///
  /// In en, this message translates to:
  /// **'Request desktop site'**
  String get browseRequestDesktopSite;

  /// Subtitle explaining when to enable the request-desktop-site toggle
  ///
  /// In en, this message translates to:
  /// **'Try this if the source finds nothing, or shows no chapters — some sites send phones a cut-down page'**
  String get browseRequestDesktopSiteDesc;

  /// Save button for source settings
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get browseSave;

  /// Value shown when no option is selected
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get browseNone;

  /// Summary of how many items are selected; {count} is the number
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String browseSelectedCount(Object count);

  /// Placeholder shown when a setting has no value
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get browseNotSet;

  /// iOS-only warning that folder access is not allowed; suggests importing files instead
  ///
  /// In en, this message translates to:
  /// **'iOS does not allow apps to keep access to a folder. Use \"Import File\" to add .cbz/.cbr/.zip/.epub/.pdf instead.'**
  String get browseIosFolderWarning;

  /// Snackbar confirming import; {count} is the number of files imported
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Imported 1 file} other{Imported {count} files}}'**
  String browseImportedFiles(int count);

  /// Snackbar shown when an import produced no usable files
  ///
  /// In en, this message translates to:
  /// **'Nothing imported (unsupported or unreadable)'**
  String get browseNothingImported;

  /// Count of local folders; {count} is the number of folders
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 folder} other{{count} folders}}'**
  String browseFolderCount(int count);

  /// Action to open the local source folders manager
  ///
  /// In en, this message translates to:
  /// **'Manage folders'**
  String get browseManageFolders;

  /// Tooltip for the import-file button listing supported formats
  ///
  /// In en, this message translates to:
  /// **'Import file (CBZ/ZIP/EPUB/PDF)'**
  String get browseImportFileTooltip;

  /// Action to add a local content folder
  ///
  /// In en, this message translates to:
  /// **'Add folder'**
  String get browseAddFolder;

  /// Action to rescan local folders for new content
  ///
  /// In en, this message translates to:
  /// **'Rescan'**
  String get browseRescan;

  /// Empty-state title when no local content has been imported
  ///
  /// In en, this message translates to:
  /// **'Nothing imported yet'**
  String get browseNothingImportedYet;

  /// Empty-state title when no local sources exist
  ///
  /// In en, this message translates to:
  /// **'No local sources'**
  String get browseNoLocalSources;

  /// Empty-state body explaining how to add local content and which formats work
  ///
  /// In en, this message translates to:
  /// **'Add a folder of manga, or import a single file.\nSupported: images (JPG, PNG, WebP, GIF), CBZ/ZIP, EPUB and PDF.\n(CBR/RAR only if the file is actually ZIP-packed — true RAR isn\'t supported.)'**
  String get browseLocalSourcesDesc;

  /// Empty-state button to add a folder
  ///
  /// In en, this message translates to:
  /// **'Add Folder'**
  String get browseAddFolderButton;

  /// Empty-state button to import a single file
  ///
  /// In en, this message translates to:
  /// **'Import File'**
  String get browseImportFile;

  /// Title of the local source folders management screen
  ///
  /// In en, this message translates to:
  /// **'Local Source Folders'**
  String get browseLocalSourceFolders;

  /// Empty-state text when no local folders are configured
  ///
  /// In en, this message translates to:
  /// **'No folders added'**
  String get browseNoFoldersAdded;

  /// Abbreviated chapter count on a card; {n} is the number of chapters
  ///
  /// In en, this message translates to:
  /// **'{n} ch'**
  String browseChaptersAbbrev(Object n);

  /// Section header over installed extensions/sources
  ///
  /// In en, this message translates to:
  /// **'INSTALLED'**
  String get browseInstalled;

  /// Section header over extensions available to install
  ///
  /// In en, this message translates to:
  /// **'AVAILABLE'**
  String get browseAvailable;

  /// Message shown when opening a source that isn't installed
  ///
  /// In en, this message translates to:
  /// **'Source is not installed'**
  String get browseSourceNotInstalled;

  /// Content-type filter chip/label for manga
  ///
  /// In en, this message translates to:
  /// **'Manga'**
  String get browseManga;

  /// Content-type filter chip/label for anime
  ///
  /// In en, this message translates to:
  /// **'Anime'**
  String get browseAnime;

  /// Content-type filter chip/label for novels
  ///
  /// In en, this message translates to:
  /// **'Novels'**
  String get browseNovels;

  /// Filter option including sources of every language
  ///
  /// In en, this message translates to:
  /// **'All languages'**
  String get browseAllLanguages;

  /// Label/tooltip for the filter control
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get browseFilter;

  /// Language filter summary; {count} is the number of selected languages
  ///
  /// In en, this message translates to:
  /// **'{count} languages'**
  String browseLanguagesCount(Object count);

  /// Label for the repository filter
  ///
  /// In en, this message translates to:
  /// **'Repository'**
  String get browseFilterRepository;

  /// Filter option including every repository
  ///
  /// In en, this message translates to:
  /// **'All repositories'**
  String get browseAllRepositories;

  /// Repository filter summary; {count} is the number of selected repositories
  ///
  /// In en, this message translates to:
  /// **'{count} repositories'**
  String browseReposCount(Object count);

  /// Search result count; {count} is the number of results
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 result} other{{count} results}}'**
  String browseResultCount(int count);

  /// Empty-state title when no extensions are available
  ///
  /// In en, this message translates to:
  /// **'No extensions yet'**
  String get browseNoExtensions;

  /// Empty-state body telling the user to add a repository first
  ///
  /// In en, this message translates to:
  /// **'Add a repository using the settings\nbutton above to browse extensions.'**
  String get browseNoExtensionsDesc;

  /// Snackbar after updating sources; {count} is how many were updated
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Updated 1 source} other{Updated {count} sources}}'**
  String browseUpdatedSources(int count);

  /// Snackbar confirming a single source was updated
  ///
  /// In en, this message translates to:
  /// **'Source updated'**
  String get browseSourceUpdated;

  /// Snackbar noting the source is already up to date
  ///
  /// In en, this message translates to:
  /// **'No update available'**
  String get browseNoUpdateAvailable;

  /// Snackbar for a failed update; {error} is the error message
  ///
  /// In en, this message translates to:
  /// **'Update failed: {error}'**
  String browseUpdateFailed(Object error);

  /// Snackbar for a failed repo refresh; {error} is the error message
  ///
  /// In en, this message translates to:
  /// **'Refresh failed: {error}'**
  String browseRefreshFailed(Object error);

  /// Section header over extensions with updates; {count} is how many
  ///
  /// In en, this message translates to:
  /// **'UPDATES AVAILABLE ({count})'**
  String browseUpdatesAvailable(Object count);

  /// Button to update all extensions with pending updates
  ///
  /// In en, this message translates to:
  /// **'Update all'**
  String get browseUpdateAll;

  /// Button to update a single extension
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get browseUpdate;

  /// Button/menu action opening a source's settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get browseSettings;

  /// Button to install an extension
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get browseInstall;

  /// Badge marking an extension as already installed
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get browseInstalledBadge;

  /// Section header over an extension's about/details info
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get browseAbout;

  /// Line showing where a source comes from; {url} is the repository URL
  ///
  /// In en, this message translates to:
  /// **'Source from {url}'**
  String browseSourceFrom(Object url);

  /// Line showing the source language; {lang} is the language name
  ///
  /// In en, this message translates to:
  /// **'Language: {lang}'**
  String browseLanguageLabel(Object lang);

  /// Badge/label noting the source is behind Cloudflare protection
  ///
  /// In en, this message translates to:
  /// **'Uses Cloudflare protection'**
  String get browseUsesCloudflare;

  /// Badge/label noting the source has no Cloudflare protection
  ///
  /// In en, this message translates to:
  /// **'No Cloudflare'**
  String get browseNoCloudflare;

  /// Badge marking a source as adult/18+ content
  ///
  /// In en, this message translates to:
  /// **'18+ Content'**
  String get browseAdultContent;

  /// Badge marking a source as safe-for-work (non-adult)
  ///
  /// In en, this message translates to:
  /// **'Safe for work'**
  String get browseSafeForWork;

  /// Section header over an extension's feature badges
  ///
  /// In en, this message translates to:
  /// **'FEATURES'**
  String get browseFeatures;

  /// Label for browsing a source's popular titles
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get browsePopular;

  /// Label for browsing a source's latest updates
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get browseLatest;

  /// Action to open/browse a source; {name} is the source name
  ///
  /// In en, this message translates to:
  /// **'Browse {name}'**
  String browseSourceAction(Object name);

  /// Transient status shown while a source is being uninstalled
  ///
  /// In en, this message translates to:
  /// **'Removing...'**
  String get browseRemoving;

  /// Transient status shown while an extension is installing
  ///
  /// In en, this message translates to:
  /// **'Installing...'**
  String get browseInstalling;

  /// Error status for a failed action; {error} is the error message
  ///
  /// In en, this message translates to:
  /// **'Failed: {error}'**
  String browseFailed(Object error);

  /// Empty state in the Browse language-filter search when the query matches no language
  ///
  /// In en, this message translates to:
  /// **'No languages match'**
  String get browseNoLanguagesMatch;

  /// Section header in the Browse language filter for the user's pinned and device languages (shown uppercased in the UI)
  ///
  /// In en, this message translates to:
  /// **'Your languages'**
  String get browseYourLanguages;

  /// Hint text in the Browse language-filter search field
  ///
  /// In en, this message translates to:
  /// **'Search languages'**
  String get browseSearchLanguages;

  /// Transient status shown while an extension is updating
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get browseUpdating;

  /// Menu action to update the extension's code
  ///
  /// In en, this message translates to:
  /// **'Update extension code'**
  String get browseUpdateExtensionCode;

  /// Snackbar confirming a source updated; {name} is the source name
  ///
  /// In en, this message translates to:
  /// **'Updated {name}'**
  String browseUpdatedSource(Object name);

  /// Section header over pinned sources
  ///
  /// In en, this message translates to:
  /// **'PINNED'**
  String get browsePinned;

  /// Section header/tab for all sources
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get browseAll;

  /// Empty-state title when no sources are installed
  ///
  /// In en, this message translates to:
  /// **'No installed sources'**
  String get browseNoInstalledSources;

  /// Empty-state body directing the user to the Extensions tab
  ///
  /// In en, this message translates to:
  /// **'Install extensions from the Extensions tab\nto see sources here.'**
  String get browseNoInstalledSourcesDesc;

  /// Action to unpin a source
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get browseUnpin;

  /// Action to pin a source
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get browsePin;

  /// Body text shown when a source is not installed
  ///
  /// In en, this message translates to:
  /// **'Source not installed'**
  String get browseSourceNotInstalledBody;

  /// Transient status while solving Cloudflare protection
  ///
  /// In en, this message translates to:
  /// **'Bypassing Cloudflare protection...'**
  String get browseBypassingCloudflare;

  /// Action to open the source in the in-app browser
  ///
  /// In en, this message translates to:
  /// **'Open in WebView'**
  String get browseOpenInWebView;

  /// Dialog title about Cloudflare protection
  ///
  /// In en, this message translates to:
  /// **'Cloudflare Protection'**
  String get browseCloudflareProtection;

  /// Error shown when content fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get browseFailedToLoad;

  /// Dialog body explaining a Cloudflare challenge must be solved in the browser
  ///
  /// In en, this message translates to:
  /// **'This source requires solving a Cloudflare challenge in the browser first.'**
  String get browseCloudflareChallengeDesc;

  /// Button to open the browser and solve the Cloudflare challenge
  ///
  /// In en, this message translates to:
  /// **'Solve Cloudflare'**
  String get browseSolveCloudflare;

  /// Button to retry a failed load
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get browseRetry;

  /// Content-type noun for anime, inserted into other strings (lowercase)
  ///
  /// In en, this message translates to:
  /// **'anime'**
  String get browseContentAnime;

  /// Content-type noun for light novels, inserted into other strings (lowercase)
  ///
  /// In en, this message translates to:
  /// **'light novels'**
  String get browseContentNovels;

  /// Content-type noun for manga, inserted into other strings (lowercase)
  ///
  /// In en, this message translates to:
  /// **'manga'**
  String get browseContentManga;

  /// Empty-state; {noun} is the content type (manga/anime/light novels)
  ///
  /// In en, this message translates to:
  /// **'No {noun} found'**
  String browseNoContentFound(Object noun);

  /// Filter option including every category
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get browseAllCategories;

  /// Empty-state when a source has no categories
  ///
  /// In en, this message translates to:
  /// **'No categories'**
  String get browseNoCategories;

  /// Placeholder text in a manga search field
  ///
  /// In en, this message translates to:
  /// **'Search manga...'**
  String get browseSearchMangaHint;

  /// Fallback label when a value is unknown
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get browseUnknown;

  /// Placeholder text in the global search field
  ///
  /// In en, this message translates to:
  /// **'Search across all sources...'**
  String get browseSearchAllSourcesHint;

  /// Empty-state title when no sources are installed
  ///
  /// In en, this message translates to:
  /// **'No sources installed'**
  String get browseNoSourcesInstalled;

  /// Empty-state body directing the user to the Browse tab
  ///
  /// In en, this message translates to:
  /// **'Install extensions from Browse tab.'**
  String get browseNoSourcesInstalledDesc;

  /// Title of the global search across all sources
  ///
  /// In en, this message translates to:
  /// **'Search All Sources'**
  String get browseSearchAllSources;

  /// Note on how many sources search covers; {count} is the number
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Search 1 source at once.} other{Search {count} sources at once.}}'**
  String browseSearchSourcesAtOnce(int count);

  /// Progress text during global search; {count} is the number being searched
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Searching 1 source...} other{Searching {count} sources...}}'**
  String browseSearchingSources(int count);

  /// Action to expand and see all results from a source
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get browseSeeAll;

  /// Shown under a source in global search when it returned no matches
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get globalSearchSourceNoResults;

  /// Shown under a source in global search when its search failed
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t search this source'**
  String get globalSearchSourceFailed;

  /// Settings section header for sources options
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get browseSectionSources;

  /// Toggle title to show 18+ sources
  ///
  /// In en, this message translates to:
  /// **'Show NSFW Sources'**
  String get browseShowNsfw;

  /// Subtitle explaining the show-NSFW-sources toggle
  ///
  /// In en, this message translates to:
  /// **'Show 18+ sources in browse and search'**
  String get browseShowNsfwDesc;

  /// Toggle title to show only pinned sources when browsing
  ///
  /// In en, this message translates to:
  /// **'Pinned Sources Only'**
  String get browsePinnedOnly;

  /// Subtitle explaining the pinned-only browse toggle
  ///
  /// In en, this message translates to:
  /// **'Only show pinned sources in browse'**
  String get browsePinnedOnlyBrowseDesc;

  /// Settings section header for global search options
  ///
  /// In en, this message translates to:
  /// **'Global Search'**
  String get browseSectionGlobalSearch;

  /// Subtitle explaining the pinned-only global search toggle
  ///
  /// In en, this message translates to:
  /// **'Only search pinned sources in global search'**
  String get browsePinnedOnlyGlobalSearchDesc;

  /// Settings section header for in-app browser options
  ///
  /// In en, this message translates to:
  /// **'WebView'**
  String get browseSectionWebView;

  /// Toggle title to enable the in-app browser ad blocker
  ///
  /// In en, this message translates to:
  /// **'Ad Blocker'**
  String get browseAdBlocker;

  /// Subtitle explaining the ad blocker toggle
  ///
  /// In en, this message translates to:
  /// **'Block ads, popups, and overlays in the browser'**
  String get browseAdBlockerDesc;

  /// Settings section header for extensions options
  ///
  /// In en, this message translates to:
  /// **'Extensions'**
  String get browseSectionExtensions;

  /// Toggle title to auto-update extensions
  ///
  /// In en, this message translates to:
  /// **'Auto-Update Extensions'**
  String get browseAutoUpdate;

  /// Subtitle explaining the auto-update extensions toggle
  ///
  /// In en, this message translates to:
  /// **'Refresh installed extension code on app launch'**
  String get browseAutoUpdateDesc;

  /// Screen title for the Advanced settings page
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get setxAdvancedTitle;

  /// Section header for logging-related settings on the Advanced page
  ///
  /// In en, this message translates to:
  /// **'Logging'**
  String get setxAdvancedSectionLogging;

  /// Toggle label enabling detailed debug logging
  ///
  /// In en, this message translates to:
  /// **'Verbose Logging'**
  String get setxAdvancedVerboseLoggingTitle;

  /// Subtitle under the Verbose Logging toggle explaining it
  ///
  /// In en, this message translates to:
  /// **'Log detailed debug information'**
  String get setxAdvancedVerboseLoggingSubtitle;

  /// Row label opening the error/debug log viewer
  ///
  /// In en, this message translates to:
  /// **'View Error Logs'**
  String get setxAdvancedViewErrorLogsTitle;

  /// Subtitle under View Error Logs row
  ///
  /// In en, this message translates to:
  /// **'Browse debug and error logs'**
  String get setxAdvancedViewErrorLogsSubtitle;

  /// Section header for network settings on the Advanced page
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get setxAdvancedSectionNetwork;

  /// Toggle label for enabling DNS over HTTPS (DoH)
  ///
  /// In en, this message translates to:
  /// **'DNS over HTTPS'**
  String get setxAdvancedDnsOverHttpsTitle;

  /// Subtitle under the DNS over HTTPS toggle
  ///
  /// In en, this message translates to:
  /// **'Use secure DNS resolution'**
  String get setxAdvancedDnsOverHttpsSubtitle;

  /// Row label to pick which DNS-over-HTTPS provider to use
  ///
  /// In en, this message translates to:
  /// **'DNS Provider'**
  String get setxAdvancedDnsProviderTitle;

  /// Button and dialog title to add a user-defined DNS-over-HTTPS provider
  ///
  /// In en, this message translates to:
  /// **'Add custom DNS'**
  String get setxAdvancedDnsAddCustom;

  /// Text-field label for a custom DNS provider's display name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get setxAdvancedDnsName;

  /// Placeholder example shown in the custom DNS name field
  ///
  /// In en, this message translates to:
  /// **'My DNS'**
  String get setxAdvancedDnsNameHint;

  /// Text-field label for a custom DNS-over-HTTPS endpoint URL
  ///
  /// In en, this message translates to:
  /// **'DoH URL'**
  String get setxAdvancedDnsUrlLabel;

  /// Validation error shown when the entered custom DNS URL is not a valid https URL
  ///
  /// In en, this message translates to:
  /// **'Enter a valid https:// URL'**
  String get setxAdvancedDnsInvalidUrl;

  /// Button to confirm adding a custom DNS provider
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get setxAdvancedDnsAdd;

  /// Delete action for a custom DNS provider, used as both the tooltip and the confirm button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get setxAdvancedDnsDelete;

  /// Title of the confirmation dialog for removing a custom DNS provider
  ///
  /// In en, this message translates to:
  /// **'Delete custom DNS?'**
  String get setxAdvancedDnsDeleteTitle;

  /// Confirmation-dialog body for removing a custom DNS provider; {name} is the provider's name
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\" from your DNS providers?'**
  String setxAdvancedDnsDeleteBody(String name);

  /// Small badge label marking an experimental/beta feature.
  ///
  /// In en, this message translates to:
  /// **'BETA'**
  String get commonBeta;

  /// Section header for the Beta features toggle on the Advanced page.
  ///
  /// In en, this message translates to:
  /// **'Experimental'**
  String get setxAdvancedSectionBeta;

  /// Toggle to show experimental features.
  ///
  /// In en, this message translates to:
  /// **'Beta features'**
  String get setxAdvancedBeta;

  /// Subtitle under the Beta features toggle.
  ///
  /// In en, this message translates to:
  /// **'Show experimental features: hands-free and volume-key scrolling, AI translation and auto-crop. They may be unstable or change.'**
  String get setxAdvancedBetaDesc;

  /// Section header for extension settings on the Advanced page
  ///
  /// In en, this message translates to:
  /// **'Extensions'**
  String get setxAdvancedSectionExtensions;

  /// Toggle label allowing extensions from third-party/unknown sources
  ///
  /// In en, this message translates to:
  /// **'Third-Party Extensions'**
  String get setxAdvancedThirdPartyTitle;

  /// Subtitle warning under the Third-Party Extensions toggle
  ///
  /// In en, this message translates to:
  /// **'Allow extensions from unknown sources'**
  String get setxAdvancedThirdPartySubtitle;

  /// Toggle label for notifications when extensions have updates
  ///
  /// In en, this message translates to:
  /// **'Extension Update Alerts'**
  String get setxAdvancedExtUpdateTitle;

  /// Subtitle under the Extension Update Alerts toggle
  ///
  /// In en, this message translates to:
  /// **'Notify when extensions have updates'**
  String get setxAdvancedExtUpdateSubtitle;

  /// Section header for browser settings on the Advanced page
  ///
  /// In en, this message translates to:
  /// **'Browser'**
  String get setxAdvancedSectionBrowser;

  /// Toggle label to open links in the system browser instead of in-app
  ///
  /// In en, this message translates to:
  /// **'External Browser'**
  String get setxAdvancedExternalBrowserTitle;

  /// Subtitle under the External Browser toggle
  ///
  /// In en, this message translates to:
  /// **'Open links in system browser'**
  String get setxAdvancedExternalBrowserSubtitle;

  /// Section header for data/storage settings on the Advanced page
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get setxAdvancedSectionData;

  /// Row label to clear cached chapter images
  ///
  /// In en, this message translates to:
  /// **'Clear Chapter Cache'**
  String get setxAdvancedClearCacheTitle;

  /// Subtitle under Clear Chapter Cache explaining the benefit
  ///
  /// In en, this message translates to:
  /// **'Free up storage space'**
  String get setxAdvancedClearCacheSubtitle;

  /// Row label opening the clear-database action
  ///
  /// In en, this message translates to:
  /// **'Clear Database'**
  String get setxAdvancedClearDbEntryTitle;

  /// Subtitle listing what clearing the database resets
  ///
  /// In en, this message translates to:
  /// **'Reset library, categories, and read history'**
  String get setxAdvancedClearDbEntrySubtitle;

  /// Snackbar confirming the chapter image cache was cleared
  ///
  /// In en, this message translates to:
  /// **'Chapter image cache cleared'**
  String get setxAdvancedCacheCleared;

  /// Confirmation dialog title before clearing the database
  ///
  /// In en, this message translates to:
  /// **'Clear database?'**
  String get setxAdvancedClearDbTitle;

  /// Confirmation dialog body warning what clearing the database deletes
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your library, categories, and read history. Installed extensions and downloads are not affected.'**
  String get setxAdvancedClearDbBody;

  /// Cancel button in the clear-database confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get setxAdvancedCancel;

  /// Confirm button (Clear) in the clear-database dialog
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get setxAdvancedClear;

  /// Snackbar confirming the database was cleared, prompting a restart
  ///
  /// In en, this message translates to:
  /// **'Database cleared — restart the app to reseed defaults'**
  String get setxAdvancedDbCleared;

  /// Screen title for the error/debug logs viewer
  ///
  /// In en, this message translates to:
  /// **'Error Logs'**
  String get setxAdvancedErrorLogsTitle;

  /// Tooltip on the button that deletes all stored logs
  ///
  /// In en, this message translates to:
  /// **'Clear all logs'**
  String get setxAdvancedClearAllLogsTooltip;

  /// Label for the log filter dropdown by category
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get setxAdvancedFilterCategory;

  /// Label for the log filter dropdown by severity level
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get setxAdvancedFilterLevel;

  /// Log filter option meaning no category/level filter (show everything)
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get setxAdvancedLogAll;

  /// Debug-log category filter: repository/source-repo events
  ///
  /// In en, this message translates to:
  /// **'Repo'**
  String get setxAdvancedLogCatRepo;

  /// Debug-log category filter: extension events
  ///
  /// In en, this message translates to:
  /// **'Extension'**
  String get setxAdvancedLogCatExtension;

  /// Debug-log category filter: network events
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get setxAdvancedLogCatNetwork;

  /// Debug-log category filter: install events
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get setxAdvancedLogCatInstall;

  /// Debug-log category filter: library events
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get setxAdvancedLogCatLibrary;

  /// Debug-log category filter: general/uncategorised events
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get setxAdvancedLogCatGeneral;

  /// Debug-log severity level: debug
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get setxAdvancedLogLvlDebug;

  /// Debug-log severity level: info
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get setxAdvancedLogLvlInfo;

  /// Debug-log severity level: warning
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get setxAdvancedLogLvlWarning;

  /// Debug-log severity level: error
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get setxAdvancedLogLvlError;

  /// Empty-state message shown when no logs exist yet
  ///
  /// In en, this message translates to:
  /// **'No logs yet'**
  String get setxAdvancedNoLogs;

  /// Empty-state subtitle under the no-logs message
  ///
  /// In en, this message translates to:
  /// **'Logs will appear here as you use the app'**
  String get setxAdvancedNoLogsSubtitle;

  /// Confirmation dialog title before deleting all logs
  ///
  /// In en, this message translates to:
  /// **'Clear all logs?'**
  String get setxAdvancedClearLogsTitle;

  /// Confirmation dialog body warning that all logs will be deleted
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all stored log entries.'**
  String get setxAdvancedClearLogsBody;

  /// Snackbar confirming all logs were cleared
  ///
  /// In en, this message translates to:
  /// **'Logs cleared'**
  String get setxAdvancedLogsCleared;

  /// Snackbar confirming a log entry was copied to clipboard
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get setxAdvancedCopiedToClipboard;

  /// Screen title for the Notifications settings page
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get setxNotifTitle;

  /// Section header for chapter-update notification settings
  ///
  /// In en, this message translates to:
  /// **'Chapter Updates'**
  String get setxNotifSectionChapterUpdates;

  /// Toggle label for new-chapter available notifications
  ///
  /// In en, this message translates to:
  /// **'New Chapters'**
  String get setxNotifNewChaptersTitle;

  /// Subtitle under the New Chapters notification toggle
  ///
  /// In en, this message translates to:
  /// **'Notify when new chapters are available'**
  String get setxNotifNewChaptersSubtitle;

  /// Toggle label for library-update completion notifications
  ///
  /// In en, this message translates to:
  /// **'Library Updates'**
  String get setxNotifLibraryUpdatesTitle;

  /// Subtitle under the Library Updates notification toggle
  ///
  /// In en, this message translates to:
  /// **'Notify after library update completes'**
  String get setxNotifLibraryUpdatesSubtitle;

  /// Section header for download notification settings
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get setxNotifSectionDownloads;

  /// Toggle label for download-finished notifications
  ///
  /// In en, this message translates to:
  /// **'Download Complete'**
  String get setxNotifDownloadCompleteTitle;

  /// Subtitle under the Download Complete toggle
  ///
  /// In en, this message translates to:
  /// **'Notify when chapters finish downloading'**
  String get setxNotifDownloadCompleteSubtitle;

  /// Toggle label for download-failure notifications
  ///
  /// In en, this message translates to:
  /// **'Download Error'**
  String get setxNotifDownloadErrorTitle;

  /// Subtitle under the Download Error toggle
  ///
  /// In en, this message translates to:
  /// **'Notify when a download fails'**
  String get setxNotifDownloadErrorSubtitle;

  /// Section header for notification behavior settings
  ///
  /// In en, this message translates to:
  /// **'Behavior'**
  String get setxNotifSectionBehavior;

  /// Toggle label for playing a sound with notifications
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get setxNotifSoundTitle;

  /// Subtitle under the notification Sound toggle
  ///
  /// In en, this message translates to:
  /// **'Play sound for notifications'**
  String get setxNotifSoundSubtitle;

  /// Toggle label for vibrating on notifications
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get setxNotifVibrationTitle;

  /// Subtitle under the notification Vibration toggle
  ///
  /// In en, this message translates to:
  /// **'Vibrate for notifications'**
  String get setxNotifVibrationSubtitle;

  /// Toggle label for grouping multiple notifications together
  ///
  /// In en, this message translates to:
  /// **'Group Notifications'**
  String get setxNotifGroupTitle;

  /// Subtitle under the Group Notifications toggle
  ///
  /// In en, this message translates to:
  /// **'Combine multiple notifications'**
  String get setxNotifGroupSubtitle;

  /// Screen title for the Security & Privacy settings page
  ///
  /// In en, this message translates to:
  /// **'Security & Privacy'**
  String get setxSecurityTitle;

  /// Section header for app-lock settings
  ///
  /// In en, this message translates to:
  /// **'App Lock'**
  String get setxSecuritySectionAppLock;

  /// Toggle label requiring authentication to open the app
  ///
  /// In en, this message translates to:
  /// **'App Lock'**
  String get setxSecurityAppLockTitle;

  /// Subtitle under the App Lock toggle
  ///
  /// In en, this message translates to:
  /// **'Require authentication to open app'**
  String get setxSecurityAppLockSubtitle;

  /// Toggle label for unlocking with fingerprint or face
  ///
  /// In en, this message translates to:
  /// **'Biometrics'**
  String get setxSecurityBiometricsTitle;

  /// Subtitle under the Biometrics toggle
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or face to unlock'**
  String get setxSecurityBiometricsSubtitle;

  /// Section header for privacy settings
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get setxSecuritySectionPrivacy;

  /// Toggle label for incognito/private mode
  ///
  /// In en, this message translates to:
  /// **'Incognito mode'**
  String get setxSecurityIncognitoTitle;

  /// Subtitle under the Incognito mode toggle
  ///
  /// In en, this message translates to:
  /// **'Don\'t save reading history or update trackers'**
  String get setxSecurityIncognitoSubtitle;

  /// Tooltip on the library app-bar badge shown while incognito mode is active
  ///
  /// In en, this message translates to:
  /// **'Incognito mode on'**
  String get libraryIncognitoActive;

  /// Toggle label hiding app content in the OS recent-apps view and screenshots
  ///
  /// In en, this message translates to:
  /// **'Secure Screen'**
  String get setxSecuritySecureScreenTitle;

  /// Subtitle under the Secure Screen toggle
  ///
  /// In en, this message translates to:
  /// **'Hide app content in recent apps'**
  String get setxSecuritySecureScreenSubtitle;

  /// Toggle label hiding sensitive text in notifications
  ///
  /// In en, this message translates to:
  /// **'Hide Notification Content'**
  String get setxSecurityHideNotifTitle;

  /// Subtitle under the Hide Notification Content toggle
  ///
  /// In en, this message translates to:
  /// **'Show generic notification text'**
  String get setxSecurityHideNotifSubtitle;

  /// Android notification channel name for library updates
  ///
  /// In en, this message translates to:
  /// **'Library updates'**
  String get notifChannelUpdatesName;

  /// Android notification channel description for library updates
  ///
  /// In en, this message translates to:
  /// **'New chapters and update summaries'**
  String get notifChannelUpdatesDesc;

  /// Android notification channel name for downloads
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get notifChannelDownloadsName;

  /// Android notification channel description for downloads
  ///
  /// In en, this message translates to:
  /// **'Download completion and errors'**
  String get notifChannelDownloadsDesc;

  /// Notification title when a chapter/episode finishes downloading
  ///
  /// In en, this message translates to:
  /// **'Download complete'**
  String get notifDownloadCompleteTitle;

  /// Notification title when a download fails
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get notifDownloadFailedTitle;

  /// Notification title shown once when the whole download queue finishes
  ///
  /// In en, this message translates to:
  /// **'Downloads complete'**
  String get notifDownloadsDoneTitle;

  /// Notification body summarizing how many chapters/episodes finished downloading
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item downloaded} other{{count} items downloaded}}'**
  String notifDownloadsDoneBody(int count);

  /// Notification body when the queue finished with some failures
  ///
  /// In en, this message translates to:
  /// **'{count} downloaded · {failed} failed'**
  String notifDownloadsDoneBodyFailed(int count, int failed);

  /// Notification body: how many new chapters were found for a title
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 new chapter} other{{count} new chapters}}'**
  String notifNewChapters(int count);

  /// Notification title for the library-update summary
  ///
  /// In en, this message translates to:
  /// **'Library updated'**
  String get notifLibraryUpdatedTitle;

  /// Notification body summarizing a library update run
  ///
  /// In en, this message translates to:
  /// **'{count} new chapters across {titles} titles'**
  String notifLibrarySummaryBody(int count, int titles);

  /// Generic notification body shown when Hide Notification Content is on
  ///
  /// In en, this message translates to:
  /// **'New activity'**
  String get notifHiddenBody;

  /// Notification title when installed extensions have updates available
  ///
  /// In en, this message translates to:
  /// **'Extension updates'**
  String get notifExtensionUpdatesTitle;

  /// Notification body: how many extension updates are available
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 extension update available} other{{count} extension updates available}}'**
  String notifExtensionUpdates(int count);

  /// Heading on the app-lock screen
  ///
  /// In en, this message translates to:
  /// **'Foxlations is locked'**
  String get securityLockedTitle;

  /// Button to trigger device authentication on the app-lock screen
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get securityUnlock;

  /// Reason string shown in the OS biometric/passcode prompt
  ///
  /// In en, this message translates to:
  /// **'Unlock Foxlations'**
  String get securityUnlockReason;

  /// Screen title for the Backup & Restore settings page
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get setxBackupTitle;

  /// Section header for the app's own (Foxlations) backup format
  ///
  /// In en, this message translates to:
  /// **'Foxlations backup'**
  String get setxBackupSectionFoxlations;

  /// Row label to create a Foxlations backup file
  ///
  /// In en, this message translates to:
  /// **'Create backup'**
  String get setxBackupCreateTitle;

  /// Subtitle listing what the Foxlations backup includes
  ///
  /// In en, this message translates to:
  /// **'Save your library, categories, read progress, sources and tracking'**
  String get setxBackupCreateSubtitle;

  /// Row label to restore from a Foxlations backup file
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get setxBackupRestoreTitle;

  /// Checkbox to include vault titles in a backup (requires unlock)
  ///
  /// In en, this message translates to:
  /// **'Include vault'**
  String get backupIncludeVault;

  /// Subtitle explaining the Include vault checkbox
  ///
  /// In en, this message translates to:
  /// **'Adds your vault titles under “Vault-” categories — requires unlocking'**
  String get backupIncludeVaultSubtitle;

  /// Title of the prompt to unlock the vault before including it in a backup
  ///
  /// In en, this message translates to:
  /// **'Unlock vault'**
  String get backupUnlockVaultTitle;

  /// Password field hint when unlocking the vault for a backup
  ///
  /// In en, this message translates to:
  /// **'Vault password'**
  String get backupUnlockVaultHint;

  /// Confirmation dialog title before importing a backup
  ///
  /// In en, this message translates to:
  /// **'Restore this backup?'**
  String get backupRestoreConfirmTitle;

  /// Confirmation body before importing a backup; {name} is the file name
  ///
  /// In en, this message translates to:
  /// **'This adds “{name}” to your library. You can cancel if you changed your mind.'**
  String backupRestoreConfirmBody(String name);

  /// Subtitle explaining the restore accepts a .fxbackup file
  ///
  /// In en, this message translates to:
  /// **'Restore from a Foxlations .fxbackup file'**
  String get setxBackupRestoreSubtitle;

  /// Section header for importing backups from other reader apps
  ///
  /// In en, this message translates to:
  /// **'Import from other apps'**
  String get setxBackupSectionTachiyomi;

  /// Row label to export a Tachiyomi/Mihon-compatible backup
  ///
  /// In en, this message translates to:
  /// **'Create compatible backup'**
  String get setxBackupCreateCompatTitle;

  /// Subtitle explaining the .tachibk export can be imported into Tachiyomi/Mihon/forks
  ///
  /// In en, this message translates to:
  /// **'Export a .tachibk you can import into Tachiyomi, Mihon and forks'**
  String get setxBackupCreateCompatSubtitle;

  /// Row label to import a backup from another reader app
  ///
  /// In en, this message translates to:
  /// **'Import from another app'**
  String get setxBackupRestoreTachiyomiTitle;

  /// Subtitle listing accepted external backup formats and name-matching
  ///
  /// In en, this message translates to:
  /// **'Mihon / Tachiyomi & forks, Aniyomi, Tachimanga, Mangayomi (matches sources by name)'**
  String get setxBackupRestoreTachiyomiSubtitle;

  /// Section header for automatic scheduled backups
  ///
  /// In en, this message translates to:
  /// **'Automatic backup'**
  String get setxBackupSectionAutomatic;

  /// Row label to choose the automatic backup frequency
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get setxBackupFrequency;

  /// Subtitle showing the auto-backup schedule; {freq} is the interval word (e.g. Daily)
  ///
  /// In en, this message translates to:
  /// **'Auto-create a backup {freq}'**
  String setxBackupAutoSubtitle(Object freq);

  /// Section header listing existing backups; {count} is the number of backups
  ///
  /// In en, this message translates to:
  /// **'Backups ({count})'**
  String setxBackupSectionBackups(Object count);

  /// Empty-state message when no backups exist yet
  ///
  /// In en, this message translates to:
  /// **'No backups yet.'**
  String get setxBackupNone;

  /// Restore option in a backup entry's popup menu
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get setxBackupMenuRestore;

  /// Delete option in a backup entry's popup menu
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get setxBackupMenuDelete;

  /// Frequency choice: automatic backups disabled
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get setxBackupFreqOff;

  /// Frequency choice: back up once a day
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get setxBackupFreqDaily;

  /// Frequency choice: back up once a week
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get setxBackupFreqWeekly;

  /// Frequency choice: back up once a month
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get setxBackupFreqMonthly;

  /// Snackbar after restore; {count} is the number of manga imported
  ///
  /// In en, this message translates to:
  /// **'Imported {count} manga'**
  String setxBackupImportedManga(Object count);

  /// Snackbar confirming a backup restore finished
  ///
  /// In en, this message translates to:
  /// **'Restore complete'**
  String get setxBackupRestoreComplete;

  /// Title of the dialog that maps a backup's categories after import
  ///
  /// In en, this message translates to:
  /// **'Organize imported categories'**
  String get backupOrganizeTitle;

  /// Explains the category-mapping choices after a backup import
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{The backup added 1 category. Keep it, or send it to one of yours.} other{The backup added {count} categories. Keep each, or send it to one of yours.}}'**
  String backupOrganizePrompt(int count);

  /// Button to leave the imported categories unchanged
  ///
  /// In en, this message translates to:
  /// **'Keep as-is'**
  String get backupOrganizeKeepAll;

  /// Button to apply the category mapping
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get backupOrganizeApply;

  /// Dropdown option to keep a backup category as its own
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get backupOrganizeKeep;

  /// Toggle to include the vault's categories as mapping targets
  ///
  /// In en, this message translates to:
  /// **'Show vault categories'**
  String get backupOrganizeShowVault;

  /// Shown when the vault is locked and its categories can't be targets yet
  ///
  /// In en, this message translates to:
  /// **'Unlock the vault to use its categories'**
  String get backupOrganizeUnlockVault;

  /// Label for a vault category target in the mapping dropdown
  ///
  /// In en, this message translates to:
  /// **'Vault: {name}'**
  String backupOrganizeVaultPrefix(String name);

  /// How many titles are in a backup category being mapped
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 title} other{{count} titles}}'**
  String backupOrganizeItemCount(int count);

  /// Snackbar after applying the category mapping
  ///
  /// In en, this message translates to:
  /// **'Reorganized {count} titles'**
  String backupOrganizeDone(int count);

  /// Snackbar when restore fails; {error} is the error message
  ///
  /// In en, this message translates to:
  /// **'Restore failed: {error}'**
  String setxBackupRestoreFailed(Object error);

  /// Screen title for the About page
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get setxAboutTitle;

  /// Section header for app info on the About page
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get setxAboutSectionApp;

  /// Row label opening the changelog/release notes
  ///
  /// In en, this message translates to:
  /// **'What\'s New'**
  String get setxAboutWhatsNewTitle;

  /// Subtitle under the What's New row
  ///
  /// In en, this message translates to:
  /// **'Changelog and release notes'**
  String get setxAboutWhatsNewSubtitle;

  /// Row label to check for a newer app build
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get setxAboutCheckUpdatesTitle;

  /// Subtitle under the Check for Updates row
  ///
  /// In en, this message translates to:
  /// **'See if a newer build has been released'**
  String get setxAboutCheckUpdatesSubtitle;

  /// Section header for legal info on the About page
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get setxAboutSectionLegal;

  /// Row label opening open-source license info
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get setxAboutLicensesTitle;

  /// Subtitle under the Licenses row
  ///
  /// In en, this message translates to:
  /// **'Open source licenses'**
  String get setxAboutLicensesSubtitle;

  /// Section header for external links on the About page
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get setxAboutSectionLinks;

  /// Row label to copy the project's GitHub URL
  ///
  /// In en, this message translates to:
  /// **'Source Code'**
  String get setxAboutSourceCodeTitle;

  /// Subtitle under Source Code row prompting a tap to copy
  ///
  /// In en, this message translates to:
  /// **'Tap to copy GitHub URL'**
  String get setxAboutSourceCodeSubtitle;

  /// Row label to copy the issue-tracker URL
  ///
  /// In en, this message translates to:
  /// **'Report a Bug'**
  String get setxAboutReportBugTitle;

  /// Subtitle under Report a Bug row prompting a tap to copy
  ///
  /// In en, this message translates to:
  /// **'Tap to copy issue tracker URL'**
  String get setxAboutReportBugSubtitle;

  /// Close button on the What's New / changelog dialog
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get setxAboutClose;

  /// Version line under the app name on the About page; {version} is like 1.2.99 and {build} is like 285
  ///
  /// In en, this message translates to:
  /// **'Version {version} (Build {build})'**
  String setxAboutVersionBuild(String version, String build);

  /// Subtitle under the Discord row on the About page
  ///
  /// In en, this message translates to:
  /// **'Join the community'**
  String get setxAboutDiscordSubtitle;

  /// Title of the Settings > Help & Tips page
  ///
  /// In en, this message translates to:
  /// **'Help & Tips'**
  String get helpTipsTitle;

  /// Row that replays the first-launch tutorial
  ///
  /// In en, this message translates to:
  /// **'View tutorial'**
  String get helpTipsViewTutorial;

  /// Subtitle under the View tutorial row
  ///
  /// In en, this message translates to:
  /// **'A quick tour of the app'**
  String get helpTipsViewTutorialSub;

  /// Row that opens the community Discord invite
  ///
  /// In en, this message translates to:
  /// **'Join our Discord'**
  String get helpTipsDiscord;

  /// Subtitle under the Join our Discord row
  ///
  /// In en, this message translates to:
  /// **'Help, requests & community'**
  String get helpTipsDiscordSub;

  /// Section header above the list of quick tips
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get helpTipsSectionTips;

  /// Tip title: what to do when the app shows no manga/sources
  ///
  /// In en, this message translates to:
  /// **'No content showing?'**
  String get helpTipsNoContentTitle;

  /// Tip body telling the user to add a source repository from the Browse overflow menu
  ///
  /// In en, this message translates to:
  /// **'Add an extension repository in Browse → ⋯ to install sources first.'**
  String get helpTipsNoContentBody;

  /// Tip title about reader touch gestures
  ///
  /// In en, this message translates to:
  /// **'Reader gestures'**
  String get helpTipsGesturesTitle;

  /// Tip body explaining reader tap zones and long-press
  ///
  /// In en, this message translates to:
  /// **'Tap the edges to turn pages, the center to show controls; long-press a page for more.'**
  String get helpTipsGesturesBody;

  /// Tip title about the private Vault feature
  ///
  /// In en, this message translates to:
  /// **'The Vault'**
  String get helpTipsVaultTitle;

  /// Tip body explaining the Vault keeps titles behind a lock
  ///
  /// In en, this message translates to:
  /// **'Move private titles into the Vault to keep them behind a lock.'**
  String get helpTipsVaultBody;

  /// Tip title about keeping the library updated
  ///
  /// In en, this message translates to:
  /// **'Keep up to date'**
  String get helpTipsUpdateTitle;

  /// Tip body explaining pull-to-refresh and the update schedule setting
  ///
  /// In en, this message translates to:
  /// **'Pull down on the Library to check for new chapters; set a schedule in Library settings.'**
  String get helpTipsUpdateBody;

  /// Button that skips the first-launch tutorial
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get tutorialSkip;

  /// Button to advance to the next tutorial slide
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tutorialNext;

  /// Button on the last tutorial slide that finishes the tour
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get tutorialGetStarted;

  /// Button on the tutorial community slide that opens the Discord invite
  ///
  /// In en, this message translates to:
  /// **'Join Discord'**
  String get tutorialJoinDiscord;

  /// Tutorial slide 1 title (Foxlations is the app's brand name, keep it)
  ///
  /// In en, this message translates to:
  /// **'Welcome to Foxlations'**
  String get tutorialSlide1Title;

  /// Tutorial slide 1 body: what the app is
  ///
  /// In en, this message translates to:
  /// **'One app for manga and manhwa, anime, and light novels - read, watch and listen, all from sources you add yourself. No account, no ads, nothing phoning home.'**
  String get tutorialSlide1Body;

  /// Tutorial slide 2 title
  ///
  /// In en, this message translates to:
  /// **'Get your content'**
  String get tutorialSlide2Title;

  /// Tutorial slide 2 body: how to add source repositories
  ///
  /// In en, this message translates to:
  /// **'Foxlations ships empty - you choose the sources. In the Browse tab, open the ⋯ menu to add an extension repository (a link your community shares). Installed sources show up ready to search.'**
  String get tutorialSlide2Body;

  /// Tutorial slide 3 title
  ///
  /// In en, this message translates to:
  /// **'Build your library'**
  String get tutorialSlide3Title;

  /// Tutorial slide 3 body: searching and adding titles to the library
  ///
  /// In en, this message translates to:
  /// **'Search a source or use global search across all of them, open a title, and tap the heart to add it. Your library is organized with categories (Reading, On-hold, your own…) and a “Continue reading” shortcut right up top.'**
  String get tutorialSlide3Body;

  /// Tutorial slide 4 title
  ///
  /// In en, this message translates to:
  /// **'Read your way'**
  String get tutorialSlide4Title;

  /// Tutorial slide 4 body: reader modes and options
  ///
  /// In en, this message translates to:
  /// **'Paged, webtoon or double-page; tap the edges to turn pages and the centre for controls. Dial in eye-comfort (warm filter + dim), customise the novel reader, let it read novels aloud, and skip anime intros automatically.'**
  String get tutorialSlide4Body;

  /// Tutorial slide 5 title
  ///
  /// In en, this message translates to:
  /// **'Private & offline'**
  String get tutorialSlide5Title;

  /// Tutorial slide 5 body: downloads, backup, Vault, privacy
  ///
  /// In en, this message translates to:
  /// **'Download chapters and episodes to read with no connection, back up your whole library, and keep private titles locked away in the Vault. There’s incognito mode and an app lock too.'**
  String get tutorialSlide5Body;

  /// Tutorial slide 6 title
  ///
  /// In en, this message translates to:
  /// **'Join the community'**
  String get tutorialSlide6Title;

  /// Tutorial slide 6 body: inviting the user to the community Discord
  ///
  /// In en, this message translates to:
  /// **'Questions, source help, feature requests, or just want to chat? Come say hi on our Discord - and you can reopen this tour any time from Settings → Help & Tips.'**
  String get tutorialSlide6Body;

  /// Changelog dialog title; {version} is the app version number
  ///
  /// In en, this message translates to:
  /// **'What\'s New in v{version}'**
  String setxAboutWhatsNewVersioned(Object version);

  /// Snackbar after copying a link; {label} is the link's name (e.g. Source code)
  ///
  /// In en, this message translates to:
  /// **'{label} link copied to clipboard'**
  String setxAboutLinkCopied(Object label);

  /// Link name used in the copied-to-clipboard snackbar for the source code URL
  ///
  /// In en, this message translates to:
  /// **'Source code'**
  String get setxAboutSourceCodeLabel;

  /// Link name used in the copied-to-clipboard snackbar for the bug report URL
  ///
  /// In en, this message translates to:
  /// **'Bug report'**
  String get setxAboutBugReportLabel;

  /// Title of the dialog asking whether to resume video playback.
  ///
  /// In en, this message translates to:
  /// **'Resume playback?'**
  String get miscResumePlaybackTitle;

  /// Dialog text showing where playback stopped; {time} = last watched timestamp (e.g. 12:34).
  ///
  /// In en, this message translates to:
  /// **'You stopped watching at {time}.'**
  String miscStoppedWatchingAt(Object time);

  /// Button to restart video playback from the beginning.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get miscStartOver;

  /// Button to resume playback; {time} = the saved position timestamp.
  ///
  /// In en, this message translates to:
  /// **'Continue ({time})'**
  String miscContinueAt(Object time);

  /// Label for the video quality selector in the player.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get miscQuality;

  /// Label for a numbered video source/stream option; {index} = source number.
  ///
  /// In en, this message translates to:
  /// **'Source {index}'**
  String miscSourceIndex(Object index);

  /// Label for the subtitle track selector in the player.
  ///
  /// In en, this message translates to:
  /// **'Subtitles'**
  String get miscSubtitles;

  /// Option to turn subtitles off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get miscSubtitleOff;

  /// Fallback label for an audio/subtitle track with no known name.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get miscUnknownTrack;

  /// Label for the control that shifts subtitle timing.
  ///
  /// In en, this message translates to:
  /// **'Subtitle delay'**
  String get miscSubtitleDelay;

  /// Label for the audio track selector in the player.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get miscAudio;

  /// Label for the playback speed control in the player.
  ///
  /// In en, this message translates to:
  /// **'Playback speed'**
  String get miscPlaybackSpeed;

  /// Button that skips the episode's ending/outro segment.
  ///
  /// In en, this message translates to:
  /// **'Skip Outro'**
  String get miscSkipOutro;

  /// Button that skips the episode's opening/intro segment.
  ///
  /// In en, this message translates to:
  /// **'Skip Intro'**
  String get miscSkipIntro;

  /// Button to unlock the player controls after they were locked.
  ///
  /// In en, this message translates to:
  /// **'Unlock controls'**
  String get miscUnlockControls;

  /// Generic fallback message shown when an error has no specific description.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get miscUnknownError;

  /// Generic Retry button, shown after a failed action.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get miscRetry;

  /// Title of the screen listing extension repositories.
  ///
  /// In en, this message translates to:
  /// **'Extension Repositories'**
  String get miscExtensionRepositories;

  /// Placeholder text in the field for a repository URL (expects an index.json link).
  ///
  /// In en, this message translates to:
  /// **'Repository URL (index.json)'**
  String get miscRepositoryUrlHint;

  /// Generic Add button, here to add a repository.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get miscAdd;

  /// Title of the confirmation dialog shown when a foxlations:// link asks to add a source repository
  ///
  /// In en, this message translates to:
  /// **'Add source repo?'**
  String get deeplinkAddRepoTitle;

  /// Shows which site a deep-linked repo comes from; {host} is the domain
  ///
  /// In en, this message translates to:
  /// **'From {host}'**
  String deeplinkFromHost(String host);

  /// Snackbar after adding a named repo via deep link; {name} is the repo name
  ///
  /// In en, this message translates to:
  /// **'Added \"{name}\" - see Browse > Extensions'**
  String deeplinkAddedNamed(String name);

  /// Snackbar after adding an unnamed repo via deep link
  ///
  /// In en, this message translates to:
  /// **'Repo added - see Browse > Extensions'**
  String get deeplinkAdded;

  /// Snackbar when adding a deep-linked repo fails; {error} is the error detail
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t add repo: {error}'**
  String deeplinkAddFailed(String error);

  /// Section header above the list of added repositories; often shown uppercase.
  ///
  /// In en, this message translates to:
  /// **'REPOSITORIES'**
  String get miscRepositoriesHeader;

  /// Empty-state message when no extension repositories have been added.
  ///
  /// In en, this message translates to:
  /// **'No repos added yet'**
  String get miscNoReposYet;

  /// Error snackbar when adding a repository fails; {error} = failure reason/message.
  ///
  /// In en, this message translates to:
  /// **'Failed to add repo: {error}'**
  String miscFailedToAddRepo(Object error);

  /// Title shown when the user must pass a Cloudflare human-verification check.
  ///
  /// In en, this message translates to:
  /// **'Verify you are human'**
  String get miscVerifyHuman;

  /// Instructions for completing the Cloudflare verification shown below this text.
  ///
  /// In en, this message translates to:
  /// **'Complete the site’s check below. It closes automatically and won’t ask again while the verification lasts.'**
  String get miscCfInstructions;

  /// Header/title of the Tracking section or dialog.
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get trackTitle;

  /// Empty-state label shown when no tracking service is linked.
  ///
  /// In en, this message translates to:
  /// **'No tracker connected'**
  String get trackNoTrackerConnected;

  /// Hint under the no-tracker empty state pointing to Settings › Tracking; keep AniList/MyAnimeList/Kitsu untranslated.
  ///
  /// In en, this message translates to:
  /// **'Connect AniList, MyAnimeList, or Kitsu in Settings › Tracking.'**
  String get trackConnectHint;

  /// Status label meaning this title isn't linked on a service; {name} is the tracker's name.
  ///
  /// In en, this message translates to:
  /// **'Not linked on {name}'**
  String trackNotLinkedOn(Object name);

  /// Button to link this title to a tracking service.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get trackLink;

  /// Button to remove the link between this title and a tracking service.
  ///
  /// In en, this message translates to:
  /// **'Unlink'**
  String get trackUnlink;

  /// Label for the reading/watching status field (e.g. Reading, Completed).
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get trackStatus;

  /// Label for the chapter-progress field in the tracking panel.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get trackChapters;

  /// Label for the user's score/rating field in the tracking panel.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get trackScore;

  /// Label showing the title is linked; {name} is the tracker's name.
  ///
  /// In en, this message translates to:
  /// **'Linked to {name}'**
  String trackLinkedTo(Object name);

  /// Button/action to link this title on a specific service; {name} is the tracker's name.
  ///
  /// In en, this message translates to:
  /// **'Link on {name}'**
  String trackLinkOn(Object name);

  /// Placeholder text in the search-title field of the link dialog.
  ///
  /// In en, this message translates to:
  /// **'Search title'**
  String get trackSearchTitleHint;

  /// Search button in the link-to-tracker dialog.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get trackSearch;

  /// Message shown when a tracker title search returns nothing.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get trackNoResults;

  /// Compact chapter count on a search result; {count} is the number of chapters.
  ///
  /// In en, this message translates to:
  /// **'{count} ch'**
  String trackChaptersShort(Object count);

  /// Title/button to connect a tracking service; {name} is the tracker's name.
  ///
  /// In en, this message translates to:
  /// **'Connect {name}'**
  String trackConnectTracker(Object name);

  /// Instructions on the OAuth login screen telling the user to authorize.
  ///
  /// In en, this message translates to:
  /// **'Log in and press Authorize. You’ll be signed in automatically.'**
  String get trackOauthInstructions;

  /// Section header for the list of tracking services in Settings.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get trackServices;

  /// Explanatory text under the Services header describing auto-syncing of reading progress.
  ///
  /// In en, this message translates to:
  /// **'Connect a tracking service to sync your reading progress. Once a manga is linked, progress updates automatically as you read.'**
  String get trackServicesDescription;

  /// Login dialog title; {name} is the tracking service being signed into.
  ///
  /// In en, this message translates to:
  /// **'Log in to {name}'**
  String trackLogInTo(Object name);

  /// Label for the email/username field in the tracker login form.
  ///
  /// In en, this message translates to:
  /// **'Email or username'**
  String get trackEmailOrUsername;

  /// Label for the password field in the tracker login form.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get trackPassword;

  /// Cancel button in tracking dialogs.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get trackCancel;

  /// Log in button in the tracker login form.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get trackLogIn;

  /// Confirmation that the account is linked; {name} is the tracking service.
  ///
  /// In en, this message translates to:
  /// **'Connected to {name}'**
  String trackConnectedTo(Object name);

  /// Error snackbar shown when tracker login fails due to bad credentials.
  ///
  /// In en, this message translates to:
  /// **'Login failed — check your credentials'**
  String get trackLoginFailed;

  /// Error snackbar telling the user to enter a client ID before connecting.
  ///
  /// In en, this message translates to:
  /// **'Set a client ID first'**
  String get trackSetClientIdFirst;

  /// Error snackbar shown when the OAuth sign-in flow does not finish.
  ///
  /// In en, this message translates to:
  /// **'Could not complete sign-in'**
  String get trackCouldNotCompleteSignIn;

  /// Title of the advanced client-ID dialog; {name} is the tracking service.
  ///
  /// In en, this message translates to:
  /// **'{name} client ID (advanced)'**
  String trackClientIdTitle(Object name);

  /// Help text in the advanced client-ID dialog; {name} is the tracking service (appears three times).
  ///
  /// In en, this message translates to:
  /// **'Optional. Foxlations already has a built-in {name} client ID — just tap Connect. Only set this if you registered your own {name} developer app and want to use it instead.'**
  String trackClientIdDescription(Object name);

  /// Label for the client ID input field.
  ///
  /// In en, this message translates to:
  /// **'Client ID'**
  String get trackClientId;

  /// Save button in the client-ID dialog.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get trackSave;

  /// Title/label for the paste-access-token dialog.
  ///
  /// In en, this message translates to:
  /// **'Paste access token'**
  String get trackPasteAccessToken;

  /// Placeholder hint in the access-token paste field.
  ///
  /// In en, this message translates to:
  /// **'Paste the token shown after authorizing'**
  String get trackPasteTokenHint;

  /// Connect button to link/authorize a tracking service.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get trackConnect;

  /// Error snackbar shown when the pasted access token can't be verified.
  ///
  /// In en, this message translates to:
  /// **'Could not verify token'**
  String get trackCouldNotVerifyToken;

  /// Short status label indicating the service is connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get trackConnected;

  /// Status showing which account is signed in; {username} is the account name.
  ///
  /// In en, this message translates to:
  /// **'Connected as {username}'**
  String trackConnectedAs(Object username);

  /// Hint prompting the user to tap Connect to start authorization.
  ///
  /// In en, this message translates to:
  /// **'Tap Connect to authorize'**
  String get trackTapConnectToAuthorize;

  /// Prompt to sign in with the user's own tracking-service account.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your account'**
  String get trackSignInWithAccount;

  /// Button to disconnect/unlink a tracking service account.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get trackDisconnect;

  /// Header/title of the AI & Translation settings screen.
  ///
  /// In en, this message translates to:
  /// **'AI & Translation'**
  String get trackAiTitle;

  /// Tab label for translation settings.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get trackTabTranslation;

  /// Tab label for the API keys section.
  ///
  /// In en, this message translates to:
  /// **'API Keys'**
  String get trackTabApiKeys;

  /// Tab label for the translation models section.
  ///
  /// In en, this message translates to:
  /// **'Models'**
  String get trackTabModels;

  /// Toggle label to enable AI-powered translation.
  ///
  /// In en, this message translates to:
  /// **'Enable AI Translation'**
  String get trackEnableAiTranslation;

  /// Subtitle explaining the AI translation toggle adds a translate button in the reader.
  ///
  /// In en, this message translates to:
  /// **'Show translate button in the reader'**
  String get trackEnableAiTranslationDesc;

  /// Label for the AI/translation provider selector.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get trackProvider;

  /// Toggle label for offline translation mode.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get trackOfflineMode;

  /// Subtitle explaining offline mode uses downloaded models without internet.
  ///
  /// In en, this message translates to:
  /// **'Use downloaded models without internet'**
  String get trackOfflineModeDesc;

  /// Section header for translation settings.
  ///
  /// In en, this message translates to:
  /// **'Translation Settings'**
  String get trackTranslationSettings;

  /// Label for the target language selector.
  ///
  /// In en, this message translates to:
  /// **'Target Language'**
  String get trackTargetLanguage;

  /// Subtitle explaining text is translated into the chosen language.
  ///
  /// In en, this message translates to:
  /// **'Translate manga text into this language'**
  String get trackTargetLanguageDesc;

  /// Toggle label for automatic speech-bubble detection.
  ///
  /// In en, this message translates to:
  /// **'Bubble Detection'**
  String get trackBubbleDetection;

  /// Subtitle explaining bubble detection finds speech bubbles on manga pages.
  ///
  /// In en, this message translates to:
  /// **'Auto-detect speech bubbles in manga pages'**
  String get trackBubbleDetectionDesc;

  /// Label for the translation quality selector.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get trackQuality;

  /// Quality option: fast (lower quality, quicker).
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get trackQualityFast;

  /// Quality option: balanced between speed and quality.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get trackQualityBalanced;

  /// Quality option: high quality (slower).
  ///
  /// In en, this message translates to:
  /// **'High Quality'**
  String get trackQualityHigh;

  /// Label/header for the Koharu inpainting server settings; Koharu is a product name.
  ///
  /// In en, this message translates to:
  /// **'Koharu Server'**
  String get trackKoharuServer;

  /// Label for the server URL input field.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get trackServerUrl;

  /// Subtitle explaining Koharu does full manga inpainting via a local Docker server.
  ///
  /// In en, this message translates to:
  /// **'Full manga inpainting via local Docker server'**
  String get trackKoharuServerDesc;

  /// Warning/validation shown when an API key is missing.
  ///
  /// In en, this message translates to:
  /// **'API key required'**
  String get trackApiKeyRequired;

  /// Reassurance note that API keys stay on-device and aren't sent to servers.
  ///
  /// In en, this message translates to:
  /// **'Keys are stored locally on your device and never sent to our servers.'**
  String get trackApiKeysNotice;

  /// Notice that on-device translation models are only available on Android and iOS.
  ///
  /// In en, this message translates to:
  /// **'On-device translation models are available on Android and iOS.'**
  String get trackModelsPlatformOnly;

  /// Explanatory text about downloading language packs (~30 MB each) for offline translation.
  ///
  /// In en, this message translates to:
  /// **'Download a language to translate it fully offline. Each pack is about 30 MB and is also fetched automatically the first time you translate that language.'**
  String get trackModelsDescription;

  /// Uppercase section header listing downloadable translation languages.
  ///
  /// In en, this message translates to:
  /// **'TRANSLATION LANGUAGES'**
  String get trackTranslationLanguages;

  /// Status label meaning a language pack is downloaded and usable offline.
  ///
  /// In en, this message translates to:
  /// **'Downloaded — available offline'**
  String get trackDownloaded;

  /// Status label meaning a language pack hasn't been downloaded yet.
  ///
  /// In en, this message translates to:
  /// **'Not downloaded'**
  String get trackNotDownloaded;

  /// Button to delete a downloaded language pack.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get trackDelete;

  /// Button to download a language pack.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get trackDownload;

  /// Error snackbar when a language pack download fails; {error} is the failure reason.
  ///
  /// In en, this message translates to:
  /// **'Download failed: {error}'**
  String trackDownloadFailed(Object error);

  /// Error snackbar when deleting a language pack fails; {error} is the failure reason.
  ///
  /// In en, this message translates to:
  /// **'Delete failed: {error}'**
  String trackDeleteFailed(Object error);

  /// Menu item in the repository options sheet that re-downloads a repo's sources
  ///
  /// In en, this message translates to:
  /// **'Reinstall sources'**
  String get repoReinstallSources;

  /// Menu item in the repository options sheet that copies the repo URL to the clipboard
  ///
  /// In en, this message translates to:
  /// **'Copy repo URL'**
  String get repoCopyUrl;

  /// Menu item that opens the repo's GitHub page in a browser
  ///
  /// In en, this message translates to:
  /// **'Open GitHub page'**
  String get repoOpenGithubPage;

  /// Menu item that opens the repo's website in a browser
  ///
  /// In en, this message translates to:
  /// **'Open website'**
  String get repoOpenWebsite;

  /// Menu item that opens the repo's Discord invite
  ///
  /// In en, this message translates to:
  /// **'Open Discord'**
  String get repoOpenDiscord;

  /// Destructive menu item in the repository options sheet that removes the repository
  ///
  /// In en, this message translates to:
  /// **'Delete repo'**
  String get repoDeleteRepo;

  /// Snackbar shown when a link fails to open; {url} is the URL that could not be opened
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open {url}'**
  String repoCouldNotOpen(String url);

  /// Snackbar shown while a repository's sources are being reinstalled (value ends with an ellipsis)
  ///
  /// In en, this message translates to:
  /// **'Reinstalling sources…'**
  String get repoReinstalling;

  /// Snackbar shown when a reinstall found nothing new to install but refreshed the repo
  ///
  /// In en, this message translates to:
  /// **'Repo refreshed'**
  String get repoRefreshed;

  /// Snackbar reporting how many sources were reinstalled from a repo
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Reinstalled 1 source} other{Reinstalled {count} sources}}'**
  String repoReinstalledCount(int count);

  /// Snackbar shown when reinstalling a repo's sources fails; {error} is the error message
  ///
  /// In en, this message translates to:
  /// **'Reinstall failed: {error}'**
  String repoReinstallFailed(String error);

  /// Title of the confirmation dialog before deleting a repository
  ///
  /// In en, this message translates to:
  /// **'Delete repo?'**
  String get repoDeleteTitle;

  /// Body of the delete-repo confirmation dialog; {name} is the repository name
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\" and uninstall its sources?'**
  String repoDeleteBody(String name);

  /// Confirm button in the delete-repo confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get repoDeleteConfirm;

  /// Subtitle under a repository row showing how many sources it provides
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 source} other{{count} sources}}'**
  String repoSourceCount(int count);

  /// Button that dismisses a dialog without acting; generic Cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get repoCancel;

  /// Field label for the source's display name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get repoName;

  /// Snackbar confirming one source was imported; {id} is its identifier.
  ///
  /// In en, this message translates to:
  /// **'Imported source · {id}'**
  String repoImportedSource(Object id);

  /// Progress status while searching the target source for matching library entries.
  ///
  /// In en, this message translates to:
  /// **'Checking matches'**
  String get repoCheckingMatches;

  /// Progress status shown while a migration is running.
  ///
  /// In en, this message translates to:
  /// **'Migrating'**
  String get repoMigrating;

  /// Title of the confirmation dialog for migrating one source's entries.
  ///
  /// In en, this message translates to:
  /// **'Migrate this source?'**
  String get repoMigrateThisSource;

  /// Migration preview line; {count} entries matched by URL.
  ///
  /// In en, this message translates to:
  /// **'{count} matched by URL'**
  String repoMatchedByUrl(Object count);

  /// Migration preview line; {count} entries matched by title.
  ///
  /// In en, this message translates to:
  /// **'{count} matched by title'**
  String repoMatchedByTitle(Object count);

  /// Migration preview line; {count} entries not found and kept on the old source.
  ///
  /// In en, this message translates to:
  /// **'{count} not found — left in place'**
  String repoNotFoundLeftInPlace(Object count);

  /// Explanatory note that progress, categories and tracking carry over during migration.
  ///
  /// In en, this message translates to:
  /// **'Read progress, categories and tracking carry over. The originals are removed only for entries that move.'**
  String get repoMigrateCarryOver;

  /// Confirm button on the migrate dialog; {count} is how many entries will move.
  ///
  /// In en, this message translates to:
  /// **'Migrate {count}'**
  String repoMigrateCount(Object count);

  /// Title/heading of the Migrate-a-source screen.
  ///
  /// In en, this message translates to:
  /// **'Migrate a source'**
  String get repoMigrateASource;

  /// Intro paragraph on the migration screen explaining how source-to-source moves work.
  ///
  /// In en, this message translates to:
  /// **'Move every library entry from one source to another. Same-site swaps match exactly by URL; imported entries from a backup can be re-homed to a real source too.'**
  String get repoMigrateIntro;

  /// All-caps label above the source picker for the migration origin.
  ///
  /// In en, this message translates to:
  /// **'FROM'**
  String get repoFrom;

  /// Placeholder text in the source-picker dropdown.
  ///
  /// In en, this message translates to:
  /// **'Select a source…'**
  String get repoSelectSource;

  /// All-caps label above the source picker for the migration destination.
  ///
  /// In en, this message translates to:
  /// **'TO'**
  String get repoTo;

  /// Toggle label to also match entries by title during cross-site migration.
  ///
  /// In en, this message translates to:
  /// **'Also match by title'**
  String get repoAlsoMatchByTitle;

  /// Hint under the title-matching toggle warning it may attach the wrong series.
  ///
  /// In en, this message translates to:
  /// **'For cross-site moves: if an entry isn\'t found by URL, search the new source by title and take the closest match. Off by default so it can\'t attach the wrong series.'**
  String get repoAlsoMatchByTitleHint;

  /// Button that starts the source-to-source migration.
  ///
  /// In en, this message translates to:
  /// **'Migrate source'**
  String get repoMigrateSource;

  /// Heading of the results screen shown after migration finishes.
  ///
  /// In en, this message translates to:
  /// **'Migration complete'**
  String get repoMigrationComplete;

  /// Migration result line; {count} entries moved via URL match.
  ///
  /// In en, this message translates to:
  /// **'{count} moved by URL'**
  String repoMovedByUrl(Object count);

  /// Migration result line; {count} entries moved via title match.
  ///
  /// In en, this message translates to:
  /// **'{count} moved by title'**
  String repoMovedByTitle(Object count);

  /// Migration result line; {count} entries not moved.
  ///
  /// In en, this message translates to:
  /// **'{count} left in place'**
  String repoLeftInPlace(Object count);

  /// Header above the list of entries that stayed on the old source.
  ///
  /// In en, this message translates to:
  /// **'Not migrated (still on the old source):'**
  String get repoNotMigratedHeader;

  /// Note suggesting the per-title Migrate option for the unmoved entries.
  ///
  /// In en, this message translates to:
  /// **'Use the per-title Migrate for these.'**
  String get repoUsePerTitleMigrate;

  /// Button that closes the migration results screen.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get repoDone;

  /// Screen title of the Downloads settings page.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get setdDownloadsTitle;

  /// Section header grouping automatic-download options.
  ///
  /// In en, this message translates to:
  /// **'Automatic Downloads'**
  String get setdDownloadsSectionAutomatic;

  /// Toggle label: auto-download newly released chapters.
  ///
  /// In en, this message translates to:
  /// **'Download New Chapters'**
  String get setdDownloadsNewChapters;

  /// Subtitle under the 'Download New Chapters' toggle.
  ///
  /// In en, this message translates to:
  /// **'Automatically download new chapters'**
  String get setdDownloadsNewChaptersDesc;

  /// Toggle label restricting downloads to Wi-Fi only.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi Only'**
  String get setdDownloadsWifiOnly;

  /// Subtitle under the Wi-Fi Only toggle.
  ///
  /// In en, this message translates to:
  /// **'Only download on Wi-Fi'**
  String get setdDownloadsWifiOnlyDesc;

  /// Toggle label restricting downloads to when charging.
  ///
  /// In en, this message translates to:
  /// **'Charging Only'**
  String get setdDownloadsChargingOnly;

  /// Subtitle under the Charging Only toggle.
  ///
  /// In en, this message translates to:
  /// **'Only download while plugged in'**
  String get setdDownloadsChargingOnlyDesc;

  /// Toggle label: pre-fetch upcoming chapters while reading.
  ///
  /// In en, this message translates to:
  /// **'Download Ahead While Reading'**
  String get setdDownloadsAhead;

  /// Subtitle explaining the Download Ahead toggle.
  ///
  /// In en, this message translates to:
  /// **'Pre-download next chapter as you read'**
  String get setdDownloadsAheadDesc;

  /// Section header for the download-queue settings.
  ///
  /// In en, this message translates to:
  /// **'Download Queue'**
  String get setdDownloadsSectionQueue;

  /// Setting row label: number of concurrent downloads allowed.
  ///
  /// In en, this message translates to:
  /// **'Simultaneous Downloads'**
  String get setdDownloadsSimultaneous;

  /// Setting row label for chosen download image quality.
  ///
  /// In en, this message translates to:
  /// **'Download Quality'**
  String get setdDownloadsQuality;

  /// Section header for auto-delete-of-downloads options.
  ///
  /// In en, this message translates to:
  /// **'Delete Downloaded Chapters'**
  String get setdDownloadsSectionDelete;

  /// Toggle label: delete a chapter once it is read.
  ///
  /// In en, this message translates to:
  /// **'After Reading'**
  String get setdDownloadsAfterReading;

  /// Subtitle under the After Reading toggle.
  ///
  /// In en, this message translates to:
  /// **'Delete chapters after they are read'**
  String get setdDownloadsAfterReadingDesc;

  /// Toggle label: also delete bookmarked chapters when auto-deleting.
  ///
  /// In en, this message translates to:
  /// **'Include Bookmarked Chapters'**
  String get setdDownloadsIncludeBookmarked;

  /// Subtitle under the Include Bookmarked Chapters toggle.
  ///
  /// In en, this message translates to:
  /// **'Delete bookmarked chapters along with the rest'**
  String get setdDownloadsIncludeBookmarkedDesc;

  /// Toggle label: automatically delete chapters after reading.
  ///
  /// In en, this message translates to:
  /// **'Auto-Delete Read Chapters'**
  String get setdDownloadsAutoDelete;

  /// Section header for download file-format options.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get setdDownloadsSectionFormat;

  /// Toggle label: save downloaded chapters as CBZ archives.
  ///
  /// In en, this message translates to:
  /// **'Save as CBZ'**
  String get setdDownloadsSaveCbz;

  /// Subtitle under the Save as CBZ toggle.
  ///
  /// In en, this message translates to:
  /// **'Archive chapters as CBZ files with metadata'**
  String get setdDownloadsSaveCbzDesc;

  /// Toggle label: save downloaded chapters as PDF files.
  ///
  /// In en, this message translates to:
  /// **'Save as PDF'**
  String get setdDownloadsSavePdf;

  /// Subtitle under the Save as PDF toggle.
  ///
  /// In en, this message translates to:
  /// **'Package chapters as a single PDF (one image per page)'**
  String get setdDownloadsSavePdfDesc;

  /// Section header for where downloads are stored.
  ///
  /// In en, this message translates to:
  /// **'Download Location'**
  String get setdDownloadsSectionLocation;

  /// Radio/option label: use the app's default download folder.
  ///
  /// In en, this message translates to:
  /// **'Default Location'**
  String get setdDownloadsDefaultLocation;

  /// Radio/option label: use a user-chosen download folder.
  ///
  /// In en, this message translates to:
  /// **'Custom Location'**
  String get setdDownloadsCustomLocation;

  /// Button opening the folder picker for downloads.
  ///
  /// In en, this message translates to:
  /// **'Choose Folder'**
  String get setdDownloadsChooseFolder;

  /// Explanatory note shown on iOS about folder-access limits; 'Foxlations' is the app name in the Files app path.
  ///
  /// In en, this message translates to:
  /// **'iOS does not allow apps to keep access to a folder. Downloads stay in the app\'s folder, reachable via Files › On My iPhone › Foxlations.'**
  String get setdDownloadsIosFolderWarning;

  /// Button resetting the download location to default.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get setdDownloadsReset;

  /// Section header for storage-usage info.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get setdDownloadsSectionStorage;

  /// Storage summary line; {size} is total megabytes used by downloads.
  ///
  /// In en, this message translates to:
  /// **'Total: {size} MB'**
  String setdDownloadsTotalSize(Object size);

  /// Storage breakdown line; {lib} = library size in MB, {vault} = vault size in MB.
  ///
  /// In en, this message translates to:
  /// **'Library: {lib} MB  |  Vault: {vault} MB'**
  String setdDownloadsLibraryVaultSize(Object lib, Object vault);

  /// Title of the download queue / manager screen.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get dlQueueTitle;

  /// Tooltip for the gear icon that opens download settings from the queue screen.
  ///
  /// In en, this message translates to:
  /// **'Download settings'**
  String get dlQueueSettingsTooltip;

  /// Row that opens the list of chapters/episodes downloaded this session.
  ///
  /// In en, this message translates to:
  /// **'Recently Downloaded'**
  String get dlQueueRecent;

  /// Button that resumes a paused download queue.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get dlQueueResume;

  /// Button that pauses the download queue.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get dlQueuePause;

  /// Button showing how many downloads run at once; tapping it changes the number.
  ///
  /// In en, this message translates to:
  /// **'Concurrent downloads: {count}'**
  String dlQueueConcurrent(Object count);

  /// Empty state when there are no active or queued downloads.
  ///
  /// In en, this message translates to:
  /// **'No Downloads'**
  String get dlQueueEmpty;

  /// Banner shown over the queue while downloads are paused.
  ///
  /// In en, this message translates to:
  /// **'Downloads paused'**
  String get dlQueuePaused;

  /// Per-item status label for a download waiting in the queue.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get dlQueueStatusQueued;

  /// Per-item status label for a download in progress.
  ///
  /// In en, this message translates to:
  /// **'Downloading'**
  String get dlQueueStatusDownloading;

  /// Overflow action that cancels every queued and active download.
  ///
  /// In en, this message translates to:
  /// **'Cancel all'**
  String get dlQueueCancelAll;

  /// Tooltip for the per-item cancel button.
  ///
  /// In en, this message translates to:
  /// **'Cancel download'**
  String get dlQueueCancelItem;

  /// Per-item progress; {done} pages/parts completed out of {total}.
  ///
  /// In en, this message translates to:
  /// **'{done} / {total}'**
  String dlQueueProgress(Object done, Object total);

  /// Title of the recently-downloaded list screen.
  ///
  /// In en, this message translates to:
  /// **'Recently Downloaded'**
  String get dlQueueRecentTitle;

  /// Empty state on the recently-downloaded screen (session-scoped).
  ///
  /// In en, this message translates to:
  /// **'Nothing downloaded yet'**
  String get dlQueueRecentEmpty;

  /// Action that clears the session recently-downloaded list.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get dlQueueRecentClear;

  /// Caption clarifying the recently-downloaded list resets when the app restarts.
  ///
  /// In en, this message translates to:
  /// **'This session only'**
  String get dlQueueRecentNote;

  /// Screen title of the Vault settings page.
  ///
  /// In en, this message translates to:
  /// **'Vault'**
  String get setdVaultTitle;

  /// Section header for vault access options.
  ///
  /// In en, this message translates to:
  /// **'Access'**
  String get setdVaultSectionAccess;

  /// Toggle label: turn the hidden Vault feature on.
  ///
  /// In en, this message translates to:
  /// **'Enable Vault'**
  String get setdVaultEnable;

  /// Subtitle explaining how to open the vault (tap Library 8 times).
  ///
  /// In en, this message translates to:
  /// **'Allow access to the hidden vault by tapping Library 8 times'**
  String get setdVaultEnableDesc;

  /// Section header for vault password/security options.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get setdVaultSectionSecurity;

  /// Row label shown when a vault password already exists.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get setdVaultChangePassword;

  /// Row label shown when no vault password is set yet.
  ///
  /// In en, this message translates to:
  /// **'Set Password'**
  String get setdVaultSetPassword;

  /// Subtitle shown when a vault password is set.
  ///
  /// In en, this message translates to:
  /// **'Password is set — tap to change or remove'**
  String get setdVaultPasswordSetDesc;

  /// Subtitle shown when no vault password is set.
  ///
  /// In en, this message translates to:
  /// **'Protect vault access with a password'**
  String get setdVaultPasswordUnsetDesc;

  /// Section header for vault category management.
  ///
  /// In en, this message translates to:
  /// **'Vault Categories'**
  String get setdVaultSectionCategories;

  /// Row/button opening the vault-category editor.
  ///
  /// In en, this message translates to:
  /// **'Edit Vault Categories'**
  String get setdVaultEditCategories;

  /// Subtitle under Edit Vault Categories.
  ///
  /// In en, this message translates to:
  /// **'Add, remove, and reorder vault categories'**
  String get setdVaultEditCategoriesDesc;

  /// Section header for managing vault contents.
  ///
  /// In en, this message translates to:
  /// **'Contents'**
  String get setdVaultSectionContents;

  /// Row/button opening the vault contents manager.
  ///
  /// In en, this message translates to:
  /// **'Manage Vault Contents'**
  String get setdVaultManageContents;

  /// Subtitle under Manage Vault Contents.
  ///
  /// In en, this message translates to:
  /// **'Move manga, anime or novels in and out of the vault'**
  String get setdVaultManageContentsDesc;

  /// Snackbar shown when a vault action is tried while locked.
  ///
  /// In en, this message translates to:
  /// **'Unlock the vault first (tap in from the library)'**
  String get setdVaultUnlockFirstSnack;

  /// Section header for vault-only hidden sources.
  ///
  /// In en, this message translates to:
  /// **'Hidden Sources'**
  String get setdVaultSectionHiddenSources;

  /// Row/button label for sources visible only in vault mode.
  ///
  /// In en, this message translates to:
  /// **'Vault-Only Sources'**
  String get setdVaultOnlySources;

  /// Count line for hidden sources; {count} is the number of hidden sources (plural form).
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 source hidden} other{{count} sources hidden}}'**
  String setdVaultHiddenSourcesCount(int count);

  /// Section header for the vault explanation text.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get setdVaultSectionInfo;

  /// Informational paragraph explaining what the vault is and how to toggle it.
  ///
  /// In en, this message translates to:
  /// **'The vault is a hidden library with its own categories and manga. Tap the Library tab 8 times rapidly to toggle vault mode. Vault manga are stored separately and never appear in your main library.'**
  String get setdVaultInfoText;

  /// Text-field hint for entering the existing vault password.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get setdVaultCurrentPasswordHint;

  /// Text-field hint for the new password; empty removes it.
  ///
  /// In en, this message translates to:
  /// **'New password (leave empty to remove)'**
  String get setdVaultNewPasswordHint;

  /// Text-field hint to re-type the new vault password.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get setdVaultConfirmPasswordHint;

  /// Error shown when the entered current password is incorrect.
  ///
  /// In en, this message translates to:
  /// **'Current password is wrong'**
  String get setdVaultCurrentPasswordWrong;

  /// Error shown when new and confirm passwords differ.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get setdVaultPasswordsMismatch;

  /// Progress message while decrypting/removing the vault password.
  ///
  /// In en, this message translates to:
  /// **'Removing encryption…'**
  String get setdVaultRemovingEncryption;

  /// Progress message while encrypting the vault.
  ///
  /// In en, this message translates to:
  /// **'Encrypting vault…'**
  String get setdVaultEncrypting;

  /// Snackbar confirming the vault password was removed.
  ///
  /// In en, this message translates to:
  /// **'Password removed — vault is no longer encrypted'**
  String get setdVaultPasswordRemoved;

  /// Snackbar confirming the vault password was set and vault encrypted.
  ///
  /// In en, this message translates to:
  /// **'Password set — vault encrypted'**
  String get setdVaultPasswordSet;

  /// Empty-state text when the vault has no categories.
  ///
  /// In en, this message translates to:
  /// **'No vault categories'**
  String get setdVaultNoCategories;

  /// Confirmation dialog before deleting a vault category; {name} is the category name.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? Manga in this category will not be removed from the vault.'**
  String setdVaultDeleteCategoryConfirm(Object name);

  /// Empty-state text when no sources are installed.
  ///
  /// In en, this message translates to:
  /// **'No installed sources'**
  String get setdVaultNoInstalledSources;

  /// Hint above the source list explaining the toggle behavior.
  ///
  /// In en, this message translates to:
  /// **'Toggle sources to make them only visible in vault mode.'**
  String get setdVaultHiddenSourcesToggleHint;

  /// Search-field placeholder for filtering the source list.
  ///
  /// In en, this message translates to:
  /// **'Search sources...'**
  String get setdVaultSearchSourcesHint;

  /// Text-field hint for entering a category name.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get setdCategoryNameHint;

  /// Dialog title for creating a new category.
  ///
  /// In en, this message translates to:
  /// **'New Category'**
  String get setdNewCategory;

  /// Dialog title for renaming a category.
  ///
  /// In en, this message translates to:
  /// **'Rename Category'**
  String get setdRenameCategory;

  /// Dialog title for deleting a category.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get setdDeleteCategory;

  /// Generic Cancel button in dialogs.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get setdActionCancel;

  /// Generic Save button in dialogs.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get setdActionSave;

  /// Generic Add button in dialogs.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get setdActionAdd;

  /// Generic Delete button in dialogs.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get setdActionDelete;

  /// Empty-state hint prompting the user to tap + to add a category.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add a category'**
  String get setdTapToAddCategory;

  /// Screen title of the Vault Contents manager.
  ///
  /// In en, this message translates to:
  /// **'Vault Contents'**
  String get setdVaultContentsTitle;

  /// Message shown when vault contents are viewed while locked.
  ///
  /// In en, this message translates to:
  /// **'Unlock the vault first to manage its contents.'**
  String get setdVaultContentsLockedMessage;

  /// Tab label for manga in the vault contents manager.
  ///
  /// In en, this message translates to:
  /// **'Manga'**
  String get setdVaultContentsTabManga;

  /// Tab label for anime in the vault contents manager.
  ///
  /// In en, this message translates to:
  /// **'Anime'**
  String get setdVaultContentsTabAnime;

  /// Tab label for novels in the vault contents manager.
  ///
  /// In en, this message translates to:
  /// **'Novels'**
  String get setdVaultContentsTabNovels;

  /// Empty-state for the library list; {type} is the content type (manga/anime/novels).
  ///
  /// In en, this message translates to:
  /// **'No {type} in your library'**
  String setdVaultContentsEmptyLibrary(Object type);

  /// Empty-state for the vault list; {type} is the content type (manga/anime/novels).
  ///
  /// In en, this message translates to:
  /// **'No {type} in the vault'**
  String setdVaultContentsEmptyVault(Object type);

  /// Snackbar confirming an item moved into the vault; {title} is the item title.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" moved to vault'**
  String setdVaultContentsMovedIn(Object title);

  /// Snackbar confirming an item moved out of the vault; {title} is the item title.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" moved out of vault'**
  String setdVaultContentsMovedOut(Object title);

  /// Progress label on a list item; {read} = chapters/episodes read, {total} = total count.
  ///
  /// In en, this message translates to:
  /// **'{read}/{total} read'**
  String setdVaultContentsReadProgress(Object read, Object total);

  /// Screen title of the Library settings page.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get setdLibraryTitle;

  /// Section header for library category options.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get setdLibrarySectionCategories;

  /// Row/button opening the library-category editor.
  ///
  /// In en, this message translates to:
  /// **'Edit Categories'**
  String get setdLibraryEditCategories;

  /// Subtitle under Edit Categories.
  ///
  /// In en, this message translates to:
  /// **'Add, remove, and reorder categories'**
  String get setdLibraryEditCategoriesDesc;

  /// Toggle label: hide categories that contain no items.
  ///
  /// In en, this message translates to:
  /// **'Hide Empty Categories'**
  String get setdLibraryHideEmpty;

  /// Subtitle under the Hide Empty Categories toggle.
  ///
  /// In en, this message translates to:
  /// **'Only show categories with manga'**
  String get setdLibraryHideEmptyDesc;

  /// Section header for global library-update options.
  ///
  /// In en, this message translates to:
  /// **'Global Update'**
  String get setdLibrarySectionGlobalUpdate;

  /// Setting row for how often the library auto-updates.
  ///
  /// In en, this message translates to:
  /// **'Update Frequency'**
  String get setdLibraryUpdateFrequency;

  /// Toggle label restricting library updates to Wi-Fi only.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi Only'**
  String get setdLibraryWifiOnly;

  /// Subtitle under the library Wi-Fi Only toggle.
  ///
  /// In en, this message translates to:
  /// **'Only update on Wi-Fi connections'**
  String get setdLibraryWifiOnlyDesc;

  /// Toggle label restricting library updates to when charging.
  ///
  /// In en, this message translates to:
  /// **'Only While Charging'**
  String get setdLibraryChargingOnly;

  /// Subtitle under the Only While Charging toggle.
  ///
  /// In en, this message translates to:
  /// **'Only update when device is charging'**
  String get setdLibraryChargingOnlyDesc;

  /// Section header for library update restrictions.
  ///
  /// In en, this message translates to:
  /// **'Update Restrictions'**
  String get setdLibrarySectionRestrictions;

  /// Toggle label: skip updating titles with no reading progress.
  ///
  /// In en, this message translates to:
  /// **'Skip Not Started'**
  String get setdLibrarySkipNotStarted;

  /// Subtitle under the Skip Not Started toggle.
  ///
  /// In en, this message translates to:
  /// **'Skip manga with no reading progress'**
  String get setdLibrarySkipNotStartedDesc;

  /// Toggle label: show a new-chapter count badge on cards.
  ///
  /// In en, this message translates to:
  /// **'Show New Chapter Count'**
  String get setdLibraryShowUpdateCount;

  /// Subtitle under the Show New Chapter Count toggle.
  ///
  /// In en, this message translates to:
  /// **'Show badge on library manga cards'**
  String get setdLibraryShowUpdateCountDesc;

  /// Section header for library data/migration options.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get setdLibrarySectionData;

  /// Row/button opening the source-migration flow.
  ///
  /// In en, this message translates to:
  /// **'Migrate a Source'**
  String get setdLibraryMigrateSource;

  /// Subtitle under Migrate a Source.
  ///
  /// In en, this message translates to:
  /// **'Move every entry from one source to another'**
  String get setdLibraryMigrateSourceDesc;

  /// Empty-state text when the library has no categories.
  ///
  /// In en, this message translates to:
  /// **'No categories'**
  String get setdLibraryNoCategories;

  /// Confirmation dialog before deleting a library category; {name} is the category name.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? Manga in this category will not be removed from your library.'**
  String setdLibraryDeleteCategoryConfirm(Object name);

  /// Screen title of the video Player settings page.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get setdPlayerTitle;

  /// Section header (uppercase) for double-tap seek options.
  ///
  /// In en, this message translates to:
  /// **'DOUBLE-TAP TO SEEK'**
  String get setdPlayerSectionSeek;

  /// Setting row for the double-tap forward-skip duration.
  ///
  /// In en, this message translates to:
  /// **'Skip forward'**
  String get setdPlayerSkipForward;

  /// Setting row for the double-tap backward-skip duration.
  ///
  /// In en, this message translates to:
  /// **'Skip backward'**
  String get setdPlayerSkipBackward;

  /// Section header (uppercase) for player gesture options.
  ///
  /// In en, this message translates to:
  /// **'GESTURES'**
  String get setdPlayerSectionGestures;

  /// Toggle label: hold to temporarily speed up playback.
  ///
  /// In en, this message translates to:
  /// **'Hold to speed up'**
  String get setdPlayerHoldToSpeed;

  /// Subtitle for Hold to speed up; {speed} is the playback multiplier (e.g. 2).
  ///
  /// In en, this message translates to:
  /// **'Press and hold anywhere to play at {speed}x'**
  String setdPlayerHoldToSpeedDesc(Object speed);

  /// Setting row for the hold-to-speed multiplier value.
  ///
  /// In en, this message translates to:
  /// **'Hold speed'**
  String get setdPlayerHoldSpeed;

  /// Toggle label: swipe to adjust volume.
  ///
  /// In en, this message translates to:
  /// **'Volume swipe'**
  String get setdPlayerVolumeSwipe;

  /// Subtitle explaining the volume-swipe gesture.
  ///
  /// In en, this message translates to:
  /// **'Slide up/down on the right half to adjust volume'**
  String get setdPlayerVolumeSwipeDesc;

  /// Toggle label: swipe to adjust brightness.
  ///
  /// In en, this message translates to:
  /// **'Brightness swipe'**
  String get setdPlayerBrightnessSwipe;

  /// Subtitle explaining the brightness-swipe gesture.
  ///
  /// In en, this message translates to:
  /// **'Slide up/down on the left half to adjust brightness'**
  String get setdPlayerBrightnessSwipeDesc;

  /// Section header (uppercase) for playback options.
  ///
  /// In en, this message translates to:
  /// **'PLAYBACK'**
  String get setdPlayerSectionPlayback;

  /// Setting row for the default playback speed.
  ///
  /// In en, this message translates to:
  /// **'Default speed'**
  String get setdPlayerDefaultSpeed;

  /// Toggle label: automatically play the next episode.
  ///
  /// In en, this message translates to:
  /// **'Autoplay next episode'**
  String get setdPlayerAutoplayNext;

  /// Subtitle under Autoplay next episode.
  ///
  /// In en, this message translates to:
  /// **'Start the next episode automatically when one ends'**
  String get setdPlayerAutoplayNextDesc;

  /// Toggle label: auto-skip intros and outros.
  ///
  /// In en, this message translates to:
  /// **'Auto-skip intro/outro'**
  String get setdPlayerAutoSkipIntro;

  /// Subtitle under Auto-skip intro/outro.
  ///
  /// In en, this message translates to:
  /// **'Skip source-marked openings/endings without tapping'**
  String get setdPlayerAutoSkipIntroDesc;

  /// Dialog/picker title for choosing a skip duration.
  ///
  /// In en, this message translates to:
  /// **'Skip amount'**
  String get setdPlayerSkipAmountTitle;

  /// Toggle: show a manual Skip Intro button near the start of an episode.
  ///
  /// In en, this message translates to:
  /// **'Skip-intro button'**
  String get setdPlayerShowSkipButton;

  /// Subtitle under the Skip-intro button toggle.
  ///
  /// In en, this message translates to:
  /// **'Show a Skip Intro button near the start, even when the source has no markers'**
  String get setdPlayerShowSkipButtonDesc;

  /// Dialog/picker title for choosing a playback speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get setdPlayerSpeedTitle;

  /// Screen title of the Appearance settings page.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get setdAppearanceTitle;

  /// Section header for theme options.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get setdAppearanceSectionTheme;

  /// Section header for display options.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get setdAppearanceSectionDisplay;

  /// Toggle label: invert the app's colors.
  ///
  /// In en, this message translates to:
  /// **'Invert Colors'**
  String get setdAppearanceInvertColors;

  /// Subtitle under the Invert Colors toggle.
  ///
  /// In en, this message translates to:
  /// **'Inverts the entire app UI'**
  String get setdAppearanceInvertColorsDesc;

  /// Toggle for a true-black dark-mode background.
  ///
  /// In en, this message translates to:
  /// **'Pure black (OLED)'**
  String get setdAppearanceOledBlack;

  /// Subtitle under the OLED pure-black toggle.
  ///
  /// In en, this message translates to:
  /// **'True-black background in dark mode — saves power on OLED screens'**
  String get setdAppearanceOledBlackDesc;

  /// Title for the bottom-nav reorder setting/page.
  ///
  /// In en, this message translates to:
  /// **'Navigation bar'**
  String get setdAppearanceNavOrder;

  /// Subtitle/description for the bottom-nav reorder page.
  ///
  /// In en, this message translates to:
  /// **'Drag to arrange the bottom tabs in any order'**
  String get setdAppearanceNavOrderDesc;

  /// Button to reset the nav tab order to default.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get setdAppearanceNavOrderReset;

  /// Title for the setting that picks which tab the app opens on at launch.
  ///
  /// In en, this message translates to:
  /// **'Open to'**
  String get setdAppearanceStartTab;

  /// Subtitle under the 'Open to' setting.
  ///
  /// In en, this message translates to:
  /// **'Which screen the app opens on at launch'**
  String get setdAppearanceStartTabDesc;

  /// Option label selecting the dark theme.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get setdAppearanceDarkMode;

  /// Option label selecting the light theme.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get setdAppearanceLightMode;

  /// Status subtitle indicating dark theme is active.
  ///
  /// In en, this message translates to:
  /// **'Currently dark'**
  String get setdAppearanceCurrentlyDark;

  /// Status subtitle indicating light theme is active.
  ///
  /// In en, this message translates to:
  /// **'Currently light'**
  String get setdAppearanceCurrentlyLight;

  /// Publication status badge: title is ongoing
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get detailStatusOngoing;

  /// Publication status badge: title is completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get detailStatusCompleted;

  /// Publication status badge: title is on hiatus
  ///
  /// In en, this message translates to:
  /// **'Hiatus'**
  String get detailStatusHiatus;

  /// Publication status badge: title was canceled
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get detailStatusCanceled;

  /// Publication status badge: title has finished airing/publishing
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get detailStatusFinished;

  /// Publication status badge: status is unknown
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get detailStatusUnknown;

  /// Count of chapters; {count} is the number (plural forms)
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Chapter} other{{count} Chapters}}'**
  String detailChapterCount(int count);

  /// Count of episodes for anime; {count} is the number (plural forms)
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Episode} other{{count} Episodes}}'**
  String detailEpisodeCount(int count);

  /// Progress label while downloading; {count} is number of chapters (plural forms)
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Downloading 1 chapter} other{Downloading {count} chapters}}'**
  String detailDownloadingChapters(int count);

  /// Title of the Discover tab: a feed recommending new series to read or watch.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discoverTitle;

  /// Tooltip for the button that changes how the Discover feed is ordered.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get discoverSort;

  /// Discover sort option: titles that are currently trending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get discoverSortTrending;

  /// Discover sort option: the most popular titles overall.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get discoverSortPopular;

  /// Discover content-type selector: manga/comics.
  ///
  /// In en, this message translates to:
  /// **'Manga'**
  String get discoverKindManga;

  /// Discover content-type selector: anime/video.
  ///
  /// In en, this message translates to:
  /// **'Anime'**
  String get discoverKindAnime;

  /// Discover content-type selector: light novels.
  ///
  /// In en, this message translates to:
  /// **'Novels'**
  String get discoverKindNovel;

  /// Button that removes all selected genre filters in Discover.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get discoverClearGenres;

  /// Discover empty-state heading shown when no recommendations are available.
  ///
  /// In en, this message translates to:
  /// **'Nothing to recommend right now'**
  String get discoverEmpty;

  /// Discover empty-state subtext suggesting how to get results.
  ///
  /// In en, this message translates to:
  /// **'Try another type, clear genre filters, or check your connection.'**
  String get discoverEmptyHint;

  /// Button to reload the Discover feed after an empty result.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get discoverRetry;

  /// Confirmation shown after a Discover title is added to the library.
  ///
  /// In en, this message translates to:
  /// **'Added to library'**
  String get discoverAddedToLibrary;

  /// Snackbar action to open the title that was just added to the library.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get discoverRead;

  /// Button label after the current Discover recommendation has been added to the library.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get discoverAdded;

  /// Button label while Discover searches installed sources for a readable copy of the recommendation.
  ///
  /// In en, this message translates to:
  /// **'Finding a source…'**
  String get discoverFindingSource;

  /// Button to add the current Discover recommendation to the library.
  ///
  /// In en, this message translates to:
  /// **'Add to Library'**
  String get discoverAddToLibrary;

  /// Add-button label when no installed source carries the recommended title.
  ///
  /// In en, this message translates to:
  /// **'Not in your sources'**
  String get discoverNoSourceMatch;

  /// Button label when the current recommendation has already been saved for later.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get discoverSaved;

  /// Button to bookmark a recommendation to read once a source is available.
  ///
  /// In en, this message translates to:
  /// **'Save for later'**
  String get discoverSaveForLater;

  /// Button that shows the next recommendation in the Discover feed.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get discoverNext;

  /// Title of the page listing recommendations the user saved to read later.
  ///
  /// In en, this message translates to:
  /// **'Saved for later'**
  String get discoverWishlistTitle;

  /// Empty-state heading for the Saved for later page.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet'**
  String get discoverWishlistEmpty;

  /// Empty-state subtext for the Saved for later page.
  ///
  /// In en, this message translates to:
  /// **'Save recommendations here to read once you have a source for them.'**
  String get discoverWishlistEmptyHint;

  /// Message when a saved title still isn't carried by any installed source.
  ///
  /// In en, this message translates to:
  /// **'No source found yet'**
  String get discoverNoSourceYet;

  /// Button on a saved item that searches installed sources for a readable copy.
  ///
  /// In en, this message translates to:
  /// **'Find source'**
  String get discoverFindSource;

  /// Tooltip for the switcher that picks which tracker (AniList / MyAnimeList) powers the Discover feed.
  ///
  /// In en, this message translates to:
  /// **'Recommendation source'**
  String get discoverSource;

  /// Label on a personalized recommendation card naming the title it was based on; {title} is a series name.
  ///
  /// In en, this message translates to:
  /// **'Because you read {title}'**
  String discoverBecauseYouRead(String title);

  /// Reader setting: scroll by looking toward the top/bottom of the screen (iOS front-camera gaze tracking).
  ///
  /// In en, this message translates to:
  /// **'Hands-free scrolling'**
  String get readerGazeScroll;

  /// Subtitle for the hands-free scrolling reader toggle.
  ///
  /// In en, this message translates to:
  /// **'Scroll by looking toward the top or bottom of the screen. Uses the front camera.'**
  String get readerGazeScrollSubtitle;

  /// Title of the consent dialog shown before enabling gaze scrolling.
  ///
  /// In en, this message translates to:
  /// **'Use the front camera?'**
  String get readerGazeCameraTitle;

  /// Body of the consent dialog explaining the camera + battery use of gaze scrolling.
  ///
  /// In en, this message translates to:
  /// **'Hands-free scrolling watches your gaze with the front camera while you read. It runs entirely on your device — nothing is recorded or sent anywhere — but it uses extra battery.'**
  String get readerGazeCameraWarning;

  /// Reader setting: which signal drives gaze scrolling (eyes, head tilt, or both).
  ///
  /// In en, this message translates to:
  /// **'Control with'**
  String get readerGazeMode;

  /// Reader slider: how far you must look to trigger a gaze scroll.
  ///
  /// In en, this message translates to:
  /// **'Sensitivity'**
  String get readerGazeSensitivity;

  /// Reader slider: how long a look must be held before scrolling starts.
  ///
  /// In en, this message translates to:
  /// **'Hold time'**
  String get readerGazeHoldTime;

  /// Reader slider: how much the gaze signal is smoothed.
  ///
  /// In en, this message translates to:
  /// **'Smoothing'**
  String get readerGazeSmoothing;

  /// Reader action: record the resting gaze/head position as the baseline.
  ///
  /// In en, this message translates to:
  /// **'Calibrate'**
  String get readerGazeCalibrate;

  /// Subtitle for the gaze calibration action.
  ///
  /// In en, this message translates to:
  /// **'Set your resting gaze and head position as the baseline.'**
  String get readerGazeCalibrateSubtitle;

  /// Message shown while gaze calibration samples the neutral position.
  ///
  /// In en, this message translates to:
  /// **'Look at the centre and hold still…'**
  String get readerGazeCalibrating;

  /// Reader setting: scroll by tilting the phone forward/back (accelerometer).
  ///
  /// In en, this message translates to:
  /// **'Tilt to scroll'**
  String get readerTiltScroll;

  /// Subtitle for the tilt-to-scroll reader toggle.
  ///
  /// In en, this message translates to:
  /// **'Scroll by tilting the phone forward or back. Works on any phone.'**
  String get readerTiltScrollSubtitle;

  /// Subtitle for the tilt calibration action.
  ///
  /// In en, this message translates to:
  /// **'Hold the phone at your reading angle, then set it as the baseline.'**
  String get readerTiltCalibrateSubtitle;

  /// Message shown while tilt calibration samples the resting angle.
  ///
  /// In en, this message translates to:
  /// **'Hold the phone still at your reading angle…'**
  String get readerTiltCalibrating;

  /// Reader slider: how fast hands-free (gaze/tilt) scrolling moves.
  ///
  /// In en, this message translates to:
  /// **'Scroll speed'**
  String get readerScrollSpeed;

  /// Title of the quick-options sheet opened by long-pressing the in-reader hands-free toggle.
  ///
  /// In en, this message translates to:
  /// **'Hands-free options'**
  String get readerHandsFreeOptions;

  /// Title of the gaze calibration screen.
  ///
  /// In en, this message translates to:
  /// **'Gaze calibration'**
  String get readerCalibrateTitle;

  /// Instruction while gaze calibration samples the neutral position.
  ///
  /// In en, this message translates to:
  /// **'Look at the dot and hold still'**
  String get readerCalibrateInstruction;

  /// Shown when gaze calibration succeeds.
  ///
  /// In en, this message translates to:
  /// **'Calibrated!'**
  String get readerCalibrateSuccess;

  /// Prompt during the calibration test run.
  ///
  /// In en, this message translates to:
  /// **'Try it — look up or down to scroll'**
  String get readerCalibrateTestPrompt;

  /// Button to keep the new gaze calibration.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get readerCalibrateKeep;

  /// Button to redo gaze calibration.
  ///
  /// In en, this message translates to:
  /// **'Recalibrate'**
  String get readerCalibrateRedo;

  /// Button to finish the calibration test run.
  ///
  /// In en, this message translates to:
  /// **'Done testing'**
  String get readerCalibrateDoneTest;

  /// Progress label during multi-point gaze calibration; {n} is the current point number and {total} the total count.
  ///
  /// In en, this message translates to:
  /// **'Point {n} of {total}'**
  String readerCalibratePointOf(int n, int total);

  /// Setting title for the opt-in in-reader radial control.
  ///
  /// In en, this message translates to:
  /// **'Radial menu'**
  String get readerRadialMenu;

  /// Explanation of the radial menu reader setting.
  ///
  /// In en, this message translates to:
  /// **'Replace the reader bars with a back button and a corner wheel. Hold the wheel for quick actions and the page slider.'**
  String get readerRadialMenuSubtitle;

  /// In-reader toggle (dual-page landscape) that offsets which pages pair into a two-page spread.
  ///
  /// In en, this message translates to:
  /// **'Shift double pages'**
  String get readerShiftPages;

  /// Explanation of the shift-double-pages reader toggle.
  ///
  /// In en, this message translates to:
  /// **'Nudge the pairing by one if two-page spreads land split across the middle.'**
  String get readerShiftPagesDesc;

  /// Small caps label above the just-finished chapter's name at a continuous-reader chapter break.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get readerFinishedLabel;

  /// Small caps label above the next chapter's name at a continuous-reader chapter break.
  ///
  /// In en, this message translates to:
  /// **'Up next'**
  String get readerUpNextLabel;

  /// Setting to choose which bottom corner the radial wheel sits in (Left or Right).
  ///
  /// In en, this message translates to:
  /// **'Wheel corner'**
  String get readerRadialCorner;

  /// Sub-instruction telling the user the calibration dot will move to several positions.
  ///
  /// In en, this message translates to:
  /// **'Follow the dot to each corner'**
  String get readerCalibrateGetReady;

  /// Heading shown when gaze calibration can't detect the eyes because there is too little light.
  ///
  /// In en, this message translates to:
  /// **'Too dark for eye tracking'**
  String get readerCalibrateDarkTitle;

  /// Explanation shown when calibration falls back to head-tilt control due to low light.
  ///
  /// In en, this message translates to:
  /// **'Your eyes need some light to track. Switched to head-tilt — it works in any light. Tilt your head up or down to scroll.'**
  String get readerCalibrateDarkBody;

  /// Prompt during the calibration test run when head-tilt control is active.
  ///
  /// In en, this message translates to:
  /// **'Tilt your head up or down to scroll'**
  String get readerCalibrateTestPromptHead;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ja',
    'pt',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
