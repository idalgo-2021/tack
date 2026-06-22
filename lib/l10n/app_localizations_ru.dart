// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Tack';

  @override
  String get notes => 'Заметки';

  @override
  String get tags => 'Теги';

  @override
  String get settings => 'Настройки';

  @override
  String get search => 'Поиск';

  @override
  String get newNote => 'Новая заметка';

  @override
  String get editNote => 'Редактировать';

  @override
  String get deleteNote => 'Удалить заметку?';

  @override
  String get deleteConfirm => 'Это действие нельзя отменить.';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get save => 'Сохранить';

  @override
  String get done => 'Готово';

  @override
  String get startWriting => 'Начните писать...';

  @override
  String get addTag => 'Добавить тег...';

  @override
  String get noNotes => 'Нет заметок';

  @override
  String noNotesWithTag(Object tag) {
    return 'Нет заметок с тегом $tag';
  }

  @override
  String get noTags => 'Нет тегов';

  @override
  String get tagsAutoCreate =>
      'Теги создаются автоматически при добавлении в заметки';

  @override
  String get tapToCreate => 'Нажмите + чтобы создать';

  @override
  String get searchHint => 'Поиск заметок...';

  @override
  String get searchNotesHint => 'Поиск заметок... (#тег)';

  @override
  String get noResults => 'Ничего не найдено';

  @override
  String get typeToSearch => 'Введите текст для поиска';

  @override
  String get newTag => 'Новый тег';

  @override
  String get tagName => 'Название тега';

  @override
  String get renameTag => 'Переименовать тег';

  @override
  String get renameTagHint => 'Новое название';

  @override
  String get deleteTag => 'Удалить тег?';

  @override
  String get tagDeleteWarning => 'Тег будет удалён из всех заметок.';

  @override
  String get createTag => 'Создать';

  @override
  String get saveChanges => 'Сохранить изменения?';

  @override
  String get discard => 'Не сохранять';

  @override
  String get noteNotFound => 'Заметка не найдена';

  @override
  String get noteDeleted => 'Заметка была удалена';

  @override
  String get allNotes => 'Все заметки';

  @override
  String get audio => 'Аудио';

  @override
  String get camera => 'Камера';

  @override
  String get attachedFiles => 'Прикреплённые файлы';

  @override
  String get addPhoto => 'Добавить фото';

  @override
  String get recordAudio => 'Записать аудио';

  @override
  String get recordVideo => 'Записать видео';

  @override
  String get appearance => 'Внешний вид';

  @override
  String get colorScheme => 'Цветовая схема';

  @override
  String get language => 'Язык';

  @override
  String get viewMode => 'Вид списка';

  @override
  String get fontSize => 'Размер шрифта';

  @override
  String get grouping => 'Группировка';

  @override
  String get sorting => 'Сортировка';

  @override
  String get behavior => 'Поведение';

  @override
  String get autoSave => 'Автосохранение';

  @override
  String get autoSaveDesc => 'Автоматически сохранять при выходе';

  @override
  String get autoGeotag => 'Авто-геоштамп';

  @override
  String get autoGeotagDesc => 'Автоматически добавлять координаты';

  @override
  String get showTimestamp => 'Таймштамп';

  @override
  String get showTimestampDesc => 'Дата и время в карточке и форме просмотра';

  @override
  String get updateTimestampOnEdit => 'Обновлять время при редактировании';

  @override
  String get updateTimestampOnEditDesc =>
      'Изменять таймштамп на текущий при сохранении';

  @override
  String get data => 'Данные';

  @override
  String get exportFormat => 'Формат экспорта';

  @override
  String get archiveOnShare => 'Архивировать при отправке';

  @override
  String get archiveOnShareDesc => 'Упаковать всё в ZIP перед Поделиться';

  @override
  String get exportZip => 'Экспорт в ZIP';

  @override
  String get exportZipDesc => 'Выгрузить все заметки (формат из настроек)';

  @override
  String get viewModeList => 'Список';

  @override
  String get viewModeGrid => 'Плитки';

  @override
  String get fontSizeSmall => 'Мелкий';

  @override
  String get fontSizeMedium => 'Средний';

  @override
  String get fontSizeLarge => 'Крупный';

  @override
  String get groupModeNone => 'Без группировки';

  @override
  String get groupModeDay => 'По дням';

  @override
  String get groupModeWeek => 'По неделям';

  @override
  String get groupModeMonth => 'По месяцам';

  @override
  String get sortModeDateDesc => 'По дате (новые сверху)';

  @override
  String get sortModeDateAsc => 'По дате (старые сверху)';

  @override
  String get colorSchemeSage => 'Шалфей';

  @override
  String get colorSchemePeach => 'Персик';

  @override
  String get colorSchemeSky => 'Небесный';

  @override
  String get colorSchemeYellow => 'Жёлтый';

  @override
  String get colorSchemeBlue => 'Синий';

  @override
  String get colorSchemeCoral => 'Коралловый';

  @override
  String get colorSchemeNavy => 'Тёмно-синий';

  @override
  String get colorSchemeDialog => 'Цветовая схема';

  @override
  String get languageDialog => 'Язык';

  @override
  String get viewModeDialog => 'Вид списка';

  @override
  String get fontSizeDialog => 'Размер шрифта';

  @override
  String get groupingDialog => 'Группировка';

  @override
  String get sortingDialog => 'Сортировка';

  @override
  String get exportFormatDialog => 'Формат экспорта';

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
  String get dateToday => 'Сегодня';

  @override
  String get dateYesterday => 'Вчера';

  @override
  String dateWeekHeader(Object week, Object year) {
    return 'Неделя $week, $year';
  }

  @override
  String get justNow => 'Только что';

  @override
  String minutesAgo(Object minutes) {
    return '$minutes мин. назад';
  }

  @override
  String hoursAgo(Object hours) {
    return '$hours ч. назад';
  }

  @override
  String daysAgo(Object days) {
    return '$days дн. назад';
  }

  @override
  String deleteSelected(Object count) {
    return 'Удалить $count заметок?';
  }

  @override
  String get clearFilter => 'Сбросить фильтр';

  @override
  String selectedCount(Object count) {
    return 'Выбрано: $count';
  }

  @override
  String get textCopied => 'Текст скопирован';

  @override
  String get deleteGeotag => 'Удалить геоштамп?';

  @override
  String get deleteGeotagConfirm => 'Координаты будут удалены из заметки.';

  @override
  String get emptyNote => 'Пустая заметка';

  @override
  String get emptyNoteConfirm => 'Заметка пустая. Сохранить?';

  @override
  String get makePhoto => 'Сделать фото';

  @override
  String get chooseFromGallery => 'Выбрать из галереи';

  @override
  String get selectTag => 'Выбрать тег';

  @override
  String get manage => 'Управление';

  @override
  String get stopLabel => 'Стоп';

  @override
  String get addFile => 'Файл';

  @override
  String get recording => 'Идёт запись...';

  @override
  String get selectTags => 'Выбрать теги';

  @override
  String get searchTags => 'Поиск тегов...';

  @override
  String get clearAll => 'Очистить все';

  @override
  String get noTagsForQuery => 'Нет тегов по запросу';

  @override
  String get apply => 'Применить';

  @override
  String get noTagsCreated => 'Нет созданных тегов';

  @override
  String get dates => 'Даты';

  @override
  String get files => 'Файлы';

  @override
  String get clearFilters => 'Сбросить фильтры';

  @override
  String get quickFilter => 'Быстрый фильтр по тегам:';

  @override
  String get byName => 'По имени';

  @override
  String get byCount => 'По количеству';

  @override
  String get noMatches => 'Нет совпадений';

  @override
  String get exportTitle => 'Tack — Экспорт';

  @override
  String exportDate(Object date) {
    return 'Дата экспорта: $date';
  }

  @override
  String noteFrom(Object date) {
    return 'Заметка от $date';
  }

  @override
  String get locationPermissionDenied =>
      'Разрешение на геолокацию не получено. Включите в настройках телефона.';

  @override
  String get version => 'Tack v1.0.0';

  @override
  String get error => 'Ошибка';

  @override
  String notesCount(Object count) {
    return '$count заметок';
  }

  @override
  String get theme => 'Тема';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeHighContrast => 'Высокий контраст';

  @override
  String get themeDialog => 'Тема';

  @override
  String get exportNoNotes => 'Нет заметок для экспорта';

  @override
  String get showFileThumbnails => 'Миниатюры файлов';

  @override
  String get showFileThumbnailsDesc =>
      'Отображать файлы в виде сетки с иконками';

  @override
  String exportError(Object error) {
    return 'Ошибка экспорта: $error';
  }

  @override
  String get exportFormatMarkdown => 'Markdown';

  @override
  String get exportFormatJson => 'JSON';

  @override
  String fromDate(Object date) {
    return 'От: $date';
  }

  @override
  String toDate(Object date) {
    return 'До: $date';
  }

  @override
  String get recordingError => 'Ошибка записи. Повторите попытку.';
}
