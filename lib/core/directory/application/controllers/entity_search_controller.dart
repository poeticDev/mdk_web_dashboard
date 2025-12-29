import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_dashboard/core/directory/application/controllers/entity_search_args.dart';
import 'package:web_dashboard/core/directory/application/directory_providers.dart';
import 'package:web_dashboard/core/directory/application/state/entity_search_state.dart';
import 'package:web_dashboard/core/directory/application/viewmodels/entity_option.dart';
import 'package:web_dashboard/core/directory/domain/entities/department_directory_entity.dart';
import 'package:web_dashboard/core/directory/domain/entities/user_directory_entity.dart';
import 'package:web_dashboard/core/directory/domain/models/entity_search_query.dart';
import 'package:web_dashboard/core/directory/domain/models/entity_search_result.dart';
import 'package:web_dashboard/core/directory/domain/models/pagination_meta.dart';

part 'entity_search_controller.g.dart';

/// 학과/유저 검색 요청을 수행하고 Riverpod 상태를 노출하는 컨트롤러.
@riverpod
class EntitySearchController extends _$EntitySearchController {
  late EntitySearchArgs _args;
  int _requestId = 0;

  @override
  Future<EntitySearchState> build(EntitySearchArgs args) async {
    _args = args;
    final String initialQuery = args.initialQuery?.trim() ?? '';
    if (initialQuery.isEmpty) {
      return EntitySearchState.initial();
    }
    final _SearchPayload payload = await _fetch(initialQuery, 1);
    return _buildStateFromPayload(
      query: initialQuery,
      payload: payload,
      reset: true,
    );
  }

  Future<void> search(String rawQuery) async {
    final String query = rawQuery.trim();
    final int requestKey = ++_requestId;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (query.isEmpty) {
        return EntitySearchState.initial();
      }
      final _SearchPayload payload = await _fetch(query, 1);
      if (requestKey != _requestId) {
        return state.asData?.value ?? EntitySearchState.initial();
      }
      return _buildStateFromPayload(
        query: query,
        payload: payload,
        reset: true,
      );
    });
  }

  Future<void> loadMore() async {
    final EntitySearchState? current = state.asData?.value;
    if (current == null || !current.hasMore || current.isLoadingMore) {
      return;
    }
    state = AsyncValue.data(current.copyWith(isLoadingMore: true));
    final _SearchPayload payload = await _fetch(
      current.query,
      current.page + 1,
    );
    final List<EntityOption> merged = <EntityOption>[
      ...current.options,
      ...payload.options,
    ];
    state = AsyncValue.data(
      current.copyWith(
        options: merged,
        page: payload.meta.page,
        hasMore: payload.meta.hasNext,
        isLoadingMore: false,
      ),
    );
  }

  void selectOption(EntityOption option) {
    final EntitySearchState next =
        (state.asData?.value ?? EntitySearchState.initial())
            .copyWith(selected: option);
    state = AsyncValue.data(next);
  }

  void clearSelection() {
    final EntitySearchState? current = state.asData?.value;
    if (current == null) {
      return;
    }
    state = AsyncValue.data(current.copyWith(clearSelection: true));
  }

  Future<_SearchPayload> _fetch(String query, int page) async {
    final EntitySearchQuery request = EntitySearchQuery(
      keyword: query,
      page: page,
      limit: _args.limit,
    );
    switch (_args.type) {
      case EntitySearchType.department:
        final searchDepartments = ref.read(searchDepartmentsUseCaseProvider);
        final EntitySearchResult<DepartmentDirectoryEntity> result =
            await searchDepartments.execute(request);
        return _SearchPayload(
          options: result.items
              .map(
                (DepartmentDirectoryEntity entity) => EntityOption(
                  id: entity.id,
                  label: entity.name,
                  subtitle: entity.code,
                ),
              )
              .toList(),
          meta: result.meta,
        );
      case EntitySearchType.user:
        final searchUsers = ref.read(searchUsersUseCaseProvider);
        final EntitySearchResult<UserDirectoryEntity> result =
            await searchUsers.execute(request);
        return _SearchPayload(
          options: result.items
              .map(
                (UserDirectoryEntity entity) => EntityOption(
                  id: entity.id,
                  label: entity.displayName,
                  subtitle: entity.departmentName ?? entity.username,
                ),
              )
              .toList(),
          meta: result.meta,
        );
    }
  }

  EntitySearchState _buildStateFromPayload({
    required String query,
    required _SearchPayload payload,
    required bool reset,
  }) {
    final List<EntityOption> options = reset
        ? payload.options
        : <EntityOption>[
            ...(state.asData?.value?.options ?? const <EntityOption>[]),
            ...payload.options,
          ];
    return EntitySearchState(
      query: query,
      page: payload.meta.page,
      options: options,
      hasMore: payload.meta.hasNext,
      selected: state.asData?.value?.selected,
    );
  }
}

class _SearchPayload {
  const _SearchPayload({required this.options, required this.meta});

  final List<EntityOption> options;
  final PaginationMeta meta;
}
