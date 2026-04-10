import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'TaskFlow'**
  String get appTitle;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @enterTask.
  ///
  /// In en, this message translates to:
  /// **'Enter task...'**
  String get enterTask;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategory;

  /// No description provided for @editTask.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get editTask;

  /// No description provided for @newTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'New task title'**
  String get newTaskTitle;

  /// No description provided for @addComment.
  ///
  /// In en, this message translates to:
  /// **'Add comment'**
  String get addComment;

  /// No description provided for @enterCommentText.
  ///
  /// In en, this message translates to:
  /// **'Enter comment text'**
  String get enterCommentText;

  /// No description provided for @deadlineNotSelectedAddWithoutDeadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline not selected. Add task without deadline?'**
  String get deadlineNotSelectedAddWithoutDeadline;

  /// No description provided for @taskDurationTitle.
  ///
  /// In en, this message translates to:
  /// **'Set task duration'**
  String get taskDurationTitle;

  /// No description provided for @totalDuration.
  ///
  /// In en, this message translates to:
  /// **'Total: {duration}'**
  String totalDuration(Object duration);

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @setDuration.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get setDuration;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @assign.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get assign;

  /// No description provided for @unassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get unassigned;

  /// No description provided for @priorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority:'**
  String get priorityLabel;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments:'**
  String get comments;

  /// No description provided for @edited.
  ///
  /// In en, this message translates to:
  /// **' (edited)'**
  String get edited;

  /// No description provided for @enterNameAndSelectRole.
  ///
  /// In en, this message translates to:
  /// **'Enter a name and select a role'**
  String get enterNameAndSelectRole;

  /// No description provided for @addedToTeam.
  ///
  /// In en, this message translates to:
  /// **'added to the team'**
  String get addedToTeam;

  /// No description provided for @manageDeadlines.
  ///
  /// In en, this message translates to:
  /// **'Deadline management'**
  String get manageDeadlines;

  /// No description provided for @overdueTasks.
  ///
  /// In en, this message translates to:
  /// **'Overdue tasks'**
  String get overdueTasks;

  /// No description provided for @deadlinesToday.
  ///
  /// In en, this message translates to:
  /// **'Deadlines today'**
  String get deadlinesToday;

  /// No description provided for @noUrgentDeadlines.
  ///
  /// In en, this message translates to:
  /// **'No urgent deadlines!\nGreat job!'**
  String get noUrgentDeadlines;

  /// No description provided for @otherTasksFine.
  ///
  /// In en, this message translates to:
  /// **'Other tasks are under control ✅'**
  String get otherTasksFine;

  /// No description provided for @totalTasksCreated.
  ///
  /// In en, this message translates to:
  /// **'Total tasks created'**
  String get totalTasksCreated;

  /// No description provided for @tasksCompleted.
  ///
  /// In en, this message translates to:
  /// **'Tasks completed'**
  String get tasksCompleted;

  /// No description provided for @averagePercentage.
  ///
  /// In en, this message translates to:
  /// **'Average %'**
  String get averagePercentage;

  /// No description provided for @missedDeadlines.
  ///
  /// In en, this message translates to:
  /// **'Missed deadlines'**
  String get missedDeadlines;

  /// No description provided for @whenMostProductive.
  ///
  /// In en, this message translates to:
  /// **'When you are most productive'**
  String get whenMostProductive;

  /// No description provided for @mostProductiveHour.
  ///
  /// In en, this message translates to:
  /// **'Most productive hour'**
  String get mostProductiveHour;

  /// No description provided for @completeImportantTasks.
  ///
  /// In en, this message translates to:
  /// **'Complete important tasks during this time!'**
  String get completeImportantTasks;

  /// No description provided for @mostProductiveDay.
  ///
  /// In en, this message translates to:
  /// **'Most productive day'**
  String get mostProductiveDay;

  /// No description provided for @completedOfTotal.
  ///
  /// In en, this message translates to:
  /// **'Completed {completed} of {total} tasks'**
  String completedOfTotal(Object completed, Object total);

  /// No description provided for @completionTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Completion time: {times}'**
  String completionTimeLabel(Object times);

  /// No description provided for @tasksByCategory.
  ///
  /// In en, this message translates to:
  /// **'Tasks by category'**
  String get tasksByCategory;

  /// No description provided for @tasksCountSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} tasks'**
  String tasksCountSummary(Object count);

  /// No description provided for @dailyStatistics.
  ///
  /// In en, this message translates to:
  /// **'Daily statistics'**
  String get dailyStatistics;

  /// No description provided for @noDataLastDays.
  ///
  /// In en, this message translates to:
  /// **'No data for the last days'**
  String get noDataLastDays;

  /// No description provided for @notSetLabel.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSetLabel;

  /// No description provided for @remainingDays.
  ///
  /// In en, this message translates to:
  /// **'Remaining: {days} days'**
  String remainingDays(Object days);

  /// No description provided for @overdueByDays.
  ///
  /// In en, this message translates to:
  /// **'Overdue by {days} days'**
  String overdueByDays(Object days);

  /// No description provided for @taskCountWithAssignee.
  ///
  /// In en, this message translates to:
  /// **'{assignee} ({count} tasks)'**
  String taskCountWithAssignee(Object assignee, Object count);

  /// No description provided for @taskDeadlineDate.
  ///
  /// In en, this message translates to:
  /// **'Deadline: {date}'**
  String taskDeadlineDate(Object date);

  /// No description provided for @greatJob.
  ///
  /// In en, this message translates to:
  /// **'Great job!'**
  String get greatJob;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @getReminders.
  ///
  /// In en, this message translates to:
  /// **'Get reminders about tasks'**
  String get getReminders;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get darkTheme;

  /// No description provided for @useDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Use dark mode'**
  String get useDarkMode;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About app'**
  String get aboutApp;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @aboutDeveloper.
  ///
  /// In en, this message translates to:
  /// **'About developer'**
  String get aboutDeveloper;

  /// No description provided for @taskManager.
  ///
  /// In en, this message translates to:
  /// **'Task management app'**
  String get taskManager;

  /// No description provided for @clearAllTasks.
  ///
  /// In en, this message translates to:
  /// **'Clear all tasks'**
  String get clearAllTasks;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @sureClearTasks.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all tasks?'**
  String get sureClearTasks;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @allTasksCleared.
  ///
  /// In en, this message translates to:
  /// **'All tasks cleared'**
  String get allTasksCleared;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// No description provided for @shopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shopping;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// No description provided for @meetings.
  ///
  /// In en, this message translates to:
  /// **'Meetings'**
  String get meetings;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @sport.
  ///
  /// In en, this message translates to:
  /// **'Sport'**
  String get sport;

  /// No description provided for @reading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get reading;

  /// No description provided for @hobby.
  ///
  /// In en, this message translates to:
  /// **'Hobby'**
  String get hobby;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @clothes.
  ///
  /// In en, this message translates to:
  /// **'Clothes'**
  String get clothes;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @deadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadline;

  /// No description provided for @setDeadline.
  ///
  /// In en, this message translates to:
  /// **'Set deadline'**
  String get setDeadline;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @overallStatistics.
  ///
  /// In en, this message translates to:
  /// **'Overall Statistics'**
  String get overallStatistics;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @percentCompleted.
  ///
  /// In en, this message translates to:
  /// **'% completed'**
  String get percentCompleted;

  /// No description provided for @addTasksForStats.
  ///
  /// In en, this message translates to:
  /// **'📝 Add tasks to view statistics'**
  String get addTasksForStats;

  /// No description provided for @searchTasks.
  ///
  /// In en, this message translates to:
  /// **'Search tasks...'**
  String get searchTasks;

  /// No description provided for @onlyActive.
  ///
  /// In en, this message translates to:
  /// **'Only active'**
  String get onlyActive;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @byPriority.
  ///
  /// In en, this message translates to:
  /// **'by priority'**
  String get byPriority;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @noSorting.
  ///
  /// In en, this message translates to:
  /// **'No sorting'**
  String get noSorting;

  /// No description provided for @noTasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks'**
  String get noTasks;

  /// No description provided for @collaboration.
  ///
  /// In en, this message translates to:
  /// **'Collaboration'**
  String get collaboration;

  /// No description provided for @team.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get team;

  /// No description provided for @createTeam.
  ///
  /// In en, this message translates to:
  /// **'Create a team'**
  String get createTeam;

  /// No description provided for @teamMemberName.
  ///
  /// In en, this message translates to:
  /// **'Team member name'**
  String get teamMemberName;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select role'**
  String get selectRole;

  /// No description provided for @addTeamMember.
  ///
  /// In en, this message translates to:
  /// **'Add team member'**
  String get addTeamMember;

  /// No description provided for @teamMembers.
  ///
  /// In en, this message translates to:
  /// **'Team members'**
  String get teamMembers;

  /// No description provided for @taskDistribution.
  ///
  /// In en, this message translates to:
  /// **'Task distribution'**
  String get taskDistribution;

  /// No description provided for @teamDeadline.
  ///
  /// In en, this message translates to:
  /// **'Team deadline'**
  String get teamDeadline;

  /// No description provided for @taskDuration.
  ///
  /// In en, this message translates to:
  /// **'Task duration'**
  String get taskDuration;

  /// No description provided for @timerLabel.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timerLabel;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @assistantGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi! 👋 I\'m your AI assistant for task management. Ask me about your tasks, team, or productivity!'**
  String get assistantGreeting;

  /// No description provided for @clearConversation.
  ///
  /// In en, this message translates to:
  /// **'Clear conversation'**
  String get clearConversation;

  /// No description provided for @clearConversationTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear conversation?'**
  String get clearConversationTitle;

  /// No description provided for @clearConversationContent.
  ///
  /// In en, this message translates to:
  /// **'All messages will be removed.'**
  String get clearConversationContent;

  /// No description provided for @conversationCleared.
  ///
  /// In en, this message translates to:
  /// **'Conversation cleared. Starting fresh!'**
  String get conversationCleared;

  /// No description provided for @enterQuestion.
  ///
  /// In en, this message translates to:
  /// **'Enter question...'**
  String get enterQuestion;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @deadlines.
  ///
  /// In en, this message translates to:
  /// **'Deadlines'**
  String get deadlines;

  /// No description provided for @productivityAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Productivity Analytics'**
  String get productivityAnalytics;

  /// No description provided for @completedTasksChart.
  ///
  /// In en, this message translates to:
  /// **'Completed Tasks'**
  String get completedTasksChart;

  /// No description provided for @procrastinationAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Procrastination Analysis'**
  String get procrastinationAnalysis;

  /// No description provided for @averageCompletionTime.
  ///
  /// In en, this message translates to:
  /// **'Average Completion Time'**
  String get averageCompletionTime;

  /// No description provided for @workloadForecast.
  ///
  /// In en, this message translates to:
  /// **'Workload Forecast'**
  String get workloadForecast;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @dayOfMonthSuffix.
  ///
  /// In en, this message translates to:
  /// **'th'**
  String get dayOfMonthSuffix;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'morning'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'afternoon'**
  String get afternoon;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'evening'**
  String get evening;

  /// No description provided for @weekdayShortMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayShortMon;

  /// No description provided for @weekdayShortTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayShortTue;

  /// No description provided for @weekdayShortWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayShortWed;

  /// No description provided for @weekdayShortThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayShortThu;

  /// No description provided for @weekdayShortFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayShortFri;

  /// No description provided for @weekdayShortSat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdayShortSat;

  /// No description provided for @weekdayShortSun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdayShortSun;

  /// No description provided for @procrastinationReasons.
  ///
  /// In en, this message translates to:
  /// **'Why didn\'t you complete the task?'**
  String get procrastinationReasons;

  /// No description provided for @tooTiring.
  ///
  /// In en, this message translates to:
  /// **'Too tiring'**
  String get tooTiring;

  /// No description provided for @lackOfTime.
  ///
  /// In en, this message translates to:
  /// **'Lack of time'**
  String get lackOfTime;

  /// No description provided for @lackOfMotivation.
  ///
  /// In en, this message translates to:
  /// **'Lack of motivation'**
  String get lackOfMotivation;

  /// No description provided for @tooComplex.
  ///
  /// In en, this message translates to:
  /// **'Too complex'**
  String get tooComplex;

  /// No description provided for @forgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot'**
  String get forgot;

  /// No description provided for @otherReason.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherReason;

  /// No description provided for @standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standard;

  /// No description provided for @setDefaultDeadline.
  ///
  /// In en, this message translates to:
  /// **'Set default deadline (tomorrow)'**
  String get setDefaultDeadline;

  /// No description provided for @lowPriority.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get lowPriority;

  /// No description provided for @mediumPriority.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get mediumPriority;

  /// No description provided for @highPriority.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get highPriority;

  /// No description provided for @experiencePoints.
  ///
  /// In en, this message translates to:
  /// **'Experience Points'**
  String get experiencePoints;

  /// No description provided for @totalExperience.
  ///
  /// In en, this message translates to:
  /// **'Total Experience'**
  String get totalExperience;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @firstCompletion.
  ///
  /// In en, this message translates to:
  /// **'First Completion'**
  String get firstCompletion;

  /// No description provided for @master5Tasks.
  ///
  /// In en, this message translates to:
  /// **'Master of 5 Tasks'**
  String get master5Tasks;

  /// No description provided for @hero10Tasks.
  ///
  /// In en, this message translates to:
  /// **'Hero of 10 Tasks'**
  String get hero10Tasks;

  /// No description provided for @legend20Tasks.
  ///
  /// In en, this message translates to:
  /// **'Legend of 20 Tasks'**
  String get legend20Tasks;

  /// No description provided for @levelUp.
  ///
  /// In en, this message translates to:
  /// **'Level Up!'**
  String get levelUp;

  /// No description provided for @achievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Achievement Unlocked!'**
  String get achievementUnlocked;

  /// No description provided for @noAchievements.
  ///
  /// In en, this message translates to:
  /// **'No achievements yet'**
  String get noAchievements;

  /// No description provided for @level2.
  ///
  /// In en, this message translates to:
  /// **'Level 2 Reached!'**
  String get level2;

  /// No description provided for @level5.
  ///
  /// In en, this message translates to:
  /// **'Level 5 Reached!'**
  String get level5;

  /// No description provided for @level10.
  ///
  /// In en, this message translates to:
  /// **'Level 10 Reached!'**
  String get level10;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
