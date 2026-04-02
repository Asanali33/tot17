class Task {
  String title;
  bool isDone;
  bool xpGranted;
  String category;
  String? subcategory;
  DateTime? deadline;
  DateTime? teamDeadline;
  List<Comment> comments;
  int priority; // 1 = низкий, 2 = средний, 3 = высокий
  DateTime createdAt;
  DateTime? completedAt;
  String? assignedTo; // кому назначена задача (роль или имя)
  List<TaskChange> changesHistory;
  TaskStatus status; // новый статус задачи
  String? assignedRole; // роль, ответственная за задачу

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
    this.status = TaskStatus.todo,
    this.assignedRole,
  }) : createdAt = createdAt ?? DateTime.now();
}

enum TaskStatus {
  todo('К выполнению'),
  inProgress('В работе'),
  review('На проверке'),
  done('Выполнено');

  const TaskStatus(this.displayName);
  final String displayName;
}

class Comment {
  String text;
  String? author;
  DateTime createdAt;
  bool isEdited;

  Comment({
    required this.text,
    this.author,
    DateTime? createdAt,
    this.isEdited = false,
  }) : createdAt = createdAt ?? DateTime.now();

  Comment copyWith({
    String? text,
    String? author,
    DateTime? createdAt,
    bool? isEdited,
  }) {
    return Comment(
      text: text ?? this.text,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      isEdited: isEdited ?? this.isEdited,
    );
  }
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
