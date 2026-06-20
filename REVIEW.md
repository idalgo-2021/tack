# Ревью-инспекция проекта Tack

**Дата:** 2026-06-19
**Проект:** Tack — приложение для заметок (Flutter + Riverpod + SQLite)
**Проанализировано:** 40+ файлов исходного кода, 8 коммитов в git

---

## 🔴 Критические (CRITICAL)

| # | Описание | Файл | Строки |
|---|----------|------|--------|
| C1 | **Дублирование путей при сохранении заметки.** `_saveNote` объединяет `_existingNote?.imagePaths` с `_imagePaths` через spread, но `_imagePaths` уже инициализируется из `_existingNote?.imagePaths` в `initState`. При каждом сохранении существующей заметки пути к изображениям будут дублироваться. | `note_editor_screen.dart` | 150–152 |
| C2 | **Дублирование класса `_TagSelectorDialog`.** Один и тот же 230-строчный виджет полностью скопирован в два файла с минимальными отличиями. Любые правки нужно вносить в оба места — гарантированная инвазия багов. | `note_editor_screen.dart` и `note_detail_screen.dart` | 446–672 и 538–768 |
| C3 | **SQL-инъекция в `tag_repository.dart`.** Значения `oldName` и `tag.name` вставляются в SQL-запрос через строковую интерполяцию без экранирования. Имя тега с кавычкой `"` сломает запрос. | `tag_repository.dart` | 42 |
| C4 | **Логическая ошибка с highContrast темой.** `themeMode: highContrast` устанавливает `useDark = false`, поэтому `MaterialApp.themeMode = null` (светлая тема по умолчанию), хотя сама `HighContrastTheme` использует `Brightness.dark`. High Contrast не применяется корректно. | `app.dart` | 43–46 |

---

## 🟠 Высокая (HIGH)

| # | Описание | Файл | Строки |
|---|----------|------|--------|
| H1 | **Нет DI / инверсии зависимостей.** Все репозитории (`NoteRepository`, `TagRepository`) создаются через `new` напрямую в каждом экране. Без DI невозможно замокать БД для тестов. | Все файлы с `NoteRepository()` / `TagRepository()` | — |
| H2 | **DatabaseHelper — синглтон без интерфейса.** Нет абстракции/контракта, жёсткая привязка к SQLite — нельзя подменить на фейковую БД в тестах. | `database_helper.dart` | 5–7 |
| H3 | **`_sortColumn` игнорирует параметр `sortMode`.** Функция всегда возвращает `'created_at'` независимо от переданного режима сортировки. | `note_list_provider.dart` | 8–10 |
| H4 | **Пустые `catch` блоки.** Ошибки геолокации полностью проглатываются (`catch (_) {}`), пользователь не узнает о проблеме. | `note_editor_screen.dart:110`, `note_action_buttons.dart:120` | 110, 120 |
| H5 | **Несоответствие версии БД.** `AppConstants.dbVersion = 1`, но `_initDatabase` использует `version: 2`. При переустановке приложения может быть несоответствие. | `database_helper.dart:22` / `app_constants.dart:4` | 22 / 4 |

---

## 🟡 Средняя (MEDIUM)

| # | Описание | Файл | Строки |
|---|----------|------|--------|
| M1 | **`ref.read()` вместо `ref.watch()`.** `_buildNoteItem` читает `viewMode` через `read`, а не `watch`, поэтому при смене режима отображения карточки не перестраиваются до полного обновления списка. | `note_list_screen.dart` | 363 |
| M2 | **Двойная обработка нажатий.** `GestureDetector` (long press) оборачивает `NoteCard`, который внутри использует `InkWell` (onTap) — два конкурирующих обработчика жестов. | `note_list_screen.dart` | 365–381 |
| M3 | **`MediaQuery` переопределяет системный `textScaleFactor`.** Пользовательский масштаб шрифта не применяется к приложению, при этом форсируется установленный в настройках. | `app.dart` | 59–62 |
| M4 | **Нулевые отступы в сетке.** `crossAxisSpacing: 0, mainAxisSpacing: 0` в `MasonryGridView` — карточки слипаются. | `note_list_screen.dart` | 272–273, 349 |
| M5 | **`ImagePicking` провайдер без `keepAlive`.** Может быть уничтожен GC между пиками изображений. | `media_provider.dart` | 57 |
| M6 | **`SearchFilters.copyWith` — нестандартный паттерн.** Используются флаги `clearDateFrom`/`clearDateTo` вместо null-coalescing для сброса полей — анти-паттерн. | `search_provider.dart` | 31–32 |
| M7 | **`_buildTagSuggestions` — потеря типов.** `AsyncValue<List>` без дженерика, код не проверяет, что в списке находятся `Tag` объекты. | `search_screen.dart` | 190 |
| M8 | **`updateTimestampOnEdit` изменяет `createdAt`.** Изменение даты создания при редактировании — семантически неверно, сбивает историю. | `note_detail_screen.dart` | 106 |
| M9 | **Ручная локализация.** 26 файлов (13 `.arb` + 13 `.dart`) вместо автогенерации через `flutter gen-l10n`. Высокие затраты на поддержку. | `lib/l10n/` | — |
| M10 | **`json_serializable` не используется.** Пакет в `dev_dependencies`, но модели (`Note`, `Tag`) имеют ручные `toMap`/`fromMap`. | `pubspec.yaml` | 46 |

---

## 🟢 Низкая (LOW)

| # | Описание | Файл | Строки |
|---|----------|------|--------|
| L1 | **Только 1 тест на весь проект.** Тест проверяет лишь, что `TackApp` рендерится. Нет unit-, widget- или интеграционных тестов. | `test/widget_test.dart` | 1–9 |
| L2 | **`high_contrast_theme.dart` — неактуальный `ignore_for_file`.** Директива `deprecated_member_use` не относится ни к одному члену файла. | `high_contrast_theme.dart` | 84 |
| L3 | **Нет CI/CD.** В `.github/` лежит только план, но нет workflow-файлов. | `.github/` | — |
| L4 | **Нет обработки ошибок при работе с файлами.** Если файл изображения/аудио удалён вручную, приложение может упасть с исключением. | `image_grid_widget.dart`, `audio_player_widget.dart` (косвенно) | — |
| L5 | **Нет шаблонов issue/PR, code owners.** | `.github/` | — |
| L6 | **`rebuildCounts` — потенциально медленный запрос.** Коррелированный подзапрос для каждого тега при каждом открытии списка тегов. | `tag_repository.dart` | 94–103 |

---

## 📋 Рекомендации по улучшению

**Неотложные (исправить до следующего релиза):**
1. **Исправить дублирование путей** — убрать `...?_existingNote?.imagePaths` из `_saveNote` в `note_editor_screen.dart`, т.к. `_imagePaths` уже содержит полный актуальный список.
2. **Вынести `_TagSelectorDialog`** в отдельный файл `lib/features/tags/widgets/tag_selector_dialog.dart` и импортировать в оба экрана.
3. **Заменить SQL-интерполяцию на параметризованный запрос** в `tag_repository.dart:42`.
4. **Исправить `themeMode` в `app.dart`** — добавить `ThemeModeOption.highContrast` в switch и установить `useDark = true`.

**Архитектурные (среднесрочные):**
5. **Внедрить DI** — использовать `riverpod` для создания репозиториев, добавить абстракцию `DatabaseHelper` через интерфейс.
6. **Добавить тесты** — хотя бы unit-тесты на `NoteRepository` (через DI фейковой БД) и widget-тесты на ключевые экраны.
7. **Перейти на автогенерацию локализации** через `flutter gen-l10n` и удалить ручные `app_localizations_*.dart`.
8. **Добавить CI/CD** — workflow для `flutter analyze`, `flutter test`, сборки APK.

**Качество кода (постоянно):**
9. Заменить `ref.read` на `ref.watch` в `_buildNoteItem`.
10. Убрать `GestureDetector` и повесить `onLongPress` прямо на `InkWell`.
11. Убрать `MasonryGridView` spacing = 0, добавить разумные отступы (4–8).
12. Добавить обработку ошибок в `_requestLocation` и `_requestAutoLocation` (показать snackbar).
13. Избавиться от неиспользуемых зависимостей в `pubspec.yaml`.

**Документация:**
14. Добавить `.github/CODEOWNERS`, шаблоны для issue и PR.
15. Обновить `README.md` с описанием архитектуры, стека и инструкцией по сборке.
