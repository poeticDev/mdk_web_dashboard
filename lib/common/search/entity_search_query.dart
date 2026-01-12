/// 검색 키워드·페이지 사이즈를 통일된 형태로 전달하는 값 객체.
class EntitySearchQuery {
  const EntitySearchQuery({
    this.keyword,
    this.page = 1,
    this.limit = 20,
  })  : assert(page > 0, 'page must be positive'),
        assert(limit > 0, 'limit must be positive');

  final String? keyword;
  final int page;
  final int limit;

  String get normalizedKeyword => keyword?.trim() ?? '';
}
