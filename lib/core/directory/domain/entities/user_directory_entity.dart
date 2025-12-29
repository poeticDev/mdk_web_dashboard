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
