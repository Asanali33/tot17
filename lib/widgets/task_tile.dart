import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback? onEditCategory;

  const TaskTile({
    super.key,
    required this.task,
    required this.onTap,
    required this.onDelete,
    this.onEditCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              task.isDone ? Icons.check_circle : Icons.circle_outlined,
              color: task.isDone ? Colors.green : Colors.grey,
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
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
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
                    style: TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Colors.indigo[100],
                  labelPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
                if (task.subcategory != null) ...[
                  SizedBox(width: 8),
                  Chip(
                    label: Text(
                      task.subcategory!,
                      style: TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.indigo[50],
                    labelPadding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                ],
                Spacer(),
                GestureDetector(
                  onTap: onEditCategory,
                  child: Icon(
                    Icons.edit,
                    color: Colors.indigo,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
