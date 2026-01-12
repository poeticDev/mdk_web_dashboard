/// 페이지네이션 정보를 표현하는 공통 메타 모델.
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
