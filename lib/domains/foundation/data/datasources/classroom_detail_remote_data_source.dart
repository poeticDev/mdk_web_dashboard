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
/// - classroom_detail_dto
library;

import 'package:dio/dio.dart';
import 'package:web_dashboard/common/constants/api_constants.dart';
import 'package:web_dashboard/domains/foundation/data/dtos/classroom_detail_dto.dart';

/// Dio를 통해 강의실 상세 API를 호출하는 데이터 소스 계약.
abstract class ClassroomDetailRemoteDataSource {
  Future<ClassroomDetailResponseDto> fetchDetail(String classroomId);
  Future<List<ClassroomDetailResponseDto>> fetchBatch(List<String> classroomIds);
}

/// 실제 HTTP 요청을 수행하는 데이터 소스 구현.
class ClassroomDetailRemoteDataSourceImpl
    implements ClassroomDetailRemoteDataSource {
  ClassroomDetailRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<ClassroomDetailResponseDto> fetchDetail(String classroomId) async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      '${ApiConstants.classrooms}/$classroomId',
    );
    return ClassroomDetailResponseDto.fromJson(
      (response.data as Map<String, Object?>?) ?? <String, Object?>{},
    );
  }

  @override
  Future<List<ClassroomDetailResponseDto>> fetchBatch(
    List<String> classroomIds,
  ) async {
    if (classroomIds.isEmpty) {
      return <ClassroomDetailResponseDto>[];
    }
    final Response<dynamic> response = await _dio.post<dynamic>(
      '${ApiConstants.classrooms}/batch',
      data: <String, Object?>{'classroomIds': classroomIds},
    );
    final List<dynamic> items = response.data as List<dynamic>? ?? <dynamic>[];
    return items
        .whereType<Map<String, Object?>>()
        .map(ClassroomDetailResponseDto.fromJson)
        .toList();
  }
}
