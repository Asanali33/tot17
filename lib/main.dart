import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatefulWidget {
  const TaskFlowApp({super.key});

  @override
  State<TaskFlowApp> createState() => _TaskFlowAppState();
}

class _TaskFlowAppState extends State<TaskFlowApp> {
  SharedPreferences? _prefs;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  /// read stored preference and update state
  Future<void> _loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = _prefs?.getBool('isDarkMode') ?? false;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    // store preference when available
    if (_prefs != null) {
      _prefs!.setBool('isDarkMode', _isDarkMode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final lightColorScheme =
            lightDynamic ??
            ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.light,
            );

        final darkColorScheme =
            darkDynamic ??
            ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.dark,
            );

        final lightTheme =
            ThemeData.from(
              colorScheme: lightColorScheme,
              useMaterial3: true,
            ).copyWith(
              scaffoldBackgroundColor: lightColorScheme.surface,
              cardColor: lightColorScheme.surface,
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedItemColor: lightColorScheme.primary,
                unselectedItemColor: lightColorScheme.onSurface.withAlpha(0xA0),
                backgroundColor: lightColorScheme.surface,
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: lightColorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: lightColorScheme.onSurface.withAlpha(0x40),
                  ),
                ),
              ),
              switchTheme: SwitchThemeData(
                thumbColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return lightColorScheme.primary;
                  }
                  return lightColorScheme.onSurface.withAlpha(
                    (0.7 * 255).round(),
                  );
                }),
                trackColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return lightColorScheme.primary.withAlpha(
                      (0.5 * 255).round(),
                    );
                  }
                  return lightColorScheme.onSurface.withAlpha(
                    (0.3 * 255).round(),
                  );
                }),
              ),
            );

        final darkTheme =
            ThemeData.from(
              colorScheme: darkColorScheme,
              useMaterial3: true,
            ).copyWith(
              scaffoldBackgroundColor: darkColorScheme.surface,
              cardColor: darkColorScheme.surface,
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedItemColor: darkColorScheme.primary,
                unselectedItemColor: darkColorScheme.onSurface.withAlpha(0xA0),
                backgroundColor: darkColorScheme.surface,
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: darkColorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: darkColorScheme.onSurface.withAlpha(0x40),
                  ),
                ),
              ),
              switchTheme: SwitchThemeData(
                thumbColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return darkColorScheme.primary;
                  }
                  return darkColorScheme.onSurface.withAlpha(
                    (0.7 * 255).round(),
                  );
                }),
                trackColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return darkColorScheme.primary.withAlpha(
                      (0.5 * 255).round(),
                    );
                  }
                  return darkColorScheme.onSurface.withAlpha(
                    (0.3 * 255).round(),
                  );
                }),
              ),
            );

        return MaterialApp(
          title: 'TaskFlow',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: MainScreen(
            onToggleTheme: _toggleTheme,
            isDarkMode: _isDarkMode,
          ),
        );
      },
    );
  }
}
