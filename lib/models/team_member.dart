import 'role.dart';

class TeamMember {
  String id;
  String name;
  Role role; // теперь Role вместо String
  String? avatarUrl;
  bool isActive;
  List<String> skills; // навыки члена команды
  DateTime joinedAt;

  TeamMember({
    required this.id,
    required this.name,
    required this.role,
    this.avatarUrl,
    this.isActive = true,
    this.skills = const [],
    DateTime? joinedAt,
  }) : joinedAt = joinedAt ?? DateTime.now();

  // Для обратной совместимости
  TeamMember.fromLegacy({
    required String id,
    required String name,
    required String roleName,
    String? avatarUrl,
    bool isActive = true,
  }) : this(
    id: id,
    name: name,
    role: Role.predefinedRoles.firstWhere(
      (r) => r.name == roleName,
      orElse: () => Role(
        name: roleName,
        description: 'Пользовательская роль',
        permissions: ['edit_comments'],
      ),
    ),
    avatarUrl: avatarUrl,
    isActive: isActive,
  );
}
