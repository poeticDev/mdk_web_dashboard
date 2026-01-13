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
/// - lecture_occurrence_dto
/// - occurrence_query_request
library;

import 'package:dio/dio.dart';
import 'package:web_dashboard/common/constants/api_constants.dart';
import 'package:web_dashboard/domains/schedule/data/dtos/lecture_occurrence_dto.dart';
import 'package:web_dashboard/domains/schedule/data/dtos/occurrence_query_request.dart';

abstract class LectureOccurrenceRemoteDataSource {
  Future<List<LectureOccurrenceDto>> fetchOccurrences(
    OccurrenceQueryRequest request,
  );
  Future<LectureOccurrenceDto> createOccurrence(
    OccurrenceCreateRequest request,
  );
  Future<LectureOccurrenceDto> updateOccurrence(
    OccurrenceUpdateRequest request,
  );
  Future<void> deleteOccurrence(OccurrenceDeleteRequest request);
}

class LectureOccurrenceRemoteDataSourceImpl
    implements LectureOccurrenceRemoteDataSource {
  LectureOccurrenceRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<LectureOccurrenceDto>> fetchOccurrences(
    OccurrenceQueryRequest request,
  ) async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      ApiConstants.lectureOccurrences,
      queryParameters: request.toQueryParameters(),
    );
    final List<dynamic> raw =
        (response.data as List<dynamic>?) ?? <dynamic>[];
    return raw
        .map(
          (dynamic item) =>
              LectureOccurrenceDto.fromJson(item as Map<String, Object?>),
        )
        .toList();
  }

  @override
  Future<LectureOccurrenceDto> createOccurrence(
    OccurrenceCreateRequest request,
  ) async {
    final Response<dynamic> response = await _dio.post<dynamic>(
      ApiConstants.lectureOccurrences,
      data: request.toJson(),
    );
    return LectureOccurrenceDto.fromJson(
      response.data as Map<String, Object?>,
    );
  }

  @override
  Future<LectureOccurrenceDto> updateOccurrence(
    OccurrenceUpdateRequest request,
  ) async {
    final Response<dynamic> response = await _dio.patch<dynamic>(
      '${ApiConstants.lectureOccurrences}/${request.occurrenceId}',
      data: request.toJson(),
    );
    return LectureOccurrenceDto.fromJson(
      response.data as Map<String, Object?>,
    );
  }

  @override
  Future<void> deleteOccurrence(OccurrenceDeleteRequest request) async {
    await _dio.delete<void>(
      '${ApiConstants.lectureOccurrences}/${request.occurrenceId}',
      queryParameters: request.toQueryParameters(),
    );
  }
}
