import '../../features/settings/providers/settings_provider.dart';

class AppDefaults {
  // Внешний вид
  static const String locale = 'en';
  static const ThemeModeOption themeMode = ThemeModeOption.light;
  static const AppColorScheme colorScheme = AppColorScheme.yellow;
  static const ViewMode viewMode = ViewMode.list;
  static const FontSize fontSize = FontSize.medium;
  static const GroupMode groupMode = GroupMode.day;
  static const SortMode sortMode = SortMode.dateDesc;

  // Поведение
  static const bool autoSave = false;
  static const bool updateTimestampOnEdit = false;
  static const bool autoGeotag = false;
  static const bool showFileNames = false;
  static const bool showTimestamp = true;
  static const bool showFileThumbnails = false;

  // Данные
  static const ExportFormat exportFormat = ExportFormat.markdown;
  static const bool zipExport = false;
}
