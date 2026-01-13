/// ROLE
/// - 유저 디렉터리 DTO를 엔티티로 변환한다
///
/// RESPONSIBILITY
/// - DTO를 UserDirectoryEntity로 매핑한다
///
/// DEPENDS ON
/// - user_directory_dto
/// - user_directory_entity
library;

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
