// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tack';

  @override
  String get notes => 'Notes';

  @override
  String get tags => 'Tags';

  @override
  String get settings => 'Settings';

  @override
  String get search => 'Search';

  @override
  String get newNote => 'New Note';

  @override
  String get editNote => 'Edit';

  @override
  String get deleteNote => 'Delete note?';

  @override
  String get deleteConfirm => 'This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get done => 'Done';

  @override
  String get startWriting => 'Start writing...';

  @override
  String get addTag => 'Add tag...';

  @override
  String get noNotes => 'No notes';

  @override
  String noNotesWithTag(Object tag) {
    return 'No notes with tag $tag';
  }

  @override
  String get noTags => 'No tags';

  @override
  String get tagsAutoCreate =>
      'Tags are created automatically when added to notes';

  @override
  String get tapToCreate => 'Tap + to create';

  @override
  String get searchHint => 'Search notes...';

  @override
  String get searchNotesHint => 'Search notes... (#tag)';

  @override
  String get noResults => 'Nothing found';

  @override
  String get typeToSearch => 'Type to search';

  @override
  String get newTag => 'New Tag';

  @override
  String get tagName => 'Tag name';

  @override
  String get renameTag => 'Rename tag';

  @override
  String get renameTagHint => 'New name';

  @override
  String get deleteTag => 'Delete tag?';

  @override
  String get tagDeleteWarning => 'The tag will be removed from all notes.';

  @override
  String get createTag => 'Create';

  @override
  String get saveChanges => 'Save changes?';

  @override
  String get discard => 'Discard';

  @override
  String get noteNotFound => 'Note not found';

  @override
  String get noteDeleted => 'Note has been deleted';

  @override
  String get allNotes => 'All notes';

  @override
  String get audio => 'Audio';

  @override
  String get camera => 'Camera';

  @override
  String get attachedFiles => 'Attached files';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get recordAudio => 'Record audio';

  @override
  String get recordVideo => 'Record video';

  @override
  String get appearance => 'Appearance';

  @override
  String get colorScheme => 'Color scheme';

  @override
  String get language => 'Language';

  @override
  String get viewMode => 'View mode';

  @override
  String get fontSize => 'Font size';

  @override
  String get grouping => 'Grouping';

  @override
  String get sorting => 'Sorting';

  @override
  String get behavior => 'Behavior';

  @override
  String get autoSave => 'Auto-save';

  @override
  String get autoSaveDesc => 'Automatically save on exit';

  @override
  String get autoGeotag => 'Auto-geotag';

  @override
  String get autoGeotagDesc => 'Automatically add coordinates';

  @override
  String get showTimestamp => 'Timestamp';

  @override
  String get showTimestampDesc => 'Date and time in card and detail view';

  @override
  String get updateTimestampOnEdit => 'Update timestamp on edit';

  @override
  String get updateTimestampOnEditDesc =>
      'Set timestamp to current time when saving';

  @override
  String get data => 'Data';

  @override
  String get exportFormat => 'Export format';

  @override
  String get archiveOnShare => 'Archive when sharing';

  @override
  String get archiveOnShareDesc => 'Pack everything into ZIP before Share';

  @override
  String get exportZip => 'Export to ZIP';

  @override
  String get exportZipDesc => 'Export all notes (format from settings)';

  @override
  String get viewModeList => 'List';

  @override
  String get viewModeGrid => 'Grid';

  @override
  String get fontSizeSmall => 'Small';

  @override
  String get fontSizeMedium => 'Medium';

  @override
  String get fontSizeLarge => 'Large';

  @override
  String get groupModeNone => 'No grouping';

  @override
  String get groupModeDay => 'By day';

  @override
  String get groupModeWeek => 'By week';

  @override
  String get groupModeMonth => 'By month';

  @override
  String get sortModeDateDesc => 'Date (newest first)';

  @override
  String get sortModeDateAsc => 'Date (oldest first)';

  @override
  String get colorSchemeSage => 'Sage';

  @override
  String get colorSchemePeach => 'Peach';

  @override
  String get colorSchemeSky => 'Sky';

  @override
  String get colorSchemeYellow => 'Yellow';

  @override
  String get colorSchemeBlue => 'Blue';

  @override
  String get colorSchemeCoral => 'Coral';

  @override
  String get colorSchemeNavy => 'Navy';

  @override
  String get colorSchemeDialog => 'Color scheme';

  @override
  String get languageDialog => 'Language';

  @override
  String get viewModeDialog => 'View mode';

  @override
  String get fontSizeDialog => 'Font size';

  @override
  String get groupingDialog => 'Grouping';

  @override
  String get sortingDialog => 'Sorting';

  @override
  String get exportFormatDialog => 'Export format';

  @override
  String get localeRu => 'Русский';

  @override
  String get localeEn => 'English';

  @override
  String get localeEs => 'Español';

  @override
  String get localeDe => 'Deutsch';

  @override
  String get localeUk => 'Українська';

  @override
  String get localePl => 'Polski';

  @override
  String get localeIt => 'Italiano';

  @override
  String get localeFr => 'Français';

  @override
  String get localeKk => 'Қазақша';

  @override
  String get localeKy => 'Кыргызча';

  @override
  String get localeTr => 'Türkçe';

  @override
  String get localeZh => '简体中文';

  @override
  String get localeJa => '日本語';

  @override
  String get dateToday => 'Today';

  @override
  String get dateYesterday => 'Yesterday';

  @override
  String dateWeekHeader(Object week, Object year) {
    return 'Week $week, $year';
  }

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(Object minutes) {
    return '$minutes min ago';
  }

  @override
  String hoursAgo(Object hours) {
    return '$hours h ago';
  }

  @override
  String daysAgo(Object days) {
    return '$days d ago';
  }

  @override
  String deleteSelected(Object count) {
    return 'Delete $count notes?';
  }

  @override
  String get clearFilter => 'Clear filter';

  @override
  String selectedCount(Object count) {
    return 'Selected: $count';
  }

  @override
  String get textCopied => 'Text copied';

  @override
  String get deleteGeotag => 'Delete geotag?';

  @override
  String get deleteGeotagConfirm =>
      'Coordinates will be removed from the note.';

  @override
  String get emptyNote => 'Empty note';

  @override
  String get emptyNoteConfirm => 'The note is empty. Save?';

  @override
  String get makePhoto => 'Take photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get selectTag => 'Select tag';

  @override
  String get manage => 'Manage';

  @override
  String get stopLabel => 'Stop';

  @override
  String get addFile => 'File';

  @override
  String get recording => 'Recording...';

  @override
  String get selectTags => 'Select tags';

  @override
  String get searchTags => 'Search tags...';

  @override
  String get clearAll => 'Clear all';

  @override
  String get noTagsForQuery => 'No tags matching';

  @override
  String get apply => 'Apply';

  @override
  String get noTagsCreated => 'No tags created yet';

  @override
  String get dates => 'Dates';

  @override
  String get files => 'Files';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get quickFilter => 'Quick filter by tags:';

  @override
  String get byName => 'By name';

  @override
  String get byCount => 'By count';

  @override
  String get noMatches => 'No matches';

  @override
  String get exportTitle => 'Tack — Export';

  @override
  String exportDate(Object date) {
    return 'Export date: $date';
  }

  @override
  String noteFrom(Object date) {
    return 'Note from $date';
  }

  @override
  String get locationPermissionDenied =>
      'Location permission not granted. Enable it in phone settings.';

  @override
  String get version => 'Tack v1.0.0';

  @override
  String get error => 'Error';

  @override
  String notesCount(Object count) {
    return '$count notes';
  }

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeHighContrast => 'High Contrast';

  @override
  String get themeDialog => 'Theme';

  @override
  String get exportNoNotes => 'No notes to export';

  @override
  String get showFileThumbnails => 'File thumbnails';

  @override
  String get showFileThumbnailsDesc => 'Show files as grid with icons';

  @override
  String exportError(Object error) {
    return 'Export error: $error';
  }

  @override
  String get exportFormatMarkdown => 'Markdown';

  @override
  String get exportFormatJson => 'JSON';

  @override
  String fromDate(Object date) {
    return 'From: $date';
  }

  @override
  String toDate(Object date) {
    return 'To: $date';
  }

  @override
  String get recordingError => 'Recording failed. Please try again.';

  @override
  String get openIn => 'Open in...';

  @override
  String get shareFile => 'Share';

  @override
  String get moreOptions => 'More options';

  @override
  String get shirt => 'Shirt';

  @override
  String get noColor => 'No color';

  @override
  String get selectAll => 'Select All';

  @override
  String get deselectAll => 'Deselect All';
}
