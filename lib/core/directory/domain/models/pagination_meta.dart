class PaginationMeta {
  const PaginationMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasPrev,
    required this.hasNext,
  });

  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasPrev;
  final bool hasNext;
}
