import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../models/team_member.dart';

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
    final role = _memberRoleController.text.trim();

    if (name.isEmpty || role.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите имя и роль')),
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
      _memberRoleController.clear();
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
        TextField(
          controller: _memberRoleController,
          decoration: InputDecoration(
            hintText: 'Роль (разработчик, тестировщик и т.д.)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.work),
          ),
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
        TextField(
          controller: _memberRoleController,
          decoration: InputDecoration(
            hintText: 'Роль',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.work),
          ),
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
              subtitle: Text(member.role),
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
                                  ...task.comments.map((comment) {
                                    return Text(
                                      comment,
                                      style: const TextStyle(fontSize: 11),
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
}
