// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'TaskFlow';

  @override
  String get tasks => 'Задачи';

  @override
  String get statistics => 'Статистика';

  @override
  String get settings => 'Настройки';

  @override
  String get enterTask => 'Введите задачу...';

  @override
  String get add => 'Добавить';

  @override
  String get general => 'Общее';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get completed => 'Выполнено';

  @override
  String get selectCategory => 'Выбрать категорию';

  @override
  String get editTask => 'Редактировать задачу';

  @override
  String get newTaskTitle => 'Новое название задачи';

  @override
  String get addComment => 'Добавить комментарий';

  @override
  String get enterCommentText => 'Введите текст комментария';

  @override
  String get deadlineNotSelectedAddWithoutDeadline =>
      'Дедлайн не выбран. Добавить задачу без дедлайна?';

  @override
  String get taskDurationTitle => 'Установить время выполнения';

  @override
  String totalDuration(Object duration) {
    return 'Итого: $duration';
  }

  @override
  String get skip => 'Пропустить';

  @override
  String get setDuration => 'Установить';

  @override
  String get notSet => 'Не установлено';

  @override
  String get assign => 'Назначить';

  @override
  String get unassigned => 'Не назначено';

  @override
  String get priorityLabel => 'Приоритет:';

  @override
  String get comments => 'Комментарии:';

  @override
  String get edited => ' (изменено)';

  @override
  String get enterNameAndSelectRole => 'Введите имя и выберите роль';

  @override
  String get addedToTeam => 'добавлен в команду';

  @override
  String get manageDeadlines => 'Управление дедлайнами';

  @override
  String get overdueTasks => 'Просроченные задачи';

  @override
  String get deadlinesToday => 'Дедлайны сегодня';

  @override
  String get noUrgentDeadlines => 'Нет срочных дедлайнов!\nХорошая работа!';

  @override
  String get otherTasksFine => 'Остальные задачи в норме ✅';

  @override
  String get totalTasksCreated => 'Всего задач создано';

  @override
  String get tasksCompleted => 'Задач выполнено';

  @override
  String get averagePercentage => 'Средний %';

  @override
  String get missedDeadlines => 'Пропущено дедлайнов';

  @override
  String get whenMostProductive => 'Когда ты продуктивнее всего';

  @override
  String get mostProductiveHour => 'Самый продуктивный час';

  @override
  String get completeImportantTasks => 'Выполняй важные задачи в это время!';

  @override
  String get mostProductiveDay => 'Самый продуктивный день';

  @override
  String completedOfTotal(Object completed, Object total) {
    return 'Выполнено $completed из $total задач';
  }

  @override
  String completionTimeLabel(Object times) {
    return 'Время завершения: $times';
  }

  @override
  String get tasksByCategory => 'Задачи по категориям';

  @override
  String tasksCountSummary(Object count) {
    return '$count задач';
  }

  @override
  String get dailyStatistics => 'Статистика по дням';

  @override
  String get noDataLastDays => 'Нет данных за последние дни';

  @override
  String get notSetLabel => 'Не установлено';

  @override
  String remainingDays(Object days) {
    return 'Осталось: $days дней';
  }

  @override
  String overdueByDays(Object days) {
    return 'Просрочено на $days дней';
  }

  @override
  String taskCountWithAssignee(Object assignee, Object count) {
    return '$assignee ($count задач)';
  }

  @override
  String taskDeadlineDate(Object date) {
    return 'Дедлайн: $date';
  }

  @override
  String get greatJob => 'Хорошая работа!';

  @override
  String get notifications => 'Уведомления';

  @override
  String get getReminders => 'Получайте напоминания о задачах';

  @override
  String get darkTheme => 'Тёмная тема';

  @override
  String get useDarkMode => 'Использовать тёмный режим';

  @override
  String get aboutApp => 'О приложении';

  @override
  String get version => 'Версия';

  @override
  String get aboutDeveloper => 'О разработчике';

  @override
  String get taskManager => 'Приложение для управления задачами';

  @override
  String get clearAllTasks => 'Очистить все задачи';

  @override
  String get confirm => 'Подтверждение';

  @override
  String get sureClearTasks => 'Вы уверены, что хотите очистить все задачи?';

  @override
  String get clear => 'Очистить';

  @override
  String get allTasksCleared => 'Все задачи очищены';

  @override
  String get work => 'Работа';

  @override
  String get personal => 'Личное';

  @override
  String get shopping => 'Покупки';

  @override
  String get projects => 'Проекты';

  @override
  String get meetings => 'Встречи';

  @override
  String get reports => 'Отчеты';

  @override
  String get other => 'Прочее';

  @override
  String get sport => 'Спорт';

  @override
  String get reading => 'Чтение';

  @override
  String get hobby => 'Хобби';

  @override
  String get food => 'Продукты';

  @override
  String get clothes => 'Одежда';

  @override
  String get home => 'Дом';

  @override
  String get deadline => 'Дедлайн';

  @override
  String get setDeadline => 'Установить дедлайн';

  @override
  String get language => 'Язык';

  @override
  String get selectLanguage => 'Выбрать язык';

  @override
  String get russian => 'Русский';

  @override
  String get english => 'Английский';

  @override
  String get overallStatistics => 'Общая статистика';

  @override
  String get total => 'Всего';

  @override
  String get remaining => 'Осталось';

  @override
  String get progress => 'Прогресс выполнения';

  @override
  String get percentCompleted => '% выполнено';

  @override
  String get addTasksForStats => '📝 Добавьте задачи для просмотра статистики';

  @override
  String get searchTasks => 'Поиск задач...';

  @override
  String get onlyActive => 'Только активные';

  @override
  String get priority => 'Приоритет';

  @override
  String get byPriority => 'по приоритету';

  @override
  String get date => 'Дата';

  @override
  String get noSorting => 'Нет сортировки';

  @override
  String get noTasks => 'Нет задач';

  @override
  String get collaboration => 'Коллаборация';

  @override
  String get team => 'Команда';

  @override
  String get createTeam => 'Создайте команду';

  @override
  String get teamMemberName => 'Имя члена команды';

  @override
  String get name => 'Имя';

  @override
  String get role => 'Роль';

  @override
  String get selectRole => 'Выберите роль';

  @override
  String get addTeamMember => 'Добавить члена команды';

  @override
  String get teamMembers => 'Члены команды';

  @override
  String get taskDistribution => 'Распределение задач';

  @override
  String get teamDeadline => 'Командный дедлайн';

  @override
  String get taskDuration => 'Время выполнения';

  @override
  String get timerLabel => 'Таймер';

  @override
  String get aiAssistant => 'AI-помощник';

  @override
  String get assistantGreeting =>
      'Привет! 👋 Я AI-помощник вашего приложения для управления задачами. Спросите меня о ваших задачах, команде или продуктивности!';

  @override
  String get clearConversation => 'Очистить диалог';

  @override
  String get clearConversationTitle => 'Очистить диалог?';

  @override
  String get clearConversationContent => 'Вся история сообщений будет удалена.';

  @override
  String get conversationCleared => 'Диалог очищен. Начнем с чистого листа!';

  @override
  String get enterQuestion => 'Введите вопрос...';

  @override
  String get analytics => 'Аналитика';

  @override
  String get overview => 'Обзор';

  @override
  String get deadlines => 'Дедлайны';

  @override
  String get productivityAnalytics => 'Аналитика продуктивности';

  @override
  String get completedTasksChart => 'Выполненные задачи';

  @override
  String get procrastinationAnalysis => 'Анализ прокрастинации';

  @override
  String get averageCompletionTime => 'Среднее время выполнения';

  @override
  String get workloadForecast => 'Прогноз загрузки';

  @override
  String get noData => 'Нет данных';

  @override
  String get days => 'дней';

  @override
  String get dayOfMonthSuffix => ' числа';

  @override
  String get hours => 'часов';

  @override
  String get minutes => 'минут';

  @override
  String get seconds => 'секунд';

  @override
  String get morning => 'утро';

  @override
  String get afternoon => 'день';

  @override
  String get evening => 'вечер';

  @override
  String get weekdayShortMon => 'Пн';

  @override
  String get weekdayShortTue => 'Вт';

  @override
  String get weekdayShortWed => 'Ср';

  @override
  String get weekdayShortThu => 'Чт';

  @override
  String get weekdayShortFri => 'Пт';

  @override
  String get weekdayShortSat => 'Сб';

  @override
  String get weekdayShortSun => 'Вс';

  @override
  String get procrastinationReasons => 'Почему не выполнил задачу?';

  @override
  String get tooTiring => 'Слишком утомительно';

  @override
  String get lackOfTime => 'Недостаток времени';

  @override
  String get lackOfMotivation => 'Отсутствие мотивации';

  @override
  String get tooComplex => 'Слишком сложно';

  @override
  String get forgot => 'Забыл';

  @override
  String get otherReason => 'Другое';

  @override
  String get standard => 'Стандартные';

  @override
  String get setDefaultDeadline => 'Установить дедлайн по умолчанию (завтра)';

  @override
  String get lowPriority => 'Низкий';

  @override
  String get mediumPriority => 'Средний';

  @override
  String get highPriority => 'Высокий';

  @override
  String get experiencePoints => 'Очки опыта';

  @override
  String get totalExperience => 'Общий опыт';

  @override
  String get level => 'Уровень';

  @override
  String get achievements => 'Достижения';

  @override
  String get firstCompletion => 'Первое выполнение';

  @override
  String get master5Tasks => 'Мастер 5 задач';

  @override
  String get hero10Tasks => 'Герой 10 задач';

  @override
  String get legend20Tasks => 'Легенда 20 задач';

  @override
  String get levelUp => 'Новый уровень!';

  @override
  String get achievementUnlocked => 'Достижение разблокировано!';

  @override
  String get noAchievements => 'Нет достижений';

  @override
  String get level2 => 'Уровень 2 достигнут!';

  @override
  String get level5 => 'Уровень 5 достигнут!';

  @override
  String get level10 => 'Уровень 10 достигнут!';
}
