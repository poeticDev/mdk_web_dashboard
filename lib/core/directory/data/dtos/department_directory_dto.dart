/// 학과 API 응답을 파싱하는 DTO.
class DepartmentDirectoryDto {
  const DepartmentDirectoryDto({
    required this.id,
    required this.name,
    this.code,
    this.scope,
  });

  factory DepartmentDirectoryDto.fromJson(Map<String, Object?> json) {
    return DepartmentDirectoryDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      code: json['code'] as String?,
      scope: json['scope'] as String?,
    );
  }

  final String id;
  final String name;
  final String? code;
  final String? scope;
}
