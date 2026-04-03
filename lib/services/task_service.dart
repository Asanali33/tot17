import '../models/task.dart';

class TaskService {
  List<Task> tasks = [];
  int experience = 0;
  int completedTotal = 0;
  final Set<String> achievements = {};

  final Map<String, List<String>> categories = {
    'work': ['projects', 'meetings', 'reports', 'other'],
    'personal': ['sport', 'reading', 'hobby', 'other'],
    'shopping': ['food', 'clothes', 'home', 'other'],
    'general': ['standard'],
  };

  void addTask(
    String title, {
    String category = 'Общие',
    String? subcategory,
    DateTime? deadline,
  }) {
    tasks.add(
      Task(
        title: title,
        category: category,
        subcategory: subcategory,
        deadline: deadline,
        comments: [],
      ),
    );
  }

  void toggleTask(int index) {
    final task = tasks[index];
    final nowDone = !task.isDone;
    task.isDone = nowDone;

    if (nowDone) {
      task.completedAt = DateTime.now();
      if (!task.xpGranted) {
        experience += 20;
        completedTotal += 1;
        task.xpGranted = true;
        _updateAchievements();
      }
    } else {
      task.completedAt = null;
      if (task.xpGranted) {
        experience = (experience - 20).clamp(0, experience);
        completedTotal = (completedTotal - 1).clamp(0, completedTotal);
        task.xpGranted = false;
        _updateAchievements();
      }
    }
  }

  void addComment(int index, String comment) {
    if (comment.trim().isEmpty) return;
    tasks[index].comments.add(comment.trim());
  }

  int get level => 1 + (experience ~/ 100);

  void _updateAchievements() {
    if (completedTotal >= 1) achievements.add('firstCompletion');
    if (completedTotal >= 5) achievements.add('master5Tasks');
    if (completedTotal >= 10) achievements.add('hero10Tasks');
    if (completedTotal >= 20) achievements.add('legend20Tasks');
    
    // Достижения за уровни
    if (level >= 2) achievements.add('level2');
    if (level >= 5) achievements.add('level5');
    if (level >= 10) achievements.add('level10');
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
  }

  void updateTask(
    int index,
    String title,
    String category,
    String? subcategory,
    DateTime? deadline,
  ) {
    tasks[index].title = title;
    tasks[index].category = category;
    tasks[index].subcategory = subcategory;
    tasks[index].deadline = deadline;
  }

  void updateTaskPriority(int index, int priority) {
    if (priority >= 1 && priority <= 3) {
      tasks[index].priority = priority;
    }
  }

  void updateTaskComments(int index, List<String> comments) {
    tasks[index].comments.clear();
    tasks[index].comments.addAll(comments.where((c) => c.trim().isNotEmpty));
  }

  void clearAllTasks() {
    tasks.clear();
  }

  /// Сортировка по приоритету (высокий -> низкий)
  List<Task> getSortedByPriority() {
    final sorted = List<Task>.from(tasks);
    sorted.sort((a, b) => b.priority.compareTo(a.priority));
    return sorted;
  }

  /// Сортировка по дате (ближайшие дедлайны первыми)
  List<Task> getSortedByDeadline() {
    final sorted = List<Task>.from(tasks);
    sorted.sort((a, b) {
      if (a.deadline == null && b.deadline == null) return 0;
      if (a.deadline == null) return 1;
      if (b.deadline == null) return -1;
      return a.deadline!.compareTo(b.deadline!);
    });
    return sorted;
  }

  /// Комбинированная сортировка: сначала по приоритету, потом по дате
  List<Task> getSortedByPriorityAndDeadline() {
    final sorted = List<Task>.from(tasks);
    sorted.sort((a, b) {
      if (a.priority != b.priority) {
        return b.priority.compareTo(a.priority);
      }
      if (a.deadline == null && b.deadline == null) return 0;
      if (a.deadline == null) return 1;
      if (b.deadline == null) return -1;
      return a.deadline!.compareTo(b.deadline!);
    });
    return sorted;
  }

  /// Фильтр незавершенных задач
  List<Task> getIncompleteTasksOnly() {
    return tasks.where((task) => !task.isDone).toList();
  }

  /// Получить отсортированные незавершенные задачи
  List<Task> getIncompleteTasksSortedByPriorityAndDeadline() {
    final incomplete = getIncompleteTasksOnly();
    incomplete.sort((a, b) {
      if (a.priority != b.priority) {
        return b.priority.compareTo(a.priority);
      }
      if (a.deadline == null && b.deadline == null) return 0;
      if (a.deadline == null) return 1;
      if (b.deadline == null) return -1;
      return a.deadline!.compareTo(b.deadline!);
    });
    return incomplete;
  }

  // === АНАЛИТИКА ПРОДУКТИВНОСТИ ===

  /// Получить данные о выполненных задачах по дням (последние 30 дней)
  Map<DateTime, int> getCompletedTasksByDay() {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    final completedTasks = tasks.where((task) =>
      task.isDone &&
      task.completedAt != null &&
      task.completedAt!.isAfter(thirtyDaysAgo)
    ).toList();

    final Map<DateTime, int> data = {};
    for (var task in completedTasks) {
      final day = DateTime(task.completedAt!.year, task.completedAt!.month, task.completedAt!.day);
      data[day] = (data[day] ?? 0) + 1;
    }
    return data;
  }

  /// Получить данные о прокрастинации
  Map<String, int> getProcrastinationReasons() {
    final reasons = <String, int>{};
    final incompleteTasks = tasks.where((task) => !task.isDone).toList();

    for (var task in incompleteTasks) {
      if (task.procrastinationReason != null && task.procrastinationReason!.isNotEmpty) {
        reasons[task.procrastinationReason!] = (reasons[task.procrastinationReason!] ?? 0) + 1;
      }
    }
    return reasons;
  }

  /// Получить среднее время выполнения задач
  Duration getAverageCompletionTime() {
    final completedTasks = tasks.where((task) =>
      task.isDone &&
      task.completedAt != null &&
      task.actualTime != null
    ).toList();

    if (completedTasks.isEmpty) return Duration.zero;

    final totalTime = completedTasks.fold<Duration>(
      Duration.zero,
      (sum, task) => sum + task.actualTime!
    );

    return Duration(seconds: totalTime.inSeconds ~/ completedTasks.length);
  }

  /// Получить прогноз загрузки на неделю
  Map<DateTime, int> getWeeklyWorkloadForecast() {
    final now = DateTime.now();
    final weekFromNow = now.add(const Duration(days: 7));

    final upcomingTasks = tasks.where((task) =>
      !task.isDone &&
      task.deadline != null &&
      task.deadline!.isBefore(weekFromNow) &&
      task.deadline!.isAfter(now)
    ).toList();

    final Map<DateTime, int> forecast = {};
    for (var task in upcomingTasks) {
      final day = DateTime(task.deadline!.year, task.deadline!.month, task.deadline!.day);
      forecast[day] = (forecast[day] ?? 0) + 1;
    }
    return forecast;
  }

  /// Получить статистику по категориям
  Map<String, Map<String, int>> getCategoryStats() {
    final stats = <String, Map<String, int>>{};

    for (var task in tasks) {
      stats[task.category] ??= {'total': 0, 'completed': 0};
      stats[task.category]!['total'] = stats[task.category]!['total']! + 1;
      if (task.isDone) {
        stats[task.category]!['completed'] = stats[task.category]!['completed']! + 1;
      }
    }
    return stats;
  }

  /// Установить причину прокрастинации для задачи
  void setProcrastinationReason(int index, String reason) {
    if (index >= 0 && index < tasks.length) {
      tasks[index].procrastinationReason = reason;
    }
  }

  /// Установить предполагаемое время выполнения
  void setEstimatedTime(int index, Duration time) {
    if (index >= 0 && index < tasks.length) {
      tasks[index].estimatedTime = time;
    }
  }

  /// Установить фактическое время выполнения
  void setActualTime(int index, Duration time) {
    if (index >= 0 && index < tasks.length) {
      tasks[index].actualTime = time;
    }
  }
}
