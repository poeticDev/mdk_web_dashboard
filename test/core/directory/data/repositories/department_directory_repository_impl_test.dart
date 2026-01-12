import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_dashboard/domains/foundation/data/datasources/department_directory_remote_data_source.dart';
import 'package:web_dashboard/domains/foundation/data/dtos/department_directory_dto.dart';
import 'package:web_dashboard/common/search/pagination_meta_dto.dart';
import 'package:web_dashboard/domains/foundation/data/mappers/department_directory_mapper.dart';
import 'package:web_dashboard/common/search/pagination_meta_mapper.dart';
import 'package:web_dashboard/domains/foundation/data/repositories/department_directory_repository_impl.dart';
import 'package:web_dashboard/common/search/directory_repository_exception.dart';
import 'package:web_dashboard/common/search/entity_search_query.dart';

void main() {
  late _FakeDepartmentRemote remote;
  const DepartmentDirectoryMapper mapper = DepartmentDirectoryMapper();
  const PaginationMetaMapper metaMapper = PaginationMetaMapper();
  late _TestClock clock;
  late DepartmentDirectoryRepositoryImpl repository;

  setUp(() {
    remote = _FakeDepartmentRemote();
    clock = _TestClock();
    repository = DepartmentDirectoryRepositoryImpl(
      remoteDataSource: remote,
      mapper: mapper,
      metaMapper: metaMapper,
      cacheTtl: const Duration(seconds: 30),
      clock: clock.now,
    );
  });

  test('searchDepartments returns mapped entities', () async {
    remote.response = _buildPaginatedDto(
      items: <DepartmentDirectoryDto>[
        const DepartmentDirectoryDto(
          id: 'dept-1',
          name: '스마트보안학과',
          code: 'SEC',
        ),
      ],
    );

    final result = await repository.searchDepartments(
      const EntitySearchQuery(keyword: '보안', page: 1, limit: 10),
    );

    expect(remote.lastKeyword, '보안');
    expect(result.items, hasLength(1));
    expect(result.items.first.name, '스마트보안학과');
    expect(result.meta.page, 1);
  });

  test('searchDepartments caches results until TTL expires', () async {
    remote.response = _buildPaginatedDto(items: <DepartmentDirectoryDto>[]);

    await repository.searchDepartments(const EntitySearchQuery(keyword: 'A'));
    await repository.searchDepartments(const EntitySearchQuery(keyword: 'A'));
    expect(remote.callCount, 1);

    clock.advance(const Duration(seconds: 31));
    await repository.searchDepartments(const EntitySearchQuery(keyword: 'A'));
    expect(remote.callCount, 2);
  });

  test('fetchByIds maps dto list', () async {
    remote.batchResponse = <DepartmentDirectoryDto>[
      const DepartmentDirectoryDto(id: 'dept-1', name: '학과1'),
      const DepartmentDirectoryDto(id: 'dept-2', name: '학과2'),
    ];

    final entities = await repository.fetchByIds(<String>['dept-1', 'dept-2']);

    expect(remote.lastBatchIds, <String>['dept-1', 'dept-2']);
    expect(entities.map((e) => e.id), containsAll(<String>['dept-1', 'dept-2']));
  });

  test('wraps dio errors as DirectoryRepositoryException', () {
    remote.error = DioException(
      requestOptions: RequestOptions(path: '/departments'),
    );

    expect(
      () => repository.searchDepartments(const EntitySearchQuery(keyword: 'a')),
      throwsA(isA<DirectoryRepositoryException>()),
    );
  });
}

class _FakeDepartmentRemote implements DepartmentDirectoryRemoteDataSource {
  PaginatedResponseDto<DepartmentDirectoryDto>? response;
  List<DepartmentDirectoryDto>? batchResponse;
  DioException? error;
  String? lastKeyword;
  List<String>? lastBatchIds;
  int callCount = 0;

  @override
  Future<List<DepartmentDirectoryDto>> fetchByIds(List<String> ids) async {
    if (error != null) {
      throw error!;
    }
    lastBatchIds = ids;
    return batchResponse ?? <DepartmentDirectoryDto>[];
  }

  @override
  Future<PaginatedResponseDto<DepartmentDirectoryDto>> searchDepartments({
    String? keyword,
    int page = 1,
    int limit = 20,
  }) async {
    if (error != null) {
      throw error!;
    }
    callCount++;
    lastKeyword = keyword;
    return response ?? _buildPaginatedDto(items: <DepartmentDirectoryDto>[]);
  }
}

class _TestClock {
  DateTime _value = DateTime.utc(2025, 1, 1, 9);

  DateTime now() => _value;

  void advance(Duration delta) {
    _value = _value.add(delta);
  }
}

PaginatedResponseDto<DepartmentDirectoryDto> _buildPaginatedDto({
  required List<DepartmentDirectoryDto> items,
}) {
  return PaginatedResponseDto<DepartmentDirectoryDto>(
    items: items,
    meta: const PaginationMetaDto(
      page: 1,
      limit: 20,
      total: 1,
      totalPages: 1,
      hasPrev: false,
      hasNext: false,
    ),
  );
}
