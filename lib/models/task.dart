class Task {
  String title;
  bool isDone;
  bool xpGranted;
  String category;
  String? subcategory;
  DateTime? deadline;
  List<String> comments;
  int priority; // 1 = низкий, 2 = средний, 3 = высокий
  DateTime createdAt;
  DateTime? completedAt; // время завершения
  String? procrastinationReason; // причина прокрастинации
  Duration? estimatedTime; // предполагаемое время выполнения
  Duration? actualTime; // фактическое время выполнения

  Task({
    required this.title,
    this.isDone = false,
    this.xpGranted = false,
    this.category = 'Общие',
    this.subcategory,
    this.deadline,
    this.comments = const [],
    this.priority = 2,
    DateTime? createdAt,
    this.completedAt,
    this.procrastinationReason,
    this.estimatedTime,
    this.actualTime,
  }) : createdAt = createdAt ?? DateTime.now();
}
