import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_dashboard/common/search/entity_search_query.dart';
import 'package:web_dashboard/common/search/entity_search_result.dart';
import 'package:web_dashboard/common/search/pagination_meta.dart';
import 'package:web_dashboard/common/widgets/entity_search/controllers/entity_search_args.dart';
import 'package:web_dashboard/common/widgets/entity_search/entity_search_field.dart';
import 'package:web_dashboard/common/widgets/entity_search/viewmodels/entity_option.dart';
import 'package:web_dashboard/domains/auth/application/user_directory_providers.dart';
import 'package:web_dashboard/domains/auth/domain/entities/user_directory_entity.dart';
import 'package:web_dashboard/domains/auth/domain/repositories/user_directory_repository.dart';
import 'package:web_dashboard/domains/foundation/application/foundation_providers.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/department_directory_entity.dart';
import 'package:web_dashboard/domains/foundation/domain/repositories/department_directory_repository.dart';

void main() {
  final _FakeDepartmentRepository fakeDepartmentRepository =
      _FakeDepartmentRepository();
  final _FakeUserRepository fakeUserRepository = _FakeUserRepository();

  ProviderScope buildScope(Widget child) {
    return ProviderScope(
      overrides: <Override>[
        departmentDirectoryRepositoryProvider.overrideWithValue(
          fakeDepartmentRepository,
        ),
        userDirectoryRepositoryProvider.overrideWithValue(fakeUserRepository),
      ],
      child: child,
    );
  }

  testWidgets('shows options and notifies when selection is made',
      (WidgetTester tester) async {
    fakeDepartmentRepository.result =
        EntitySearchResult<DepartmentDirectoryEntity>(
      items: <DepartmentDirectoryEntity>[
        const DepartmentDirectoryEntity(id: 'dept-1', name: '정보보안학과'),
      ],
      meta: const PaginationMeta(
        page: 1,
        limit: 20,
        total: 1,
        totalPages: 1,
        hasPrev: false,
        hasNext: false,
      ),
    );
    EntityOption? selected;

    await tester.pumpWidget(
      buildScope(
        MaterialApp(
          home: Scaffold(
            body: EntitySearchField(
              searchType: EntitySearchType.department,
              labelText: '학과',
              hintText: '학과 검색',
              debounceDuration: Duration.zero,
              onSelected: (EntityOption option) => selected = option,
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '정보');
    await tester.pumpAndSettle();

    expect(find.text('정보보안학과'), findsOneWidget);

    await tester.tap(find.text('정보보안학과'));
    await tester.pump();

    expect(selected?.id, 'dept-1');
  });

  testWidgets('uses bottom sheet on narrow layouts',
      (WidgetTester tester) async {
    fakeUserRepository.result = EntitySearchResult<UserDirectoryEntity>(
      items: <UserDirectoryEntity>[
        const UserDirectoryEntity(
          id: 'user-1',
          username: 'kim',
          displayName: '김교수',
        ),
      ],
      meta: const PaginationMeta(
        page: 1,
        limit: 20,
        total: 1,
        totalPages: 1,
        hasPrev: false,
        hasNext: false,
      ),
    );

    await tester.pumpWidget(
      buildScope(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(360, 640)),
            child: Scaffold(
              body: EntitySearchField(
                searchType: EntitySearchType.user,
                labelText: '담당자',
                debounceDuration: Duration.zero,
                onSelected: (_) {},
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, '김');
    await tester.pumpAndSettle();

    expect(find.text('김교수'), findsOneWidget);
  });
}

class _FakeDepartmentRepository implements DepartmentDirectoryRepository {
  EntitySearchResult<DepartmentDirectoryEntity>? result;

  @override
  Future<List<DepartmentDirectoryEntity>> fetchByIds(List<String> ids) async {
    final List<DepartmentDirectoryEntity> items = result?.items ?? const [];
    return items.where((DepartmentDirectoryEntity entity) {
      return ids.contains(entity.id);
    }).toList();
  }

  @override
  Future<EntitySearchResult<DepartmentDirectoryEntity>> searchDepartments(
    EntitySearchQuery query,
  ) async {
    return result ??
        EntitySearchResult<DepartmentDirectoryEntity>(
          items: const <DepartmentDirectoryEntity>[],
          meta: const PaginationMeta(
            page: 1,
            limit: 20,
            total: 0,
            totalPages: 1,
            hasPrev: false,
            hasNext: false,
          ),
        );
  }
}

class _FakeUserRepository implements UserDirectoryRepository {
  EntitySearchResult<UserDirectoryEntity>? result;

  @override
  Future<EntitySearchResult<UserDirectoryEntity>> searchUsers(
    EntitySearchQuery query,
  ) async {
    return result ??
        EntitySearchResult<UserDirectoryEntity>(
          items: const <UserDirectoryEntity>[],
          meta: const PaginationMeta(
            page: 1,
            limit: 20,
            total: 0,
            totalPages: 1,
            hasPrev: false,
            hasNext: false,
          ),
        );
  }
}
