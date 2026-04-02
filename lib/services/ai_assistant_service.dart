import '../models/ai_message.dart';
import '../models/task.dart';
import 'task_service.dart';

class AIAssistantService {
  final TaskService taskService;
  late AIAssistantContext context;

  AIAssistantService({required this.taskService}) {
    context = AIAssistantContext();
  }

  Future<String> processMessage(String userMessage) async {
    // Добавляем сообщение пользователя в историю
    context.addMessage(AIMessage(
      content: userMessage,
      sender: 'user',
    ));

    // Генерируем ответ AI
    String response = await _generateAIResponse(userMessage);

    // Добавляем ответ AI в историю
    context.addMessage(AIMessage(
      content: response,
      sender: 'ai',
    ));

    return response;
  }

  Future<String> _generateAIResponse(String userMessage) async {
    // Имитация задержки API запроса
    await Future.delayed(const Duration(milliseconds: 500));

    final lowerMessage = userMessage.toLowerCase();

    // Помощь с задачами
    if (lowerMessage.contains('задача') || lowerMessage.contains('задач')) {
      if (lowerMessage.contains('сколько') || lowerMessage.contains('количество')) {
        return 'У вас всего ${taskService.tasks.length} задач. '
            'Из них выполнено ${taskService.completedTotal}, в процессе ${taskService.tasks.where((t) => !t.isDone).length}. '
            'Ваш уровень: ${taskService.level}, опыт: ${taskService.experience} XP.';
      }
      if (lowerMessage.contains('приоритет') || lowerMessage.contains('важн')) {
        final highPriority = taskService.tasks.where((t) => t.priority == 3).length;
        return 'У вас $highPriority задач с высоким приоритетом. '
            'Рекомендую сначала сосредоточиться на них!';
      }
      if (lowerMessage.contains('дедлайн') || lowerMessage.contains('время')) {
        final upcoming = taskService.getUpcomingDeadlines();
        if (upcoming.isEmpty) {
          return 'Хорошие новости! Приближающихся дедлайнов нет.';
        }
        return 'У вас ${upcoming.length} задач с дедлайнами в ближайшие 3 дня. '
            'Не забудьте про них!';
      }
    }

    // Помощь с командой
    if (lowerMessage.contains('команда') || lowerMessage.contains('члены')) {
      return 'В вашей команде ${taskService.teamMembers.length} человек. '
          '${taskService.teamMembers.map((m) => m.name).join(', ')}. '
          'Всего задач распределено: ${taskService.tasks.where((t) => t.assignedTo != null).length}.';
    }

    // Помощь с продуктивностью
    if (lowerMessage.contains('продуктив') || lowerMessage.contains('статистик')) {
      final overview = taskService.getProductivityOverview();
      return 'Ваша статистика: '
          'Всего создано задач: ${overview['totalTasksCreated']}, '
          'Выполнено: ${overview['totalTasksCompleted']}, '
          'Процент выполнения: ${overview['averageCompletionRate']}%. '
          'Пропущено дедлайнов: ${overview['missedDeadlines']}.';
    }

    // Советы и рекомендации
    if (lowerMessage.contains('совет') || lowerMessage.contains('помощь') || lowerMessage.contains('как')) {
      return 'Вот несколько советов для повышения продуктивности:\n'
          '1️⃣ Устанавливайте реалистичные дедлайны для задач\n'
          '2️⃣ Разбивайте большие задачи на подзадачи\n'
          '3️⃣ Добавляйте комментарии и отслеживайте прогресс\n'
          '4️⃣ Назначайте ответственных людей для командных задач\n'
          '5️⃣ Регулярно проверяйте аналитику и статистику';
    }

    // Помощь с ролями
    if (lowerMessage.contains('роль') || lowerMessage.contains('пермисс')) {
      return 'Доступные роли:\n'
          '👨‍💻 Разработчик - может назначать задачи и менять статус\n'
          '🧪 Тестировщик - может проверять и оставлять комментарии\n'
          '📊 Менеджер - управляет всем и всеми\n'
          '🎨 Дизайнер - отвечает за дизайн задач';
    }

    // Общие ответы
    return 'Я помощник по управлению задачами! 🤖\n'
        'Я могу помочь вам с:\n'
        '📋 Информацией о задачах\n'
        '👥 Управлением командой\n'
        '📊 Статистикой продуктивности\n'
        '💡 Советами и рекомендациями\n\n'
        'Спросите меня о чем-нибудь!';
  }

  void setTaskFocus(int? taskIndex) {
    context.currentTaskFocus = taskIndex?.toString();
  }

  void clearConversation() {
    context.clearHistory();
  }

  List<AIMessage> getConversationHistory() {
    return context.conversationHistory;
  }

  String getSummary() {
    final totalMessages = context.conversationHistory.length;
    final userMessages = context.conversationHistory
        .where((m) => m.sender == 'user')
        .length;
    return 'Диалог: $totalMessages сообщений ($userMessages от вас)';
  }
}
