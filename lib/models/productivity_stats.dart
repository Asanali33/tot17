class DailyStats {
  DateTime date;
  int tasksCompleted;
  int totalTasks;
  List<DateTime> completionTimes; // время, когда были выполнены задачи

  DailyStats({
    required this.date,
    this.tasksCompleted = 0,
    this.totalTasks = 0,
    this.completionTimes = const [],
  });

  double get completionRate =>
      totalTasks > 0 ? (tasksCompleted / totalTasks * 100) : 0;
}

class ProductivityStats {
  late Map<DateTime, DailyStats> dailyStats;
  late List<int> missedDeadlines;
  late Map<String, int> completionByCategory;
  late Map<int, int> completionByHour;

  ProductivityStats() {
    dailyStats = {};
    missedDeadlines = [];
    completionByCategory = {};
    completionByHour = {};
  }

  DateTime get mostProductiveDay {
    if (dailyStats.isEmpty) return DateTime.now();
    return dailyStats.entries
        .reduce((a, b) => a.value.completionRate > b.value.completionRate ? a : b)
        .key;
  }

  int get mostProductiveHour {
    if (completionByHour.isEmpty) return 0;
    return completionByHour.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  double get averageCompletionRate {
    if (dailyStats.isEmpty) return 0;
    double sum = dailyStats.values
        .map((stat) => stat.completionRate)
        .fold(0, (a, b) => a + b);
    return sum / dailyStats.length;
  }

  int get totalTasksCompleted {
    return dailyStats.values
        .map((stat) => stat.tasksCompleted)
        .fold(0, (a, b) => a + b);
  }

  int get totalTasksCreated {
    return dailyStats.values
        .map((stat) => stat.totalTasks)
        .fold(0, (a, b) => a + b);
  }
}
