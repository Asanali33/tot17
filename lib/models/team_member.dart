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

  Map<String, dynamic> toJson() {
    return {
      'memberId': id,
      'name': name,
      'role': {
        'name': role.name,
        'description': role.description,
        'permissions': role.permissions,
      },
      'avatarUrl': avatarUrl,
      'isActive': isActive,
      'skills': skills,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    final roleJson = json['role'] ?? {};
    final role = Role(
      name: roleJson['name'] ?? 'Разработчик',
      description: roleJson['description'] ?? '',
      permissions: (roleJson['permissions'] as List<dynamic>?)
              ?.map((p) => p.toString())
              .toList() ??
          [],
    );

    return TeamMember(
      id: json['memberId']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      role: role,
      avatarUrl: json['avatarUrl'],
      isActive: json['isActive'] ?? true,
      skills: (json['skills'] as List<dynamic>?)
              ?.map((s) => s.toString())
              .toList() ??
          [],
      joinedAt: json['joinedAt'] != null
          ? DateTime.parse(json['joinedAt'])
          : DateTime.now(),
    );
  }
}
