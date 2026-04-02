import '../models/task.dart';
import '../models/team_member.dart';
import '../models/role.dart';
import '../models/productivity_stats.dart';

class TaskService {
  List<Task> tasks = [];
  int experience = 0;
  int completedTotal = 0;
  final Set<String> achievements = {};

  // Коллаборация
  List<TeamMember> teamMembers = [];
  String? currentUserId;
  String? currentUserName;

  // Аналитика
  late ProductivityStats productivityStats;
  Map<String, List<TaskChange>> changeHistory = {};

  final Map<String, List<String>> categories = {
    'work': ['projects', 'meetings', 'reports', 'other'],
    'personal': ['sport', 'reading', 'hobby', 'other'],
    'shopping': ['food', 'clothes', 'home', 'other'],
    'general': ['standard'],
  };

  TaskService() {
    productivityStats = ProductivityStats();
    _initializeProductivityStats();
  }

  void _initializeProductivityStats() {
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    productivityStats.dailyStats[today] = DailyStats(
      date: today,
      tasksCompleted: 0,
      totalTasks: 0,
    );
  }

  void addTask(
    String title, {
    String category = 'Общие',
    String? subcategory,
    DateTime? deadline,
    DateTime? teamDeadline,
    String? assignedTo,
    String? assignedRole,
  }) {
    final task = Task(
      title: title,
      category: category,
      subcategory: subcategory,
      deadline: deadline,
      teamDeadline: teamDeadline,
      assignedTo: assignedTo,
      assignedRole: assignedRole,
      comments: [],
    );
    tasks.add(task);
    
    // Обновляем статистику
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (!productivityStats.dailyStats.containsKey(today)) {
      productivityStats.dailyStats[today] = DailyStats(
        date: today,
        tasksCompleted: 0,
        totalTasks: 0,
      );
    }
    productivityStats.dailyStats[today]?.totalTasks += 1;
    
    // Инициализируем историю изменений
    changeHistory['task_${tasks.length - 1}'] = [];
    _recordChange(tasks.length - 1, 'Создание', '', title);
  }

  void toggleTask(int index) {
    final task = tasks[index];
    final nowDone = !task.isDone;
    task.isDone = nowDone;
    task.status = nowDone ? TaskStatus.done : TaskStatus.todo;
    
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (!productivityStats.dailyStats.containsKey(today)) {
      productivityStats.dailyStats[today] = DailyStats(
        date: today,
        tasksCompleted: 0,
        totalTasks: 0,
      );
    }

    if (nowDone) {
      if (!task.xpGranted) {
        experience += 20;
        completedTotal += 1;
        task.xpGranted = true;
        task.completedAt = DateTime.now();
        
        // Отслеживание аналитики
        productivityStats.dailyStats[today]?.tasksCompleted += 1;
        
        final hour = DateTime.now().hour;
        productivityStats.completionByHour[hour] = 
            (productivityStats.completionByHour[hour] ?? 0) + 1;
        
        productivityStats.completionByCategory[task.category] = 
            (productivityStats.completionByCategory[task.category] ?? 0) + 1;
        
        // Отслеживание пропущенных дедлайнов
        if (task.teamDeadline != null && DateTime.now().isAfter(task.teamDeadline!)) {
          productivityStats.missedDeadlines.add(index);
        }
        
        final completionTimes = productivityStats.dailyStats[today]?.completionTimes ?? [];
        productivityStats.dailyStats[today]?.completionTimes = [...completionTimes, DateTime.now()];
        
        _recordChange(index, 'Статус', task.status.displayName, TaskStatus.done.displayName);
        _updateAchievements();
      }
    } else {
      if (task.xpGranted) {
        experience = (experience - 20).clamp(0, experience);
        completedTotal = (completedTotal - 1).clamp(0, completedTotal);
        task.xpGranted = false;
        task.completedAt = null;
        
        // Обновляем статистику
        productivityStats.dailyStats[today]?.tasksCompleted = 
            (productivityStats.dailyStats[today]?.tasksCompleted ?? 0) - 1;
        
        _recordChange(index, 'Статус', TaskStatus.done.displayName, TaskStatus.todo.displayName);
        _updateAchievements();
      }
    }
  }

  void addComment(int index, String comment) {
    if (comment.trim().isEmpty) return;
    final newComment = Comment(
      text: comment.trim(),
      author: currentUserName,
    );
    tasks[index].comments.add(newComment);
  }

  int get level => 1 + (experience ~/ 100);

  void _updateAchievements() {
    if (completedTotal >= 1) achievements.add('Первое выполнение');
    if (completedTotal >= 5) achievements.add('Мастер 5 задач');
    if (completedTotal >= 10) achievements.add('Герой 10 задач');
    if (completedTotal >= 20) achievements.add('Легенда 20 задач');
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
    {DateTime? teamDeadline, String? assignedTo, String? assignedRole}
  ) {
    final task = tasks[index];
    _recordChange(index, 'Название', task.title, title);
    _recordChange(index, 'Категория', task.category, category);
    if (task.subcategory != subcategory) {
      _recordChange(index, 'Подкатегория', task.subcategory ?? '', subcategory ?? '');
    }
    if (task.deadline != deadline) {
      _recordChange(index, 'Дедлайн', task.deadline?.toString() ?? '', deadline?.toString() ?? '');
    }
    if (task.teamDeadline != teamDeadline) {
      _recordChange(index, 'Командный дедлайн', task.teamDeadline?.toString() ?? '', teamDeadline?.toString() ?? '');
    }
    if (task.assignedTo != assignedTo) {
      _recordChange(index, 'Назначено', task.assignedTo ?? '', assignedTo ?? '');
    }
    if (task.assignedRole != assignedRole) {
      _recordChange(index, 'Роль исполнителя', task.assignedRole ?? '', assignedRole ?? '');
    }
    
    task.title = title;
    task.category = category;
    task.subcategory = subcategory;
    task.deadline = deadline;
    task.teamDeadline = teamDeadline;
    task.assignedTo = assignedTo;
    task.assignedRole = assignedRole;
  }

  void updateTaskPriority(int index, int priority) {
    if (priority >= 1 && priority <= 3) {
      tasks[index].priority = priority;
    }
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

  // ===================== КОЛЛАБОРАЦИЯ =====================

  void addTeamMember(TeamMember member) {
    if (!teamMembers.any((m) => m.id == member.id)) {
      teamMembers.add(member);
    }
  }

  void removeTeamMember(String memberId) {
    teamMembers.removeWhere((m) => m.id == memberId);
  }

  void setCurrentUser(String userId, String userName) {
    currentUserId = userId;
    currentUserName = userName;
  }

  void assignTaskToMember(int taskIndex, String memberId) {
    if (taskIndex < 0 || taskIndex >= tasks.length) return;
    final member = teamMembers.firstWhere(
      (m) => m.id == memberId,
      orElse: () => TeamMember(id: memberId, name: memberId, role: 'unknown'),
    );
    _recordChange(taskIndex, 'Исполнитель', tasks[taskIndex].assignedTo ?? 'Не назначено', member.name);
    tasks[taskIndex].assignedTo = member.name;
  }

  void updateTaskStatus(int taskIndex, TaskStatus newStatus) {
    if (taskIndex < 0 || taskIndex >= tasks.length) return;
    final oldStatus = tasks[taskIndex].status;
    tasks[taskIndex].status = newStatus;
    tasks[taskIndex].isDone = newStatus == TaskStatus.done;
    _recordChange(taskIndex, 'Статус', oldStatus.displayName, newStatus.displayName);
  }

  void assignTaskToRole(int taskIndex, String roleName) {
    if (taskIndex < 0 || taskIndex >= tasks.length) return;
    final oldRole = tasks[taskIndex].assignedRole;
    tasks[taskIndex].assignedRole = roleName;
    _recordChange(taskIndex, 'Роль исполнителя', oldRole ?? 'Не назначена', roleName);
  }

  List<Task> getTasksByRole(String roleName) {
    return tasks.where((task) => task.assignedRole == roleName).toList();
  }

  List<Task> getTasksByStatus(TaskStatus status) {
    return tasks.where((task) => task.status == status).toList();
  }

  Map<TaskStatus, int> getTaskStatusCounts() {
    final counts = <TaskStatus, int>{};
    for (final status in TaskStatus.values) {
      counts[status] = tasks.where((task) => task.status == status).length;
    }
    return counts;
  }

  List<String> getAvailableRoles() {
    return teamMembers.map((member) => member.role.name).toSet().toList();
  }

  // Уведомления о дедлайнах
  List<Task> getUpcomingDeadlines({int daysAhead = 3}) {
    final now = DateTime.now();
    final futureDate = now.add(Duration(days: daysAhead));
    return tasks.where((task) {
      if (task.teamDeadline == null || task.isDone) return false;
      return task.teamDeadline!.isAfter(now) && task.teamDeadline!.isBefore(futureDate);
    }).toList();
  }

  List<Task> getOverdueTasks() {
    final now = DateTime.now();
    return tasks.where((task) {
      if (task.teamDeadline == null || task.isDone) return false;
      return task.teamDeadline!.isBefore(now);
    }).toList();
  }

  List<String> getTaskComments(int taskIndex) {
    if (taskIndex < 0 || taskIndex >= tasks.length) return [];
    return tasks[taskIndex].comments;
  }

  List<TaskChange> getTaskChangeHistory(int taskIndex) {
    final key = 'task_$taskIndex';
    return changeHistory[key] ?? [];
  }

  void _recordChange(int taskIndex, String field, String oldValue, String newValue) {
    final key = 'task_$taskIndex';
    if (!changeHistory.containsKey(key)) {
      changeHistory[key] = [];
    }
    
    final change = TaskChange(
      field: field,
      oldValue: oldValue,
      newValue: newValue,
      changedAt: DateTime.now(),
      changedBy: currentUserName,
    );
    
    changeHistory[key]?.add(change);
  }

  // ===================== АНАЛИТИКА ПРОДУКТИВНОСТИ =====================

  Map<String, dynamic> getProductivityOverview() {
    return {
      'totalTasksCreated': productivityStats.totalTasksCreated,
      'totalTasksCompleted': productivityStats.totalTasksCompleted,
      'averageCompletionRate': productivityStats.averageCompletionRate.toStringAsFixed(1),
      'mostProductiveDay': productivityStats.mostProductiveDay,
      'mostProductiveHour': productivityStats.mostProductiveHour,
      'missedDeadlines': productivityStats.missedDeadlines.length,
    };
  }

  DateTime? getMostProductiveDay() {
    if (productivityStats.dailyStats.isEmpty) return null;
    return productivityStats.mostProductiveDay;
  }

  int getMostProductiveHour() {
    return productivityStats.mostProductiveHour;
  }

  Map<String, int> getCompletionByCategory() {
    return productivityStats.completionByCategory;
  }

  Map<DateTime, DailyStats> getDailyStats() {
    return productivityStats.dailyStats;
  }

  List<int> getMissedDeadlines() {
    return productivityStats.missedDeadlines;
  }

  double getAverageCompletionRate() {
    return productivityStats.averageCompletionRate;
  }

  List<Task> getTasksDueToday() {
    final today = DateTime.now();
    return tasks.where((task) {
      if (task.teamDeadline == null) return false;
      return task.teamDeadline!.year == today.year &&
          task.teamDeadline!.month == today.month &&
          task.teamDeadline!.day == today.day;
    }).toList();
  }

  List<Task> getOverdueTasks() {
    final now = DateTime.now();
    return tasks.where((task) {
      if (task.teamDeadline == null || task.isDone) return false;
      return task.teamDeadline!.isBefore(now);
    }).toList();
  }

  List<Task> getTasksByAssignee(String assigneeName) {
    return tasks.where((task) => task.assignedTo == assigneeName).toList();
  }

  Map<String, List<Task>> getTasksByTeam() {
    final result = <String, List<Task>>{};
    for (final task in tasks) {
      final assignee = task.assignedTo ?? 'Не назначено';
      result.putIfAbsent(assignee, () => []);
      result[assignee]?.add(task);
    }
    return result;
  }

  int getCompletionCountForDate(DateTime date) {
    final stats = productivityStats.dailyStats[date];
    return stats?.tasksCompleted ?? 0;
  }

  double getCompletionRateForDate(DateTime date) {
    final stats = productivityStats.dailyStats[date];
    return stats?.completionRate ?? 0;
  }
}

