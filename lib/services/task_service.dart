import '../models/task.dart';
import '../models/team_member.dart';
import '../models/role.dart';
import '../models/productivity_stats.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TaskService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080';
    }
    return 'http://10.0.2.2:8080';
  }
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
    Duration? estimatedDuration,
  }) async {
    final task = Task(
      title: title,
      category: category,
      subcategory: subcategory,
      deadline: deadline,
      teamDeadline: teamDeadline,
      assignedTo: assignedTo,
      assignedRole: assignedRole,
      comments: [],
      estimatedDuration: estimatedDuration,
    );
    
    // Save to server first
    await saveTask(task);
    
    // Update local stats
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (!productivityStats.dailyStats.containsKey(today)) {
      productivityStats.dailyStats[today] = DailyStats(
        date: today,
        tasksCompleted: 0,
        totalTasks: 0,
      );
    }
    productivityStats.dailyStats[today]?.totalTasks += 1;
    
    // Initialize change history
    if (task.id != null) {
      changeHistory['task_${task.id}'] = [];
      _recordChangeById(task.id!, 'Создание', '', title);
    }
  }

  void toggleTask(int index) async {
    final task = tasks[index];
    final nowDone = !task.isDone;
    task.isDone = nowDone;
    task.status = nowDone ? TaskStatus.done : TaskStatus.todo;
    
    // Update on server
    await updateTaskOnServer(task);
    
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
        
        final List<DateTime> completionTimes = productivityStats.dailyStats[today]?.completionTimes ?? <DateTime>[];
        productivityStats.dailyStats[today]!.completionTimes = [...completionTimes, DateTime.now()];
        
        if (task.id != null) {
          _recordChangeById(task.id!, 'Статус', task.status.displayName, TaskStatus.done.displayName);
        }
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
        
        if (task.id != null) {
          _recordChangeById(task.id!, 'Статус', TaskStatus.done.displayName, TaskStatus.todo.displayName);
        }
        _updateAchievements();
      }
    }
  }

  void addComment(int index, String comment) async {
    if (comment.trim().isEmpty) return;
    final newComment = Comment(
      text: comment.trim(),
      author: currentUserName,
    );
    tasks[index].comments.add(newComment);
    
    // Update on server
    await updateTaskOnServer(tasks[index]);
  }

  int get level => 1 + (experience ~/ 100);

  void _updateAchievements() {
    if (completedTotal >= 1) achievements.add('Первое выполнение');
    if (completedTotal >= 5) achievements.add('Мастер 5 задач');
    if (completedTotal >= 10) achievements.add('Герой 10 задач');
    if (completedTotal >= 20) achievements.add('Легенда 20 задач');
  }

  void deleteTask(int index) async {
    if (index < 0 || index >= tasks.length) return;
    final task = tasks[index];
    if (task.id != null) {
      await deleteTaskFromServer(task.id!);
    }
    tasks.removeAt(index);
  }

  void updateTask(
    int index,
    String title,
    String category,
    String? subcategory,
    DateTime? deadline,
    {DateTime? teamDeadline, String? assignedTo, String? assignedRole}
  ) async {
    final task = tasks[index];
    if (task.id != null) {
      _recordChangeById(task.id!, 'Название', task.title, title);
      _recordChangeById(task.id!, 'Категория', task.category, category);
      if (task.subcategory != subcategory) {
        _recordChangeById(task.id!, 'Подкатегория', task.subcategory ?? '', subcategory ?? '');
      }
      if (task.deadline != deadline) {
        _recordChangeById(task.id!, 'Дедлайн', task.deadline?.toString() ?? '', deadline?.toString() ?? '');
      }
      if (task.teamDeadline != teamDeadline) {
        _recordChangeById(task.id!, 'Командный дедлайн', task.teamDeadline?.toString() ?? '', teamDeadline?.toString() ?? '');
      }
      if (task.assignedTo != assignedTo) {
        _recordChangeById(task.id!, 'Назначено', task.assignedTo ?? '', assignedTo ?? '');
      }
      if (task.assignedRole != assignedRole) {
        _recordChangeById(task.id!, 'Роль исполнителя', task.assignedRole ?? '', assignedRole ?? '');
      }
    }
    
    task.title = title;
    task.category = category;
    task.subcategory = subcategory;
    task.deadline = deadline;
    task.teamDeadline = teamDeadline;
    task.assignedTo = assignedTo;
    task.assignedRole = assignedRole;
    
    // Update on server
    await updateTaskOnServer(task);
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
      orElse: () => TeamMember(id: memberId, name: memberId, role: Role.developer),
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

  List<Comment> getTaskComments(int taskIndex) {
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

  void _recordChangeById(String taskId, String field, String oldValue, String newValue) {
    final key = 'task_$taskId';
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

  Map<DateTime, int> getCompletedTasksByDay() {
    return productivityStats.dailyStats.map((date, stats) => MapEntry(date, stats.tasksCompleted));
  }

  Map<String, int> getProcrastinationReasons() {
    return {};
  }

  Duration getAverageCompletionTime() {
    final allCompletionTimes = productivityStats.dailyStats.values
        .expand((stats) => stats.completionTimes)
        .toList();
    if (allCompletionTimes.isEmpty) {
      return Duration.zero;
    }

    final totalSeconds = allCompletionTimes
        .map((time) => time.hour * 3600 + time.minute * 60 + time.second)
        .fold<int>(0, (sum, seconds) => sum + seconds);
    final averageSeconds = totalSeconds ~/ allCompletionTimes.length;
    return Duration(seconds: averageSeconds);
  }

  Map<DateTime, int> getWeeklyWorkloadForecast() {
    final now = DateTime.now();
    final forecast = <DateTime, int>{};

    for (var i = 0; i < 7; i++) {
      final day = DateTime(now.year, now.month, now.day).add(Duration(days: i));
      forecast[day] = tasks.where((task) {
        if (task.deadline == null || task.isDone) return false;
        return task.deadline!.year == day.year &&
            task.deadline!.month == day.month &&
            task.deadline!.day == day.day;
      }).length;
    }

    return forecast;
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

  // ===================== МЕТОДЫ ДЛЯ РАБОТЫ С ТАЙМЕРОМ =====================

  /// Установить время выполнения для задачи
  void setTaskDuration(int index, Duration duration) {
    if (index < 0 || index >= tasks.length) return;
    tasks[index].estimatedDuration = duration;
    _recordChange(index, 'Время выполнения', '', _formatDuration(duration));
  }

  /// Запустить таймер для задачи
  void startTimer(int index) {
    if (index < 0 || index >= tasks.length) return;
    final task = tasks[index];
    if (task.estimatedDuration == null || task.estimatedDuration!.inSeconds <= 0) return;
    
    task.isTimerActive = true;
    task.timerStartedAt = DateTime.now();
  }

  /// Остановить таймер для задачи
  void stopTimer(int index) {
    if (index < 0 || index >= tasks.length) return;
    final task = tasks[index];
    task.isTimerActive = false;
    task.timerStartedAt = null;
  }

  /// Получить оставшееся время для задачи
  Duration? getRemainingTime(int index) {
    if (index < 0 || index >= tasks.length) return null;
    final task = tasks[index];
    
    if (task.estimatedDuration == null || task.timerStartedAt == null) {
      return task.estimatedDuration;
    }

    final elapsed = DateTime.now().difference(task.timerStartedAt!);
    final remaining = task.estimatedDuration!.inSeconds - elapsed.inSeconds;

    if (remaining <= 0) {
      task.isTimerActive = false;
      return Duration.zero;
    }

    return Duration(seconds: remaining);
  }

  /// Получить прогресс таймера (0-1)
  double getTimerProgress(int index) {
    if (index < 0 || index >= tasks.length) return 0;
    final task = tasks[index];
    
    if (task.estimatedDuration == null || task.estimatedDuration!.inSeconds <= 0) {
      return 0;
    }

    if (task.timerStartedAt == null) {
      return 0;
    }

    final elapsed = DateTime.now().difference(task.timerStartedAt!);
    final progress = elapsed.inSeconds / task.estimatedDuration!.inSeconds;

    return progress.clamp(0.0, 1.0);
  }

  /// Форматировать Duration в строку (HH:MM:SS)
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Получить отформатированное время выполнения
  String getFormattedDuration(int index) {
    if (index < 0 || index >= tasks.length) return 'Не установлено';
    final task = tasks[index];
    
    if (task.estimatedDuration == null) {
      return 'Не установлено';
    }

    return _formatDuration(task.estimatedDuration!);
  }

  /// Получить отформатированное оставшееся время
  String getFormattedRemainingTime(int index) {
    final remaining = getRemainingTime(index);
    if (remaining == null) return 'Не установлено';
    return _formatDuration(remaining);
  }

  /// Проверить, истекло ли время
  bool isTimeExpired(int index) {
    if (index < 0 || index >= tasks.length) return false;
    final task = tasks[index];
    
    if (task.estimatedDuration == null || task.timerStartedAt == null) {
      return false;
    }

    final elapsed = DateTime.now().difference(task.timerStartedAt!);
    return elapsed.inSeconds >= task.estimatedDuration!.inSeconds;
  }

  /// Сбросить таймер
  void resetTimer(int index) {
    if (index < 0 || index >= tasks.length) return;
    final task = tasks[index];
    task.isTimerActive = false;
    task.timerStartedAt = null;
  }

  // ===================== BACKEND METHODS =====================

  int _getTaskIndexById(String id) {
    return tasks.indexWhere((task) => task.id == id);
  }

  Future<void> loadTasks() async {
    try {
      print('🔵 Loading tasks from: $baseUrl/tasks');
      final response = await http.get(Uri.parse('$baseUrl/tasks')).timeout(
        Duration(seconds: 5),
        onTimeout: () {
          print('❌ Timeout connecting to backend');
          throw Exception('Connection timeout');
        },
      );
      print('📡 Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('✅ Tasks loaded successfully');
        final List<dynamic> jsonList = jsonDecode(response.body);
        print('📊 Loaded ${jsonList.length} tasks');
        tasks = jsonList.map((json) => Task.fromJson(json)).toList();
      } else {
        print('❌ Failed to load tasks: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('❌ Error loading tasks: $e');
      print('Stack trace: $e');
    }
  }

  Future<void> saveTask(Task task) async {
    try {
      print('🔵 Saving task to: $baseUrl/tasks');
      final json = task.toJson();
      print('📤 Request body: ${jsonEncode(json)}');
      final response = await http.post(
        Uri.parse('$baseUrl/tasks'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(json),
      ).timeout(
        Duration(seconds: 5),
        onTimeout: () {
          print('❌ Timeout saving task');
          throw Exception('Connection timeout');
        },
      );
      print('📡 Response status: ${response.statusCode}');
      if (response.statusCode == 201) {
        print('✅ Task saved successfully');
        final createdJson = jsonDecode(response.body);
        task.id = createdJson['_id']?.toString();
        tasks.add(task);
        print('✅ Task ID: ${task.id}');
      } else {
        print('❌ Failed to save task: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('❌ Error saving task: $e');
      print('Stack trace: $e');
    }
  }

  Future<void> updateTaskOnServer(Task task) async {
    if (task.id == null) return;
    try {
      print('🔵 Updating task: $baseUrl/tasks/${task.id}');
      final json = task.toJson();
      final response = await http.put(
        Uri.parse('$baseUrl/tasks/${task.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(json),
      ).timeout(
        Duration(seconds: 5),
        onTimeout: () {
          print('❌ Timeout updating task');
          throw Exception('Connection timeout');
        },
      );
      print('📡 Response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        print('❌ Failed to update task: ${response.statusCode}');
        print('Response body: ${response.body}');
      } else {
        print('✅ Task updated successfully');
      }
    } catch (e) {
      print('❌ Error updating task: $e');
    }
  }

  Future<void> deleteTaskFromServer(String taskId) async {
    try {
      print('🔵 Deleting task: $baseUrl/tasks/$taskId');
      final response = await http.delete(Uri.parse('$baseUrl/tasks/$taskId')).timeout(
        Duration(seconds: 5),
        onTimeout: () {
          print('❌ Timeout deleting task');
          throw Exception('Connection timeout');
        },
      );
      print('📡 Response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        print('❌ Failed to delete task: ${response.statusCode}');
        print('Response body: ${response.body}');
      } else {
        print('✅ Task deleted successfully');
      }
    } catch (e) {
      print('❌ Error deleting task: $e');
    }
  }
}

