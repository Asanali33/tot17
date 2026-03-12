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
    final lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
          .copyWith(brightness: Brightness.light),
      scaffoldBackgroundColor: Colors.grey[100],
      cardColor: Colors.white,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
      ),
    );

    final darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
          .copyWith(brightness: Brightness.dark),
      scaffoldBackgroundColor: Colors.grey[900],
      cardColor: Colors.grey[800],
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.indigo[200],
        unselectedItemColor: Colors.grey[400],
        backgroundColor: Colors.grey[850],
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
  }
}

