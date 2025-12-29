import 'package:web_dashboard/core/directory/data/dtos/department_directory_dto.dart';
import 'package:web_dashboard/core/directory/domain/entities/department_directory_entity.dart';

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
