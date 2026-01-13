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
