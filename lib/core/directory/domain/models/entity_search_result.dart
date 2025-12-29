import 'package:web_dashboard/core/directory/domain/models/pagination_meta.dart';

class EntitySearchResult<T> {
  const EntitySearchResult({required this.items, required this.meta});

  final List<T> items;
  final PaginationMeta meta;

  bool get hasMore => meta.hasNext;
}
