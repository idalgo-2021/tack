// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Tack';

  @override
  String get notes => 'Нотатки';

  @override
  String get tags => 'Теги';

  @override
  String get settings => 'Налаштування';

  @override
  String get search => 'Пошук';

  @override
  String get newNote => 'Нова нотатка';

  @override
  String get editNote => 'Редагувати';

  @override
  String get deleteNote => 'Видалити нотатку?';

  @override
  String get deleteConfirm => 'Цю дію не можна скасувати.';

  @override
  String get cancel => 'Скасувати';

  @override
  String get delete => 'Видалити';

  @override
  String get save => 'Зберегти';

  @override
  String get done => 'Готово';

  @override
  String get startWriting => 'Почніть писати...';

  @override
  String get addTag => 'Додати тег...';

  @override
  String get noNotes => 'Немає нотаток';

  @override
  String noNotesWithTag(Object tag) {
    return 'Немає нотаток з тегом $tag';
  }

  @override
  String get noTags => 'Немає тегів';

  @override
  String get tagsAutoCreate =>
      'Теги створюються автоматично при додаванні до нотаток';

  @override
  String get tapToCreate => 'Натисніть + щоб створити';

  @override
  String get searchHint => 'Пошук нотаток...';

  @override
  String get searchNotesHint => 'Пошук нотаток... (#тег)';

  @override
  String get noResults => 'Нічого не знайдено';

  @override
  String get typeToSearch => 'Введіть текст для пошуку';

  @override
  String get newTag => 'Новий тег';

  @override
  String get tagName => 'Назва тегу';

  @override
  String get renameTag => 'Перейменувати тег';

  @override
  String get renameTagHint => 'Нова назва';

  @override
  String get deleteTag => 'Видалити тег?';

  @override
  String get tagDeleteWarning => 'Тег буде видалено з усіх нотаток.';

  @override
  String get createTag => 'Створити';

  @override
  String get saveChanges => 'Зберегти зміни?';

  @override
  String get discard => 'Не зберігати';

  @override
  String get noteNotFound => 'Нотатку не знайдено';

  @override
  String get noteDeleted => 'Нотатку видалено';

  @override
  String get allNotes => 'Всі нотатки';

  @override
  String get photo => 'Фото';

  @override
  String get audio => 'Аудіо';

  @override
  String get attachedFiles => 'Прикріплені файли';

  @override
  String get addPhoto => 'Додати фото';

  @override
  String get recordAudio => 'Записати аудіо';

  @override
  String get appearance => 'Зовнішній вигляд';

  @override
  String get colorScheme => 'Колірна схема';

  @override
  String get language => 'Мова';

  @override
  String get viewMode => 'Вид списку';

  @override
  String get fontSize => 'Розмір шрифту';

  @override
  String get grouping => 'Групування';

  @override
  String get sorting => 'Сортування';

  @override
  String get behavior => 'Поведінка';

  @override
  String get autoSave => 'Автозбереження';

  @override
  String get autoSaveDesc => 'Автоматично зберігати при виході';

  @override
  String get compressImages => 'Стискати зображення';

  @override
  String get compressImagesDesc => 'Зменшувати розмір фото при додаванні';

  @override
  String get autoGeotag => 'Авто-геотег';

  @override
  String get autoGeotagDesc => 'Автоматично додавати координати';

  @override
  String get showFileNames => 'Назви файлів';

  @override
  String get showFileNamesDesc => 'Показувати назви в картці нотатки';

  @override
  String get showTimestamp => 'Часова мітка';

  @override
  String get showTimestampDesc => 'Дата та час у картці та перегляді';

  @override
  String get updateTimestampOnEdit => 'Оновлювати час при редагуванні';

  @override
  String get updateTimestampOnEditDesc =>
      'Змінювати мітку на поточну при збереженні';

  @override
  String get data => 'Дані';

  @override
  String get exportFormat => 'Формат експорту';

  @override
  String get archiveOnShare => 'Архівувати при надсиланні';

  @override
  String get archiveOnShareDesc => 'Пакувати все в ZIP перед Поділитися';

  @override
  String get exportZip => 'Експорт в ZIP';

  @override
  String get exportZipDesc => 'Вивантажити всі нотатки (формат з налаштувань)';

  @override
  String get viewModeList => 'Список';

  @override
  String get viewModeGrid => 'Плитки (2 колонки)';

  @override
  String get fontSizeSmall => 'Дрібний';

  @override
  String get fontSizeMedium => 'Середній';

  @override
  String get fontSizeLarge => 'Великий';

  @override
  String get groupModeNone => 'Без групування';

  @override
  String get groupModeDay => 'По днях';

  @override
  String get groupModeWeek => 'По тижнях';

  @override
  String get groupModeMonth => 'По місяцях';

  @override
  String get sortModeDateDesc => 'За датою (нові зверху)';

  @override
  String get sortModeDateAsc => 'За датою (старі зверху)';

  @override
  String get colorSchemeSage => 'Шавлія';

  @override
  String get colorSchemePeach => 'Персик';

  @override
  String get colorSchemeSky => 'Небесний';

  @override
  String get colorSchemeYellow => 'Жовтий';

  @override
  String get colorSchemeBlue => 'Синій';

  @override
  String get colorSchemeCoral => 'Кораловий';

  @override
  String get colorSchemeNavy => 'Темно-синій';

  @override
  String get colorSchemeDialog => 'Колірна схема';

  @override
  String get languageDialog => 'Мова';

  @override
  String get viewModeDialog => 'Вид списку';

  @override
  String get fontSizeDialog => 'Розмір шрифту';

  @override
  String get groupingDialog => 'Групування';

  @override
  String get sortingDialog => 'Сортування';

  @override
  String get exportFormatDialog => 'Формат експорту';

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
  String get dateToday => 'Сьогодні';

  @override
  String get dateYesterday => 'Вчора';

  @override
  String dateWeekHeader(Object week, Object year) {
    return 'Тиждень $week, $year';
  }

  @override
  String get justNow => 'Щойно';

  @override
  String minutesAgo(Object minutes) {
    return '$minutes хв. тому';
  }

  @override
  String hoursAgo(Object hours) {
    return '$hours год. тому';
  }

  @override
  String daysAgo(Object days) {
    return '$days дн. тому';
  }

  @override
  String deleteSelected(Object count) {
    return 'Видалити $count нотаток?';
  }

  @override
  String get clearFilter => 'Скинути фільтр';

  @override
  String selectedCount(Object count) {
    return 'Вибрано: $count';
  }

  @override
  String get textCopied => 'Текст скопійовано';

  @override
  String get deleteGeotag => 'Видалити геотег?';

  @override
  String get deleteGeotagConfirm => 'Координати буде видалено з нотатки.';

  @override
  String get emptyNote => 'Порожня нотатка';

  @override
  String get emptyNoteConfirm => 'Нотатка порожня. Зберегти?';

  @override
  String get makePhoto => 'Зробити фото';

  @override
  String get chooseFromGallery => 'Вибрати з галереї';

  @override
  String get selectTag => 'Вибрати тег';

  @override
  String get manage => 'Керування';

  @override
  String get stopLabel => 'Стоп';

  @override
  String get addFile => 'Файл';

  @override
  String get recording => 'Запис...';

  @override
  String get selectTags => 'Вибрати теги';

  @override
  String get searchTags => 'Пошук тегів...';

  @override
  String get clearAll => 'Очистити все';

  @override
  String get noTagsForQuery => 'Немає тегів за запитом';

  @override
  String get apply => 'Застосувати';

  @override
  String get noTagsCreated => 'Немає створених тегів';

  @override
  String get dates => 'Дати';

  @override
  String get files => 'Файли';

  @override
  String get clearFilters => 'Скинути фільтри';

  @override
  String get quickFilter => 'Швидкий фільтр за тегами:';

  @override
  String get byName => 'За ім\'ям';

  @override
  String get byCount => 'За кількістю';

  @override
  String get noMatches => 'Немає збігів';

  @override
  String get exportTitle => 'Tack — Експорт';

  @override
  String exportDate(Object date) {
    return 'Дата експорту: $date';
  }

  @override
  String noteFrom(Object date) {
    return 'Нотатка від $date';
  }

  @override
  String get locationPermissionDenied =>
      'Дозвіл на геолокацію не отримано. Увімкніть у налаштуваннях телефону.';

  @override
  String get version => 'Tack v1.0.0';

  @override
  String get error => 'Помилка';

  @override
  String notesCount(Object count) {
    return '$count нотаток';
  }

  @override
  String get theme => 'Тема';

  @override
  String get themeLight => 'Світла';

  @override
  String get themeDark => 'Темна';

  @override
  String get themeHighContrast => 'Високий контраст';

  @override
  String get themeDialog => 'Тема';

  @override
  String get exportNoNotes => 'Немає нотаток для експорту';

  @override
  String exportError(Object error) {
    return 'Помилка експорту: $error';
  }

  @override
  String get exportFormatMarkdown => 'Markdown';

  @override
  String get exportFormatJson => 'JSON';

  @override
  String fromDate(Object date) {
    return 'Від: $date';
  }

  @override
  String toDate(Object date) {
    return 'До: $date';
  }

  @override
  String get showFileThumbnails => 'Мініатюри файлів';

  @override
  String get showFileThumbnailsDesc =>
      'Відображати файли у вигляді сітки з іконками';

  @override
  String get recordingError => 'Помилка запису. Спробуйте ще раз.';
}
