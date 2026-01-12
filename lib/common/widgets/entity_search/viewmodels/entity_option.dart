/// 검색 결과를 UI 친화적 구조로 래핑한 뷰모델.
class EntityOption {
  const EntityOption({
    required this.id,
    required this.label,
    this.subtitle,
    this.metadata = const <String, Object?>{},
  });

  final String id;
  final String label;
  final String? subtitle;
  final Map<String, Object?> metadata;
}
