import 'task_detail_screen.dart';

class CollaborationScreen extends StatefulWidget {
  final TaskService taskService;

  const CollaborationScreen({
    Key? key,
    required this.taskService,
  }) : super(key: key);

  @override
  State<CollaborationScreen> createState() => _CollaborationScreenState();
}

class _CollaborationScreenState extends State<CollaborationScreen> {
  final TextEditingController _memberNameController = TextEditingController();
  final TextEditingController _memberRoleController = TextEditingController();
  late PageController _pageController;
  int _currentPage = 0;
  Role? _selectedRole;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _memberNameController.dispose();
    _memberRoleController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _addTeamMember() {
    final name = _memberNameController.text.trim();
    final role = _selectedRole;

    if (name.isEmpty || role == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите имя и выберите роль')),
      );
      return;
    }

    final member = TeamMember(
      id: 'member_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      role: role,
    );

    setState(() {
      widget.taskService.addTeamMember(member);
      _memberNameController.clear();
      _selectedRole = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name добавлен в команду')),
    );
  }

  void _removeTeamMember(String memberId) {
    setState(() {
      widget.taskService.removeTeamMember(memberId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasksByTeam = widget.taskService.getTasksByTeam();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Коллаборация'),
        centerTitle: true,
      ),
      body: widget.taskService.teamMembers.isEmpty
          ? _buildEmptyTeam()
          : PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                _buildTeamMembersView(),
                _buildTasksByTeamView(tasksByTeam),
              ],
            ),
      bottomNavigationBar: widget.taskService.teamMembers.isNotEmpty
          ? BottomNavigationBar(
              currentIndex: _currentPage,
              onTap: (index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Команда',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.assignment),
                  label: 'Задачи',
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildEmptyTeam() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 20),
        const Icon(Icons.people_outline, size: 64, color: Colors.grey),
        const SizedBox(height: 16),
        const Text(
          'Создайте команду',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _memberNameController,
          decoration: InputDecoration(
            hintText: 'Имя члена команды',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<Role>(
          value: _selectedRole,
          decoration: InputDecoration(
            hintText: 'Выберите роль',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.work),
          ),
          items: Role.predefinedRoles.map((role) {
            return DropdownMenuItem<Role>(
              value: role,
              child: Text(role.name),
            );
          }).toList(),
          onChanged: (role) {
            setState(() {
              _selectedRole = role;
            });
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _addTeamMember,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Добавить члена команды'),
        ),
      ],
    );
  }

  Widget _buildTeamMembersView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _memberNameController,
          decoration: InputDecoration(
            hintText: 'Имя',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<Role>(
          value: _selectedRole,
          decoration: InputDecoration(
            hintText: 'Роль',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.work),
          ),
          items: Role.predefinedRoles.map((role) {
            return DropdownMenuItem<Role>(
              value: role,
              child: Text(role.name),
            );
          }).toList(),
          onChanged: (role) {
            setState(() {
              _selectedRole = role;
            });
          },
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: _addTeamMember,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Добавить'),
        ),
        const SizedBox(height: 24),
        const Text(
          'Члены команды',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...widget.taskService.teamMembers.map((member) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(member.name[0].toUpperCase()),
              ),
              title: Text(member.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.role.name),
                  Text(
                    member.role.description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _removeTeamMember(member.id);
                },
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTasksByTeamView(Map<String, List<dynamic>> tasksByTeam) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Распределение задач',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...tasksByTeam.entries.map((entry) {
          final assignee = entry.key;
          final tasks = entry.value;
          final completedCount = tasks.where((t) => t.isDone).length;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              title: Text(
                '$assignee (${tasks.length} задач)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: LinearProgressIndicator(
                value: tasks.isEmpty ? 0 : (completedCount / tasks.length),
                minHeight: 4,
              ),
              children: [
                ...tasks.map((task) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: task.isDone,
                              onChanged: (_) {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.info_outline, size: 20),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskDetailScreen(
                                      task: task,
                                      taskIndex: widget.taskService.tasks.indexOf(task),
                                      taskService: widget.taskService,
                                    ),
                                  ),
                                ).then((_) => setState(() {}));
                              },
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: TextStyle(
                                      decoration: task.isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(task.status),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          task.status.displayName,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (task.assignedRole != null) ...[
                                        const SizedBox(width: 8),
                                        Text(
                                          'Роль: ${task.assignedRole}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  if (task.teamDeadline != null)
                                    Text(
                                      'Дедлайн: ${task.teamDeadline!.day}.${task.teamDeadline!.month}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (task.comments.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Комментарии:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  ...task.comments.map((comment) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              if (comment.author != null)
                                                Text(
                                                  '${comment.author}:',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              const Spacer(),
                                              Text(
                                                '${comment.createdAt.day}.${comment.createdAt.month} ${comment.createdAt.hour}:${comment.createdAt.minute.toString().padLeft(2, '0')}',
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              if (comment.isEdited)
                                                const Text(
                                                  ' (изменено)',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.orange,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          Text(
                                            comment.text,
                                            style: const TextStyle(fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return Colors.grey;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.review:
        return Colors.orange;
      case TaskStatus.done:
        return Colors.green;
    }
  }
}
