import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../widgets/task_tile.dart';
import 'edit_task_screen.dart';
import '../l10n/app_localizations.dart';

class TaskEditorScreen extends StatefulWidget {
  final TaskService taskService;

  const TaskEditorScreen({super.key, required this.taskService});

  @override
  State<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends State<TaskEditorScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final tasks = widget.taskService.tasks;

    if (tasks.isEmpty) {
      return Center(
        child: Text(
          localizations.noTasks,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: tasks.length,
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemBuilder: (context, index) {
        final task = tasks[index];

        return TaskTile(
          task: task,
          onTap: () {
            setState(() {
              widget.taskService.toggleTask(index);
            });
          },
          onDelete: () {
            setState(() {
              widget.taskService.deleteTask(index);
            });
          },
          onEditTitle: () {
            Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (context) => EditTaskScreen(
                  taskService: widget.taskService,
                  taskIndex: index,
                ),
              ),
            ).then((result) {
              if (result == true) {
                setState(() {});
              }
            });
          },
          onEditCategory: () {},
          onAddComment: () {
            // Для быстроты перенаправляем на экран редактирования,
            // чтобы пользователь мог править комментарии.
            Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (context) => EditTaskScreen(
                  taskService: widget.taskService,
                  taskIndex: index,
                ),
              ),
            ).then((result) {
              if (result == true) {
                setState(() {});
              }
            });
          },
          onSetProcrastinationReason: (reason) {
            setState(() {
              widget.taskService.setProcrastinationReason(index, reason);
            });
          },
        );
      },
    );
  }
}
