/// ROLE
/// - 유저 검색 결과를 표현하는 엔티티다
///
/// RESPONSIBILITY
/// - 검색 결과 표시용 필드를 보관한다
///
/// DEPENDS ON
/// - 없음
library;

/// 유저 검색 결과 요약을 담는 도메인 엔티티.
class UserDirectoryEntity {
  const UserDirectoryEntity({
    required this.id,
    required this.username,
    required this.displayName,
    this.departmentName,
  });

  final String id;
  final String username;
  final String displayName;
  final String? departmentName;
}
