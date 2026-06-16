import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  Future<void> setLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale);
    ref.invalidateSelf();
  }

  Future<void> setAutoSave(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_save', enabled);
    ref.invalidateSelf();
  }

  Future<void> setCompressImages(bool compress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('compress_images', compress);
    ref.invalidateSelf();
  }

  Future<void> setUpdateTimestampOnEdit(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('update_timestamp_on_edit', enabled);
    ref.invalidateSelf();
  }

  Future<void> setAutoGeotag(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_geotag', enabled);
    ref.invalidateSelf();
  }

  Future<void> setViewMode(ViewMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('view_mode', mode.name);
    ref.invalidateSelf();
  }

  Future<void> setShowFileNames(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_file_names', show);
    ref.invalidateSelf();
  }

  Future<void> setShowTimestamp(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_timestamp', show);
    ref.invalidateSelf();
  }

  Future<void> setFontSize(FontSize size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('font_size', size.name);
    ref.invalidateSelf();
  }

  Future<void> setGroupMode(GroupMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('group_mode', mode.name);
    ref.invalidateSelf();
  }

  Future<void> setSortMode(SortMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sort_mode', mode.name);
    ref.invalidateSelf();
  }

  Future<void> setAppColorScheme(AppColorScheme scheme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_color_scheme', scheme.name);
    ref.invalidateSelf();
  }

  Future<void> setThemeMode(ThemeModeOption mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.name);
    ref.invalidateSelf();
  }

  Future<void> setExportFormat(ExportFormat format) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('export_format', format.name);
    ref.invalidateSelf();
  }

  Future<void> setZipExport(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('zip_export', enabled);
    ref.invalidateSelf();
  }
}


@riverpod
String appLocale(Ref ref) {
  final prefsAsync = ref.watch(settingsProvider);
  return prefsAsync.whenOrNull(
        data: (prefs) => prefs.getString('locale') ?? 'ru',
      ) ??
      'ru';
}

@riverpod
bool autoSave(Ref ref) {
  final prefsAsync = ref.watch(settingsProvider);
  return prefsAsync.whenOrNull(
        data: (prefs) => prefs.getBool('auto_save') ?? true,
      ) ??
      true;
}

@riverpod
bool compressImages(Ref ref) {
  final prefsAsync = ref.watch(settingsProvider);
  return prefsAsync.whenOrNull(
        data: (prefs) => prefs.getBool('compress_images') ?? true,
      ) ??
      true;
}

@riverpod
bool updateTimestampOnEdit(Ref ref) {
  final prefsAsync = ref.watch(settingsProvider);
  return prefsAsync.whenOrNull(
        data: (prefs) => prefs.getBool('update_timestamp_on_edit') ?? false,
      ) ??
      false;
}

@riverpod
bool autoGeotag(Ref ref) {
  final prefsAsync = ref.watch(settingsProvider);
  return prefsAsync.whenOrNull(
        data: (prefs) => prefs.getBool('auto_geotag') ?? false,
      ) ??
      false;
}

@riverpod
ViewMode viewMode(Ref ref) {
  final prefsAsync = ref.watch(settingsProvider);
  return prefsAsync.whenOrNull(
        data: (prefs) {
          final value = prefs.getString('view_mode');
          return ViewMode.values.firstWhere(
            (e) => e.name == value,
            orElse: () => ViewMode.list,
          );
        },
      ) ??
      ViewMode.list;
}

@riverpod
bool showFileNames(Ref ref) {
  final prefsAsync = ref.watch(settingsProvider);
  return prefsAsync.whenOrNull(
        data: (prefs) => prefs.getBool('show_file_names') ?? false,
      ) ??
      false;
}

@riverpod
bool showTimestamp(Ref ref) {
  final prefsAsync = ref.watch(settingsProvider);
  return prefsAsync.whenOrNull(
        data: (prefs) => prefs.getBool('show_timestamp') ?? false,
      ) ??
      false;
}

@riverpod
FontSize fontSize(Ref ref) {
  final prefsAsync = ref.watch(settingsProvider);
  return prefsAsync.whenOrNull(
        data: (prefs) {
          final value = prefs.getString('font_size');
          return FontSize.values.firstWhere(
            (e) => e.name == value,
            orElse: () => FontSize.medium,
          );
        },
      ) ??
      FontSize.medium;
}

@riverpod
GroupMode groupMode(Ref ref) {
  final prefsAsync = ref.watch(settingsProvider);
  return prefsAsync.whenOrNull(
        data: (prefs) {
          final value = prefs.getString('group_mode');
          return GroupMode.values.firstWhere(
            (e) => e.name == value,
            orElse: () => GroupMode.none,
          );
        },
      ) ??
      GroupMode.none;
}

@riverpod
SortMode sortMode(Ref ref) {
  final prefsAsync = ref.watch(settingsProvider);
  return prefsAsync.whenOrNull(
        data: (prefs) {
          final value = prefs.getString('sort_mode');
          return SortMode.values.firstWhere(
            (e) => e.name == value,
            orElse: () => SortMode.dateDesc,
          );
        },
      ) ??
      SortMode.dateDesc;
}

@riverpod
AppColorScheme appColorScheme(Ref ref) {
  final prefsAsync = ref.watch(settingsProvider);
  return prefsAsync.whenOrNull(
        data: (prefs) {
          final value = prefs.getString('app_color_scheme');
          return AppColorScheme.values.firstWhere(
            (e) => e.name == value,
            orElse: () => AppColorScheme.sage,
          );
        },
      ) ??
      AppColorScheme.sage;
}

@riverpod
ThemeModeOption themeMode(Ref ref) {
  final prefsAsync = ref.watch(settingsProvider);
  return prefsAsync.whenOrNull(
        data: (prefs) {
          final value = prefs.getString('theme_mode');
          return ThemeModeOption.values.firstWhere(
            (e) => e.name == value,
            orElse: () => ThemeModeOption.light,
          );
        },
      ) ??
      ThemeModeOption.light;
}

@riverpod
ExportFormat exportFormat(Ref ref) {
  final prefsAsync = ref.watch(settingsProvider);
  return prefsAsync.whenOrNull(
        data: (prefs) {
          final value = prefs.getString('export_format');
          return ExportFormat.values.firstWhere(
            (e) => e.name == value,
            orElse: () => ExportFormat.markdown,
          );
        },
      ) ??
      ExportFormat.markdown;
}

@riverpod
bool zipExport(Ref ref) {
  final prefsAsync = ref.watch(settingsProvider);
  return prefsAsync.whenOrNull(
        data: (prefs) => prefs.getBool('zip_export') ?? false,
      ) ??
      false;
}
