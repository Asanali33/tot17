import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/team_member.dart';
import '../models/role.dart';
import '../services/task_service.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final int taskIndex;
  final TaskService taskService;

  const TaskDetailScreen({
    Key? key,
    required this.task,
    required this.taskIndex,
    required this.taskService,
  }) : super(key: key);

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  late TaskStatus _selectedStatus;
  String? _selectedAssignee;
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.task.status;
    _selectedAssignee = widget.task.assignedTo;
    _selectedRole = widget.task.assignedRole;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    widget.taskService.addComment(widget.taskIndex, commentText);
    _commentController.clear();
    setState(() {});
  }

  void _updateStatus(TaskStatus newStatus) {
    widget.taskService.updateTaskStatus(widget.taskIndex, newStatus);
    setState(() {
      _selectedStatus = newStatus;
    });
  }

  void _assignToMember(String? memberName) {
    if (memberName == null) return;
    widget.taskService.assignTaskToMember(widget.taskIndex, 
      widget.taskService.teamMembers.firstWhere((m) => m.name == memberName).id);
    setState(() {
      _selectedAssignee = memberName;
    });
  }

  void _assignToRole(String? roleName) {
    if (roleName == null) return;
    widget.taskService.assignTaskToRole(widget.taskIndex, roleName);
    setState(() {
      _selectedRole = roleName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final changeHistory = widget.taskService.getTaskChangeHistory(widget.taskIndex);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали задачи'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showChangeHistory(context, changeHistory),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок задачи
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Статус
            Row(
              children: [
                const Text('Статус:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                DropdownButton<TaskStatus>(
                  value: _selectedStatus,
                  items: TaskStatus.values.map((status) {
                    return DropdownMenuItem<TaskStatus>(
                      value: status,
                      child: Text(status.displayName),
                    );
                  }).toList(),
                  onChanged: _updateStatus,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Исполнитель
            Row(
              children: [
                const Text('Исполнитель:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String?>(
                    value: _selectedAssignee,
                    hint: const Text('Не назначен'),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Не назначен'),
                      ),
                      ...widget.taskService.teamMembers.map((member) {
                        return DropdownMenuItem<String?>(
                          value: member.name,
                          child: Text(member.name),
                        );
                      }).toList(),
                    ],
                    onChanged: _assignToMember,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Роль исполнителя
            Row(
              children: [
                const Text('Роль:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String?>(
                    value: _selectedRole,
                    hint: const Text('Не указана'),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Не указана'),
                      ),
                      ...widget.taskService.getAvailableRoles().map((role) {
                        return DropdownMenuItem<String?>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                    ],
                    onChanged: _assignToRole,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Дедлайны
            if (task.deadline != null || task.teamDeadline != null) ...[
              const Text('Дедлайны:', style: TextStyle(fontWeight: FontWeight.bold)),
              if (task.deadline != null)
                Text('Личный: ${task.deadline!.day}.${task.deadline!.month}.${task.deadline!.year}'),
              if (task.teamDeadline != null)
                Text('Командный: ${task.teamDeadline!.day}.${task.teamDeadline!.month}.${task.teamDeadline!.year}'),
              const SizedBox(height: 16),
            ],

            // Приоритет
            Text('Приоритет: ${task.priority}'),
            const SizedBox(height: 16),

            // Категория
            Text('Категория: ${task.category}'),
            if (task.subcategory != null) Text('Подкатегория: ${task.subcategory}'),
            const SizedBox(height: 24),

            // Комментарии
            const Text(
              'Комментарии',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Список комментариев
            ...task.comments.map((comment) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (comment.author != null)
                            Text(
                              comment.author!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          const Spacer(),
                          Text(
                            '${comment.createdAt.day}.${comment.createdAt.month} ${comment.createdAt.hour}:${comment.createdAt.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          if (comment.isEdited)
                            const Text(
                              ' (изм.)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(comment.text),
                    ],
                  ),
                ),
              );
            }).toList(),

            // Добавить комментарий
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Добавить комментарий...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    minLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addComment,
                  child: const Text('Отправить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeHistory(BuildContext context, List<TaskChange> changes) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('История изменений'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: changes.map((change) {
              return ListTile(
                title: Text(change.field),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Было: ${change.oldValue}'),
                    Text('Стало: ${change.newValue}'),
                    Text(
                      'Когда: ${change.changedAt.day}.${change.changedAt.month} ${change.changedAt.hour}:${change.changedAt.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    if (change.changedBy != null)
                      Text(
                        'Кем: ${change.changedBy}',
                        style: const TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}