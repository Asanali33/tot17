import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/task_service.dart';
import '../widgets/task_tile.dart';
import 'subcategories_screen.dart';
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
  String selectedCategory = 'general';

  @override
  void initState() {
    super.initState();
    taskService = widget.taskService;
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

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.selectCategory),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: taskService.categories.keys.map((categoryKey) {
              return ListTile(
                title: Text(getLocalizedCategory(categoryKey)),
                onTap: () async {
                  Navigator.pop(context);

                  DateTime? deadline;
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );

                  if (pickedDate != null) {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: 23, minute: 59),
                      helpText: 'Выберите время дедлайна',
                    );

                    if (pickedTime != null) {
                      deadline = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    }
                  }

                  setState(() {
                    selectedCategory = categoryKey;
                    taskService.addTask(
                      controller.text,
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
    final task = taskService.tasks[index];
    final controller = TextEditingController(text: task.title);
    DateTime? selectedDeadline = task.deadline;

    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(localizations.editTask),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: localizations.newTaskTitle,
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(0x40),
                      ),
                    ),
                  ),
                  autofocus: true,
                ),
                SizedBox(height: 16),
                ListTile(
                  title: Text(localizations.deadline),
                  subtitle: selectedDeadline != null
                      ? Text(
                          selectedDeadline!.toLocal().toString().split(' ')[0],
                        )
                      : Text('Не установлено'),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDeadline ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDeadline = picked;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(localizations.cancel),
              ),
              TextButton(
                onPressed: () {
                  if (controller.text.trim().isEmpty) return;
                  setState(() {
                    taskService.updateTask(
                      index,
                      controller.text.trim(),
                      task.category,
                      task.subcategory,
                      selectedDeadline,
                    );
                  });
                  Navigator.pop(context);
                },
                child: Text(localizations.save),
              ),
            ],
          ),
        );
      },
    );
  }

  double getProgress() {
    if (taskService.tasks.isEmpty) return 0;
    int completed = taskService.tasks.where((t) => t.isDone).length;
    return completed / taskService.tasks.length;
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
            child: ListView.builder(
              itemCount: taskService.tasks.length,
              itemBuilder: (context, index) {
                var task = taskService.tasks[index];

                return Dismissible(
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
                  child: TaskTile(
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
                          builder: (context) => SubcategoriesScreen(
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
