import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_dashboard/common/widgets/entity_search/controllers/entity_search_args.dart';
import 'package:web_dashboard/common/widgets/entity_search/controllers/entity_search_controller.dart';
import 'package:web_dashboard/domains/auth/application/user_directory_providers.dart';
import 'package:web_dashboard/domains/foundation/application/foundation_providers.dart';
import 'package:web_dashboard/common/widgets/entity_search/state/entity_search_state.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/department_directory_entity.dart';
import 'package:web_dashboard/domains/auth/domain/entities/user_directory_entity.dart';
import 'package:web_dashboard/common/search/entity_search_query.dart';
import 'package:web_dashboard/common/search/entity_search_result.dart';
import 'package:web_dashboard/common/search/pagination_meta.dart';
import 'package:web_dashboard/domains/foundation/domain/repositories/department_directory_repository.dart';
import 'package:web_dashboard/domains/auth/domain/repositories/user_directory_repository.dart';
import 'package:web_dashboard/domains/foundation/application/usecases/search_departments_usecase.dart';
import 'package:web_dashboard/domains/auth/application/usecases/search_users_usecase.dart';

void main() {
  late ProviderContainer container;
  late _FakeDepartmentRepository departmentRepo;
  late _FakeUserRepository userRepo;

  setUp(() {
    departmentRepo = _FakeDepartmentRepository();
    userRepo = _FakeUserRepository();
    container = ProviderContainer(
      overrides: <Override>[
        searchDepartmentsUseCaseProvider.overrideWithValue(
          SearchDepartmentsUseCase(departmentRepo),
        ),
        searchUsersUseCaseProvider.overrideWithValue(
          SearchUsersUseCase(userRepo),
        ),
      ],
    );
    addTearDown(container.dispose);
  });

  test('search loads options for departments', () async {
    departmentRepo.enqueueResult(_buildDepartmentResult(<String>['보안학과']));
    final EntitySearchArgs args =
        const EntitySearchArgs(type: EntitySearchType.department, limit: 5);
    final provider = entitySearchControllerProvider(args);

    await container.read(provider.notifier).search('보안');
    final AsyncValue<EntitySearchState> state = container.read(provider);

    expect(state.value, isNotNull);
    expect(state.value!.options.first.label, '보안학과');
    expect(state.value!.hasMore, isFalse);
  });

  test('loadMore appends results when hasMore', () async {
    departmentRepo
      ..enqueueResult(
        _buildDepartmentResult(<String>['컴퓨터공학과'], hasNext: true),
      )
      ..enqueueResult(
        _buildDepartmentResult(<String>['전자공학과'], page: 2),
      );
    final EntitySearchArgs args =
        const EntitySearchArgs(type: EntitySearchType.department, limit: 5);
    final provider = entitySearchControllerProvider(args);
    final controller = container.read(provider.notifier);

    await controller.search('공학');
    await controller.loadMore();
    final List<String> labels =
        container.read(provider).value!.options.map((option) => option.label).toList();

    expect(labels, <String>['컴퓨터공학과', '전자공학과']);
  });

  test('select and clear selection updates state', () async {
    departmentRepo.enqueueResult(_buildDepartmentResult(<String>['건축학과']));
    final provider = entitySearchControllerProvider(
      const EntitySearchArgs(type: EntitySearchType.department),
    );
    final controller = container.read(provider.notifier);

    await controller.search('건축');
    final option = container.read(provider).value!.options.first;
    controller.selectOption(option);
    expect(container.read(provider).value!.selected?.id, option.id);

    controller.clearSelection();
    expect(container.read(provider).value!.selected, isNull);
  });

  test('user search uses user repository', () async {
    userRepo.enqueueResult(_buildUserResult(<String>['홍길동']));
    final provider = entitySearchControllerProvider(
      const EntitySearchArgs(type: EntitySearchType.user),
    );

    await container.read(provider.notifier).search('홍');
    final state = container.read(provider).value;

    expect(state?.options.first.label, '홍길동');
  });
}

class _FakeDepartmentRepository implements DepartmentDirectoryRepository {
  final List<EntitySearchResult<DepartmentDirectoryEntity>> _queue =
      <EntitySearchResult<DepartmentDirectoryEntity>>[];

  void enqueueResult(EntitySearchResult<DepartmentDirectoryEntity> result) {
    _queue.add(result);
  }

  @override
  Future<List<DepartmentDirectoryEntity>> fetchByIds(List<String> ids) async {
    return _queue
        .expand((EntitySearchResult<DepartmentDirectoryEntity> result) => result.items)
        .where((DepartmentDirectoryEntity entity) => ids.contains(entity.id))
        .toList();
  }

  @override
  Future<EntitySearchResult<DepartmentDirectoryEntity>> searchDepartments(
    EntitySearchQuery query,
  ) async {
    if (_queue.isEmpty) {
      return _buildDepartmentResult(<String>[]);
    }
    return _queue.removeAt(0);
  }
}

class _FakeUserRepository implements UserDirectoryRepository {
  final List<EntitySearchResult<UserDirectoryEntity>> _queue =
      <EntitySearchResult<UserDirectoryEntity>>[];

  void enqueueResult(EntitySearchResult<UserDirectoryEntity> result) {
    _queue.add(result);
  }

  @override
  Future<EntitySearchResult<UserDirectoryEntity>> searchUsers(
    EntitySearchQuery query,
  ) async {
    if (_queue.isEmpty) {
      return _buildUserResult(<String>[]);
    }
    return _queue.removeAt(0);
  }
}

EntitySearchResult<DepartmentDirectoryEntity> _buildDepartmentResult(
  List<String> names, {
  bool hasNext = false,
  int page = 1,
}) {
  final List<DepartmentDirectoryEntity> items = <DepartmentDirectoryEntity>[
    for (final String name in names)
      DepartmentDirectoryEntity(id: name, name: name, code: 'CODE'),
  ];
  final PaginationMeta meta = PaginationMeta(
    page: page,
    limit: 20,
    total: names.length,
    totalPages: 1,
    hasPrev: page > 1,
    hasNext: hasNext,
  );
  return EntitySearchResult<DepartmentDirectoryEntity>(items: items, meta: meta);
}

EntitySearchResult<UserDirectoryEntity> _buildUserResult(
  List<String> names, {
  bool hasNext = false,
  int page = 1,
}) {
  final List<UserDirectoryEntity> items = <UserDirectoryEntity>[
    for (final String name in names)
      UserDirectoryEntity(
        id: name,
        username: '${name}_username',
        displayName: name,
        departmentName: '학과',
      ),
  ];
  final PaginationMeta meta = PaginationMeta(
    page: page,
    limit: 20,
    total: names.length,
    totalPages: 1,
    hasPrev: page > 1,
    hasNext: hasNext,
  );
  return EntitySearchResult<UserDirectoryEntity>(items: items, meta: meta);
}
