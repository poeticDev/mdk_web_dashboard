import 'package:web_dashboard/core/directory/data/dtos/user_directory_dto.dart';
import 'package:web_dashboard/core/directory/domain/entities/user_directory_entity.dart';

class UserDirectoryMapper {
  const UserDirectoryMapper();

  UserDirectoryEntity toEntity(UserDirectoryDto dto) {
    return UserDirectoryEntity(
      id: dto.id,
      username: dto.username,
      displayName: dto.displayName,
      departmentName: dto.departmentName,
    );
  }
}
