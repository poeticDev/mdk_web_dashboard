/// ROLE
/// - 리포지토리 구현체를 제공한다
///
/// RESPONSIBILITY
/// - 데이터 소스를 통해 데이터를 조회한다
/// - 도메인 모델로 변환한다
///
/// DEPENDS ON
/// - dio
/// - department_directory_remote_data_source
/// - department_directory_dto
/// - pagination_meta_dto
/// - department_directory_mapper
/// - pagination_meta_mapper
library;

// 학과 검색 캐시 전략을 적용한 리포지토리 구현체다.
import 'package:dio/dio.dart';
import 'package:web_dashboard/domains/foundation/data/datasources/department_directory_remote_data_source.dart';
import 'package:web_dashboard/domains/foundation/data/dtos/department_directory_dto.dart';
import 'package:web_dashboard/common/search/pagination_meta_dto.dart';
import 'package:web_dashboard/domains/foundation/data/mappers/department_directory_mapper.dart';
import 'package:web_dashboard/common/search/pagination_meta_mapper.dart';
import 'package:web_dashboard/common/search/directory_repository_exception.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/department_directory_entity.dart';
import 'package:web_dashboard/common/search/entity_search_query.dart';
import 'package:web_dashboard/common/search/entity_search_result.dart';
import 'package:web_dashboard/common/search/pagination_meta.dart';
import 'package:web_dashboard/domains/foundation/domain/repositories/department_directory_repository.dart';

typedef Clock = DateTime Function();

/// 학과 검색 API + 캐시 전략을 통합한 리포지토리 구현.
class DepartmentDirectoryRepositoryImpl
    implements DepartmentDirectoryRepository {
  DepartmentDirectoryRepositoryImpl({
    required DepartmentDirectoryRemoteDataSource remoteDataSource,
    required DepartmentDirectoryMapper mapper,
    required PaginationMetaMapper metaMapper,
    Duration cacheTtl = const Duration(seconds: 30),
    Clock clock = DateTime.now,
  })  : _remoteDataSource = remoteDataSource,
        _mapper = mapper,
        _metaMapper = metaMapper,
        _cacheTtl = cacheTtl,
        _now = clock;

  final DepartmentDirectoryRemoteDataSource _remoteDataSource;
  final DepartmentDirectoryMapper _mapper;
  final PaginationMetaMapper _metaMapper;
  final Duration _cacheTtl;
  final Clock _now;
  final Map<String, _CacheEntry> _cache = <String, _CacheEntry>{};

  @override
  Future<EntitySearchResult<DepartmentDirectoryEntity>> searchDepartments(
    EntitySearchQuery query,
  ) async {
    final String cacheKey = _buildCacheKey(query);
    final _CacheEntry? cached = _cache[cacheKey];
    if (cached != null && !_isExpired(cached)) {
      return cached.result;
    }
    final PaginatedResponseDto<DepartmentDirectoryDto> response =
        await _safeSearch(query);
    final EntitySearchResult<DepartmentDirectoryEntity> mapped =
        _mapResponse(response);
    _cache[cacheKey] = _CacheEntry(mapped, _now());
    return mapped;
  }

  @override
  Future<List<DepartmentDirectoryEntity>> fetchByIds(
    List<String> ids,
  ) async {
    if (ids.isEmpty) {
      return <DepartmentDirectoryEntity>[];
    }
    final List<DepartmentDirectoryDto> dtos = await _safeFetchByIds(ids);
    return dtos.map(_mapper.toEntity).toList();
  }

  EntitySearchResult<DepartmentDirectoryEntity> _mapResponse(
    PaginatedResponseDto<DepartmentDirectoryDto> response,
  ) {
    final List<DepartmentDirectoryEntity> items =
        response.items.map(_mapper.toEntity).toList();
    final PaginationMeta meta = _metaMapper.toEntity(response.meta);
    return EntitySearchResult<DepartmentDirectoryEntity>(
      items: items,
      meta: meta,
    );
  }

  bool _isExpired(_CacheEntry entry) {
    return _now().difference(entry.fetchedAt) > _cacheTtl;
  }

  String _buildCacheKey(EntitySearchQuery query) {
    final String keyword = query.normalizedKeyword.toLowerCase();
    return '$keyword|${query.page}|${query.limit}';
  }
  Future<PaginatedResponseDto<DepartmentDirectoryDto>> _safeSearch(
    EntitySearchQuery query,
  ) async {
    try {
      return await _remoteDataSource.searchDepartments(
        keyword: query.keyword,
        page: query.page,
        limit: query.limit,
      );
    } on DioException catch (error) {
      throw DirectoryRepositoryException(error);
    }
  }

  Future<List<DepartmentDirectoryDto>> _safeFetchByIds(
    List<String> ids,
  ) async {
    try {
      return await _remoteDataSource.fetchByIds(ids);
    } on DioException catch (error) {
      throw DirectoryRepositoryException(error);
    }
  }
}

class _CacheEntry {
  const _CacheEntry(this.result, this.fetchedAt);

  final EntitySearchResult<DepartmentDirectoryEntity> result;
  final DateTime fetchedAt;
}
