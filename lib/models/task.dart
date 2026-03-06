class Task {
  String title;
  bool isDone;
  String category;
  String? subcategory;

  Task({
    required this.title,
    this.isDone = false,
    this.category = 'Общие',
    this.subcategory,
  });
}
