import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/role.dart';
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
  DateTime? selectedTeamDeadline;
  int selectedPriority = 2;
  String? selectedAssignedTo;
  String? selectedAssignedRole;
  TaskStatus selectedStatus = TaskStatus.todo;
  int? estimatedHours;
  int? estimatedMinutes;

  @override
  void initState() {
    super.initState();
    task = widget.taskService.tasks[widget.taskIndex];
    titleController = TextEditingController(text: task.title);
    selectedDeadline = task.deadline;
    selectedTeamDeadline = task.teamDeadline;
    selectedPriority = task.priority;
    selectedAssignedTo = task.assignedTo;
    if (selectedAssignedTo != null &&
        !widget.taskService.teamMembers.any((m) => m.name == selectedAssignedTo)) {
      selectedAssignedTo = null;
    }

    selectedAssignedRole = task.assignedRole;
    if (selectedAssignedRole != null &&
        !Role.predefinedRoles.any((r) => r.name == selectedAssignedRole)) {
      selectedAssignedRole = null;
    }

    selectedStatus = task.status;
    
    // Инициализация продолжительности
    if (task.estimatedDuration != null) {
      estimatedHours = task.estimatedDuration!.inHours;
      estimatedMinutes = task.estimatedDuration!.inMinutes % 60;
    }
    
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

  Future<void> _pickTeamDeadline() async {
    final localizations = AppLocalizations.of(context)!;

    final date = await showDatePicker(
      context: context,
      initialDate: selectedTeamDeadline ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: selectedTeamDeadline != null
          ? TimeOfDay.fromDateTime(selectedTeamDeadline!)
          : const TimeOfDay(hour: 23, minute: 59),
      helpText: localizations.teamDeadline,
    );

    if (time == null) {
      setState(() {
        selectedTeamDeadline = DateTime(date.year, date.month, date.day);
      });
      return;
    }

    setState(() {
      selectedTeamDeadline = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _saveTask() async {
    final newTitle = titleController.text.trim();
    if (newTitle.isEmpty) return;

    final task = widget.taskService.tasks[widget.taskIndex];
    task.title = newTitle;
    task.deadline = selectedDeadline;
    task.teamDeadline = selectedTeamDeadline;
    task.priority = selectedPriority;
    task.assignedTo = selectedAssignedTo;
    task.assignedRole = selectedAssignedRole;
    task.status = selectedStatus;

    // Сохраняем продолжительность
    if (estimatedHours != null || estimatedMinutes != null) {
      final hours = estimatedHours ?? 0;
      final minutes = estimatedMinutes ?? 0;
      task.estimatedDuration = Duration(hours: hours, minutes: minutes);
    } else {
      task.estimatedDuration = null;
    }

    final newComments = commentsControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .map((text) => Comment(text: text, author: widget.taskService.currentUserName))
        .toList();

    task.comments.clear();
    task.comments.addAll(newComments);

    // Синхронизируем с сервером
    await widget.taskService.updateTaskOnServer(task);

    Navigator.of(context).pop(true);
  }

  void _resetDeadline() {
    setState(() {
      selectedDeadline = null;
    });
  }

  void _resetTeamDeadline() {
    setState(() {
      selectedTeamDeadline = null;
    });
  }

  void _resetDuration() {
    setState(() {
      estimatedHours = null;
      estimatedMinutes = null;
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.editTask),
        actions: [
          TextButton(
            onPressed: () { _saveTask(); },
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
            // Название задачи
            Text(
              'Название',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: localizations.newTaskTitle,
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // Категория и подкатегория
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.selectCategory, style: theme.textTheme.titleMedium),
                ElevatedButton.icon(
                  icon: const Icon(Icons.category),
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
            const SizedBox(height: 24),

            // Приоритет
            Text(
              localizations.priority,
              style: theme.textTheme.titleMedium,
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
            const SizedBox(height: 24),

            // Дедлайн (личный)
            Text(
              localizations.deadline,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickDeadline,
                  icon: const Icon(Icons.schedule),
                  label: Text(localizations.setDeadline),
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
            const SizedBox(height: 24),

            // Дедлайн командный
            Text(
              localizations.teamDeadline,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickTeamDeadline,
                  icon: const Icon(Icons.people),
                  label: Text(localizations.setDeadline),
                ),
                const SizedBox(width: 16),
                if (selectedTeamDeadline != null)
                  Expanded(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      children: [
                        Text(
                          '${selectedTeamDeadline!.toLocal().toString().split(' ')[0]} ${selectedTeamDeadline!.toLocal().toString().split(' ')[1].substring(0, 5)}',
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _resetTeamDeadline,
                          tooltip: localizations.cancel,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Статус задачи
            Text(
              'Статус',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            DropdownButton<TaskStatus>(
              value: selectedStatus,
              isExpanded: true,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedStatus = value;
                  });
                }
              },
              items: TaskStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(_getStatusLabel(status)),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Исполнитель
            Text(
              'Исполнитель',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            DropdownButton<String?>(
              value: selectedAssignedTo,
              isExpanded: true,
              hint: Text('Выберите исполнителя'),
              onChanged: (value) {
                setState(() {
                  selectedAssignedTo = value;
                });
              },
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Нет'),
                ),
                ...widget.taskService.teamMembers.map((member) {
                  return DropdownMenuItem(
                    value: member.name,
                    child: Text(member.name),
                  );
                }).toList(),
              ],
            ),
            const SizedBox(height: 24),

            // Роль исполнителя
            Text(
              'Роль',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            DropdownButton<String?>(
              value: selectedAssignedRole,
              isExpanded: true,
              hint: Text('Выберите роль'),
              onChanged: (value) {
                setState(() {
                  selectedAssignedRole = value;
                });
              },
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Нет'),
                ),
                ...Role.predefinedRoles.map((role) {
                  return DropdownMenuItem(
                    value: role.name,
                    child: Text(role.name),
                  );
                }).toList(),
              ],
            ),
            const SizedBox(height: 24),

            // Предполагаемая продолжительность
            Text(
              'Предполагаемое время выполнения',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Часы',
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        estimatedHours = int.tryParse(value);
                      });
                    },
                    controller: TextEditingController(
                      text: estimatedHours?.toString() ?? '',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Минуты',
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        estimatedMinutes = int.tryParse(value);
                      });
                    },
                    controller: TextEditingController(
                      text: estimatedMinutes?.toString() ?? '',
                    ),
                  ),
                ),
                if (estimatedHours != null || estimatedMinutes != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _resetDuration,
                    tooltip: localizations.cancel,
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Комментарии
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Комментарии', style: theme.textTheme.titleMedium),
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
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            const SizedBox(height: 24),

            // Кнопка сохранения
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(localizations.save),
                onPressed: () { _saveTask(); },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return 'К выполнению';
      case TaskStatus.inProgress:
        return 'В работе';
      case TaskStatus.review:
        return 'На проверке';
      case TaskStatus.done:
        return 'Выполнено';
      default:
        return status.displayName;
    }
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
