// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Tack';

  @override
  String get notes => 'Notizen';

  @override
  String get tags => 'Tags';

  @override
  String get settings => 'Einstellungen';

  @override
  String get search => 'Suche';

  @override
  String get newNote => 'Neue Notiz';

  @override
  String get editNote => 'Bearbeiten';

  @override
  String get deleteNote => 'Notiz löschen?';

  @override
  String get deleteConfirm =>
      'Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get save => 'Speichern';

  @override
  String get done => 'Fertig';

  @override
  String get startWriting => 'Schreiben...';

  @override
  String get addTag => 'Tag hinzufügen...';

  @override
  String get noNotes => 'Keine Notizen';

  @override
  String noNotesWithTag(Object tag) {
    return 'Keine Notizen mit Tag $tag';
  }

  @override
  String get noTags => 'Keine Tags';

  @override
  String get tagsAutoCreate =>
      'Tags werden automatisch erstellt, wenn sie zu Notizen hinzugefügt werden';

  @override
  String get tapToCreate => 'Tippe auf + zum Erstellen';

  @override
  String get searchHint => 'Notizen suchen...';

  @override
  String get searchNotesHint => 'Notizen suchen... (#tag)';

  @override
  String get noResults => 'Nichts gefunden';

  @override
  String get typeToSearch => 'Tippe zum Suchen';

  @override
  String get newTag => 'Neuer Tag';

  @override
  String get tagName => 'Tag-Name';

  @override
  String get renameTag => 'Tag umbenennen';

  @override
  String get renameTagHint => 'Neuer Name';

  @override
  String get deleteTag => 'Tag löschen?';

  @override
  String get tagDeleteWarning => 'Der Tag wird aus allen Notizen entfernt.';

  @override
  String get createTag => 'Erstellen';

  @override
  String get saveChanges => 'Änderungen speichern?';

  @override
  String get discard => 'Verwerfen';

  @override
  String get noteNotFound => 'Notiz nicht gefunden';

  @override
  String get noteDeleted => 'Notiz wurde gelöscht';

  @override
  String get allNotes => 'Alle Notizen';

  @override
  String get photo => 'Foto';

  @override
  String get audio => 'Audio';

  @override
  String get attachedFiles => 'Angehängte Dateien';

  @override
  String get addPhoto => 'Foto hinzufügen';

  @override
  String get recordAudio => 'Audio aufnehmen';

  @override
  String get appearance => 'Aussehen';

  @override
  String get colorScheme => 'Farbschema';

  @override
  String get language => 'Sprache';

  @override
  String get viewMode => 'Ansichtsmodus';

  @override
  String get fontSize => 'Schriftgröße';

  @override
  String get grouping => 'Gruppierung';

  @override
  String get sorting => 'Sortierung';

  @override
  String get behavior => 'Verhalten';

  @override
  String get autoSave => 'Auto-speichern';

  @override
  String get autoSaveDesc => 'Automatisch speichern beim Verlassen';

  @override
  String get compressImages => 'Bilder komprimieren';

  @override
  String get compressImagesDesc => 'Fotogröße beim Hinzufügen reduzieren';

  @override
  String get autoGeotag => 'Auto-Geotag';

  @override
  String get autoGeotagDesc => 'Koordinaten automatisch hinzufügen';

  @override
  String get showFileNames => 'Dateinamen';

  @override
  String get showFileNamesDesc => 'Namen in der Notizkarte anzeigen';

  @override
  String get showTimestamp => 'Zeitstempel';

  @override
  String get showTimestampDesc => 'Datum und Uhrzeit in Karte und Detail';

  @override
  String get updateTimestampOnEdit =>
      'Zeitstempel bei Bearbeitung aktualisieren';

  @override
  String get updateTimestampOnEditDesc =>
      'Zeitstempel beim Speichern auf aktuelle Zeit setzen';

  @override
  String get data => 'Daten';

  @override
  String get exportFormat => 'Exportformat';

  @override
  String get archiveOnShare => 'Beim Teilen archivieren';

  @override
  String get archiveOnShareDesc => 'Alles vor Teilen in ZIP packen';

  @override
  String get exportZip => 'Als ZIP exportieren';

  @override
  String get exportZipDesc =>
      'Alle Notizen exportieren (Format aus Einstellungen)';

  @override
  String get viewModeList => 'Liste';

  @override
  String get viewModeGrid => 'Raster (2 Spalten)';

  @override
  String get fontSizeSmall => 'Klein';

  @override
  String get fontSizeMedium => 'Mittel';

  @override
  String get fontSizeLarge => 'Groß';

  @override
  String get groupModeNone => 'Keine Gruppierung';

  @override
  String get groupModeDay => 'Nach Tag';

  @override
  String get groupModeWeek => 'Nach Woche';

  @override
  String get groupModeMonth => 'Nach Monat';

  @override
  String get sortModeDateDesc => 'Datum (neueste zuerst)';

  @override
  String get sortModeDateAsc => 'Datum (älteste zuerst)';

  @override
  String get colorSchemeSage => 'Salbei';

  @override
  String get colorSchemePeach => 'Pfirsich';

  @override
  String get colorSchemeSky => 'Himmel';

  @override
  String get colorSchemeYellow => 'Gelb';

  @override
  String get colorSchemeBlue => 'Blau';

  @override
  String get colorSchemeCoral => 'Koralle';

  @override
  String get colorSchemeNavy => 'Marineblau';

  @override
  String get colorSchemeDialog => 'Farbschema';

  @override
  String get languageDialog => 'Sprache';

  @override
  String get viewModeDialog => 'Ansichtsmodus';

  @override
  String get fontSizeDialog => 'Schriftgröße';

  @override
  String get groupingDialog => 'Gruppierung';

  @override
  String get sortingDialog => 'Sortierung';

  @override
  String get exportFormatDialog => 'Exportformat';

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
  String get dateToday => 'Heute';

  @override
  String get dateYesterday => 'Gestern';

  @override
  String dateWeekHeader(Object week, Object year) {
    return 'Woche $week, $year';
  }

  @override
  String get justNow => 'Gerade eben';

  @override
  String minutesAgo(Object minutes) {
    return 'vor $minutes Min';
  }

  @override
  String hoursAgo(Object hours) {
    return 'vor $hours Std';
  }

  @override
  String daysAgo(Object days) {
    return 'vor $days Tagen';
  }

  @override
  String deleteSelected(Object count) {
    return '$count Notizen löschen?';
  }

  @override
  String get clearFilter => 'Filter zurücksetzen';

  @override
  String selectedCount(Object count) {
    return 'Ausgewählt: $count';
  }

  @override
  String get textCopied => 'Text kopiert';

  @override
  String get deleteGeotag => 'Geotag löschen?';

  @override
  String get deleteGeotagConfirm =>
      'Koordinaten werden aus der Notiz entfernt.';

  @override
  String get emptyNote => 'Leere Notiz';

  @override
  String get emptyNoteConfirm => 'Die Notiz ist leer. Speichern?';

  @override
  String get makePhoto => 'Foto aufnehmen';

  @override
  String get chooseFromGallery => 'Aus Galerie wählen';

  @override
  String get selectTag => 'Tag wählen';

  @override
  String get manage => 'Verwalten';

  @override
  String get stopLabel => 'Stopp';

  @override
  String get addFile => 'Datei';

  @override
  String get recording => 'Aufnahme...';

  @override
  String get selectTags => 'Tags wählen';

  @override
  String get searchTags => 'Tags suchen...';

  @override
  String get clearAll => 'Alle löschen';

  @override
  String get noTagsForQuery => 'Keine Tags zum Suchbegriff';

  @override
  String get apply => 'Anwenden';

  @override
  String get noTagsCreated => 'Keine Tags erstellt';

  @override
  String get dates => 'Daten';

  @override
  String get files => 'Dateien';

  @override
  String get clearFilters => 'Filter zurücksetzen';

  @override
  String get quickFilter => 'Schnellfilter nach Tags:';

  @override
  String get byName => 'Nach Name';

  @override
  String get byCount => 'Nach Anzahl';

  @override
  String get noMatches => 'Keine Treffer';

  @override
  String get exportTitle => 'Tack — Export';

  @override
  String exportDate(Object date) {
    return 'Exportdatum: $date';
  }

  @override
  String noteFrom(Object date) {
    return 'Notiz vom $date';
  }

  @override
  String get locationPermissionDenied =>
      'Standortberechtigung nicht erteilt. Aktivieren Sie es in den Telefoneinstellungen.';

  @override
  String get version => 'Tack v1.0.0';

  @override
  String get error => 'Fehler';

  @override
  String notesCount(Object count) {
    return '$count Notizen';
  }

  @override
  String get theme => 'Design';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeHighContrast => 'Hoher Kontrast';

  @override
  String get themeDialog => 'Design';

  @override
  String get exportNoNotes => 'No notes to export';

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
  String get showFileThumbnails => 'File thumbnails';

  @override
  String get showFileThumbnailsDesc => 'Show files as grid with icons';

  @override
  String get recordingError => 'Recording failed. Please try again.';
}
