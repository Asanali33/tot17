import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/task_service.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;
  final TaskService taskService;

  const SettingsScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
    required this.taskService,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final localeProvider = context.watch<LocaleProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(localizations.settings), centerTitle: true),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              localizations.general,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: Text(localizations.notifications),
              subtitle: Text(localizations.getReminders),
              trailing: Switch(
                value: notificationsEnabled,
                activeThumbColor: Theme.of(context).colorScheme.primary,
                activeTrackColor: Theme.of(
                  context,
                ).colorScheme.primary.withAlpha((0.5 * 255).round()),
                inactiveThumbColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                inactiveTrackColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withAlpha((0.3 * 255).round()),
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: Text(localizations.darkTheme),
              subtitle: Text(localizations.useDarkMode),
              trailing: Switch(
                value: widget.isDarkMode,
                activeThumbColor: Theme.of(context).colorScheme.primary,
                activeTrackColor: Theme.of(
                  context,
                ).colorScheme.primary.withAlpha((0.5 * 255).round()),
                inactiveThumbColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                inactiveTrackColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withAlpha((0.3 * 255).round()),
                onChanged: (value) {
                  widget.onToggleTheme();
                },
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: Text(localizations.language),
              subtitle: Text(localeProvider.locale.languageCode == 'ru' ? localizations.russian : localizations.english),
              trailing: Icon(Icons.language),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(localizations.selectLanguage),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(localizations.russian),
                          leading: Radio<String>(
                            value: 'ru',
                            groupValue: localeProvider.locale.languageCode,
                            onChanged: (value) {
                              if (value != null) {
                                localeProvider.setLocale(Locale(value));
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(localizations.english),
                          leading: Radio<String>(
                            value: 'en',
                            groupValue: localeProvider.locale.languageCode,
                            onChanged: (value) {
                              if (value != null) {
                                localeProvider.setLocale(Locale(value));
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              localizations.aboutApp,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text("TaskFlow"),
              subtitle: Text("${localizations.version} 1.0.0"),
              leading: Icon(Icons.info),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(localizations.aboutDeveloper),
              subtitle: Text(localizations.taskManager),
              leading: Icon(Icons.person),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(localizations.confirm),
                    content: Text(
                      localizations.sureClearTasks,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(localizations.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.taskService.clearAllTasks();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(localizations.allTasksCleared)),
                          );
                        },
                        child: Text(localizations.clear),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.delete),
              label: Text(localizations.clearAllTasks),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
