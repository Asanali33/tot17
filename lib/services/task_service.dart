import '../models/task.dart';

class TaskService {
  List<Task> tasks = [];

  final Map<String, List<String>> categories = {
    'Работа': ['Проекты', 'Встречи', 'Отчеты', 'Прочее'],
    'Личное': ['Спорт', 'Чтение', 'Хобби', 'Прочее'],
    'Покупки': ['Продукты', 'Одежда', 'Дом', 'Другое'],
    'Общие': ['Стандартные'],
  };

  void addTask(String title, {String category = 'Общие', String? subcategory}) {
    tasks.add(Task(
      title: title,
      category: category,
      subcategory: subcategory,
    ));
  }

  void toggleTask(int index) {
    tasks[index].isDone = !tasks[index].isDone;
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
  }

  void updateTask(int index, String title, String category, String? subcategory) {
    tasks[index].title = title;
    tasks[index].category = category;
    tasks[index].subcategory = subcategory;
  }

  void clearAllTasks() {
    tasks.clear();
  }
}
