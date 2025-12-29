import 'package:web_dashboard/core/directory/application/viewmodels/entity_option.dart';

/// 검색 쿼리·결과·선택 여부를 표현하는 UI 상태 모델.
class EntitySearchState {
  const EntitySearchState({
    required this.query,
    required this.page,
    required this.options,
    required this.hasMore,
    this.isLoadingMore = false,
    this.selected,
  });

  factory EntitySearchState.initial({String query = ''}) {
    return EntitySearchState(
      query: query,
      page: 1,
      options: const <EntityOption>[],
      hasMore: false,
    );
  }

  final String query;
  final int page;
  final List<EntityOption> options;
  final bool hasMore;
  final bool isLoadingMore;
  final EntityOption? selected;

  EntitySearchState copyWith({
    String? query,
    int? page,
    List<EntityOption>? options,
    bool? hasMore,
    bool? isLoadingMore,
    EntityOption? selected,
    bool clearSelection = false,
  }) {
    return EntitySearchState(
      query: query ?? this.query,
      page: page ?? this.page,
      options: options ?? this.options,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      selected: clearSelection ? null : (selected ?? this.selected),
    );
  }
}
