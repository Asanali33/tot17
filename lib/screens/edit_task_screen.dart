import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import 'subcategories_screen.dart';
import '../l10n/app_localizations.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskService taskService;
  final int taskIndex;

  const EditTaskScreen({super.key, required this.taskService, required this.taskIndex});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late Task task;
  late TextEditingController titleController;
  late List<TextEditingController> commentsControllers;
  DateTime? selectedDeadline;
  int selectedPriority = 2;

  @override
  void initState() {
    super.initState();
    task = widget.taskService.tasks[widget.taskIndex];
    titleController = TextEditingController(text: task.title);
    selectedDeadline = task.deadline;
    selectedPriority = task.priority;
    commentsControllers = task.comments
        .map((c) => TextEditingController(text: c.text))
        .toList();
  }

  @override
  void dispose() {
    titleController.dispose();
    for (var c in commentsControllers) {
      c.dispose();
    }
    super.dispose();
  }

  String getLocalizedCategory(String key) {
    final localizations = AppLocalizations.of(context)!;
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
    final localizations = AppLocalizations.of(context)!;
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

  Future<void> _pickDeadline() async {
    final localizations = AppLocalizations.of(context)!;

    final date = await showDatePicker(
      context: context,
      initialDate: selectedDeadline ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: selectedDeadline != null
          ? TimeOfDay.fromDateTime(selectedDeadline!)
          : const TimeOfDay(hour: 23, minute: 59),
      helpText: localizations.deadline,
    );

    if (time == null) {
      setState(() {
        selectedDeadline = DateTime(date.year, date.month, date.day);
      });
      return;
    }

    setState(() {
      selectedDeadline = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _saveTask() {
    final newTitle = titleController.text.trim();
    if (newTitle.isEmpty) return;

    widget.taskService.tasks[widget.taskIndex].title = newTitle;
    widget.taskService.tasks[widget.taskIndex].deadline = selectedDeadline;
    widget.taskService.tasks[widget.taskIndex].priority = selectedPriority;

    final newComments = commentsControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .map((text) => Comment(text: text, author: widget.taskService.currentUserName))
        .toList();

    widget.taskService.tasks[widget.taskIndex].comments.clear();
    widget.taskService.tasks[widget.taskIndex].comments.addAll(newComments);

    Navigator.of(context).pop(true);
  }

  void _resetDeadline() {
    setState(() {
      selectedDeadline = null;
    });
  }

  void _addCommentField() {
    setState(() {
      commentsControllers.add(TextEditingController());
    });
  }

  void _removeCommentField(int i) {
    setState(() {
      commentsControllers[i].dispose();
      commentsControllers.removeAt(i);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.editTask),
        actions: [
          TextButton(
            onPressed: _saveTask,
            child: Text(
              localizations.save,
              style: TextStyle(color: colorScheme.onPrimary),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: localizations.newTaskTitle,
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickDeadline,
                  icon: const Icon(Icons.schedule),
                  label: Text(localizations.deadline),
                ),
                const SizedBox(width: 16),
                if (selectedDeadline != null)
                  Expanded(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      children: [
                        Text(
                          '${selectedDeadline!.toLocal().toString().split(' ')[0]} ${selectedDeadline!.toLocal().toString().split(' ')[1].substring(0, 5)}',
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _resetDeadline,
                          tooltip: localizations.cancel,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              localizations.priority,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _priorityChip(localizations.lowPriority, 1, Colors.blue),
                _priorityChip(localizations.mediumPriority, 2, Colors.orange),
                _priorityChip(localizations.highPriority, 3, Colors.red),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text('Сохранить изменения'),
                onPressed: _saveTask,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.selectCategory, style: Theme.of(context).textTheme.titleMedium),
                ElevatedButton.icon(
                  icon: Icon(Icons.category),
                  label: Text(
                    getLocalizedCategory(task.category) +
                    (task.subcategory != null ? ' / ${getLocalizedSubcategory(task.subcategory!)}' : ''),
                  ),
                  onPressed: () {
                    Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubcategoriesScreen(
                          taskService: widget.taskService,
                          taskIndex: widget.taskIndex,
                        ),
                      ),
                    ).then((result) {
                      if (result == true && mounted) {
                        setState(() {
                          task = widget.taskService.tasks[widget.taskIndex];
                        });
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Комментарии', style: Theme.of(context).textTheme.titleMedium),
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: Text(localizations.add),
                  onPressed: _addCommentField,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...List.generate(commentsControllers.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentsControllers[i],
                        decoration: const InputDecoration(
                          hintText: 'Комментарий',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 1,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _removeCommentField(i),
                    ),
                  ],
                ),
              );
            }),
            if (commentsControllers.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Нет комментариев',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _priorityChip(String label, int priority, Color color) {
    final selected = selectedPriority == priority;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: color.withOpacity(0.2),
      onSelected: (flag) {
        if (flag) {
          setState(() {
            selectedPriority = priority;
          });
        }
      },
    );
  }
}
