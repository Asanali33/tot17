class Role {
  String name;
  String description;
  List<String> permissions; // список разрешений: 'assign_tasks', 'edit_comments', 'change_deadlines', etc.

  Role({
    required this.name,
    required this.description,
    required this.permissions,
  });

  // Предопределенные роли
  static Role developer = Role(
    name: 'Разработчик',
    description: 'Отвечает за разработку и реализацию задач',
    permissions: ['assign_tasks', 'edit_comments', 'change_status'],
  );

  static Role tester = Role(
    name: 'Тестировщик',
    description: 'Отвечает за тестирование и проверку качества',
    permissions: ['edit_comments', 'change_status', 'review_tasks'],
  );

  static Role manager = Role(
    name: 'Менеджер',
    description: 'Координирует работу команды и управляет задачами',
    permissions: ['assign_tasks', 'edit_comments', 'change_deadlines', 'manage_team'],
  );

  static Role designer = Role(
    name: 'Дизайнер',
    description: 'Отвечает за дизайн и пользовательский интерфейс',
    permissions: ['edit_comments', 'change_status'],
  );

  static List<Role> get predefinedRoles => [
    developer,
    tester,
    manager,
    designer,
  ];

  bool hasPermission(String permission) {
    return permissions.contains(permission);
  }
}