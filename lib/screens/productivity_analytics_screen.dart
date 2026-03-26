import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../models/productivity_stats.dart';

class ProductivityAnalyticsScreen extends StatefulWidget {
  final TaskService taskService;

  const ProductivityAnalyticsScreen({
    Key? key,
    required this.taskService,
  }) : super(key: key);

  @override
  State<ProductivityAnalyticsScreen> createState() =>
      _ProductivityAnalyticsScreenState();
}

class _ProductivityAnalyticsScreenState extends State<ProductivityAnalyticsScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final overview = widget.taskService.getProductivityOverview();
    final dailyStats = widget.taskService.getDailyStats();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Аналитика продуктивности'),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          _buildOverviewTab(overview),
          _buildDailyStatsTab(dailyStats),
          _buildDeadlinesTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.trending_up),
            label: 'Обзор',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Статистика',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm_off),
            label: 'Дедлайны',
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(Map<String, dynamic> overview) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Общая статистика',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        _buildStatCard(
          'Всего задач создано',
          '${overview['totalTasksCreated']}',
          Icons.add_circle,
          Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          'Задач выполнено',
          '${overview['totalTasksCompleted']}',
          Icons.check_circle,
          Colors.green,
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          'Средний %',
          '${overview['averageCompletionRate']}%',
          Icons.pie_chart,
          Colors.purple,
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          'Пропущено дедлайнов',
          '${overview['missedDeadlines']}',
          Icons.warning,
          Colors.red,
        ),
        const SizedBox(height: 24),
        const Text(
          'Когда ты продуктивнее всего',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildProductiveHourCard(),
        const SizedBox(height: 12),
        _buildProductiveDayCard(),
        const SizedBox(height: 24),
        _buildCompletionByCategory(),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductiveHourCard() {
    final mostProductiveHour = widget.taskService.getMostProductiveHour();
    final period = mostProductiveHour < 12 ? 'утро' : mostProductiveHour < 18 ? 'день' : 'вечер';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Самый продуктивный час',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '$mostProductiveHour:00 - $period',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Выполняй важные задачи в это время!',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductiveDayCard() {
    final mostProductiveDay = widget.taskService.getMostProductiveDay();
    if (mostProductiveDay == null) {
      return const SizedBox.shrink();
    }

    final dayName = _getDayName(mostProductiveDay.weekday);
    final stats = widget.taskService.getDailyStats()[mostProductiveDay];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Самый продуктивный день',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '$dayName, ${mostProductiveDay.day} числа',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (stats != null)
              Text(
                'Выполнено ${stats.tasksCompleted} из ${stats.totalTasks} задач (${stats.completionRate.toStringAsFixed(1)}%)',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionByCategory() {
    final byCategory = widget.taskService.getCompletionByCategory();

    if (byCategory.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Задачи по категориям',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...byCategory.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${entry.value} задач',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: entry.value.toDouble() /
                          byCategory.values
                              .reduce((a, b) => a + b)
                              .toDouble(),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyStatsTab(Map<DateTime, DailyStats> dailyStats) {
    if (dailyStats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Нет данных за последние дни'),
          ],
        ),
      );
    }

    final sortedDates = dailyStats.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Статистика по дням',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...sortedDates.map((date) {
          final stats = dailyStats[date]!;
          final dayName = _getDayName(date.weekday);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$dayName, ${date.day}.${date.month}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${stats.completionRate.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: stats.completionRate / 100,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Выполнено: ${stats.tasksCompleted} из ${stats.totalTasks}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (stats.completionTimes.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Время завершения: ${stats.completionTimes.map((t) => '${t.hour}:${t.minute.toString().padLeft(2, '0')}').join(', ')}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildDeadlinesTab() {
    final dueTodayTasks = widget.taskService.getTasksDueToday();
    final overdueTasks = widget.taskService.getOverdueTasks();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Управление дедлайнами',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        if (overdueTasks.isNotEmpty) ...[
          const Text(
            '🔴 Просроченные задачи',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const SizedBox(height: 12),
          ...overdueTasks.map((task) {
            return _buildTaskDeadlineCard(task, Colors.red);
          }).toList(),
          const SizedBox(height: 24),
        ],
        if (dueTodayTasks.isNotEmpty) ...[
          const Text(
            '🟡 Дедлайны сегодня',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
          const SizedBox(height: 12),
          ...dueTodayTasks.map((task) {
            return _buildTaskDeadlineCard(task, Colors.orange);
          }).toList(),
          const SizedBox(height: 24),
        ],
        if (overdueTasks.isEmpty && dueTodayTasks.isEmpty) ...[
          Center(
            child: Column(
              children: [
                const Icon(Icons.check_circle, size: 64, color: Colors.green),
                const SizedBox(height: 16),
                const Text(
                  'Нет срочных дедлайнов!\nХорошая работа!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ] else ...[
          const Text(
            'Остальные задачи в норме ✅',
            style: TextStyle(fontSize: 14, color: Colors.green),
          ),
        ],
      ],
    );
  }

  Widget _buildTaskDeadlineCard(dynamic task, Color color) {
    final deadline = task.teamDeadline;
    final daysLeft = deadline?.difference(DateTime.now()).inDays ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(Icons.warning, color: color),
        title: Text(task.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Дедлайн: ${deadline?.day}.${deadline?.month}.${deadline?.year}',
              style: const TextStyle(fontSize: 12),
            ),
            if (daysLeft != null && daysLeft != 0)
              Text(
                daysLeft > 0 ? 'Осталось: $daysLeft дней' : 'Просрочено на ${daysLeft.abs()} дней',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
          ],
        ),
        trailing: task.assignedTo != null
            ? Tooltip(
                message: task.assignedTo,
                child: CircleAvatar(
                  child: Text(task.assignedTo[0].toUpperCase()),
                ),
              )
            : null,
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return days[weekday - 1];
  }
}
