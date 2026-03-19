import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback? onEditTitle;
  final VoidCallback? onEditCategory;

  const TaskTile({
    super.key,
    required this.task,
    required this.onTap,
    required this.onDelete,
    this.onEditTitle,
    this.onEditCategory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
            child: Row(
              children: [
                Chip(
                  label: Text(
                    task.category,
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
                      task.subcategory!,
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
                  onTap: onEditCategory,
                  child: Icon(Icons.edit, color: colorScheme.primary, size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
