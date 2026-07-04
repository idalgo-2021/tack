import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/widgets/centered_app_bar_title.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final autoSaveValue = ref.watch(autoSaveProvider);
    final localeValue = ref.watch(appLocaleProvider);
    final autoGeotagValue = ref.watch(autoGeotagProvider);
    final viewModeValue = ref.watch(viewModeProvider);
    final showTimestampValue = ref.watch(showTimestampProvider);

    final fontSizeValue = ref.watch(fontSizeProvider);
    final groupModeValue = ref.watch(groupModeProvider);
    final sortModeValue = ref.watch(sortModeProvider);
    final themeModeValue = ref.watch(themeModeProvider);
    final appColorSchemeValue = ref.watch(appColorSchemeProvider);
    final exportFormatValue = ref.watch(exportFormatProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: CenteredAppBarTitle(title: Text(l10n.settings)),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          _SectionHeader(title: l10n.appearance),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(l10n.colorScheme),
            subtitle: Text(_appColorSchemeLabel(l10n, appColorSchemeValue)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showAppColorSchemePicker(context, ref, l10n, appColorSchemeValue),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: Text(l10n.theme),
            subtitle: Text(_themeModeLabel(l10n, themeModeValue)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeModePicker(context, ref, l10n, themeModeValue),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(_localeLabel(l10n, localeValue)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLocalePicker(context, ref, l10n, localeValue),
          ),
          ListTile(
            leading: const Icon(Icons.grid_view),
            title: Text(l10n.viewMode),
            subtitle: Text(viewModeValue == ViewMode.list ? l10n.viewModeList : l10n.viewModeGrid),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showViewModePicker(context, ref, l10n, viewModeValue),
          ),
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: Text(l10n.fontSize),
            subtitle: Text(_fontSizeLabel(l10n, fontSizeValue)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showFontSizePicker(context, ref, l10n, fontSizeValue),
          ),
          ListTile(
            leading: const Icon(Icons.view_headline),
            title: Text(l10n.grouping),
            subtitle: Text(_groupModeLabel(l10n, groupModeValue)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showGroupModePicker(context, ref, l10n, groupModeValue),
          ),
          ListTile(
            leading: const Icon(Icons.sort),
            title: Text(l10n.sorting),
            subtitle: Text(_sortModeLabel(l10n, sortModeValue)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showSortModePicker(context, ref, l10n, sortModeValue),
          ),
          const Divider(),
          _SectionHeader(title: l10n.behavior),
          SwitchListTile(
            secondary: const Icon(Icons.save),
            title: Text(l10n.autoSave),
            subtitle: Text(l10n.autoSaveDesc),
            value: autoSaveValue,
            onChanged: (v) => ref.read(settingsProvider.notifier).setAutoSave(v),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.location_on),
            title: Text(l10n.autoGeotag),
            subtitle: Text(l10n.autoGeotagDesc),
            value: autoGeotagValue,
            onChanged: (v) => _toggleAutoGeotag(v, ref, l10n),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.access_time),
            title: Text(l10n.showTimestamp),
            subtitle: Text(l10n.showTimestampDesc),
            value: showTimestampValue,
            onChanged: (v) => ref.read(settingsProvider.notifier).setShowTimestamp(v),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.update),
            title: Text(l10n.updateTimestampOnEdit),
            subtitle: Text(l10n.updateTimestampOnEditDesc),
            value: ref.watch(updateTimestampOnEditProvider),
            onChanged: (v) => ref.read(settingsProvider.notifier).setUpdateTimestampOnEdit(v),
          ),
          const Divider(),
          _SectionHeader(title: l10n.data),
          ListTile(
            leading: const Icon(Icons.file_present),
            title: Text(l10n.exportFormat),
            subtitle: Text(_exportFormatLabel(exportFormatValue, l10n)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showExportFormatPicker(context, ref, l10n, exportFormatValue),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.folder_zip),
            title: Text(l10n.archiveOnShare),
            subtitle: Text(l10n.archiveOnShareDesc),
            value: ref.watch(zipExportProvider),
            onChanged: (v) => ref.read(settingsProvider.notifier).setZipExport(v),
          ),
          const Divider(),
          const SizedBox(height: 16),
          Center(
            child: Text(
              l10n.version,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _toggleAutoGeotag(bool enabled, WidgetRef ref, AppLocalizations l10n) async {
    if (!enabled) {
      ref.read(settingsProvider.notifier).setAutoGeotag(false);
      return;
    }
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.locationPermissionDenied)),
        );
      }
      return;
    }
    ref.read(settingsProvider.notifier).setAutoGeotag(true);
  }

  String _localeLabel(AppLocalizations l10n, String locale) {
    switch (locale) {
      case 'ru': return l10n.localeRu;
      case 'en': return l10n.localeEn;
      case 'es': return l10n.localeEs;
      case 'de': return l10n.localeDe;
      case 'uk': return l10n.localeUk;
      case 'pl': return l10n.localePl;
      case 'it': return l10n.localeIt;
      case 'fr': return l10n.localeFr;
      case 'kk': return l10n.localeKk;
      case 'ky': return l10n.localeKy;
      case 'tr': return l10n.localeTr;
      case 'zh': return l10n.localeZh;
      case 'ja': return l10n.localeJa;
      default: return locale;
    }
  }

  String _appColorSchemeLabel(AppLocalizations l10n, AppColorScheme scheme) {
    switch (scheme) {
      case AppColorScheme.sage: return l10n.colorSchemeSage;
      case AppColorScheme.peach: return l10n.colorSchemePeach;
      case AppColorScheme.sky: return l10n.colorSchemeSky;
      case AppColorScheme.yellow: return l10n.colorSchemeYellow;
      case AppColorScheme.blue: return l10n.colorSchemeBlue;
      case AppColorScheme.coral: return l10n.colorSchemeCoral;
      case AppColorScheme.navy: return l10n.colorSchemeNavy;
    }
  }

  void _showAppColorSchemePicker(BuildContext context, WidgetRef ref, AppLocalizations l10n, AppColorScheme current) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.colorSchemeDialog),
        children: AppColorScheme.values.map((scheme) {
          return ListTile(
            title: Text(_appColorSchemeLabel(l10n, scheme)),
            trailing: scheme == current ? const Icon(Icons.check) : null,
            onTap: () {
              ref.read(settingsProvider.notifier).setAppColorScheme(scheme);
              Navigator.pop(ctx);
            },
          );
        }).toList(),
      ),
    );
  }

  String _themeModeLabel(AppLocalizations l10n, ThemeModeOption mode) {
    switch (mode) {
      case ThemeModeOption.light: return l10n.themeLight;
      case ThemeModeOption.dark: return l10n.themeDark;
      case ThemeModeOption.highContrast: return l10n.themeHighContrast;
    }
  }

  void _showThemeModePicker(BuildContext context, WidgetRef ref, AppLocalizations l10n, ThemeModeOption current) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.themeDialog),
        children: ThemeModeOption.values.map((mode) {
          return ListTile(
            title: Text(_themeModeLabel(l10n, mode)),
            trailing: mode == current ? const Icon(Icons.check) : null,
            onTap: () {
              ref.read(settingsProvider.notifier).setThemeMode(mode);
              Navigator.pop(ctx);
            },
          );
        }).toList(),
      ),
    );
  }

  String _exportFormatLabel(ExportFormat format, AppLocalizations l10n) {
    switch (format) {
      case ExportFormat.markdown: return l10n.exportFormatMarkdown;
      case ExportFormat.json: return l10n.exportFormatJson;
    }
  }

  void _showExportFormatPicker(BuildContext context, WidgetRef ref, AppLocalizations l10n, ExportFormat current) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.exportFormatDialog),
        children: ExportFormat.values.map((format) {
          return ListTile(
            title: Text(_exportFormatLabel(format, l10n)),
            trailing: format == current ? const Icon(Icons.check) : null,
            onTap: () {
              ref.read(settingsProvider.notifier).setExportFormat(format);
              Navigator.pop(ctx);
            },
          );
        }).toList(),
      ),
    );
  }

  void _showLocalePicker(BuildContext context, WidgetRef ref, AppLocalizations l10n, String current) {
    final locales = [
      ('ru', l10n.localeRu),
      ('en', l10n.localeEn),
      ('es', l10n.localeEs),
      ('de', l10n.localeDe),
      ('uk', l10n.localeUk),
      ('pl', l10n.localePl),
      ('it', l10n.localeIt),
      ('fr', l10n.localeFr),
      ('kk', l10n.localeKk),
      ('ky', l10n.localeKy),
      ('tr', l10n.localeTr),
      ('zh', l10n.localeZh),
      ('ja', l10n.localeJa),
    ];

    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.languageDialog),
        children: locales.map((l) {
          return ListTile(
            title: Text(l.$2),
            trailing: l.$1 == current ? const Icon(Icons.check) : null,
            onTap: () {
              ref.read(settingsProvider.notifier).setLocale(l.$1);
              Navigator.pop(ctx);
            },
          );
        }).toList(),
      ),
    );
  }

  String _fontSizeLabel(AppLocalizations l10n, FontSize size) {
    switch (size) {
      case FontSize.small: return l10n.fontSizeSmall;
      case FontSize.medium: return l10n.fontSizeMedium;
      case FontSize.large: return l10n.fontSizeLarge;
    }
  }

  void _showFontSizePicker(BuildContext context, WidgetRef ref, AppLocalizations l10n, FontSize current) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.fontSizeDialog),
        children: FontSize.values.map((size) {
          return ListTile(
            title: Text(_fontSizeLabel(l10n, size)),
            trailing: size == current ? const Icon(Icons.check) : null,
            onTap: () {
              ref.read(settingsProvider.notifier).setFontSize(size);
              Navigator.pop(ctx);
            },
          );
        }).toList(),
      ),
    );
  }

  String _groupModeLabel(AppLocalizations l10n, GroupMode mode) {
    switch (mode) {
      case GroupMode.none: return l10n.groupModeNone;
      case GroupMode.day: return l10n.groupModeDay;
      case GroupMode.week: return l10n.groupModeWeek;
      case GroupMode.month: return l10n.groupModeMonth;
    }
  }

  void _showGroupModePicker(BuildContext context, WidgetRef ref, AppLocalizations l10n, GroupMode current) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.groupingDialog),
        children: GroupMode.values.map((mode) {
          return ListTile(
            title: Text(_groupModeLabel(l10n, mode)),
            trailing: mode == current ? const Icon(Icons.check) : null,
            onTap: () {
              ref.read(settingsProvider.notifier).setGroupMode(mode);
              Navigator.pop(ctx);
            },
          );
        }).toList(),
      ),
    );
  }

  String _sortModeLabel(AppLocalizations l10n, SortMode mode) {
    switch (mode) {
      case SortMode.dateDesc: return l10n.sortModeDateDesc;
      case SortMode.dateAsc: return l10n.sortModeDateAsc;
    }
  }

  void _showSortModePicker(BuildContext context, WidgetRef ref, AppLocalizations l10n, SortMode current) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.sortingDialog),
        children: SortMode.values.map((mode) {
          return ListTile(
            title: Text(_sortModeLabel(l10n, mode)),
            trailing: mode == current ? const Icon(Icons.check) : null,
            onTap: () {
              ref.read(settingsProvider.notifier).setSortMode(mode);
              Navigator.pop(ctx);
            },
          );
        }).toList(),
      ),
    );
  }

  void _showViewModePicker(BuildContext context, WidgetRef ref, AppLocalizations l10n, ViewMode current) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.viewModeDialog),
        children: [
          ListTile(
            title: Text(l10n.viewModeList),
            trailing: current == ViewMode.list ? const Icon(Icons.check) : null,
            onTap: () {
              ref.read(settingsProvider.notifier).setViewMode(ViewMode.list);
              Navigator.pop(ctx);
            },
          ),
          ListTile(
            title: Text(l10n.viewModeGrid),
            trailing: current == ViewMode.grid ? const Icon(Icons.check) : null,
            onTap: () {
              ref.read(settingsProvider.notifier).setViewMode(ViewMode.grid);
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
