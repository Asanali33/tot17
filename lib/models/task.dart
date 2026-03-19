class Task {
  String title;
  bool isDone;
  bool xpGranted;
  String category;
  String? subcategory;
  DateTime? deadline;
  List<String> comments;

  Task({
    required this.title,
    this.isDone = false,
    this.xpGranted = false,
    this.category = 'Общие',
    this.subcategory,
    this.deadline,
    this.comments = const [],
  });
}
