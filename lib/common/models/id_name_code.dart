/// ROLE
/// - 공통 요약 모델을 정의한다
///
/// RESPONSIBILITY
/// - ID/이름/코드 조합을 재사용한다
///
/// DEPENDS ON
/// - 없음
library;

class IdNameCode {
  const IdNameCode({
    required this.id,
    required this.name,
    this.code,
  });

  final String id;
  final String name;
  final String? code;
}
