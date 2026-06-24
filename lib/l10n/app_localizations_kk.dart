// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get appTitle => 'Tack';

  @override
  String get notes => 'Жазбалар';

  @override
  String get tags => 'Тегтер';

  @override
  String get settings => 'Баптаулар';

  @override
  String get search => 'Іздеу';

  @override
  String get newNote => 'Жаңа жазба';

  @override
  String get editNote => 'Өңдеу';

  @override
  String get deleteNote => 'Жазбаны жою?';

  @override
  String get deleteConfirm => 'Бұл әрекетті болдырмау мүмкін емес.';

  @override
  String get cancel => 'Бас тарту';

  @override
  String get delete => 'Жою';

  @override
  String get save => 'Сақтау';

  @override
  String get done => 'Дайын';

  @override
  String get startWriting => 'Жаза бастаңыз...';

  @override
  String get addTag => 'Тег қосу...';

  @override
  String get noNotes => 'Жазбалар жоқ';

  @override
  String noNotesWithTag(Object tag) {
    return '$tag тегі бар жазбалар жоқ';
  }

  @override
  String get noTags => 'Тегтер жоқ';

  @override
  String get tagsAutoCreate =>
      'Тегтер жазбаларға қосылғанда автоматты түрде жасалады';

  @override
  String get tapToCreate => 'Жасау үшін + басыңыз';

  @override
  String get searchHint => 'Жазбаларды іздеу...';

  @override
  String get searchNotesHint => 'Жазбаларды іздеу... (#тег)';

  @override
  String get noResults => 'Ештеңе табылмады';

  @override
  String get typeToSearch => 'Іздеу үшін мәтінді енгізіңіз';

  @override
  String get newTag => 'Жаңа тег';

  @override
  String get tagName => 'Тег атауы';

  @override
  String get renameTag => 'Тегті қайта атау';

  @override
  String get renameTagHint => 'Жаңа атау';

  @override
  String get deleteTag => 'Тегті жою?';

  @override
  String get tagDeleteWarning => 'Тег барлық жазбалардан жойылады.';

  @override
  String get createTag => 'Жасау';

  @override
  String get saveChanges => 'Өзгерістерді сақтау?';

  @override
  String get discard => 'Сақтамау';

  @override
  String get noteNotFound => 'Жазба табылмады';

  @override
  String get noteDeleted => 'Жазба жойылды';

  @override
  String get allNotes => 'Барлық жазбалар';

  @override
  String get audio => 'Аудио';

  @override
  String get camera => 'Камера';

  @override
  String get attachedFiles => 'Тіркелген файлдар';

  @override
  String get addPhoto => 'Фото қосу';

  @override
  String get recordAudio => 'Аудио жазу';

  @override
  String get recordVideo => 'Бейне жазу';

  @override
  String get appearance => 'Сыртқы түрі';

  @override
  String get colorScheme => 'Түс схемасы';

  @override
  String get language => 'Тіл';

  @override
  String get viewMode => 'Көрініс режимі';

  @override
  String get fontSize => 'Қаріп өлшемі';

  @override
  String get grouping => 'Топтау';

  @override
  String get sorting => 'Сұрыптау';

  @override
  String get behavior => 'Мінез-құлық';

  @override
  String get autoSave => 'Автосақтау';

  @override
  String get autoSaveDesc => 'Шыққанда автоматты түрде сақтау';

  @override
  String get autoGeotag => 'Авто-геотег';

  @override
  String get autoGeotagDesc => 'Координаттарды автоматты түрде қосу';

  @override
  String get showTimestamp => 'Уақыт белгісі';

  @override
  String get showTimestampDesc => 'Картада және толық көріністе күн мен уақыт';

  @override
  String get updateTimestampOnEdit => 'Өңдеу кезінде уақытты жаңарту';

  @override
  String get updateTimestampOnEditDesc =>
      'Сақтау кезінде уақыт белгісін ағымдағы уақытқа өзгерту';

  @override
  String get data => 'Деректер';

  @override
  String get exportFormat => 'Экспорт форматы';

  @override
  String get archiveOnShare => 'Бөлісу кезінде мұрағаттау';

  @override
  String get archiveOnShareDesc => 'Бөлісуден бұрын бәрін ZIP-ке салу';

  @override
  String get exportZip => 'ZIP-ке экспорттау';

  @override
  String get exportZipDesc =>
      'Барлық жазбаларды экспорттау (баптаулардағы формат)';

  @override
  String get viewModeList => 'Тізім';

  @override
  String get viewModeGrid => 'Тор';

  @override
  String get fontSizeSmall => 'Кіші';

  @override
  String get fontSizeMedium => 'Орташа';

  @override
  String get fontSizeLarge => 'Үлкен';

  @override
  String get groupModeNone => 'Топтаусыз';

  @override
  String get groupModeDay => 'Күн бойынша';

  @override
  String get groupModeWeek => 'Апта бойынша';

  @override
  String get groupModeMonth => 'Ай бойынша';

  @override
  String get sortModeDateDesc => 'Күні бойынша (жаңасы бірінші)';

  @override
  String get sortModeDateAsc => 'Күні бойынша (ескісі бірінші)';

  @override
  String get colorSchemeSage => 'Шалфей';

  @override
  String get colorSchemePeach => 'Шабдалы';

  @override
  String get colorSchemeSky => 'Аспан';

  @override
  String get colorSchemeYellow => 'Сары';

  @override
  String get colorSchemeBlue => 'Көк';

  @override
  String get colorSchemeCoral => 'Маржан';

  @override
  String get colorSchemeNavy => 'Қою көк';

  @override
  String get colorSchemeDialog => 'Түс схемасы';

  @override
  String get languageDialog => 'Тіл';

  @override
  String get viewModeDialog => 'Көрініс режимі';

  @override
  String get fontSizeDialog => 'Қаріп өлшемі';

  @override
  String get groupingDialog => 'Топтау';

  @override
  String get sortingDialog => 'Сұрыптау';

  @override
  String get exportFormatDialog => 'Экспорт форматы';

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
  String get dateToday => 'Бүгін';

  @override
  String get dateYesterday => 'Кеше';

  @override
  String dateWeekHeader(Object week, Object year) {
    return '$week апта, $year';
  }

  @override
  String get justNow => 'Дәл қазір';

  @override
  String minutesAgo(Object minutes) {
    return '$minutes мин бұрын';
  }

  @override
  String hoursAgo(Object hours) {
    return '$hours сағ бұрын';
  }

  @override
  String daysAgo(Object days) {
    return '$days күн бұрын';
  }

  @override
  String deleteSelected(Object count) {
    return '$count жазбаны жою?';
  }

  @override
  String get clearFilter => 'Сүзгіні тазалау';

  @override
  String selectedCount(Object count) {
    return 'Таңдалды: $count';
  }

  @override
  String get textCopied => 'Мәтін көшірілді';

  @override
  String get deleteGeotag => 'Геотегті жою?';

  @override
  String get deleteGeotagConfirm => 'Координаттар жазбадан жойылады.';

  @override
  String get emptyNote => 'Бос жазба';

  @override
  String get emptyNoteConfirm => 'Жазба бос. Сақтау?';

  @override
  String get makePhoto => 'Суретке түсіру';

  @override
  String get chooseFromGallery => 'Галереядан таңдау';

  @override
  String get selectTag => 'Тегті таңдау';

  @override
  String get manage => 'Басқару';

  @override
  String get stopLabel => 'Тоқтату';

  @override
  String get addFile => 'Файл';

  @override
  String get recording => 'Жазылуда...';

  @override
  String get selectTags => 'Тегтерді таңдау';

  @override
  String get searchTags => 'Тегтерді іздеу...';

  @override
  String get clearAll => 'Барлығын тазалау';

  @override
  String get noTagsForQuery => 'Сұраныс бойынша тегтер жоқ';

  @override
  String get apply => 'Қолдану';

  @override
  String get noTagsCreated => 'Тегтер жасалмаған';

  @override
  String get dates => 'Күндер';

  @override
  String get files => 'Файлдар';

  @override
  String get clearFilters => 'Сүзгілерді тазалау';

  @override
  String get quickFilter => 'Тегтер бойынша жылдам сүзгі:';

  @override
  String get byName => 'Аты бойынша';

  @override
  String get byCount => 'Саны бойынша';

  @override
  String get noMatches => 'Сәйкестіктер жоқ';

  @override
  String get exportTitle => 'Tack — Экспорт';

  @override
  String exportDate(Object date) {
    return 'Экспорт күні: $date';
  }

  @override
  String noteFrom(Object date) {
    return '$date жазбасы';
  }

  @override
  String get locationPermissionDenied =>
      'Геолокация рұқсаты алынбады. Оны телефон баптауларында қосыңыз.';

  @override
  String get version => 'Tack v1.0.0';

  @override
  String get error => 'Қате';

  @override
  String notesCount(Object count) {
    return '$count жазба';
  }

  @override
  String get theme => 'Тақырып';

  @override
  String get themeLight => 'Ашық';

  @override
  String get themeDark => 'Қараңғы';

  @override
  String get themeHighContrast => 'Жоғары контраст';

  @override
  String get themeDialog => 'Тақырып';

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
  String get openIn => 'Ашу...';

  @override
  String get shareFile => 'Бөлісу';

  @override
  String get moreOptions => 'Толығырақ опциялар';
}
