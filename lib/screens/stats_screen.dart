import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../l10n/app_localizations.dart';

class StatsScreen extends StatefulWidget {
  final TaskService taskService;

  const StatsScreen({super.key, required this.taskService});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    int total = widget.taskService.tasks.length;
    int completed = widget.taskService.tasks.where((t) => t.isDone).length;
    int remaining = total - completed;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text("Статистика"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              color: theme.cardColor,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.overallStatistics,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          title: localizations.total,
                          value: total.toString(),
                          color: colorScheme.primary,
                        ),
                        _StatItem(
                          title: localizations.completed,
                          value: completed.toString(),
                          color: colorScheme.secondary,
                        ),
                        _StatItem(
                          title: localizations.remaining,
                          value: remaining.toString(),
                          color: colorScheme.tertiary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.progress,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: total > 0 ? completed / total : 0,
                        minHeight: 20,
                        backgroundColor: colorScheme.onSurface.withAlpha(
                          (0.2 * 255).round(),
                        ),
                        valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "${total > 0 ? ((completed / total) * 100).toStringAsFixed(1) : 0}% выполнено",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            if (total == 0)
              Center(
                child: Text(
                  localizations.addTasksForStats,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatItem({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
