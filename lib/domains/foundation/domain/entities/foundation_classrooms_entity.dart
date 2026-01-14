/// ROLE
/// - 도메인 엔티티를 정의한다
///
/// RESPONSIBILITY
/// - Foundation 기준 강의실 목록을 표현한다
///
/// DEPENDS ON
/// - 없음
library;

/// Foundation 조회 타입.
enum FoundationType {
  site('site'),
  building('building'),
  department('department');

  const FoundationType(this.apiValue);

  final String apiValue;

  static FoundationType fromApi(String value) {
    switch (value.toLowerCase()) {
      case 'building':
        return FoundationType.building;
      case 'department':
        return FoundationType.department;
      case 'site':
      default:
        return FoundationType.site;
    }
  }
}

/// Foundation 기준 강의실 목록 응답 엔티티.
class FoundationClassroomsEntity {
  const FoundationClassroomsEntity({
    required this.foundation,
    required this.classrooms,
    required this.count,
  });

  final FoundationSummaryEntity foundation;
  final List<FoundationClassroomSummaryEntity> classrooms;
  final int count;
}

/// Foundation 요약 정보 엔티티.
class FoundationSummaryEntity {
  const FoundationSummaryEntity({
    required this.type,
    required this.id,
    required this.name,
    this.code,
  });

  final FoundationType type;
  final String id;
  final String name;
  final String? code;
}

/// 강의실 요약 정보 엔티티.
class FoundationClassroomSummaryEntity {
  const FoundationClassroomSummaryEntity({
    required this.id,
    required this.name,
    this.code,
    this.building,
    this.department,
  });

  final String id;
  final String name;
  final String? code;
  final FoundationBuildingSummaryEntity? building;
  final FoundationDepartmentSummaryEntity? department;
}

/// 건물 요약 엔티티.
class FoundationBuildingSummaryEntity {
  const FoundationBuildingSummaryEntity({
    required this.id,
    required this.name,
    this.code,
  });

  final String id;
  final String name;
  final String? code;
}

/// 학과 요약 엔티티.
class FoundationDepartmentSummaryEntity {
  const FoundationDepartmentSummaryEntity({
    required this.id,
    required this.name,
    this.code,
  });

  final String id;
  final String name;
  final String? code;
}

/// Foundation 기준 강의실 조회 입력 값.
class FoundationClassroomsQuery {
  const FoundationClassroomsQuery({
    required this.type,
    required this.foundationId,
  });

  final FoundationType type;
  final String foundationId;
}
