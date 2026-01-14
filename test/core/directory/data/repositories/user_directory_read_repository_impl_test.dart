import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_dashboard/domains/auth/data/datasources/user_directory_remote_data_source.dart';
import 'package:web_dashboard/common/search/pagination_meta_dto.dart';
import 'package:web_dashboard/domains/auth/data/dtos/user_directory_dto.dart';
import 'package:web_dashboard/common/search/pagination_meta_mapper.dart';
import 'package:web_dashboard/domains/auth/data/mappers/user_directory_mapper.dart';
import 'package:web_dashboard/common/search/directory_repository_exception.dart';
import 'package:web_dashboard/domains/auth/data/repositories/user_directory_read_repository_impl.dart';
import 'package:web_dashboard/common/search/entity_search_query.dart';

void main() {
  late _FakeUserRemote remote;
  const UserDirectoryMapper mapper = UserDirectoryMapper();
  const PaginationMetaMapper metaMapper = PaginationMetaMapper();
  late _TestClock clock;
  late UserDirectoryReadRepositoryImpl repository;

  setUp(() {
    remote = _FakeUserRemote();
    clock = _TestClock();
    repository = UserDirectoryReadRepositoryImpl(
      remoteDataSource: remote,
      mapper: mapper,
      metaMapper: metaMapper,
      cacheTtl: const Duration(seconds: 15),
      clock: clock.now,
    );
  });

  test('searchUsers returns mapped result', () async {
    remote.response = _buildUserDto(
      items: <UserDirectoryDto>[
        const UserDirectoryDto(
          id: 'user-1',
          username: 'profkim',
          displayName: '김교수',
          departmentName: '컴퓨터공학과',
        ),
      ],
    );

    final result =
        await repository.searchUsers(const EntitySearchQuery(keyword: 'kim'));

    expect(remote.lastKeyword, 'kim');
    expect(result.items.first.displayName, '김교수');
    expect(result.meta.total, 1);
  });

  test('searchUsers caches per query', () async {
    await repository.searchUsers(const EntitySearchQuery(keyword: 'lee'));
    await repository.searchUsers(const EntitySearchQuery(keyword: 'lee'));
    expect(remote.callCount, 1);
    clock.advance(const Duration(seconds: 20));
    await repository.searchUsers(const EntitySearchQuery(keyword: 'lee'));
    expect(remote.callCount, 2);
  });

  test('throws DirectoryRepositoryException on dio error', () {
    remote.error = DioException(
      requestOptions: RequestOptions(path: '/users'),
    );

    expect(
      () => repository.searchUsers(const EntitySearchQuery(keyword: 'err')),
      throwsA(isA<DirectoryRepositoryException>()),
    );
  });
}

class _FakeUserRemote implements UserDirectoryRemoteDataSource {
  PaginatedResponseDto<UserDirectoryDto>? response;
  DioException? error;
  String? lastKeyword;
  int callCount = 0;

  @override
  Future<PaginatedResponseDto<UserDirectoryDto>> searchUsers({
    String? keyword,
    int page = 1,
    int limit = 20,
  }) async {
    if (error != null) {
      throw error!;
    }
    callCount++;
    lastKeyword = keyword;
    return response ?? _buildUserDto(items: <UserDirectoryDto>[]);
  }
}

class _TestClock {
  DateTime _value = DateTime.utc(2025, 1, 1, 9);

  DateTime now() => _value;

  void advance(Duration delta) {
    _value = _value.add(delta);
  }
}

PaginatedResponseDto<UserDirectoryDto> _buildUserDto({
  required List<UserDirectoryDto> items,
}) {
  return PaginatedResponseDto<UserDirectoryDto>(
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
