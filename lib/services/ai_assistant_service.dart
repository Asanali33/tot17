import '../models/ai_message.dart';
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

    if (lowerMessage.contains('привет') || lowerMessage.contains('здравств') || lowerMessage.contains('hi') || lowerMessage.contains('hello')) {
      return 'Привет! Я AI помощник вашего приложения. Спросите меня о задачах, дедлайнах, команде или приоритете, и я помогу.';
    }

    if (lowerMessage.contains('спасибо') || lowerMessage.contains('thx') || lowerMessage.contains('thank')) {
      return 'Пожалуйста! Если хотите, я могу подсказать, какие задачи стоит закрыть в первую очередь.';
    }

    if (lowerMessage.contains('как дела') || lowerMessage.contains('как ты')) {
      return 'У меня всё отлично, я готов помогать вам планировать задачи и организовывать команду!';
    }

    final totalTasks = taskService.tasks.length;
    final incompleteTasks = taskService.getIncompleteTasksOnly().length;
    final overdueTasks = taskService.getOverdueTasks().length;
    final highPriority = taskService.tasks.where((task) => task.priority == 3 && !task.isDone).length;
    final dueToday = taskService.getTasksDueToday().length;

    if (lowerMessage.contains('задача') || lowerMessage.contains('задач')) {
      if (lowerMessage.contains('сколько') || lowerMessage.contains('количество') || lowerMessage.contains('всего')) {
        return 'У вас всего $totalTasks задач, из них $incompleteTasks незавершенных, '
            '$overdueTasks просроченных и $dueToday актуальных на сегодня.';
      }
      if (lowerMessage.contains('приоритет') || lowerMessage.contains('важн')) {
        return 'Среди незавершенных задач $highPriority имеют высокий приоритет. '
            'Я рекомендую начать с них.';
      }
      if (lowerMessage.contains('дедлайн') || lowerMessage.contains('срок') || lowerMessage.contains('сегодня') || lowerMessage.contains('срочно')) {
        if (dueToday > 0) {
          final tasks = taskService.getTasksDueToday().take(3).map((task) => task.title).join(', ');
          return 'Сегодня нужно закрыть $dueToday задач(и): $tasks. '
              'Начните с тех, у которых дедлайн ближе всего.';
        }
        return 'Сегодня задач с дедлайнами нет. Можно сосредоточиться на важных задачах или добавить новую цель.';
      }
      if (lowerMessage.contains('лучше') || lowerMessage.contains('что делать') || lowerMessage.contains('с чего начать')) {
        final recommendations = taskService.getIncompleteTasksSortedByPriorityAndDeadline();
        if (recommendations.isEmpty) {
          return 'Сейчас нет незавершенных задач. Отличная возможность создать новую задачу и начать планирование.';
        }
        final first = recommendations.first;
        final deadline = first.deadline != null ? _formatDate(first.deadline!) : 'не задан';
        return 'Совет: начните с задачи "${first.title}" (приоритет ${first.priority}, дедлайн $deadline).';
      }
    }

    if (lowerMessage.contains('команда') || lowerMessage.contains('члены')) {
      return 'В вашей команде ${taskService.teamMembers.length} человек. '
          '${taskService.teamMembers.map((m) => m.name).join(', ')}. '
          'Всего задач распределено: ${taskService.tasks.where((t) => t.assignedTo != null).length}.';
    }

    if (lowerMessage.contains('продуктив') || lowerMessage.contains('статистик') || lowerMessage.contains('анализ')) {
      final overview = taskService.getProductivityOverview();
      return 'Ваша статистика: всего создано ${overview['totalTasksCreated']}, '
          'выполнено ${overview['totalTasksCompleted']}, '
          'средний процент выполнения ${overview['averageCompletionRate']}%. '
          'Пропущено дедлайнов: ${overview['missedDeadlines']}.';
    }

    if (lowerMessage.contains('совет') || lowerMessage.contains('помощь') || lowerMessage.contains('как')) {
      return 'Нужно повысить продуктивность? Вот как я могу помочь:\n'
          '1️⃣ Подскажу, какие задачи стоит выполнить в первую очередь\n'
          '2️⃣ Напомню о дедлайнах на сегодня\n'
          '3️⃣ Помогу с командой и распределением\n'
          '4️⃣ Посоветую, как лучше планировать рабочий день';
    }

    if (lowerMessage.contains('роль') || lowerMessage.contains('пермисс') || lowerMessage.contains('права')) {
      return 'Доступные роли:\n'
          '👨‍💻 Разработчик - может назначать задачи и менять статус\n'
          '🧪 Тестировщик - может проверять и комментировать задачи\n'
          '📊 Менеджер - управляет всеми задачами\n'
          '🎨 Дизайнер - отвечает за визуальную часть задач';
    }

    return 'Я AI-помощник по управлению задачами. '
        'Спросите меня о задачах, приоритетах, дедлайнах или команде, и я дам ответ.';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';
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
