import 'package:dio/dio.dart';
import 'package:web_dashboard/common/constants/api_constants.dart';
import 'package:web_dashboard/core/timetable/data/dtos/lecture_occurrence_dto.dart';
import 'package:web_dashboard/core/timetable/data/dtos/occurrence_query_request.dart';

abstract class LectureOccurrenceRemoteDataSource {
  Future<List<LectureOccurrenceDto>> fetchOccurrences(
    OccurrenceQueryRequest request,
  );
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
}
