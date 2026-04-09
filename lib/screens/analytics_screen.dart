import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/task_service.dart';
import '../l10n/app_localizations.dart';

class AnalyticsScreen extends StatefulWidget {
  final TaskService taskService;

  const AnalyticsScreen({super.key, required this.taskService});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.productivityAnalytics),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Табы для разных графиков
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildTabButton(
                  0,
                  localizations.completedTasksChart,
                  Icons.check_circle,
                ),
                const SizedBox(width: 8),
                _buildTabButton(
                  1,
                  localizations.procrastinationAnalysis,
                  Icons.access_time,
                ),
                const SizedBox(width: 8),
                _buildTabButton(
                  2,
                  localizations.averageCompletionTime,
                  Icons.timer,
                ),
                const SizedBox(width: 8),
                _buildTabButton(
                  3,
                  localizations.workloadForecast,
                  Icons.calendar_view_week,
                ),
              ],
            ),
          ),
          // График
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildChart(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String title, IconData icon) {
    final isSelected = _selectedTab == index;
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: ElevatedButton.icon(
        onPressed: () => setState(() => _selectedTab = index),
        icon: Icon(icon, size: 18),
        label: Text(title, textAlign: TextAlign.center),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surface,
          foregroundColor: isSelected
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurface,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildChart() {
    switch (_selectedTab) {
      case 0:
        return _buildCompletedTasksChart();
      case 1:
        return _buildProcrastinationChart();
      case 2:
        return _buildAverageTimeChart();
      case 3:
        return _buildWorkloadForecastChart();
      default:
        return const SizedBox();
    }
  }

  Widget _buildCompletedTasksChart() {
    final data = widget.taskService.getCompletedTasksByDay();
    final localizations = AppLocalizations.of(context)!;

    if (data.isEmpty) {
      return _buildEmptyState(localizations.noData);
    }

    final spots = data.entries.map((entry) {
      final daysSinceStart = entry.key
          .difference(DateTime.now().subtract(const Duration(days: 30)))
          .inDays;
      return FlSpot(daysSinceStart.toDouble(), entry.value.toDouble());
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final date = DateTime.now()
                    .subtract(const Duration(days: 30))
                    .add(Duration(days: value.toInt()));
                return Text('${date.day}/${date.month}');
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcrastinationChart() {
    final data = widget.taskService.getProcrastinationReasons();
    final localizations = AppLocalizations.of(context)!;

    if (data.isEmpty) {
      return _buildEmptyState(localizations.noData);
    }

    final sections = data.entries.map((entry) {
      final colors = [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.purple,
      ];
      final color =
          colors[data.keys.toList().indexOf(entry.key) % colors.length];

      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: '${entry.key}\n${entry.value}',
        color: color,
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return PieChart(
      PieChartData(sections: sections, sectionsSpace: 2, centerSpaceRadius: 40),
    );
  }

  Widget _buildAverageTimeChart() {
    final averageTime = widget.taskService.getAverageCompletionTime();
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            localizations.averageCompletionTime,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            _formatDuration(averageTime),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkloadForecastChart() {
    final data = widget.taskService.getWeeklyWorkloadForecast();
    final localizations = AppLocalizations.of(context)!;

    if (data.isEmpty) {
      return _buildEmptyState(localizations.noData);
    }

    final bars = data.entries.map((entry) {
      final daysFromNow = entry.key.difference(DateTime.now()).inDays;
      return BarChartGroupData(
        x: daysFromNow,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Theme.of(context).colorScheme.primary,
            width: 20,
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        barGroups: bars,
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final date = DateTime.now().add(Duration(days: value.toInt()));
                final weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
                return Text(weekdays[date.weekday - 1]);
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),
        borderData: FlBorderData(show: true),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final localizations = AppLocalizations.of(context)!;

    if (duration.inDays > 0) {
      return '${duration.inDays} ${localizations.days}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} ${localizations.hours}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} ${localizations.minutes}';
    } else {
      return '${duration.inSeconds} ${localizations.seconds}';
    }
  }
}
