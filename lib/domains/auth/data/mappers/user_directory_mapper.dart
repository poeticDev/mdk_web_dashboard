import 'package:web_dashboard/domains/auth/data/dtos/user_directory_dto.dart';
import 'package:web_dashboard/domains/auth/domain/entities/user_directory_entity.dart';

/// 유저 DTO → 도메인 엔티티 변환을 담당하는 매퍼.
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
