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

/// 강의실이 속한 건물 정보를 표현하는 엔티티.
class BuildingEntity {
  const BuildingEntity({
    required this.id,
    required this.name,
    this.code,
  });

  final String id;
  final String name;
  final String? code;
}
