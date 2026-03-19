import '../models/task.dart';

class TaskService {
  List<Task> tasks = [];

  final Map<String, List<String>> categories = {
    'work': ['projects', 'meetings', 'reports', 'other'],
    'personal': ['sport', 'reading', 'hobby', 'other'],
    'shopping': ['food', 'clothes', 'home', 'other'],
    'general': ['standard'],
  };

  void addTask(String title, {String category = 'Общие', String? subcategory, DateTime? deadline}) {
    tasks.add(Task(
      title: title,
      category: category,
      subcategory: subcategory,
      deadline: deadline,
    ));
  }

  void toggleTask(int index) {
    tasks[index].isDone = !tasks[index].isDone;
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
  }

  void updateTask(int index, String title, String category, String? subcategory, DateTime? deadline) {
    tasks[index].title = title;
    tasks[index].category = category;
    tasks[index].subcategory = subcategory;
    tasks[index].deadline = deadline;
  }

  void clearAllTasks() {
    tasks.clear();
  }
}
