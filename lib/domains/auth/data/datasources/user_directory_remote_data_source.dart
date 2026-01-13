/// ROLE
/// - 유저 디렉터리 원격 데이터 소스를 제공한다
///
/// RESPONSIBILITY
/// - 검색 API 호출과 페이지네이션 DTO 반환을 담당한다
///
/// DEPENDS ON
/// - dio
/// - api_constants
/// - pagination_meta_dto
library;

import 'package:dio/dio.dart';
import 'package:web_dashboard/common/constants/api_constants.dart';
import 'package:web_dashboard/common/search/pagination_meta_dto.dart';
import 'package:web_dashboard/domains/auth/data/dtos/user_directory_dto.dart';

/// 유저 목록 API를 호출하는 데이터 소스 계약.
abstract class UserDirectoryRemoteDataSource {
  Future<PaginatedResponseDto<UserDirectoryDto>> searchUsers({
    String? keyword,
    int page = 1,
    int limit = 20,
  });
}

/// Dio 기반 유저 검색 원격 데이터 소스 구현.
class UserDirectoryRemoteDataSourceImpl
    implements UserDirectoryRemoteDataSource {
  UserDirectoryRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<PaginatedResponseDto<UserDirectoryDto>> searchUsers({
    String? keyword,
    int page = 1,
    int limit = 20,
  }) async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      ApiConstants.users,
      queryParameters: <String, Object?>{
        if (keyword != null && keyword.trim().isNotEmpty) 'q': keyword.trim(),
        'page': page,
        'limit': limit,
      },
    );
    final Map<String, Object?> payload =
        (response.data as Map<String, Object?>?) ?? <String, Object?>{};
    return PaginatedResponseDto<UserDirectoryDto>.fromJson(
      payload,
      UserDirectoryDto.fromJson,
    );
  }
}
