import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TaskService taskService = TaskService();
  TextEditingController controller = TextEditingController();

  void addTask() {
    if (controller.text.isEmpty) return;

    setState(() {
      taskService.addTask(controller.text);
      controller.clear();
    });
  }

  double getProgress() {
    if (taskService.tasks.isEmpty) return 0;
    int completed = taskService.tasks.where((t) => t.isDone).length;
    return completed / taskService.tasks.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TaskFlow"),
        centerTitle: true,
      ),
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
                ElevatedButton(
                  onPressed: addTask,
                  child: Icon(Icons.add),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: getProgress(),
                  minHeight: 8,
                ),
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
                    onDelete: () {
                      setState(() {
                        taskService.deleteTask(index);
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
