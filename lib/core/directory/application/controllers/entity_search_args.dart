/// 검색 대상 타입을 구분하는 열거형.
enum EntitySearchType { department, user }

/// 컨트롤러 family 인자를 캡슐화한 설정 객체.
class EntitySearchArgs {
  const EntitySearchArgs({
    required this.type,
    this.limit = 20,
    this.initialQuery,
    this.initialSelection,
  });

  final EntitySearchType type;
  final int limit;
  final String? initialQuery;
  final String? initialSelection;
}
