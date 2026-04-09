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

class _TaskDetailScreenState extends State<TaskDetailScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _commentController = TextEditingController();
  late TaskStatus _selectedStatus;
  String? _selectedAssignee;
  String? _selectedRole;
  late AnimationController _timerUpdateController;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.task.status;
    _selectedAssignee = widget.task.assignedTo;
    _selectedRole = widget.task.assignedRole;

    // Таймер для обновления UI каждую секунду
    _timerUpdateController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _timerUpdateController.dispose();
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
                  onChanged: (value) {
                    if (value != null) _updateStatus(value);
                  },
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

            // Таймер
            if (task.estimatedDuration != null) ...[
              const Text(
                'Таймер',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _timerUpdateController,
                        builder: (context, child) {
                          final remaining = widget.taskService
                              .getRemainingTime(widget.taskIndex);
                          final progress = widget.taskService
                              .getTimerProgress(widget.taskIndex);
                          final isExpired = widget.taskService
                              .isTimeExpired(widget.taskIndex);

                          return Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: CircularProgressIndicator(
                                      value: progress,
                                      strokeWidth: 8,
                                      backgroundColor: Colors.grey[300],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        isExpired ? Colors.red : Colors.blue,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        _formatDuration(remaining ?? Duration.zero),
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: isExpired ? Colors.red : Colors.black,
                                        ),
                                      ),
                                      Text(
                                        task.isTimerActive ? 'Таймер активен' : 'Таймер остановлен',
                                        style: TextStyle(
                                          color: task.isTimerActive ? Colors.green : Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: task.isTimerActive
                                        ? null
                                        : () {
                                            widget.taskService
                                                .startTimer(widget.taskIndex);
                                            setState(() {});
                                          },
                                    icon: const Icon(Icons.play_arrow),
                                    label: const Text('Запустить'),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: task.isTimerActive
                                        ? () {
                                            widget.taskService
                                                .stopTimer(widget.taskIndex);
                                            setState(() {});
                                          }
                                        : null,
                                    icon: const Icon(Icons.pause),
                                    label: const Text('Остановить'),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      widget.taskService
                                          .resetTimer(widget.taskIndex);
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Сбросить'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: _showDurationDialog,
                                icon: const Icon(Icons.edit),
                                label: const Text('Изменить время'),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

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

  void _showDurationDialog() {
    int hours = widget.task.estimatedDuration?.inHours ?? 0;
    int minutes = widget.task.estimatedDuration?.inMinutes.remainder(60) ?? 0;
    int seconds = widget.task.estimatedDuration?.inSeconds.remainder(60) ?? 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Изменить время выполнения'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text('Часы', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                controller: TextEditingController(text: hours.toString()),
                                onChanged: (value) {
                                  setState(() {
                                    hours = int.tryParse(value) ?? 0;
                                  });
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            children: [
                              const Text('Минуты', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                controller: TextEditingController(text: minutes.toString()),
                                onChanged: (value) {
                                  setState(() {
                                    minutes = int.tryParse(value) ?? 0;
                                  });
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            children: [
                              const Text('Секунды', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                controller: TextEditingController(text: seconds.toString()),
                                onChanged: (value) {
                                  setState(() {
                                    seconds = int.tryParse(value) ?? 0;
                                  });
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Итого: ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Отмена'),
                ),
                TextButton(
                  onPressed: () {
                    if (hours > 0 || minutes > 0 || seconds > 0) {
                      final newDuration = Duration(
                        hours: hours,
                        minutes: minutes,
                        seconds: seconds,
                      );
                      widget.taskService.setTaskDuration(widget.taskIndex, newDuration);
                      widget.taskService.resetTimer(widget.taskIndex);
                      this.setState(() {});
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Сохранить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}