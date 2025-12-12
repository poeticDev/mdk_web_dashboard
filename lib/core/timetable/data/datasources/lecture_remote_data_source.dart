import 'package:dio/dio.dart';
import 'package:web_dashboard/common/constants/api_constants.dart';
import 'package:web_dashboard/core/timetable/data/dtos/lecture_dto.dart';
import 'package:web_dashboard/core/timetable/data/dtos/lecture_request_dtos.dart';

abstract class LectureRemoteDataSource {
  Future<List<LectureDto>> fetchLectures(LectureQueryRequest request);
  Future<LectureDto> createLecture(LecturePayloadDto payload);
  Future<LectureDto> updateLecture(UpdateLectureRequest request);
  Future<void> deleteLecture(DeleteLectureRequest request);
}

class LectureRemoteDataSourceImpl implements LectureRemoteDataSource {
  LectureRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<LectureDto>> fetchLectures(LectureQueryRequest request) async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      ApiConstants.lectures,
      queryParameters: request.toQueryParameters(),
    );
    final List<dynamic> items = response.data as List<dynamic>? ?? <dynamic>[];
    return items
        .map((dynamic item) =>
            LectureDto.fromJson(item as Map<String, Object?>))
        .toList();
  }

  @override
  Future<LectureDto> createLecture(LecturePayloadDto payload) async {
    final Response<dynamic> response = await _dio.post<dynamic>(
      ApiConstants.lectures,
      data: payload.toJson(),
    );
    return LectureDto.fromJson(response.data as Map<String, Object?>);
  }

  @override
  Future<LectureDto> updateLecture(UpdateLectureRequest request) async {
    final Response<dynamic> response = await _dio.put<dynamic>(
      '${ApiConstants.lectures}/${request.lectureId}',
      data: request.payload.toJson(),
      queryParameters: request.toQueryParameters(),
    );
    return LectureDto.fromJson(response.data as Map<String, Object?>);
  }

  @override
  Future<void> deleteLecture(DeleteLectureRequest request) async {
    await _dio.delete<void>(
      '${ApiConstants.lectures}/${request.lectureId}',
      queryParameters: request.toQueryParameters(),
    );
  }
}
