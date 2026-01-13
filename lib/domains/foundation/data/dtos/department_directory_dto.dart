/// ROLE
/// - API DTO를 정의한다
///
/// RESPONSIBILITY
/// - 응답/요청 필드를 모델링한다
/// - JSON 변환을 제공한다
///
/// DEPENDS ON
/// - 없음
library;

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
