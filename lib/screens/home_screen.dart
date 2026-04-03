import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/task_service.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import 'subcategories_screen.dart';
import 'edit_task_screen.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  final TaskService taskService;

  const HomeScreen({super.key, required this.taskService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TaskService taskService;
  TextEditingController controller = TextEditingController();
  TextEditingController searchController = TextEditingController();
  String selectedCategory = 'general';
  bool showOnlyIncomplete = false;
  String sortByOption = 'priority';

  @override
  void initState() {
    super.initState();
    taskService = widget.taskService;
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
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

  void addCommentToTask(int index) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Добавить комментарий'),
        content: TextField(
          controller: controller,
          minLines: 1,
          maxLines: 5,
          autofocus: true,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\s\S]')),
          ],
          decoration: InputDecoration(hintText: 'Введите текст комментария'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isEmpty) return;
              setState(() {
                taskService.addComment(index, controller.text.trim());
              });
              Navigator.pop(context);
            },
            child: Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void addTask() {
    if (controller.text.isEmpty) return;

    final localizations = AppLocalizations.of(context)!;
    final parentContext = context;

    showDialog(
      context: parentContext,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(localizations.selectCategory),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: taskService.categories.keys.map((categoryKey) {
              return ListTile(
                title: Text(getLocalizedCategory(categoryKey)),
                onTap: () async {
                  Navigator.pop(dialogContext);

                  DateTime? deadline;
                  // ignore: use_build_context_synchronously
                  final pickedDate = await showDatePicker(
                    context: parentContext,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (!mounted) return;

                  if (pickedDate == null) {
                    // ignore: use_build_context_synchronously
                    final addWithoutDeadline = await showDialog<bool>(
                      context: parentContext,
                      builder: (innerContext) {
                        return AlertDialog(
                          title: Text(localizations.deadline),
                          content: const Text(
                            'Дедлайн не выбран. Добавить задачу без дедлайна?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(innerContext, false),
                              child: Text(localizations.cancel),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(innerContext, true),
                              child: Text(localizations.save),
                            ),
                          ],
                        );
                      },
                    );
                    if (!mounted) return;

                    if (addWithoutDeadline != true) return;
                  } else {
                    final pickedTime = await showTimePicker(
                      context: parentContext,
                      initialTime: const TimeOfDay(hour: 23, minute: 59),
                      helpText: 'Выберите время дедлайна',
                    );
                    if (!mounted) return;

                    if (pickedTime == null) {
                      // ignore: use_build_context_synchronously
                      final addWithoutDeadline = await showDialog<bool>(
                        context: parentContext,
                        builder: (innerContext) {
                          return AlertDialog(
                            title: Text(localizations.deadline),
                            content: const Text(
                              'Время не выбрано. Добавить задачу без дедлайна?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(innerContext, false),
                                child: Text(localizations.cancel),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(innerContext, true),
                                child: Text(localizations.save),
                              ),
                            ],
                          );
                        },
                      );
                      if (!mounted) return;

                      if (addWithoutDeadline != true) return;
                    } else {
                      deadline = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    }
                  }

                  if (!mounted) return;
                  setState(() {
                    selectedCategory = categoryKey;
                    taskService.addTask(
                      controller.text.trim(),
                      category: categoryKey,
                      deadline: deadline,
                    );
                    controller.clear();
                  });
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void editTaskTitle(int index) {
    Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(
          taskService: taskService,
          taskIndex: index,
        ),
      ),
    ).then((result) {
      if (result == true) {
        setState(() {});
      }
    });
  }

  double getProgress() {
    if (taskService.tasks.isEmpty) return 0;
    int completed = taskService.tasks.where((t) => t.isDone).length;
    return completed / taskService.tasks.length;
  }

  /// Получить отфильтрованный и отсортированный список задач
  List<Task> getFilteredAndSortedTasks() {
    List<Task> filtered = showOnlyIncomplete
        ? taskService.getIncompleteTasksOnly()
        : List<Task>.from(taskService.tasks);

    final searchText = searchController.text.toLowerCase();
    if (searchText.isNotEmpty) {
      filtered = filtered
          .where((task) => task.title.toLowerCase().contains(searchText))
          .toList();
    }

    if (sortByOption == 'priority') {
      filtered.sort((a, b) {
        if (a.priority != b.priority) {
          return b.priority.compareTo(a.priority);
        }
        if (a.deadline == null && b.deadline == null) return 0;
        if (a.deadline == null) return 1;
        if (b.deadline == null) return -1;
        return a.deadline!.compareTo(b.deadline!);
      });
    } else if (sortByOption == 'date') {
      filtered.sort((a, b) {
        if (a.deadline == null && b.deadline == null) return 0;
        if (a.deadline == null) return 1;
        if (b.deadline == null) return -1;
        return a.deadline!.compareTo(b.deadline!);
      });
    }

    return filtered;
  }

  int getOriginalIndex(Task task) {
    for (int i = 0; i < taskService.tasks.length; i++) {
      if (identical(taskService.tasks[i], task)) {
        return i;
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context)!;

    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: 1),
    );

    return Scaffold(
      appBar: AppBar(title: Text("TaskFlow"), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\s\S]')),
                    ],
                    decoration: InputDecoration(
                      hintText: localizations.enterTask,
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      filled: true,
                      fillColor: colorScheme.surface,
                      border: border(colorScheme.onSurface.withAlpha(0x40)),
                      enabledBorder: border(
                        colorScheme.onSurface.withAlpha(0x40),
                      ),
                      focusedBorder: border(colorScheme.primary),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: addTask,
                  child: Text(localizations.add),
                ),
              ],
            ),
          ),

          // Поиск и фильтр
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchTasks,
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showOnlyIncomplete = !showOnlyIncomplete;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: showOnlyIncomplete
                                ? colorScheme.primaryContainer
                                : colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: showOnlyIncomplete,
                                onChanged: (_) {
                                  setState(() {
                                    showOnlyIncomplete = !showOnlyIncomplete;
                                  });
                                },
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!.onlyActive,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: showOnlyIncomplete
                                        ? colorScheme.onPrimaryContainer
                                        : colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DropdownMenu<String>(
                        initialSelection: sortByOption,
                        onSelected: (String? value) {
                          setState(() {
                            sortByOption = value ?? 'priority';
                          });
                        },
                        dropdownMenuEntries: [
                          DropdownMenuEntry(
                            value: 'priority',
                            label: AppLocalizations.of(context)!.priority,
                          ),
                          DropdownMenuEntry(
                            value: 'date',
                            label: AppLocalizations.of(context)!.date,
                          ),
                          DropdownMenuEntry(
                            value: 'none',
                            label: AppLocalizations.of(context)!.noSorting,
                          ),
                        ],
                        width: 140,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                LinearProgressIndicator(value: getProgress(), minHeight: 8),
                SizedBox(height: 8),
                Text(
                  '${(getProgress() * 100).toStringAsFixed(0)}% ${localizations.completed}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),

          Expanded(
            child: getFilteredAndSortedTasks().isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 64,
                          color: colorScheme.outlineVariant,
                        ),
                        SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.noTasks,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.outlineVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: getFilteredAndSortedTasks().length,
                    itemBuilder: (context, filteredIndex) {
                      final task = getFilteredAndSortedTasks()[filteredIndex];
                      final index = getOriginalIndex(task);

                      return AnimatedOpacity(
                        opacity: task.isDone ? 0.6 : 1.0,
                        duration: Duration(milliseconds: 300),
                        child: AnimatedSlide(
                          offset: task.isDone ? Offset(0.05, 0) : Offset.zero,
                          duration: Duration(milliseconds: 300),
                          child: Dismissible(
                            key: Key(task.title + index.toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              setState(() {
                                taskService.deleteTask(index);
                              });
                            },
                            background: Container(
                              color: Theme.of(context).colorScheme.error,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(
                                Icons.delete,
                                color: Theme.of(context).colorScheme.onError,
                              ),
                            ),
                            child: Stack(
                              children: [
                                TaskTile(
                                  task: task,
                                  onTap: () {
                                    setState(() {
                                      taskService.toggleTask(index);
                                    });
                                  },
                                  onEditTitle: () => editTaskTitle(index),
                                  onDelete: () {
                                    setState(() {
                                      taskService.deleteTask(index);
                                    });
                                  },
                                  onAddComment: () => addCommentToTask(index),
                                  onEditCategory: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SubcategoriesScreen(
                                              taskService: taskService,
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
                                      taskService.setProcrastinationReason(
                                        index,
                                        reason,
                                      );
                                    });
                                  },
                                ),
                                // Индикатор приоритета слева
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 4,
                                    decoration: BoxDecoration(
                                      color: _getPriorityColor(task.priority),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
