import 'package:dio/dio.dart';
import 'package:web_dashboard/core/classroom_detail/data/datasources/classroom_detail_remote_data_source.dart';
import 'package:web_dashboard/core/classroom_detail/data/dtos/classroom_detail_dto.dart';
import 'package:web_dashboard/core/classroom_detail/data/mappers/classroom_detail_mapper.dart';
import 'package:web_dashboard/core/classroom_detail/domain/entities/classroom_detail_entity.dart';
import 'package:web_dashboard/core/classroom_detail/domain/repositories/classroom_detail_repository.dart';

typedef _Clock = DateTime Function();

/// 강의실 상세 정보를 서버에서 조회하고 TTL 캐시를 적용하는 리포지토리 구현.
class ClassroomDetailRepositoryImpl implements ClassroomDetailRepository {
  ClassroomDetailRepositoryImpl({
    required ClassroomDetailRemoteDataSource remoteDataSource,
    required ClassroomDetailMapper mapper,
    Duration cacheTtl = const Duration(minutes: 1),
    _Clock clock = DateTime.now,
  })  : _remoteDataSource = remoteDataSource,
        _mapper = mapper,
        _cacheTtl = cacheTtl,
        _now = clock;

  final ClassroomDetailRemoteDataSource _remoteDataSource;
  final ClassroomDetailMapper _mapper;
  final Duration _cacheTtl;
  final _Clock _now;
  final Map<String, _CacheEntry> _cache = <String, _CacheEntry>{};

  @override
  Future<ClassroomDetailEntity> fetchById(String classroomId) async {
    final _CacheEntry? cached = _cache[classroomId];
    if (cached != null && !_isExpired(cached)) {
      return cached.entity;
    }

    try {
      final ClassroomDetailResponseDto dto =
          await _remoteDataSource.fetchDetail(classroomId);
      final ClassroomDetailEntity entity = _mapper.toEntity(dto);
      _cache[classroomId] = _CacheEntry(entity: entity, fetchedAt: _now());
      return entity;
    } on DioException catch (error) {
      throw _mapDioException(error, classroomId);
    } on FormatException catch (error) {
      throw ClassroomDetailUnexpectedException(error);
    } on TypeError catch (error) {
      throw ClassroomDetailUnexpectedException(error);
    }
  }

  void clearCache([String? classroomId]) {
    if (classroomId == null) {
      _cache.clear();
      return;
    }
    _cache.remove(classroomId);
  }

  bool _isExpired(_CacheEntry entry) {
    return _now().difference(entry.fetchedAt) > _cacheTtl;
  }

  Exception _mapDioException(DioException error, String classroomId) {
    final int? statusCode = error.response?.statusCode;
    if (statusCode == 404) {
      return ClassroomDetailNotFoundException(classroomId: classroomId);
    }
    if (statusCode == 401 || statusCode == 403) {
      return ClassroomDetailUnauthorizedException();
    }
    return ClassroomDetailUnexpectedException(error);
  }
}

/// 요청한 강의실이 존재하지 않을 때 던지는 예외.
class ClassroomDetailNotFoundException implements Exception {
  ClassroomDetailNotFoundException({required this.classroomId});

  final String classroomId;

  @override
  String toString() => 'Classroom detail not found: $classroomId';
}

/// 세션 만료 혹은 권한 부족으로 조회할 수 없을 때 던지는 예외.
class ClassroomDetailUnauthorizedException implements Exception {
  @override
  String toString() => 'Unauthorized classroom detail access';
}

/// 예상하지 못한 오류를 감싸 UI 계층에 전달하는 예외.
class ClassroomDetailUnexpectedException implements Exception {
  ClassroomDetailUnexpectedException(this.cause);

  final Object cause;

  @override
  String toString() => 'Unexpected classroom detail error: $cause';
}

class _CacheEntry {
  const _CacheEntry({required this.entity, required this.fetchedAt});

  final ClassroomDetailEntity entity;
  final DateTime fetchedAt;
}
