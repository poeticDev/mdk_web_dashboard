/// 사용자 API 요약 응답을 표현하는 DTO.
class UserDirectoryDto {
  const UserDirectoryDto({
    required this.id,
    required this.username,
    required this.displayName,
    this.departmentName,
  });

  factory UserDirectoryDto.fromJson(Map<String, Object?> json) {
    return UserDirectoryDto(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      departmentName: json['departmentName'] as String?,
    );
  }

  final String id;
  final String username;
  final String displayName;
  final String? departmentName;
}
