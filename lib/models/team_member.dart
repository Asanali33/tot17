class TeamMember {
  String id;
  String name;
  String role; // разработчик, тестировщик, менеджер и т.д.
  String? avatarUrl;
  bool isActive;

  TeamMember({
    required this.id,
    required this.name,
    required this.role,
    this.avatarUrl,
    this.isActive = true,
  });
}
