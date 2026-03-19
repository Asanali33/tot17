import '../models/task.dart';

class TaskService {
  List<Task> tasks = [];
  int experience = 0;
  int completedTotal = 0;
  final Set<String> achievements = {};

  final Map<String, List<String>> categories = {
    'work': ['projects', 'meetings', 'reports', 'other'],
    'personal': ['sport', 'reading', 'hobby', 'other'],
    'shopping': ['food', 'clothes', 'home', 'other'],
    'general': ['standard'],
  };

  void addTask(
    String title, {
    String category = 'Общие',
    String? subcategory,
    DateTime? deadline,
  }) {
    tasks.add(
      Task(
        title: title,
        category: category,
        subcategory: subcategory,
        deadline: deadline,
        comments: [],
      ),
    );
  }

  void toggleTask(int index) {
    final task = tasks[index];
    final nowDone = !task.isDone;
    task.isDone = nowDone;

    if (nowDone) {
      if (!task.xpGranted) {
        experience += 20;
        completedTotal += 1;
        task.xpGranted = true;
        _updateAchievements();
      }
    } else {
      if (task.xpGranted) {
        experience = (experience - 20).clamp(0, experience);
        completedTotal = (completedTotal - 1).clamp(0, completedTotal);
        task.xpGranted = false;
        _updateAchievements();
      }
    }
  }

  void addComment(int index, String comment) {
    if (comment.trim().isEmpty) return;
    tasks[index].comments.add(comment.trim());
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
  ) {
    tasks[index].title = title;
    tasks[index].category = category;
    tasks[index].subcategory = subcategory;
    tasks[index].deadline = deadline;
  }

  void clearAllTasks() {
    tasks.clear();
  }
}
