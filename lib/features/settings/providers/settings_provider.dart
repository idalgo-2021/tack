import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/constants/defaults.dart';

part 'settings_provider.g.dart';

enum ViewMode { list, grid }
enum FontSize { small, medium, large }
enum GroupMode { none, day, week, month }
enum SortMode { dateDesc, dateAsc }
enum AppColorScheme { sage, peach, sky, yellow, blue, coral, navy }
enum ThemeModeOption { light, dark, highContrast }
enum ExportFormat { markdown, json }

@riverpod
class Settings extends _$Settings {
  @override
  Future<SharedPreferences> build() async {
    return SharedPreferences.getInstance();
  }

  Future<void> setLocale(String locale) async { await _set('locale', locale); }
  Future<void> setAutoSave(bool enabled) async { await _set('auto_save', enabled); }
  Future<void> setUpdateTimestampOnEdit(bool enabled) async { await _set('update_timestamp_on_edit', enabled); }
  Future<void> setAutoGeotag(bool enabled) async { await _set('auto_geotag', enabled); }
  Future<void> setViewMode(ViewMode mode) async { await _set('view_mode', mode.name); }
  Future<void> setShowFileNames(bool show) async { await _set('show_file_names', show); }
  Future<void> setShowTimestamp(bool show) async { await _set('show_timestamp', show); }
  Future<void> setShowFileThumbnails(bool enabled) async { await _set('show_file_thumbnails', enabled); }
  Future<void> setFontSize(FontSize size) async { await _set('font_size', size.name); }
  Future<void> setGroupMode(GroupMode mode) async { await _set('group_mode', mode.name); }
  Future<void> setSortMode(SortMode mode) async { await _set('sort_mode', mode.name); }
  Future<void> setAppColorScheme(AppColorScheme scheme) async { await _set('app_color_scheme', scheme.name); }
  Future<void> setThemeMode(ThemeModeOption mode) async { await _set('theme_mode', mode.name); }
  Future<void> setExportFormat(ExportFormat format) async { await _set('export_format', format.name); }
  Future<void> setZipExport(bool enabled) async { await _set('zip_export', enabled); }

  Future<void> _set(String key, Object value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    }
    ref.invalidateSelf();
  }
}

bool _prefBool(Ref ref, String key, bool defaultValue) {
  final prefsAsync = ref.watch(settingsProvider);
  return prefsAsync.whenOrNull(data: (prefs) => prefs.getBool(key) ?? defaultValue) ?? defaultValue;
}

String _prefString(Ref ref, String key, String defaultValue) {
  final prefsAsync = ref.watch(settingsProvider);
  return prefsAsync.whenOrNull(data: (prefs) => prefs.getString(key) ?? defaultValue) ?? defaultValue;
}

T _prefEnum<T extends Enum>(Ref ref, String key, List<T> values, T defaultValue) {
  final prefsAsync = ref.watch(settingsProvider);
  return prefsAsync.whenOrNull(
    data: (prefs) {
      final value = prefs.getString(key);
      return values.firstWhere((e) => e.name == value, orElse: () => defaultValue);
    },
  ) ?? defaultValue;
}

@riverpod
String appLocale(Ref ref) => _prefString(ref, 'locale', AppDefaults.locale);

@riverpod
bool autoSave(Ref ref) => _prefBool(ref, 'auto_save', AppDefaults.autoSave);

@riverpod
bool updateTimestampOnEdit(Ref ref) => _prefBool(ref, 'update_timestamp_on_edit', AppDefaults.updateTimestampOnEdit);

@riverpod
bool autoGeotag(Ref ref) => _prefBool(ref, 'auto_geotag', AppDefaults.autoGeotag);

@riverpod
ViewMode viewMode(Ref ref) => _prefEnum(ref, 'view_mode', ViewMode.values, AppDefaults.viewMode);

@riverpod
bool showFileNames(Ref ref) => _prefBool(ref, 'show_file_names', AppDefaults.showFileNames);

@riverpod
bool showTimestamp(Ref ref) => _prefBool(ref, 'show_timestamp', AppDefaults.showTimestamp);

@riverpod
bool showFileThumbnails(Ref ref) => _prefBool(ref, 'show_file_thumbnails', AppDefaults.showFileThumbnails);

@riverpod
FontSize fontSize(Ref ref) => _prefEnum(ref, 'font_size', FontSize.values, AppDefaults.fontSize);

@riverpod
GroupMode groupMode(Ref ref) => _prefEnum(ref, 'group_mode', GroupMode.values, AppDefaults.groupMode);

@riverpod
SortMode sortMode(Ref ref) => _prefEnum(ref, 'sort_mode', SortMode.values, AppDefaults.sortMode);

@riverpod
AppColorScheme appColorScheme(Ref ref) => _prefEnum(ref, 'app_color_scheme', AppColorScheme.values, AppDefaults.colorScheme);

@riverpod
ThemeModeOption themeMode(Ref ref) => _prefEnum(ref, 'theme_mode', ThemeModeOption.values, AppDefaults.themeMode);

@riverpod
ExportFormat exportFormat(Ref ref) => _prefEnum(ref, 'export_format', ExportFormat.values, AppDefaults.exportFormat);

@riverpod
bool zipExport(Ref ref) => _prefBool(ref, 'zip_export', AppDefaults.zipExport);
