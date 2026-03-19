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
    // define explicit theme objects so changes are more visible
    final lightColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.indigo,
    ).copyWith(brightness: Brightness.light);

    final lightTheme = ThemeData(
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: Colors.grey[100],
      cardColor: Colors.white,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return lightColorScheme.primary;
          }
          return lightColorScheme.onSurface.withAlpha((0.7 * 255).round());
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return lightColorScheme.primary.withAlpha((0.5 * 255).round());
          }
          return lightColorScheme.onSurface.withAlpha((0.3 * 255).round());
        }),
      ),
    );

    final darkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.indigo,
    ).copyWith(brightness: Brightness.dark);

    final darkTheme = ThemeData(
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: Colors.grey[900],
      cardColor: Colors.grey[800],
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.indigo[200],
        unselectedItemColor: Colors.grey[400],
        backgroundColor: Colors.grey[850],
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkColorScheme.primary;
          }
          return darkColorScheme.onSurface.withAlpha((0.7 * 255).round());
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkColorScheme.primary.withAlpha((0.5 * 255).round());
          }
          return darkColorScheme.onSurface.withAlpha((0.3 * 255).round());
        }),
      ),
    );

    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MainScreen(onToggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
    );
  }
}
