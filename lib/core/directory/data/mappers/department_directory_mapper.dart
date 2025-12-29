import 'package:web_dashboard/core/directory/data/dtos/department_directory_dto.dart';
import 'package:web_dashboard/core/directory/domain/entities/department_directory_entity.dart';

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
