/// ROLE
/// - DTO와 엔티티 변환을 담당한다
///
/// RESPONSIBILITY
/// - DTO를 도메인 모델로 변환한다
/// - 요청 모델을 구성한다
///
/// DEPENDS ON
/// - department_directory_dto
/// - department_directory_entity
library;

import 'package:web_dashboard/domains/foundation/data/dtos/department_directory_dto.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/department_directory_entity.dart';

/// 학과 DTO를 도메인 엔티티로 변환하는 전담 매퍼.
class DepartmentDirectoryMapper {
  const DepartmentDirectoryMapper();

  DepartmentDirectoryEntity toEntity(DepartmentDirectoryDto dto) {
    return DepartmentDirectoryEntity(
      id: dto.id,
      name: dto.name,
      code: dto.code,
      scope: dto.scope,
    );
  }
}
