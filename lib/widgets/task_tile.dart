import 'package:flutter/material.dart';
import '../models/task.dart';
import '../l10n/app_localizations.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback? onEditTitle;
  final VoidCallback? onEditCategory;
  final VoidCallback? onAddComment;

  const TaskTile({
    super.key,
    required this.task,
    required this.onTap,
    required this.onDelete,
    this.onEditTitle,
    this.onEditCategory,
    this.onAddComment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context)!;

    String getLocalizedCategory(String key) {
      switch (key) {
        case 'work':
          return localizations.work;
        case 'personal':
          return localizations.personal;
        case 'shopping':
          return localizations.shopping;
        case 'general':
          return localizations.general;
        default:
          return key;
      }
    }

    String getLocalizedSubcategory(String key) {
      switch (key) {
        case 'projects':
          return localizations.projects;
        case 'meetings':
          return localizations.meetings;
        case 'reports':
          return localizations.reports;
        case 'sport':
          return localizations.sport;
        case 'reading':
          return localizations.reading;
        case 'hobby':
          return localizations.hobby;
        case 'food':
          return localizations.food;
        case 'clothes':
          return localizations.clothes;
        case 'home':
          return localizations.home;
        case 'standard':
          return localizations.standard;
        case 'other':
          return localizations.other;
        default:
          return key;
      }
    }

    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              task.isDone ? Icons.check_circle : Icons.circle_outlined,
              color: task.isDone
                  ? colorScheme.primary
                  : colorScheme.onSurface.withAlpha((0.6 * 255).round()),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            onTap: onTap,
            onLongPress: onEditTitle,
            trailing: IconButton(
              icon: Icon(Icons.delete, color: colorScheme.error),
              onPressed: onDelete,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Chip(
                      label: Text(
                        getLocalizedCategory(task.category),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                      backgroundColor: colorScheme.secondaryContainer,
                      labelPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    if (task.subcategory != null) ...[
                      SizedBox(width: 8),
                      Chip(
                        label: Text(
                          getLocalizedSubcategory(task.subcategory!),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        labelPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ],
                    Spacer(),
                    GestureDetector(
                      onTap: onAddComment,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.comment,
                            color: colorScheme.primary,
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(
                            task.comments.length.toString(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    GestureDetector(
                      onTap: onEditCategory,
                      child: Icon(
                        Icons.edit,
                        color: colorScheme.primary,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                if (task.deadline != null) ...[
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${localizations.deadline}: ${task.deadline!.toLocal().toString().split(' ')[0]} ${task.deadline!.toLocal().toString().split(' ')[1].substring(0, 5)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
                if (task.teamDeadline != null) ...[
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Командный: ${task.teamDeadline!.toLocal().toString().split(' ')[0]} ${task.teamDeadline!.toLocal().toString().split(' ')[1].substring(0, 5)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
                if (task.estimatedDuration != null) ...[
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.timer,
                        size: 16,
                        color: colorScheme.tertiary,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Время выполнения: ${_formatDuration(task.estimatedDuration!)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (task.isTimerActive && task.timerStartedAt != null)
                              Text(
                                'Таймер: ${_getRemainingTime(task)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.tertiary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                if (task.assignedTo != null) ...[
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Исполнитель: ${task.assignedTo}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
                if (task.comments.isNotEmpty) ...[
                  Divider(color: colorScheme.onSurfaceVariant.withAlpha(120)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Комментарии:',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  ...task.comments.map(
                    (comment) => Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (comment.author != null)
                                Text(
                                  '${comment.author}: ',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              Spacer(),
                              Text(
                                '${comment.createdAt.day}.${comment.createdAt.month} ${comment.createdAt.hour}:${comment.createdAt.minute.toString().padLeft(2, '0')}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 6,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  comment.text,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ).toList(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}ч ${minutes}м ${seconds}с';
    } else if (minutes > 0) {
      return '${minutes}м ${seconds}с';
    } else {
      return '${seconds}с';
    }
  }

  String _getRemainingTime(Task task) {
    if (task.timerStartedAt == null || task.estimatedDuration == null) {
      return 'Не установлено';
    }

    final elapsed = DateTime.now().difference(task.timerStartedAt!);
    final remaining = task.estimatedDuration!.inSeconds - elapsed.inSeconds;

    if (remaining <= 0) {
      return '⏰ Время истекло!';
    }

    final hours = remaining ~/ 3600;
    final minutes = (remaining % 3600) ~/ 60;
    final seconds = remaining % 60;

    if (hours > 0) {
      return '${hours}ч ${minutes}м ${seconds}с';
    } else if (minutes > 0) {
      return '${minutes}м ${seconds}с';
    } else {
      return '${seconds}с';
    }
  }
}
