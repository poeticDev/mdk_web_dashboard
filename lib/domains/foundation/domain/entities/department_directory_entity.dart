/// ROLE
/// - 도메인 엔티티를 정의한다
///
/// RESPONSIBILITY
/// - 핵심 필드를 보관한다
/// - 도메인 모델을 제공한다
///
/// DEPENDS ON
/// - 없음
library;

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
