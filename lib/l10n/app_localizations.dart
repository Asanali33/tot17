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

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

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
