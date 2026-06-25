import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_ky.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
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
    Locale('ru'),
    Locale('en'),
    Locale('es'),
    Locale('de'),
    Locale('uk'),
    Locale('pl'),
    Locale('it'),
    Locale('fr'),
    Locale('kk'),
    Locale('ky'),
    Locale('tr'),
    Locale('zh'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Tack'**
  String get appTitle;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @newNote.
  ///
  /// In en, this message translates to:
  /// **'New Note'**
  String get newNote;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editNote;

  /// No description provided for @deleteNote.
  ///
  /// In en, this message translates to:
  /// **'Delete note?'**
  String get deleteNote;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @startWriting.
  ///
  /// In en, this message translates to:
  /// **'Start writing...'**
  String get startWriting;

  /// No description provided for @addTag.
  ///
  /// In en, this message translates to:
  /// **'Add tag...'**
  String get addTag;

  /// No description provided for @noNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes'**
  String get noNotes;

  /// No description provided for @noNotesWithTag.
  ///
  /// In en, this message translates to:
  /// **'No notes with tag {tag}'**
  String noNotesWithTag(Object tag);

  /// No description provided for @noTags.
  ///
  /// In en, this message translates to:
  /// **'No tags'**
  String get noTags;

  /// No description provided for @tagsAutoCreate.
  ///
  /// In en, this message translates to:
  /// **'Tags are created automatically when added to notes'**
  String get tagsAutoCreate;

  /// No description provided for @tapToCreate.
  ///
  /// In en, this message translates to:
  /// **'Tap + to create'**
  String get tapToCreate;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search notes...'**
  String get searchHint;

  /// No description provided for @searchNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Search notes... (#tag)'**
  String get searchNotesHint;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get noResults;

  /// No description provided for @typeToSearch.
  ///
  /// In en, this message translates to:
  /// **'Type to search'**
  String get typeToSearch;

  /// No description provided for @newTag.
  ///
  /// In en, this message translates to:
  /// **'New Tag'**
  String get newTag;

  /// No description provided for @tagName.
  ///
  /// In en, this message translates to:
  /// **'Tag name'**
  String get tagName;

  /// No description provided for @renameTag.
  ///
  /// In en, this message translates to:
  /// **'Rename tag'**
  String get renameTag;

  /// No description provided for @renameTagHint.
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get renameTagHint;

  /// No description provided for @deleteTag.
  ///
  /// In en, this message translates to:
  /// **'Delete tag?'**
  String get deleteTag;

  /// No description provided for @tagDeleteWarning.
  ///
  /// In en, this message translates to:
  /// **'The tag will be removed from all notes.'**
  String get tagDeleteWarning;

  /// No description provided for @createTag.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createTag;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes?'**
  String get saveChanges;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @noteNotFound.
  ///
  /// In en, this message translates to:
  /// **'Note not found'**
  String get noteNotFound;

  /// No description provided for @noteDeleted.
  ///
  /// In en, this message translates to:
  /// **'Note has been deleted'**
  String get noteDeleted;

  /// No description provided for @allNotes.
  ///
  /// In en, this message translates to:
  /// **'All notes'**
  String get allNotes;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audio;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @attachedFiles.
  ///
  /// In en, this message translates to:
  /// **'Attached files'**
  String get attachedFiles;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get addPhoto;

  /// No description provided for @recordAudio.
  ///
  /// In en, this message translates to:
  /// **'Record audio'**
  String get recordAudio;

  /// No description provided for @recordVideo.
  ///
  /// In en, this message translates to:
  /// **'Record video'**
  String get recordVideo;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @colorScheme.
  ///
  /// In en, this message translates to:
  /// **'Color scheme'**
  String get colorScheme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @viewMode.
  ///
  /// In en, this message translates to:
  /// **'View mode'**
  String get viewMode;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get fontSize;

  /// No description provided for @grouping.
  ///
  /// In en, this message translates to:
  /// **'Grouping'**
  String get grouping;

  /// No description provided for @sorting.
  ///
  /// In en, this message translates to:
  /// **'Sorting'**
  String get sorting;

  /// No description provided for @behavior.
  ///
  /// In en, this message translates to:
  /// **'Behavior'**
  String get behavior;

  /// No description provided for @autoSave.
  ///
  /// In en, this message translates to:
  /// **'Auto-save'**
  String get autoSave;

  /// No description provided for @autoSaveDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically save on exit'**
  String get autoSaveDesc;

  /// No description provided for @autoGeotag.
  ///
  /// In en, this message translates to:
  /// **'Auto-geotag'**
  String get autoGeotag;

  /// No description provided for @autoGeotagDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically add coordinates'**
  String get autoGeotagDesc;

  /// No description provided for @showTimestamp.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get showTimestamp;

  /// No description provided for @showTimestampDesc.
  ///
  /// In en, this message translates to:
  /// **'Date and time in card and detail view'**
  String get showTimestampDesc;

  /// No description provided for @updateTimestampOnEdit.
  ///
  /// In en, this message translates to:
  /// **'Update timestamp on edit'**
  String get updateTimestampOnEdit;

  /// No description provided for @updateTimestampOnEditDesc.
  ///
  /// In en, this message translates to:
  /// **'Set timestamp to current time when saving'**
  String get updateTimestampOnEditDesc;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @exportFormat.
  ///
  /// In en, this message translates to:
  /// **'Export format'**
  String get exportFormat;

  /// No description provided for @archiveOnShare.
  ///
  /// In en, this message translates to:
  /// **'Archive when sharing'**
  String get archiveOnShare;

  /// No description provided for @archiveOnShareDesc.
  ///
  /// In en, this message translates to:
  /// **'Pack everything into ZIP before Share'**
  String get archiveOnShareDesc;

  /// No description provided for @exportZip.
  ///
  /// In en, this message translates to:
  /// **'Export to ZIP'**
  String get exportZip;

  /// No description provided for @exportZipDesc.
  ///
  /// In en, this message translates to:
  /// **'Export all notes (format from settings)'**
  String get exportZipDesc;

  /// No description provided for @viewModeList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get viewModeList;

  /// No description provided for @viewModeGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get viewModeGrid;

  /// No description provided for @fontSizeSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get fontSizeSmall;

  /// No description provided for @fontSizeMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get fontSizeMedium;

  /// No description provided for @fontSizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get fontSizeLarge;

  /// No description provided for @groupModeNone.
  ///
  /// In en, this message translates to:
  /// **'No grouping'**
  String get groupModeNone;

  /// No description provided for @groupModeDay.
  ///
  /// In en, this message translates to:
  /// **'By day'**
  String get groupModeDay;

  /// No description provided for @groupModeWeek.
  ///
  /// In en, this message translates to:
  /// **'By week'**
  String get groupModeWeek;

  /// No description provided for @groupModeMonth.
  ///
  /// In en, this message translates to:
  /// **'By month'**
  String get groupModeMonth;

  /// No description provided for @sortModeDateDesc.
  ///
  /// In en, this message translates to:
  /// **'Date (newest first)'**
  String get sortModeDateDesc;

  /// No description provided for @sortModeDateAsc.
  ///
  /// In en, this message translates to:
  /// **'Date (oldest first)'**
  String get sortModeDateAsc;

  /// No description provided for @colorSchemeSage.
  ///
  /// In en, this message translates to:
  /// **'Sage'**
  String get colorSchemeSage;

  /// No description provided for @colorSchemePeach.
  ///
  /// In en, this message translates to:
  /// **'Peach'**
  String get colorSchemePeach;

  /// No description provided for @colorSchemeSky.
  ///
  /// In en, this message translates to:
  /// **'Sky'**
  String get colorSchemeSky;

  /// No description provided for @colorSchemeYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get colorSchemeYellow;

  /// No description provided for @colorSchemeBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorSchemeBlue;

  /// No description provided for @colorSchemeCoral.
  ///
  /// In en, this message translates to:
  /// **'Coral'**
  String get colorSchemeCoral;

  /// No description provided for @colorSchemeNavy.
  ///
  /// In en, this message translates to:
  /// **'Navy'**
  String get colorSchemeNavy;

  /// No description provided for @colorSchemeDialog.
  ///
  /// In en, this message translates to:
  /// **'Color scheme'**
  String get colorSchemeDialog;

  /// No description provided for @languageDialog.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageDialog;

  /// No description provided for @viewModeDialog.
  ///
  /// In en, this message translates to:
  /// **'View mode'**
  String get viewModeDialog;

  /// No description provided for @fontSizeDialog.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get fontSizeDialog;

  /// No description provided for @groupingDialog.
  ///
  /// In en, this message translates to:
  /// **'Grouping'**
  String get groupingDialog;

  /// No description provided for @sortingDialog.
  ///
  /// In en, this message translates to:
  /// **'Sorting'**
  String get sortingDialog;

  /// No description provided for @exportFormatDialog.
  ///
  /// In en, this message translates to:
  /// **'Export format'**
  String get exportFormatDialog;

  /// No description provided for @localeRu.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get localeRu;

  /// No description provided for @localeEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get localeEn;

  /// No description provided for @localeEs.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get localeEs;

  /// No description provided for @localeDe.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get localeDe;

  /// No description provided for @localeUk.
  ///
  /// In en, this message translates to:
  /// **'Українська'**
  String get localeUk;

  /// No description provided for @localePl.
  ///
  /// In en, this message translates to:
  /// **'Polski'**
  String get localePl;

  /// No description provided for @localeIt.
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get localeIt;

  /// No description provided for @localeFr.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get localeFr;

  /// No description provided for @localeKk.
  ///
  /// In en, this message translates to:
  /// **'Қазақша'**
  String get localeKk;

  /// No description provided for @localeKy.
  ///
  /// In en, this message translates to:
  /// **'Кыргызча'**
  String get localeKy;

  /// No description provided for @localeTr.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get localeTr;

  /// No description provided for @localeZh.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get localeZh;

  /// No description provided for @localeJa.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get localeJa;

  /// No description provided for @dateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateToday;

  /// No description provided for @dateYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dateYesterday;

  /// No description provided for @dateWeekHeader.
  ///
  /// In en, this message translates to:
  /// **'Week {week}, {year}'**
  String dateWeekHeader(Object week, Object year);

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String minutesAgo(Object minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} h ago'**
  String hoursAgo(Object hours);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} d ago'**
  String daysAgo(Object days);

  /// No description provided for @deleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete {count} notes?'**
  String deleteSelected(Object count);

  /// No description provided for @clearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear filter'**
  String get clearFilter;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'Selected: {count}'**
  String selectedCount(Object count);

  /// No description provided for @textCopied.
  ///
  /// In en, this message translates to:
  /// **'Text copied'**
  String get textCopied;

  /// No description provided for @deleteGeotag.
  ///
  /// In en, this message translates to:
  /// **'Delete geotag?'**
  String get deleteGeotag;

  /// No description provided for @deleteGeotagConfirm.
  ///
  /// In en, this message translates to:
  /// **'Coordinates will be removed from the note.'**
  String get deleteGeotagConfirm;

  /// No description provided for @emptyNote.
  ///
  /// In en, this message translates to:
  /// **'Empty note'**
  String get emptyNote;

  /// No description provided for @emptyNoteConfirm.
  ///
  /// In en, this message translates to:
  /// **'The note is empty. Save?'**
  String get emptyNoteConfirm;

  /// No description provided for @makePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get makePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @selectTag.
  ///
  /// In en, this message translates to:
  /// **'Select tag'**
  String get selectTag;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @stopLabel.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopLabel;

  /// No description provided for @addFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get addFile;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording...'**
  String get recording;

  /// No description provided for @selectTags.
  ///
  /// In en, this message translates to:
  /// **'Select tags'**
  String get selectTags;

  /// No description provided for @searchTags.
  ///
  /// In en, this message translates to:
  /// **'Search tags...'**
  String get searchTags;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @noTagsForQuery.
  ///
  /// In en, this message translates to:
  /// **'No tags matching'**
  String get noTagsForQuery;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @noTagsCreated.
  ///
  /// In en, this message translates to:
  /// **'No tags created yet'**
  String get noTagsCreated;

  /// No description provided for @dates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get dates;

  /// No description provided for @files.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get files;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @quickFilter.
  ///
  /// In en, this message translates to:
  /// **'Quick filter by tags:'**
  String get quickFilter;

  /// No description provided for @byName.
  ///
  /// In en, this message translates to:
  /// **'By name'**
  String get byName;

  /// No description provided for @byCount.
  ///
  /// In en, this message translates to:
  /// **'By count'**
  String get byCount;

  /// No description provided for @noMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get noMatches;

  /// No description provided for @exportTitle.
  ///
  /// In en, this message translates to:
  /// **'Tack — Export'**
  String get exportTitle;

  /// No description provided for @exportDate.
  ///
  /// In en, this message translates to:
  /// **'Export date: {date}'**
  String exportDate(Object date);

  /// No description provided for @noteFrom.
  ///
  /// In en, this message translates to:
  /// **'Note from {date}'**
  String noteFrom(Object date);

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission not granted. Enable it in phone settings.'**
  String get locationPermissionDenied;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Tack v1.0.0'**
  String get version;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @notesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} notes'**
  String notesCount(Object count);

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeHighContrast.
  ///
  /// In en, this message translates to:
  /// **'High Contrast'**
  String get themeHighContrast;

  /// No description provided for @themeDialog.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeDialog;

  /// No description provided for @exportNoNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes to export'**
  String get exportNoNotes;

  /// No description provided for @showFileThumbnails.
  ///
  /// In en, this message translates to:
  /// **'File thumbnails'**
  String get showFileThumbnails;

  /// No description provided for @showFileThumbnailsDesc.
  ///
  /// In en, this message translates to:
  /// **'Show files as grid with icons'**
  String get showFileThumbnailsDesc;

  /// No description provided for @exportError.
  ///
  /// In en, this message translates to:
  /// **'Export error: {error}'**
  String exportError(Object error);

  /// No description provided for @exportFormatMarkdown.
  ///
  /// In en, this message translates to:
  /// **'Markdown'**
  String get exportFormatMarkdown;

  /// No description provided for @exportFormatJson.
  ///
  /// In en, this message translates to:
  /// **'JSON'**
  String get exportFormatJson;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From: {date}'**
  String fromDate(Object date);

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'To: {date}'**
  String toDate(Object date);

  /// No description provided for @recordingError.
  ///
  /// In en, this message translates to:
  /// **'Recording failed. Please try again.'**
  String get recordingError;

  /// No description provided for @openIn.
  ///
  /// In en, this message translates to:
  /// **'Open in...'**
  String get openIn;

  /// No description provided for @shareFile.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareFile;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// No description provided for @shirt.
  ///
  /// In en, this message translates to:
  /// **'Shirt'**
  String get shirt;

  /// No description provided for @noColor.
  ///
  /// In en, this message translates to:
  /// **'No color'**
  String get noColor;
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
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ja',
    'kk',
    'ky',
    'pl',
    'ru',
    'tr',
    'uk',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
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
    case 'kk':
      return AppLocalizationsKk();
    case 'ky':
      return AppLocalizationsKy();
    case 'pl':
      return AppLocalizationsPl();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
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
