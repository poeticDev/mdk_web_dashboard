/// ROLE
/// - 원격 데이터 소스를 제공한다
///
/// RESPONSIBILITY
/// - Foundation 기준 강의실 목록 API를 호출한다
/// - 응답을 DTO로 변환한다
///
/// DEPENDS ON
/// - dio
/// - api_constants
/// - foundation_classrooms_dto
/// - foundation_classrooms_request
library;

import 'package:dio/dio.dart';
import 'package:web_dashboard/common/constants/api_constants.dart';
import 'package:web_dashboard/domains/foundation/data/dtos/foundation_classrooms_dto.dart';
import 'package:web_dashboard/domains/foundation/data/dtos/foundation_classrooms_request.dart';

abstract class FoundationClassroomsRemoteDataSource {
  Future<FoundationClassroomsResponseDto> fetchClassrooms(
    FoundationClassroomsRequest request,
  );
}

class FoundationClassroomsRemoteDataSourceImpl
    implements FoundationClassroomsRemoteDataSource {
  FoundationClassroomsRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<FoundationClassroomsResponseDto> fetchClassrooms(
    FoundationClassroomsRequest request,
  ) async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      ApiConstants.foundationClassroomsPath(
        request.foundationType,
        request.foundationId,
      ),
    );
    final Map<String, Object?> payload =
        response.data as Map<String, Object?>? ?? <String, Object?>{};
    return FoundationClassroomsResponseDto.fromJson(payload);
  }
}
