import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';
import 'collaboration_screen.dart';
import 'productivity_analytics_screen.dart';
import 'ai_assistant_screen.dart';
import '../services/task_service.dart';
import '../l10n/app_localizations.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const MainScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final TaskService taskService = TaskService();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(taskService: taskService),
      StatsScreen(taskService: taskService),
      CollaborationScreen(taskService: taskService),
      ProductivityAnalyticsScreen(taskService: taskService),
      AIAssistantScreen(taskService: taskService),
      SettingsScreen(
        onToggleTheme: widget.onToggleTheme,
        isDarkMode: widget.isDarkMode,
        taskService: taskService,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screens = _buildScreens();
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        // Colors come from theme via BottomNavigationBarThemeData
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: localizations.tasks,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: localizations.statistics,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: localizations.collaboration,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: localizations.analytics,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: localizations.aiAssistant,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: localizations.settings,
          ),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.shifting,
        //selectedItemColor: Colors.indigo,
        onTap: _onItemTapped,
      ),
    );
  }
}
