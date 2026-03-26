class Task {
  String title;
  bool isDone;
  bool xpGranted;
  String category;
  String? subcategory;
  DateTime? deadline;
  DateTime? teamDeadline;
  List<String> comments;
  int priority; // 1 = низкий, 2 = средний, 3 = высокий
  DateTime createdAt;
  DateTime? completedAt;
  String? assignedTo; // кому назначена задача (роль или имя)
  List<TaskChange> changesHistory;

  Task({
    required this.title,
    this.isDone = false,
    this.xpGranted = false,
    this.category = 'Общие',
    this.subcategory,
    this.deadline,
    this.teamDeadline,
    this.comments = const [],
    this.priority = 2,
    DateTime? createdAt,
    this.completedAt,
    this.assignedTo,
    this.changesHistory = const [],
  }) : createdAt = createdAt ?? DateTime.now();
}

class TaskChange {
  String field;
  String oldValue;
  String newValue;
  DateTime changedAt;
  String? changedBy;

  TaskChange({
    required this.field,
    required this.oldValue,
    required this.newValue,
    required this.changedAt,
    this.changedBy,
  });
}
