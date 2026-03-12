import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../widgets/task_tile.dart';
import 'subcategories_screen.dart';

class HomeScreen extends StatefulWidget {
  final TaskService taskService;

  const HomeScreen({super.key, required this.taskService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TaskService taskService;
  TextEditingController controller = TextEditingController();
  String selectedCategory = 'Общие';

  @override
  void initState() {
    super.initState();
    taskService = widget.taskService;
  }

  void addTask() {
    if (controller.text.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Выбрать категорию'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: taskService.categories.keys.map((category) {
              return ListTile(
                title: Text(category),
                onTap: () {
                  setState(() {
                    selectedCategory = category;
                    taskService.addTask(controller.text, category: category);
                    controller.clear();
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void editTaskTitle(int index) {
    final task = taskService.tasks[index];
    final controller = TextEditingController(text: task.title);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Редактировать задачу'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Новое название задачи'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) return;
                setState(() {
                  taskService.updateTask(
                    index,
                    controller.text.trim(),
                    task.category,
                    task.subcategory,
                  );
                });
                Navigator.pop(context);
              },
              child: Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  double getProgress() {
    if (taskService.tasks.isEmpty) return 0;
    int completed = taskService.tasks.where((t) => t.isDone).length;
    return completed / taskService.tasks.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TaskFlow"), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Введите задачу...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(onPressed: addTask, child: Icon(Icons.add)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                LinearProgressIndicator(value: getProgress(), minHeight: 8),
                SizedBox(height: 8),
                Text(
                  '${(getProgress() * 100).toStringAsFixed(0)}% выполнено',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: taskService.tasks.length,
              itemBuilder: (context, index) {
                var task = taskService.tasks[index];

                return Dismissible(
                  key: Key(task.title + index.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      taskService.deleteTask(index);
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: TaskTile(
                    task: task,
                    onTap: () {
                      setState(() {
                        taskService.toggleTask(index);
                      });
                    },
                    onEditTitle: () => editTaskTitle(index),
                    onDelete: () {
                      setState(() {
                        taskService.deleteTask(index);
                      });
                    },
                    onEditCategory: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubcategoriesScreen(
                            taskService: taskService,
                            taskIndex: index,
                          ),
                        ),
                      ).then((result) {
                        if (result == true) {
                          setState(() {});
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
