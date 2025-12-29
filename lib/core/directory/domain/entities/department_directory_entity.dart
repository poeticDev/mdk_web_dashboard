class DepartmentDirectoryEntity {
  const DepartmentDirectoryEntity({
    required this.id,
    required this.name,
    this.code,
    this.scope,
  });

  final String id;
  final String name;
  final String? code;
  final String? scope;
}
