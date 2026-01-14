/// ROLE
/// - DTO를 읽기 모델로 변환한다
///
/// RESPONSIBILITY
/// - foundation classrooms 응답 매핑을 제공한다
///
/// DEPENDS ON
/// - foundation_classrooms_dto
/// - foundation_classrooms_read_model
library;

import 'package:web_dashboard/common/models/id_name_code.dart';
import 'package:web_dashboard/domains/foundation/data/dtos/foundation_classrooms_dto.dart';
import 'package:web_dashboard/domains/foundation/application/read_models/classroom_summary.dart';
import 'package:web_dashboard/domains/foundation/application/read_models/foundation_classrooms_read_model.dart';

class FoundationClassroomsMapper {
  const FoundationClassroomsMapper();

  FoundationClassroomsReadModel toReadModel(
    FoundationClassroomsResponseDto dto,
  ) {
    return FoundationClassroomsReadModel(
      foundation: _mapFoundation(dto.foundation),
      classrooms: dto.classrooms.map(_mapClassroom).toList(),
      count: dto.meta.count,
    );
  }

  FoundationSummaryReadModel _mapFoundation(FoundationSummaryDto dto) {
    return FoundationSummaryReadModel(
      type: FoundationType.fromApi(dto.type),
      summary: IdNameCode(
        id: dto.id,
        name: dto.name,
        code: dto.code,
      ),
    );
  }

  ClassroomSummary _mapClassroom(
    FoundationClassroomDto dto,
  ) {
    return ClassroomSummary(
      id: dto.id,
      name: dto.name,
      code: dto.code,
      building: _mapBuilding(dto.building),
      department: _mapDepartment(dto.department),
    );
  }

  IdNameCode? _mapBuilding(FoundationBuildingDto? dto) {
    if (dto == null) {
      return null;
    }
    return IdNameCode(id: dto.id, name: dto.name, code: dto.code);
  }

  IdNameCode? _mapDepartment(FoundationDepartmentDto? dto) {
    if (dto == null) {
      return null;
    }
    return IdNameCode(id: dto.id, name: dto.name, code: dto.code);
  }
}
