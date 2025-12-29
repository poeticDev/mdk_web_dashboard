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
