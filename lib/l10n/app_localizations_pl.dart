// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Tack';

  @override
  String get notes => 'Notatki';

  @override
  String get tags => 'Tagi';

  @override
  String get settings => 'Ustawienia';

  @override
  String get search => 'Szukaj';

  @override
  String get newNote => 'Nowa notatka';

  @override
  String get editNote => 'Edytuj';

  @override
  String get deleteNote => 'Usunąć notatkę?';

  @override
  String get deleteConfirm => 'Tej czynności nie można cofnąć.';

  @override
  String get cancel => 'Anuluj';

  @override
  String get delete => 'Usuń';

  @override
  String get save => 'Zapisz';

  @override
  String get done => 'Gotowe';

  @override
  String get startWriting => 'Zacznij pisać...';

  @override
  String get addTag => 'Dodaj tag...';

  @override
  String get noNotes => 'Brak notatek';

  @override
  String noNotesWithTag(Object tag) {
    return 'Brak notatek z tagiem $tag';
  }

  @override
  String get noTags => 'Brak tagów';

  @override
  String get tagsAutoCreate =>
      'Tagi są tworzone automatycznie po dodaniu do notatek';

  @override
  String get tapToCreate => 'Naciśnij + aby utworzyć';

  @override
  String get searchHint => 'Szukaj notatek...';

  @override
  String get searchNotesHint => 'Szukaj notatek... (#tag)';

  @override
  String get noResults => 'Nic nie znaleziono';

  @override
  String get typeToSearch => 'Wpisz, aby szukać';

  @override
  String get newTag => 'Nowy tag';

  @override
  String get tagName => 'Nazwa tagu';

  @override
  String get renameTag => 'Zmień nazwę tagu';

  @override
  String get renameTagHint => 'Nowa nazwa';

  @override
  String get deleteTag => 'Usunąć tag?';

  @override
  String get tagDeleteWarning => 'Tag zostanie usunięty ze wszystkich notatek.';

  @override
  String get createTag => 'Utwórz';

  @override
  String get saveChanges => 'Zapisać zmiany?';

  @override
  String get discard => 'Odrzuć';

  @override
  String get noteNotFound => 'Notatka nie znaleziona';

  @override
  String get noteDeleted => 'Notatka została usunięta';

  @override
  String get allNotes => 'Wszystkie notatki';

  @override
  String get audio => 'Audio';

  @override
  String get camera => 'Aparat';

  @override
  String get attachedFiles => 'Załączone pliki';

  @override
  String get addPhoto => 'Dodaj zdjęcie';

  @override
  String get recordAudio => 'Nagraj audio';

  @override
  String get recordVideo => 'Nagraj wideo';

  @override
  String get appearance => 'Wygląd';

  @override
  String get colorScheme => 'Schemat kolorów';

  @override
  String get language => 'Język';

  @override
  String get viewMode => 'Widok';

  @override
  String get fontSize => 'Rozmiar czcionki';

  @override
  String get grouping => 'Grupowanie';

  @override
  String get sorting => 'Sortowanie';

  @override
  String get behavior => 'Zachowanie';

  @override
  String get autoSave => 'Autozapis';

  @override
  String get autoSaveDesc => 'Automatycznie zapisuj przy wyjściu';

  @override
  String get autoGeotag => 'Auto-geotag';

  @override
  String get autoGeotagDesc => 'Automatycznie dodawaj współrzędne';

  @override
  String get showTimestamp => 'Znacznik czasu';

  @override
  String get showTimestampDesc => 'Data i godzina w karcie i szczegółach';

  @override
  String get updateTimestampOnEdit => 'Aktualizuj znacznik przy edycji';

  @override
  String get updateTimestampOnEditDesc =>
      'Ustaw znacznik na bieżący czas przy zapisie';

  @override
  String get data => 'Dane';

  @override
  String get exportFormat => 'Format eksportu';

  @override
  String get archiveOnShare => 'Archiwizuj przy udostępnianiu';

  @override
  String get archiveOnShareDesc => 'Spakuj wszystko w ZIP przed Udostępnij';

  @override
  String get exportZip => 'Eksport do ZIP';

  @override
  String get exportZipDesc => 'Eksportuj wszystkie notatki (format z ustawień)';

  @override
  String get viewModeList => 'Lista';

  @override
  String get viewModeGrid => 'Siatka';

  @override
  String get fontSizeSmall => 'Mały';

  @override
  String get fontSizeMedium => 'Średni';

  @override
  String get fontSizeLarge => 'Duży';

  @override
  String get groupModeNone => 'Bez grupowania';

  @override
  String get groupModeDay => 'Po dniu';

  @override
  String get groupModeWeek => 'Po tygodniu';

  @override
  String get groupModeMonth => 'Po miesiącu';

  @override
  String get sortModeDateDesc => 'Data (najnowsze pierwsze)';

  @override
  String get sortModeDateAsc => 'Data (najstarsze pierwsze)';

  @override
  String get colorSchemeSage => 'Szałwia';

  @override
  String get colorSchemePeach => 'Brzoskwinia';

  @override
  String get colorSchemeSky => 'Niebo';

  @override
  String get colorSchemeYellow => 'Żółty';

  @override
  String get colorSchemeBlue => 'Niebieski';

  @override
  String get colorSchemeCoral => 'Koralowy';

  @override
  String get colorSchemeNavy => 'Granatowy';

  @override
  String get colorSchemeDialog => 'Schemat kolorów';

  @override
  String get languageDialog => 'Język';

  @override
  String get viewModeDialog => 'Widok';

  @override
  String get fontSizeDialog => 'Rozmiar czcionki';

  @override
  String get groupingDialog => 'Grupowanie';

  @override
  String get sortingDialog => 'Sortowanie';

  @override
  String get exportFormatDialog => 'Format eksportu';

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
  String get dateToday => 'Dzisiaj';

  @override
  String get dateYesterday => 'Wczoraj';

  @override
  String dateWeekHeader(Object week, Object year) {
    return 'Tydzień $week, $year';
  }

  @override
  String get justNow => 'Właśnie teraz';

  @override
  String minutesAgo(Object minutes) {
    return '$minutes min temu';
  }

  @override
  String hoursAgo(Object hours) {
    return '$hours godz temu';
  }

  @override
  String daysAgo(Object days) {
    return '$days dni temu';
  }

  @override
  String deleteSelected(Object count) {
    return 'Usunąć $count notatki?';
  }

  @override
  String get clearFilter => 'Wyczyść filtr';

  @override
  String selectedCount(Object count) {
    return 'Wybrano: $count';
  }

  @override
  String get textCopied => 'Tekst skopiowany';

  @override
  String get deleteGeotag => 'Usunąć geotag?';

  @override
  String get deleteGeotagConfirm => 'Współrzędne zostaną usunięte z notatki.';

  @override
  String get emptyNote => 'Pusta notatka';

  @override
  String get emptyNoteConfirm => 'Notatka jest pusta. Zapisać?';

  @override
  String get makePhoto => 'Zrób zdjęcie';

  @override
  String get chooseFromGallery => 'Wybierz z galerii';

  @override
  String get selectTag => 'Wybierz tag';

  @override
  String get manage => 'Zarządzaj';

  @override
  String get stopLabel => 'Stop';

  @override
  String get addFile => 'Plik';

  @override
  String get recording => 'Nagrywanie...';

  @override
  String get selectTags => 'Wybierz tagi';

  @override
  String get searchTags => 'Szukaj tagów...';

  @override
  String get clearAll => 'Wyczyść wszystko';

  @override
  String get noTagsForQuery => 'Brak tagów dla zapytania';

  @override
  String get apply => 'Zastosuj';

  @override
  String get noTagsCreated => 'Nie utworzono tagów';

  @override
  String get dates => 'Daty';

  @override
  String get files => 'Pliki';

  @override
  String get clearFilters => 'Wyczyść filtry';

  @override
  String get quickFilter => 'Szybki filtr po tagach:';

  @override
  String get byName => 'Po nazwie';

  @override
  String get byCount => 'Po ilości';

  @override
  String get noMatches => 'Brak dopasowań';

  @override
  String get exportTitle => 'Tack — Eksport';

  @override
  String exportDate(Object date) {
    return 'Data eksportu: $date';
  }

  @override
  String noteFrom(Object date) {
    return 'Notatka z $date';
  }

  @override
  String get locationPermissionDenied =>
      'Odmowa dostępu do lokalizacji. Włącz w ustawieniach telefonu.';

  @override
  String get version => 'Tack v1.0.0';

  @override
  String get error => 'Błąd';

  @override
  String notesCount(Object count) {
    return '$count notatek';
  }

  @override
  String get theme => 'Motyw';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get themeHighContrast => 'Wysoki kontrast';

  @override
  String get themeDialog => 'Motyw';

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
  String get openIn => 'Otwórz w...';

  @override
  String get shareFile => 'Udostępnij';

  @override
  String get moreOptions => 'Więcej opcji';

  @override
  String get shirt => 'Tło';

  @override
  String get noColor => 'Bez koloru';

  @override
  String get selectAll => 'Select All';

  @override
  String get deselectAll => 'Deselect All';
}
