import 'package:dio/dio.dart';
import 'package:web_dashboard/core/directory/data/datasources/user_directory_remote_data_source.dart';
import 'package:web_dashboard/core/directory/data/dtos/pagination_meta_dto.dart';
import 'package:web_dashboard/core/directory/data/dtos/user_directory_dto.dart';
import 'package:web_dashboard/core/directory/data/mappers/pagination_meta_mapper.dart';
import 'package:web_dashboard/core/directory/data/mappers/user_directory_mapper.dart';
import 'package:web_dashboard/core/directory/data/repositories/directory_repository_exception.dart';
import 'package:web_dashboard/core/directory/domain/entities/user_directory_entity.dart';
import 'package:web_dashboard/core/directory/domain/models/entity_search_query.dart';
import 'package:web_dashboard/core/directory/domain/models/entity_search_result.dart';
import 'package:web_dashboard/core/directory/domain/models/pagination_meta.dart';
import 'package:web_dashboard/core/directory/domain/repositories/user_directory_repository.dart';

typedef _Clock = DateTime Function();

/// 유저 검색 API 호출과 TTL 캐시를 책임지는 리포지토리 구현.
class UserDirectoryRepositoryImpl implements UserDirectoryRepository {
  UserDirectoryRepositoryImpl({
    required UserDirectoryRemoteDataSource remoteDataSource,
    required UserDirectoryMapper mapper,
    required PaginationMetaMapper metaMapper,
    Duration cacheTtl = const Duration(seconds: 30),
    _Clock clock = DateTime.now,
  })  : _remoteDataSource = remoteDataSource,
        _mapper = mapper,
        _metaMapper = metaMapper,
        _cacheTtl = cacheTtl,
        _now = clock;

  final UserDirectoryRemoteDataSource _remoteDataSource;
  final UserDirectoryMapper _mapper;
  final PaginationMetaMapper _metaMapper;
  final Duration _cacheTtl;
  final _Clock _now;
  final Map<String, _CacheEntry> _cache = <String, _CacheEntry>{};

  @override
  Future<EntitySearchResult<UserDirectoryEntity>> searchUsers(
    EntitySearchQuery query,
  ) async {
    final String cacheKey = _buildCacheKey(query);
    final _CacheEntry? cached = _cache[cacheKey];
    if (cached != null && !_isExpired(cached)) {
      return cached.result;
    }
    final PaginatedResponseDto<UserDirectoryDto> response =
        await _safeSearch(query);
    final List<UserDirectoryEntity> items =
        response.items.map(_mapper.toEntity).toList();
    final PaginationMeta meta = _metaMapper.toEntity(response.meta);
    final EntitySearchResult<UserDirectoryEntity> result =
        EntitySearchResult<UserDirectoryEntity>(items: items, meta: meta);
    _cache[cacheKey] = _CacheEntry(result, _now());
    return result;
  }

  bool _isExpired(_CacheEntry entry) {
    return _now().difference(entry.fetchedAt) > _cacheTtl;
  }

  String _buildCacheKey(EntitySearchQuery query) {
    final String keyword = query.normalizedKeyword.toLowerCase();
    return 'user|$keyword|${query.page}|${query.limit}';
  }

  Future<PaginatedResponseDto<UserDirectoryDto>> _safeSearch(
    EntitySearchQuery query,
  ) async {
    try {
      return await _remoteDataSource.searchUsers(
        keyword: query.keyword,
        page: query.page,
        limit: query.limit,
      );
    } on DioException catch (error) {
      throw DirectoryRepositoryException(error);
    }
  }
}

class _CacheEntry {
  const _CacheEntry(this.result, this.fetchedAt);

  final EntitySearchResult<UserDirectoryEntity> result;
  final DateTime fetchedAt;
}
