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
  final Function(String)? onSetProcrastinationReason;

  // Static set для отслеживания показанных диалогов
  static final Set<String> _shownProcrastinationDialogs = {};

  const TaskTile({
    super.key,
    required this.task,
    required this.onTap,
    required this.onDelete,
    this.onEditTitle,
    this.onEditCategory,
    this.onAddComment,
    this.onSetProcrastinationReason,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context)!;

    // Показать диалог прокрастинации для старых невыполненных задач
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskId = task.createdAt.toIso8601String();
      if (!_shownProcrastinationDialogs.contains(taskId) &&
          !task.isDone &&
          task.procrastinationReason == null &&
          task.createdAt.isBefore(DateTime.now().subtract(const Duration(days: 3))) &&
          onSetProcrastinationReason != null) {
        _showProcrastinationDialog(context, taskId);
      }
    });

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
                    if (onAddComment != null) GestureDetector(
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
                    if (onEditCategory != null) GestureDetector(
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
                      child: Row(
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
                              comment,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showProcrastinationDialog(BuildContext context, String taskId) {
    _shownProcrastinationDialogs.add(taskId);
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.procrastinationReasons),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildReasonButton(context, localizations.tooTiring),
            _buildReasonButton(context, localizations.lackOfTime),
            _buildReasonButton(context, localizations.lackOfMotivation),
            _buildReasonButton(context, localizations.tooComplex),
            _buildReasonButton(context, localizations.forgot),
            _buildReasonButton(context, localizations.otherReason),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.cancel),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonButton(BuildContext context, String reason) {
    return ListTile(
      title: Text(reason),
      onTap: () {
        onSetProcrastinationReason?.call(reason);
        Navigator.of(context).pop();
      },
    );
  }
}
