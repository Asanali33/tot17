import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
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
    final localizations = AppLocalizations.of(context)!;
    final overview = widget.taskService.getProductivityOverview();
    final dailyStats = widget.taskService.getDailyStats();

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.productivityAnalytics),
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
          _buildOverviewTab(overview, localizations),
          _buildDailyStatsTab(dailyStats, localizations),
          _buildDeadlinesTab(localizations),
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
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.trending_up),
            label: localizations.overview,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: localizations.statistics,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.alarm_off),
            label: localizations.deadlines,
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(
    Map<String, dynamic> overview,
    AppLocalizations localizations,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          localizations.overallStatistics,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        _buildStatCard(
          localizations.totalTasksCreated,
          '${overview['totalTasksCreated']}',
          Icons.add_circle,
          Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          localizations.tasksCompleted,
          '${overview['totalTasksCompleted']}',
          Icons.check_circle,
          Colors.green,
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          localizations.averagePercentage,
          '${overview['averageCompletionRate']}%',
          Icons.pie_chart,
          Colors.purple,
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          localizations.missedDeadlines,
          '${overview['missedDeadlines']}',
          Icons.warning,
          Colors.red,
        ),
        const SizedBox(height: 24),
        Text(
          localizations.whenMostProductive,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildProductiveHourCard(localizations),
        const SizedBox(height: 12),
        _buildProductiveDayCard(localizations),
        const SizedBox(height: 24),
        _buildCompletionByCategory(localizations),
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

  Widget _buildProductiveHourCard(AppLocalizations localizations) {
    final mostProductiveHour = widget.taskService.getMostProductiveHour();
    final period = mostProductiveHour < 12
        ? localizations.morning
        : mostProductiveHour < 18
            ? localizations.afternoon
            : localizations.evening;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.mostProductiveHour,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '$mostProductiveHour:00 - $period',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              localizations.completeImportantTasks,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductiveDayCard(AppLocalizations localizations) {
    final mostProductiveDay = widget.taskService.getMostProductiveDay();
    if (mostProductiveDay == null) {
      return const SizedBox.shrink();
    }

    final dayName = _getDayName(mostProductiveDay.weekday, localizations);
    final stats = widget.taskService.getDailyStats()[mostProductiveDay];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.mostProductiveDay,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '$dayName, ${mostProductiveDay.day}${localizations.dayOfMonthSuffix}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (stats != null)
              Text(
                '${localizations.completedOfTotal(stats.tasksCompleted.toString(), stats.totalTasks.toString())} (${stats.completionRate.toStringAsFixed(1)}%)',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionByCategory(AppLocalizations localizations) {
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
            Text(
              localizations.tasksByCategory,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                          localizations.tasksCountSummary(entry.value.toString()),
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

  Widget _buildDailyStatsTab(
    Map<DateTime, DailyStats> dailyStats,
    AppLocalizations localizations,
  ) {
    if (dailyStats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(localizations.noDataLastDays),
          ],
        ),
      );
    }

    final sortedDates = dailyStats.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          localizations.dailyStatistics,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...sortedDates.map((date) {
          final stats = dailyStats[date]!;
          final dayName = _getDayName(date.weekday, localizations);

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
                    localizations.completedOfTotal(
                      stats.tasksCompleted.toString(),
                      stats.totalTasks.toString(),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (stats.completionTimes.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                    localizations.completionTimeLabel(
                      stats.completionTimes
                          .map((t) => '${t.hour}:${t.minute.toString().padLeft(2, '0')}')
                          .join(', '),
                    ),
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

  Widget _buildDeadlinesTab(AppLocalizations localizations) {
    final dueTodayTasks = widget.taskService.getTasksDueToday();
    final overdueTasks = widget.taskService.getOverdueTasks();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          localizations.manageDeadlines,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        if (overdueTasks.isNotEmpty) ...[
          Text(
            '🔴 ${localizations.overdueTasks}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const SizedBox(height: 12),
          ...overdueTasks.map((task) {
            return _buildTaskDeadlineCard(task, Colors.red, localizations);
          }).toList(),
          const SizedBox(height: 24),
        ],
        if (dueTodayTasks.isNotEmpty) ...[
          Text(
            '🟡 ${localizations.deadlinesToday}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
          const SizedBox(height: 12),
          ...dueTodayTasks.map((task) {
            return _buildTaskDeadlineCard(task, Colors.orange, localizations);
          }).toList(),
          const SizedBox(height: 24),
        ],
        if (overdueTasks.isEmpty && dueTodayTasks.isEmpty) ...[
          Center(
            child: Column(
              children: [
                const Icon(Icons.check_circle, size: 64, color: Colors.green),
                const SizedBox(height: 16),
                Text(
                  localizations.noUrgentDeadlines,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ] else ...[
          Text(
            localizations.otherTasksFine,
            style: const TextStyle(fontSize: 14, color: Colors.green),
          ),
        ],
      ],
    );
  }

  Widget _buildTaskDeadlineCard(dynamic task, Color color, AppLocalizations localizations) {
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
              localizations.taskDeadlineDate(
                '${deadline?.day}.${deadline?.month}.${deadline?.year}',
              ),
              style: const TextStyle(fontSize: 12),
            ),
            if (daysLeft != 0)
              Text(
                daysLeft > 0
                    ? localizations.remainingDays(daysLeft.toString())
                    : localizations.overdueByDays(daysLeft.abs().toString()),
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

  String _getDayName(int weekday, AppLocalizations localizations) {
    switch (weekday) {
      case DateTime.monday:
        return localizations.weekdayShortMon;
      case DateTime.tuesday:
        return localizations.weekdayShortTue;
      case DateTime.wednesday:
        return localizations.weekdayShortWed;
      case DateTime.thursday:
        return localizations.weekdayShortThu;
      case DateTime.friday:
        return localizations.weekdayShortFri;
      case DateTime.saturday:
        return localizations.weekdayShortSat;
      case DateTime.sunday:
        return localizations.weekdayShortSun;
      default:
        return '';
    }
  }
}
