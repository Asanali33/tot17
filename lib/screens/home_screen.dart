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
  String sortByOption = 'byPriority';

  @override
  void initState() {
    super.initState();
    taskService = widget.taskService;
    taskService.loadTasks().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
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
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.addComment),
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
          decoration: InputDecoration(hintText: localizations.enterCommentText),
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
                taskService.addComment(
                  index,
                  controller.text.trim(),
                );
              });
              Navigator.pop(context);
            },
            child: Text(localizations.save),
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
      context: context,
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

                  setState(() {
                    selectedCategory = categoryKey;
                    taskService.addTask(
                      controller.text.trim(),
                      category: categoryKey,
                    );
                    controller.clear();
                  });

                  // Открываем полноценный редактор задачи
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    editTaskTitle(taskService.tasks.length - 1);
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
    final titleController = TextEditingController(text: task.title);
    final commentController = TextEditingController();
    
    DateTime? selectedDeadline = task.deadline;
    DateTime? selectedTeamDeadline = task.teamDeadline;
    int selectedPriority = task.priority;
    String? selectedAssignee = task.assignedTo;
    String selectedCategory = task.category;
    String? selectedSubcategory = task.subcategory;
    
    int timerHours = task.estimatedDuration?.inHours ?? 0;
    int timerMinutes = (task.estimatedDuration?.inMinutes ?? 0) % 60;
    int timerSeconds = (task.estimatedDuration?.inSeconds ?? 0) % 60;

    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
                SizedBox(width: 12),
                Text(localizations.editTask),
              ],
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ========== Основная информация ==========
                    _buildSectionHeader(context, 'ℹ️ Основная информация'),
                    
                    // Название задачи
                    TextField(
                      controller: titleController,
                      style: Theme.of(context).textTheme.bodyLarge,
                      decoration: InputDecoration(
                        labelText: localizations.newTaskTitle,
                        prefixIcon: Icon(Icons.task),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      autofocus: true,
                    ),
                    SizedBox(height: 12),
                    
                    // Категория
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        labelText: localizations.general,
                        prefixIcon: Icon(Icons.category),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: taskService.categories.keys.map((categoryKey) {
                        return DropdownMenuItem(
                          value: categoryKey,
                          child: Text(getLocalizedCategory(categoryKey)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedCategory = value;
                            selectedSubcategory = null;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 12),
                    
                    // Подкатегория
                    if (taskService.categories[selectedCategory]?.isNotEmpty ?? false)
                      DropdownButtonFormField<String>(
                        value: selectedSubcategory,
                        decoration: InputDecoration(
                          labelText: 'Подкатегория',
                          prefixIcon: Icon(Icons.label),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(localizations.notSetLabel),
                          ),
                          ...taskService.categories[selectedCategory]?.map((subcat) {
                            return DropdownMenuItem(
                              value: subcat,
                              child: Text(getLocalizedSubcategory(subcat)),
                            );
                          }).toList() ?? [],
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedSubcategory = value;
                          });
                        },
                      ),
                    
                    SizedBox(height: 20),
                    
                    // ========== Сроки ==========
                    _buildSectionHeader(context, '📅 Сроки'),
                    
                    // Дедлайн
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: Text(localizations.deadline),
                        subtitle: Text(
                          selectedDeadline != null
                              ? selectedDeadline!.toLocal().toString().split(' ')[0]
                              : localizations.notSetLabel,
                        ),
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
                    ),
                    SizedBox(height: 12),
                    
                    // Командный дедлайн
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.people),
                        title: Text(localizations.teamDeadline),
                        subtitle: Text(
                          selectedTeamDeadline != null
                              ? selectedTeamDeadline!.toLocal().toString().split(' ')[0]
                              : localizations.notSetLabel,
                        ),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedTeamDeadline ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedTeamDeadline = picked;
                            });
                          }
                        },
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // ========== Приоритет и время ==========
                    _buildSectionHeader(context, '⚡ Приоритет и время'),
                    
                    // Приоритет
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.priorityLabel,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildPriorityButton(
                              context,
                              localizations.lowPriority,
                              1,
                              selectedPriority,
                              Colors.blue,
                              (val) => setState(() => selectedPriority = val),
                            ),
                            _buildPriorityButton(
                              context,
                              localizations.mediumPriority,
                              2,
                              selectedPriority,
                              Colors.orange,
                              (val) => setState(() => selectedPriority = val),
                            ),
                            _buildPriorityButton(
                              context,
                              localizations.highPriority,
                              3,
                              selectedPriority,
                              Colors.red,
                              (val) => setState(() => selectedPriority = val),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    // Время выполнения
                    Text(
                      localizations.taskDurationTitle,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _buildTimeField(
                            localizations.hours,
                            timerHours.toString(),
                            (value) {
                              setState(() {
                                timerHours = int.tryParse(value) ?? 0;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildTimeField(
                            localizations.minutes,
                            timerMinutes.toString(),
                            (value) {
                              setState(() {
                                timerMinutes = int.tryParse(value) ?? 0;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildTimeField(
                            localizations.seconds,
                            timerSeconds.toString(),
                            (value) {
                              setState(() {
                                timerSeconds = int.tryParse(value) ?? 0;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 20),
                    
                    // ========== Команда ==========
                    if (taskService.teamMembers.isNotEmpty) ...[
                      _buildSectionHeader(context, '👥 Команда'),
                      DropdownButtonFormField<String>(
                        value: selectedAssignee,
                        decoration: InputDecoration(
                          labelText: localizations.assign,
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(localizations.unassigned),
                          ),
                          ...taskService.teamMembers.map((member) {
                            return DropdownMenuItem(
                              value: member.name,
                              child: Text(member.name),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedAssignee = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                    
                    // ========== Комментарии ==========
                    _buildSectionHeader(context, '💬 Комментарии'),
                    
                    if (task.comments.isNotEmpty) ...[
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: task.comments.map((comment) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.person_outline, size: 16),
                                      SizedBox(width: 6),
                                      Text(
                                        comment.author ?? 'Anonymous',
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      comment.text,
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 12),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            minLines: 1,
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: localizations.enterCommentText,
                              prefixIcon: Icon(Icons.comment),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            onPressed: () {
                              if (commentController.text.trim().isNotEmpty) {
                                taskService.addComment(index, commentController.text.trim());
                                commentController.clear();
                                setState(() {});
                              }
                            },
                            icon: Icon(Icons.send),
                            tooltip: 'Добавить комментарий',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(localizations.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.trim().isEmpty) return;
                  
                  taskService.updateTask(
                    index,
                    titleController.text.trim(),
                    selectedCategory,
                    selectedSubcategory,
                    selectedDeadline,
                    teamDeadline: selectedTeamDeadline,
                    assignedTo: selectedAssignee,
                  );
                  
                  taskService.updateTaskPriority(index, selectedPriority);
                  
                  if (timerHours > 0 || timerMinutes > 0 || timerSeconds > 0) {
                    final duration = Duration(
                      hours: timerHours,
                      minutes: timerMinutes,
                      seconds: timerSeconds,
                    );
                    taskService.setTaskDuration(index, duration);
                  }
                  
                  setState(() {});
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildTimeField(
    String label,
    String value,
    Function(String) onChanged,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          controller: TextEditingController(text: value),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityButton(
    BuildContext context,
    String label,
    int priority,
    int selectedPriority,
    Color color,
    Function(int) onTap,
  ) {
    final isSelected = selectedPriority == priority;
    return GestureDetector(
      onTap: () => onTap(priority),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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

    if (sortByOption == 'byPriority') {
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
      appBar: AppBar(title: Text(localizations.appTitle), centerTitle: true),
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
                    hintText: localizations.searchTasks,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                                  localizations.onlyActive,
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
                            sortByOption = value ?? 'byPriority';
                          });
                        },
                        dropdownMenuEntries: [
                          DropdownMenuEntry(
                            value: 'byPriority',
                            label: localizations.byPriority,
                          ),
                          DropdownMenuEntry(
                            value: 'date',
                            label: localizations.date,
                          ),
                          DropdownMenuEntry(
                            value: 'noSorting',
                            label: localizations.noSorting,
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
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
                        Icon(Icons.check_circle_outline,
                            size: 64, color: colorScheme.outlineVariant),
                        SizedBox(height: 16),
                        Text(localizations.noTasks,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.outlineVariant,
                            )),
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
                                  onAddComment: () =>
                                      addCommentToTask(index),
                                  onEditCategory: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditTaskScreen(
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
