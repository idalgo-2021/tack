import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/providers/settings_provider.dart';
import 'features/notes/screens/note_list_screen.dart';
import 'features/tags/screens/tag_manager_screen.dart';
import 'features/settings/screens/settings_screen.dart';

const _seedColors = {
  AppColorScheme.sage: Color(0xFF7B9E8D),
  AppColorScheme.peach: Color(0xFFD4A89B),
  AppColorScheme.sky: Color(0xFF8DB6D6),
  AppColorScheme.yellow: Color(0xFFFFC107),
  AppColorScheme.blue: Color(0xFF027DFD),
  AppColorScheme.coral: Color(0xFFE87070),
  AppColorScheme.navy: Color(0xFF1B2A4A),
};

class TackApp extends ConsumerWidget {
  const TackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final colorScheme = ref.watch(appColorSchemeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final seed = _seedColors[colorScheme] ?? _seedColors[AppColorScheme.sage]!;

    Intl.defaultLocale = locale;

    final ThemeData theme;
    final ThemeData? darkTheme;
    final bool useDark;

    switch (themeMode) {
      case ThemeModeOption.dark:
        theme = AppTheme.dark(seed);
        darkTheme = null;
        useDark = false;
      case ThemeModeOption.highContrast:
        theme = AppTheme.highContrast();
        darkTheme = null;
        useDark = false;
      case ThemeModeOption.light:
        theme = AppTheme.light(seed);
        darkTheme = AppTheme.dark(seed);
        useDark = false;
    }

    return MaterialApp(
      title: 'Tack',
      debugShowCheckedModeBanner: false,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: useDark ? ThemeMode.dark : null,
      locale: Locale(locale),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MainShell(),
    );
  }
}

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  final _screens = const [
    NoteListScreen(),
    TagManagerScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.note_outlined),
            selectedIcon: const Icon(Icons.note),
            label: l10n.notes,
          ),
          NavigationDestination(
            icon: const Icon(Icons.label_outline),
            selectedIcon: const Icon(Icons.label),
            label: l10n.tags,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}
