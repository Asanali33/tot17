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
  }) : createdAt = createdAt ?? DateTime.now();
}
