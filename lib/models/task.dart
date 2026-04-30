class Task {
  String? id;
  String? userId;
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
  Duration? estimatedDuration; // время выполнения задачи
  DateTime? timerStartedAt; // время начала таймера
  bool isTimerActive; // активен ли таймер

  Task({
    this.id,
    this.userId,
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
    this.estimatedDuration,
    this.timerStartedAt,
    this.isTimerActive = false,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'userId': userId,
      'title': title,
      'isDone': isDone,
      'xpGranted': xpGranted,
      'category': category,
      'subcategory': subcategory,
      'deadline': deadline?.toIso8601String(),
      'teamDeadline': teamDeadline?.toIso8601String(),
      'comments': comments.map((c) => c.toJson()).toList(),
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'assignedTo': assignedTo,
      'changesHistory': changesHistory.map((c) => c.toJson()).toList(),
      'status': status.name,
      'assignedRole': assignedRole,
      'estimatedDuration': estimatedDuration?.inMinutes,
      'timerStartedAt': timerStartedAt?.toIso8601String(),
      'isTimerActive': isTimerActive,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id']?.toString(),
      userId: json['userId']?.toString(),
      title: json['title'],
      isDone: json['isDone'] ?? false,
      xpGranted: json['xpGranted'] ?? false,
      category: json['category'] ?? 'general',
      subcategory: json['subcategory'],
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      teamDeadline: json['teamDeadline'] != null ? DateTime.parse(json['teamDeadline']) : null,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((c) => Comment.fromJson(c))
          .toList() ?? [],
      priority: json['priority'] ?? 2,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      assignedTo: json['assignedTo'],
      changesHistory: (json['changesHistory'] as List<dynamic>?)
          ?.map((c) => TaskChange.fromJson(c))
          .toList() ?? [],
      status: TaskStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TaskStatus.todo,
      ),
      assignedRole: json['assignedRole'],
      estimatedDuration: json['estimatedDuration'] != null
          ? Duration(minutes: json['estimatedDuration'])
          : null,
      timerStartedAt: json['timerStartedAt'] != null ? DateTime.parse(json['timerStartedAt']) : null,
      isTimerActive: json['isTimerActive'] ?? false,
    );
  }
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

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'author': author,
      'createdAt': createdAt.toIso8601String(),
      'isEdited': isEdited,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      text: json['text'],
      author: json['author'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      isEdited: json['isEdited'] ?? false,
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

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'oldValue': oldValue,
      'newValue': newValue,
      'changedAt': changedAt.toIso8601String(),
      'changedBy': changedBy,
    };
  }

  factory TaskChange.fromJson(Map<String, dynamic> json) {
    return TaskChange(
      field: json['field'],
      oldValue: json['oldValue'],
      newValue: json['newValue'],
      changedAt: json['changedAt'] != null ? DateTime.parse(json['changedAt']) : DateTime.now(),
      changedBy: json['changedBy'],
    );
  }
}
