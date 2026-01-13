/// ROLE
/// - 원격 데이터 소스를 제공한다
///
/// RESPONSIBILITY
/// - API 호출을 수행한다
/// - 응답을 DTO로 변환한다
///
/// DEPENDS ON
/// - dio
/// - api_constants
/// - department_directory_dto
/// - pagination_meta_dto
library;

import 'package:dio/dio.dart';
import 'package:web_dashboard/common/constants/api_constants.dart';
import 'package:web_dashboard/domains/foundation/data/dtos/department_directory_dto.dart';
import 'package:web_dashboard/common/search/pagination_meta_dto.dart';

/// 학과 검색/배치 API를 호출하는 데이터 소스 계약.
abstract class DepartmentDirectoryRemoteDataSource {
  Future<PaginatedResponseDto<DepartmentDirectoryDto>> searchDepartments({
    String? keyword,
    int page = 1,
    int limit = 20,
  });

  Future<List<DepartmentDirectoryDto>> fetchByIds(List<String> ids);
}

/// Dio를 사용해 실제 HTTP를 수행하는 학과 데이터 소스 구현.
class DepartmentDirectoryRemoteDataSourceImpl
    implements DepartmentDirectoryRemoteDataSource {
  DepartmentDirectoryRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<PaginatedResponseDto<DepartmentDirectoryDto>> searchDepartments({
    String? keyword,
    int page = 1,
    int limit = 20,
  }) async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      ApiConstants.departments,
      queryParameters: <String, Object?>{
        if (keyword != null && keyword.trim().isNotEmpty) 'q': keyword.trim(),
        'page': page,
        'limit': limit,
      },
    );
    final Map<String, Object?> payload =
        (response.data as Map<String, Object?>?) ?? <String, Object?>{};
    return PaginatedResponseDto<DepartmentDirectoryDto>.fromJson(
      payload,
      (Map<String, Object?> json) => DepartmentDirectoryDto.fromJson(json),
    );
  }

  @override
  Future<List<DepartmentDirectoryDto>> fetchByIds(List<String> ids) async {
    if (ids.isEmpty) {
      return <DepartmentDirectoryDto>[];
    }
    final Response<dynamic> response = await _dio.post<dynamic>(
      '${ApiConstants.departments}/batch',
      data: <String, Object?>{'departmentIds': ids},
    );
    final List<Object?> payload = response.data as List<Object?>? ?? <Object?>[];
    return payload
        .whereType<Map<String, Object?>>()
        .map(DepartmentDirectoryDto.fromJson)
        .toList();
  }
}
