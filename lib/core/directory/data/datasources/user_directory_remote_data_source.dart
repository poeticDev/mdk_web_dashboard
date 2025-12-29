import 'package:dio/dio.dart';
import 'package:web_dashboard/common/constants/api_constants.dart';
import 'package:web_dashboard/core/directory/data/dtos/pagination_meta_dto.dart';
import 'package:web_dashboard/core/directory/data/dtos/user_directory_dto.dart';

abstract class UserDirectoryRemoteDataSource {
  Future<PaginatedResponseDto<UserDirectoryDto>> searchUsers({
    String? keyword,
    int page = 1,
    int limit = 20,
  });
}

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
        'pageSize': limit,
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
