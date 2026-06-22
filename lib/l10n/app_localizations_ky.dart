// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kirghiz Kyrgyz (`ky`).
class AppLocalizationsKy extends AppLocalizations {
  AppLocalizationsKy([String locale = 'ky']) : super(locale);

  @override
  String get appTitle => 'Tack';

  @override
  String get notes => 'Жазуулар';

  @override
  String get tags => 'Тегтер';

  @override
  String get settings => 'Жөндөөлөр';

  @override
  String get search => 'Издөө';

  @override
  String get newNote => 'Жаңы жазуу';

  @override
  String get editNote => 'Түзөтүү';

  @override
  String get deleteNote => 'Жазууну жок кылуу?';

  @override
  String get deleteConfirm => 'Бул аракетти жокко чыгаруу мүмкүн эмес.';

  @override
  String get cancel => 'Жокко чыгаруу';

  @override
  String get delete => 'Жок кылуу';

  @override
  String get save => 'Сактоо';

  @override
  String get done => 'Даяр';

  @override
  String get startWriting => 'Жаза баштаңыз...';

  @override
  String get addTag => 'Тег кошуу...';

  @override
  String get noNotes => 'Жазуулар жок';

  @override
  String noNotesWithTag(Object tag) {
    return '$tag теги бар жазуулар жок';
  }

  @override
  String get noTags => 'Тегтер жок';

  @override
  String get tagsAutoCreate =>
      'Тегтер жазууларга кошулганда автоматтык түрдө түзүлөт';

  @override
  String get tapToCreate => 'Түзүү үчүн + басыңыз';

  @override
  String get searchHint => 'Жазууларды издөө...';

  @override
  String get searchNotesHint => 'Жазууларды издөө... (#тег)';

  @override
  String get noResults => 'Эч нерсе табылган жок';

  @override
  String get typeToSearch => 'Издөө үчүн текстти киргизиңиз';

  @override
  String get newTag => 'Жаңы тег';

  @override
  String get tagName => 'Тег аталышы';

  @override
  String get renameTag => 'Тегди кайра атоо';

  @override
  String get renameTagHint => 'Жаңы аталыш';

  @override
  String get deleteTag => 'Тегди жок кылуу?';

  @override
  String get tagDeleteWarning => 'Тег бардык жазуулардан өчүрүлөт.';

  @override
  String get createTag => 'Түзүү';

  @override
  String get saveChanges => 'Өзгөртүүлөрдү сактоо?';

  @override
  String get discard => 'Сактабай коюу';

  @override
  String get noteNotFound => 'Жазуу табылган жок';

  @override
  String get noteDeleted => 'Жазуу жок кылынды';

  @override
  String get allNotes => 'Бардык жазуулар';

  @override
  String get audio => 'Аудио';

  @override
  String get camera => 'Камера';

  @override
  String get attachedFiles => 'Тиркелген файлдар';

  @override
  String get addPhoto => 'Сүрөт кошуу';

  @override
  String get recordAudio => 'Аудио жаздыруу';

  @override
  String get recordVideo => 'Видео жаздыру';

  @override
  String get appearance => 'Сырткы көрүнүш';

  @override
  String get colorScheme => 'Түс схемасы';

  @override
  String get language => 'Тил';

  @override
  String get viewMode => 'Көрүнүш режими';

  @override
  String get fontSize => 'Шрифт өлчөмү';

  @override
  String get grouping => 'Топтоо';

  @override
  String get sorting => 'Иреттөө';

  @override
  String get behavior => 'Жүрүм-турум';

  @override
  String get autoSave => 'Автосактоо';

  @override
  String get autoSaveDesc => 'Чыкканда автоматтык түрдө сактоо';

  @override
  String get autoGeotag => 'Авто-геотег';

  @override
  String get autoGeotagDesc => 'Координаттарды автоматтык түрдө кошуу';

  @override
  String get showTimestamp => 'Убакыт белгиси';

  @override
  String get showTimestampDesc =>
      'Картада жана толук көрүнүштө күн жана убакыт';

  @override
  String get updateTimestampOnEdit => 'Түзөтүүдө убакытты жаңыртуу';

  @override
  String get updateTimestampOnEditDesc =>
      'Сактоодо убакыт белгисин учурдагы убакытка өзгөртүү';

  @override
  String get data => 'Маалыматтар';

  @override
  String get exportFormat => 'Экспорт форматы';

  @override
  String get archiveOnShare => 'Бөлүшүүдө архивдөө';

  @override
  String get archiveOnShareDesc => 'Бөлүшүүдөн мурун баарын ZIPке салуу';

  @override
  String get exportZip => 'ZIPке экспорттоо';

  @override
  String get exportZipDesc =>
      'Бардык жазууларды экспорттоо (жөндөөлөрдөгү формат)';

  @override
  String get viewModeList => 'Тизме';

  @override
  String get viewModeGrid => 'Тор';

  @override
  String get fontSizeSmall => 'Кичине';

  @override
  String get fontSizeMedium => 'Орточо';

  @override
  String get fontSizeLarge => 'Чоң';

  @override
  String get groupModeNone => 'Топтоосуз';

  @override
  String get groupModeDay => 'Күн боюнча';

  @override
  String get groupModeWeek => 'Апта боюнча';

  @override
  String get groupModeMonth => 'Ай боюнча';

  @override
  String get sortModeDateDesc => 'Күнү боюнча (жаңысы биринчи)';

  @override
  String get sortModeDateAsc => 'Күнү боюнча (эскиси биринчи)';

  @override
  String get colorSchemeSage => 'Шалфей';

  @override
  String get colorSchemePeach => 'Шабдалы';

  @override
  String get colorSchemeSky => 'Асман';

  @override
  String get colorSchemeYellow => 'Сары';

  @override
  String get colorSchemeBlue => 'Көгүлтүр';

  @override
  String get colorSchemeCoral => 'Коралл';

  @override
  String get colorSchemeNavy => 'Коюу көк';

  @override
  String get colorSchemeDialog => 'Түс схемасы';

  @override
  String get languageDialog => 'Тил';

  @override
  String get viewModeDialog => 'Көрүнүш режими';

  @override
  String get fontSizeDialog => 'Шрифт өлчөмү';

  @override
  String get groupingDialog => 'Топтоо';

  @override
  String get sortingDialog => 'Иреттөө';

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
  String get dateToday => 'Бүгүн';

  @override
  String get dateYesterday => 'Кечээ';

  @override
  String dateWeekHeader(Object week, Object year) {
    return '$week апта, $year';
  }

  @override
  String get justNow => 'Азыр эле';

  @override
  String minutesAgo(Object minutes) {
    return '$minutes мүн мурун';
  }

  @override
  String hoursAgo(Object hours) {
    return '$hours саат мурун';
  }

  @override
  String daysAgo(Object days) {
    return '$days күн мурун';
  }

  @override
  String deleteSelected(Object count) {
    return '$count жазууну жок кылуу?';
  }

  @override
  String get clearFilter => 'Чыпканы тазалоо';

  @override
  String selectedCount(Object count) {
    return 'Тандалды: $count';
  }

  @override
  String get textCopied => 'Текст көчүрүлдү';

  @override
  String get deleteGeotag => 'Геотегди жок кылуу?';

  @override
  String get deleteGeotagConfirm => 'Координаттар жазуудан өчүрүлөт.';

  @override
  String get emptyNote => 'Бош жазуу';

  @override
  String get emptyNoteConfirm => 'Жазуу бош. Сактоо?';

  @override
  String get makePhoto => 'Сүрөткө тартуу';

  @override
  String get chooseFromGallery => 'Галереядан тандоо';

  @override
  String get selectTag => 'Тегди тандоо';

  @override
  String get manage => 'Башкаруу';

  @override
  String get stopLabel => 'Токтотуу';

  @override
  String get addFile => 'Файл';

  @override
  String get recording => 'Жазылууда...';

  @override
  String get selectTags => 'Тегдерди тандоо';

  @override
  String get searchTags => 'Тегдерди издөө...';

  @override
  String get clearAll => 'Баарын тазалоо';

  @override
  String get noTagsForQuery => 'Суроо боюнча тегдер жок';

  @override
  String get apply => 'Колдонуу';

  @override
  String get noTagsCreated => 'Тегдер түзүлө элек';

  @override
  String get dates => 'Күндөр';

  @override
  String get files => 'Файлдар';

  @override
  String get clearFilters => 'Чыпкаларды тазалоо';

  @override
  String get quickFilter => 'Тегдер боюнча тез чыпка:';

  @override
  String get byName => 'Аты боюнча';

  @override
  String get byCount => 'Саны боюнча';

  @override
  String get noMatches => 'Даяр келгендер жок';

  @override
  String get exportTitle => 'Tack — Экспорт';

  @override
  String exportDate(Object date) {
    return 'Экспорт күнү: $date';
  }

  @override
  String noteFrom(Object date) {
    return '$date жазуусу';
  }

  @override
  String get locationPermissionDenied =>
      'Геолокация уруксаты алынган жок. Аны телефон жөндөөлөрүндө күйгүзүңүз.';

  @override
  String get version => 'Tack v1.0.0';

  @override
  String get error => 'Ката';

  @override
  String notesCount(Object count) {
    return '$count жазуу';
  }

  @override
  String get theme => 'Тема';

  @override
  String get themeLight => 'Ачык';

  @override
  String get themeDark => 'Караңгы';

  @override
  String get themeHighContrast => 'Жогорку контраст';

  @override
  String get themeDialog => 'Тема';

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
}
