class UserDirectoryEntity {
  const UserDirectoryEntity({
    required this.id,
    required this.username,
    required this.displayName,
    this.departmentName,
  });

  final String id;
  final String username;
  final String displayName;
  final String? departmentName;
}
