/// ROLE
/// - DTO를 도메인 엔티티로 변환한다
///
/// RESPONSIBILITY
/// - foundation classrooms 응답 매핑을 제공한다
///
/// DEPENDS ON
/// - foundation_classrooms_dto
/// - foundation_classrooms_entity
library;

import 'package:web_dashboard/domains/foundation/data/dtos/foundation_classrooms_dto.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/foundation_classrooms_entity.dart';

class FoundationClassroomsMapper {
  const FoundationClassroomsMapper();

  FoundationClassroomsEntity toEntity(FoundationClassroomsResponseDto dto) {
    return FoundationClassroomsEntity(
      foundation: _mapFoundation(dto.foundation),
      classrooms: dto.classrooms.map(_mapClassroom).toList(),
      count: dto.meta.count,
    );
  }

  FoundationSummaryEntity _mapFoundation(FoundationSummaryDto dto) {
    return FoundationSummaryEntity(
      type: FoundationType.fromApi(dto.type),
      id: dto.id,
      name: dto.name,
      code: dto.code,
    );
  }

  FoundationClassroomSummaryEntity _mapClassroom(
    FoundationClassroomDto dto,
  ) {
    return FoundationClassroomSummaryEntity(
      id: dto.id,
      name: dto.name,
      code: dto.code,
      building: dto.building == null ? null : _mapBuilding(dto.building!),
      department:
          dto.department == null ? null : _mapDepartment(dto.department!),
    );
  }

  FoundationBuildingSummaryEntity _mapBuilding(FoundationBuildingDto dto) {
    return FoundationBuildingSummaryEntity(
      id: dto.id,
      name: dto.name,
      code: dto.code,
    );
  }

  FoundationDepartmentSummaryEntity _mapDepartment(
    FoundationDepartmentDto dto,
  ) {
    return FoundationDepartmentSummaryEntity(
      id: dto.id,
      name: dto.name,
      code: dto.code,
    );
  }
}
