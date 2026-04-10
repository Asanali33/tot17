// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TaskFlow';

  @override
  String get tasks => 'Tasks';

  @override
  String get statistics => 'Statistics';

  @override
  String get settings => 'Settings';

  @override
  String get enterTask => 'Enter task...';

  @override
  String get add => 'Add';

  @override
  String get general => 'General';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get completed => 'Completed';

  @override
  String get selectCategory => 'Select category';

  @override
  String get editTask => 'Edit task';

  @override
  String get newTaskTitle => 'New task title';

  @override
  String get addComment => 'Add comment';

  @override
  String get enterCommentText => 'Enter comment text';

  @override
  String get deadlineNotSelectedAddWithoutDeadline =>
      'Deadline not selected. Add task without deadline?';

  @override
  String get taskDurationTitle => 'Set task duration';

  @override
  String totalDuration(Object duration) {
    return 'Total: $duration';
  }

  @override
  String get skip => 'Skip';

  @override
  String get setDuration => 'Set';

  @override
  String get notSet => 'Not set';

  @override
  String get assign => 'Assign';

  @override
  String get unassigned => 'Unassigned';

  @override
  String get priorityLabel => 'Priority:';

  @override
  String get comments => 'Comments:';

  @override
  String get edited => ' (edited)';

  @override
  String get enterNameAndSelectRole => 'Enter a name and select a role';

  @override
  String get addedToTeam => 'added to the team';

  @override
  String get manageDeadlines => 'Deadline management';

  @override
  String get overdueTasks => 'Overdue tasks';

  @override
  String get deadlinesToday => 'Deadlines today';

  @override
  String get noUrgentDeadlines => 'No urgent deadlines!\nGreat job!';

  @override
  String get otherTasksFine => 'Other tasks are under control ✅';

  @override
  String get totalTasksCreated => 'Total tasks created';

  @override
  String get tasksCompleted => 'Tasks completed';

  @override
  String get averagePercentage => 'Average %';

  @override
  String get missedDeadlines => 'Missed deadlines';

  @override
  String get whenMostProductive => 'When you are most productive';

  @override
  String get mostProductiveHour => 'Most productive hour';

  @override
  String get completeImportantTasks =>
      'Complete important tasks during this time!';

  @override
  String get mostProductiveDay => 'Most productive day';

  @override
  String completedOfTotal(Object completed, Object total) {
    return 'Completed $completed of $total tasks';
  }

  @override
  String completionTimeLabel(Object times) {
    return 'Completion time: $times';
  }

  @override
  String get tasksByCategory => 'Tasks by category';

  @override
  String tasksCountSummary(Object count) {
    return '$count tasks';
  }

  @override
  String get dailyStatistics => 'Daily statistics';

  @override
  String get noDataLastDays => 'No data for the last days';

  @override
  String get notSetLabel => 'Not set';

  @override
  String remainingDays(Object days) {
    return 'Remaining: $days days';
  }

  @override
  String overdueByDays(Object days) {
    return 'Overdue by $days days';
  }

  @override
  String taskCountWithAssignee(Object assignee, Object count) {
    return '$assignee ($count tasks)';
  }

  @override
  String taskDeadlineDate(Object date) {
    return 'Deadline: $date';
  }

  @override
  String get greatJob => 'Great job!';

  @override
  String get notifications => 'Notifications';

  @override
  String get getReminders => 'Get reminders about tasks';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get useDarkMode => 'Use dark mode';

  @override
  String get aboutApp => 'About app';

  @override
  String get version => 'Version';

  @override
  String get aboutDeveloper => 'About developer';

  @override
  String get taskManager => 'Task management app';

  @override
  String get clearAllTasks => 'Clear all tasks';

  @override
  String get confirm => 'Confirm';

  @override
  String get sureClearTasks => 'Are you sure you want to clear all tasks?';

  @override
  String get clear => 'Clear';

  @override
  String get allTasksCleared => 'All tasks cleared';

  @override
  String get work => 'Work';

  @override
  String get personal => 'Personal';

  @override
  String get shopping => 'Shopping';

  @override
  String get projects => 'Projects';

  @override
  String get meetings => 'Meetings';

  @override
  String get reports => 'Reports';

  @override
  String get other => 'Other';

  @override
  String get sport => 'Sport';

  @override
  String get reading => 'Reading';

  @override
  String get hobby => 'Hobby';

  @override
  String get food => 'Food';

  @override
  String get clothes => 'Clothes';

  @override
  String get home => 'Home';

  @override
  String get deadline => 'Deadline';

  @override
  String get setDeadline => 'Set deadline';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get russian => 'Russian';

  @override
  String get english => 'English';

  @override
  String get overallStatistics => 'Overall Statistics';

  @override
  String get total => 'Total';

  @override
  String get remaining => 'Remaining';

  @override
  String get progress => 'Progress';

  @override
  String get percentCompleted => '% completed';

  @override
  String get addTasksForStats => '📝 Add tasks to view statistics';

  @override
  String get searchTasks => 'Search tasks...';

  @override
  String get onlyActive => 'Only active';

  @override
  String get priority => 'Priority';

  @override
  String get byPriority => 'by priority';

  @override
  String get date => 'Date';

  @override
  String get noSorting => 'No sorting';

  @override
  String get noTasks => 'No tasks';

  @override
  String get collaboration => 'Collaboration';

  @override
  String get team => 'Team';

  @override
  String get createTeam => 'Create a team';

  @override
  String get teamMemberName => 'Team member name';

  @override
  String get name => 'Name';

  @override
  String get role => 'Role';

  @override
  String get selectRole => 'Select role';

  @override
  String get addTeamMember => 'Add team member';

  @override
  String get teamMembers => 'Team members';

  @override
  String get taskDistribution => 'Task distribution';

  @override
  String get teamDeadline => 'Team deadline';

  @override
  String get taskDuration => 'Task duration';

  @override
  String get timerLabel => 'Timer';

  @override
  String get aiAssistant => 'AI Assistant';

  @override
  String get assistantGreeting =>
      'Hi! 👋 I\'m your AI assistant for task management. Ask me about your tasks, team, or productivity!';

  @override
  String get clearConversation => 'Clear conversation';

  @override
  String get clearConversationTitle => 'Clear conversation?';

  @override
  String get clearConversationContent => 'All messages will be removed.';

  @override
  String get conversationCleared => 'Conversation cleared. Starting fresh!';

  @override
  String get enterQuestion => 'Enter question...';

  @override
  String get analytics => 'Analytics';

  @override
  String get overview => 'Overview';

  @override
  String get deadlines => 'Deadlines';

  @override
  String get productivityAnalytics => 'Productivity Analytics';

  @override
  String get completedTasksChart => 'Completed Tasks';

  @override
  String get procrastinationAnalysis => 'Procrastination Analysis';

  @override
  String get averageCompletionTime => 'Average Completion Time';

  @override
  String get workloadForecast => 'Workload Forecast';

  @override
  String get noData => 'No data available';

  @override
  String get days => 'days';

  @override
  String get dayOfMonthSuffix => 'th';

  @override
  String get hours => 'hours';

  @override
  String get minutes => 'minutes';

  @override
  String get seconds => 'seconds';

  @override
  String get morning => 'morning';

  @override
  String get afternoon => 'afternoon';

  @override
  String get evening => 'evening';

  @override
  String get weekdayShortMon => 'Mon';

  @override
  String get weekdayShortTue => 'Tue';

  @override
  String get weekdayShortWed => 'Wed';

  @override
  String get weekdayShortThu => 'Thu';

  @override
  String get weekdayShortFri => 'Fri';

  @override
  String get weekdayShortSat => 'Sat';

  @override
  String get weekdayShortSun => 'Sun';

  @override
  String get procrastinationReasons => 'Why didn\'t you complete the task?';

  @override
  String get tooTiring => 'Too tiring';

  @override
  String get lackOfTime => 'Lack of time';

  @override
  String get lackOfMotivation => 'Lack of motivation';

  @override
  String get tooComplex => 'Too complex';

  @override
  String get forgot => 'Forgot';

  @override
  String get otherReason => 'Other';

  @override
  String get standard => 'Standard';

  @override
  String get setDefaultDeadline => 'Set default deadline (tomorrow)';

  @override
  String get lowPriority => 'Low';

  @override
  String get mediumPriority => 'Medium';

  @override
  String get highPriority => 'High';

  @override
  String get experiencePoints => 'Experience Points';

  @override
  String get totalExperience => 'Total Experience';

  @override
  String get level => 'Level';

  @override
  String get achievements => 'Achievements';

  @override
  String get firstCompletion => 'First Completion';

  @override
  String get master5Tasks => 'Master of 5 Tasks';

  @override
  String get hero10Tasks => 'Hero of 10 Tasks';

  @override
  String get legend20Tasks => 'Legend of 20 Tasks';

  @override
  String get levelUp => 'Level Up!';

  @override
  String get achievementUnlocked => 'Achievement Unlocked!';

  @override
  String get noAchievements => 'No achievements yet';

  @override
  String get level2 => 'Level 2 Reached!';

  @override
  String get level5 => 'Level 5 Reached!';

  @override
  String get level10 => 'Level 10 Reached!';
}
