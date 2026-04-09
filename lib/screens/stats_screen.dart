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
        title: Text(localizations.statistics),
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
                      "${total > 0 ? ((completed / total) * 100).toStringAsFixed(1) : 0}${localizations.percentCompleted}",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 3,
              color: theme.cardColor,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.experiencePoints,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: colorScheme.secondary,
                          size: 32,
                        ),
                        SizedBox(width: 12),
                        Text(
                          '${widget.taskService.experience}',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          localizations.totalExperience,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.trending_up,
                          color: colorScheme.primary,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${localizations.level} ${widget.taskService.level}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
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
              color: theme.cardColor,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.achievements,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    if (widget.taskService.achievements.isEmpty)
                      Center(
                        child: Text(
                          localizations.noAchievements,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.taskService.achievements.map((achievementKey) {
                          return Chip(
                            avatar: Icon(
                              Icons.emoji_events,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            label: Text(_getAchievementText(achievementKey, localizations)),
                            backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
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

  String _getAchievementText(String key, AppLocalizations localizations) {
    switch (key) {
      case 'firstCompletion':
        return localizations.firstCompletion;
      case 'master5Tasks':
        return localizations.master5Tasks;
      case 'hero10Tasks':
        return localizations.hero10Tasks;
      case 'legend20Tasks':
        return localizations.legend20Tasks;
      case 'level2':
        return localizations.level2;
      case 'level5':
        return localizations.level5;
      case 'level10':
        return localizations.level10;
      default:
        return key;
    }
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
            color: color.withValues(alpha: 0.2),
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
