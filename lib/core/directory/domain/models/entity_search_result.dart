import 'package:web_dashboard/core/directory/domain/models/pagination_meta.dart';

/// 백엔드 페이지 응답을 앱 내부 모델로 감싸는 공통 래퍼.
class EntitySearchResult<T> {
  const EntitySearchResult({required this.items, required this.meta});

  final List<T> items;
  final PaginationMeta meta;

  bool get hasMore => meta.hasNext;
}
