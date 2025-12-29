/// 학과 검색 결과를 표현하는 도메인 엔티티.
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
