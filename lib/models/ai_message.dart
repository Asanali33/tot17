class AIMessage {
  String content;
  String sender; // 'user' or 'ai'
  DateTime createdAt;
  String? taskRelated; // ID задачи, если сообщение относится к задаче

  AIMessage({
    required this.content,
    required this.sender,
    DateTime? createdAt,
    this.taskRelated,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'sender': sender,
      'createdAt': createdAt.toIso8601String(),
      'taskRelated': taskRelated,
    };
  }

  factory AIMessage.fromJson(Map<String, dynamic> json) {
    return AIMessage(
      content: json['content'] as String,
      sender: json['sender'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      taskRelated: json['taskRelated'] as String?,
    );
  }
}

class AIAssistantContext {
  List<AIMessage> conversationHistory;
  String? currentTaskFocus; // фокус на конкретную задачу
  String? currentTeamFocus; // фокус на команду

  AIAssistantContext({
    this.conversationHistory = const [],
    this.currentTaskFocus,
    this.currentTeamFocus,
  });

  void clearHistory() {
    conversationHistory = [];
  }

  void addMessage(AIMessage message) {
    conversationHistory.add(message);
  }
}
