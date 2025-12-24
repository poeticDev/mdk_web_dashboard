import 'package:dio/dio.dart';
import 'package:web_dashboard/common/constants/api_constants.dart';
import 'package:web_dashboard/core/timetable/data/dtos/lecture_dto.dart';
import 'package:web_dashboard/core/timetable/data/dtos/lecture_request_dtos.dart';

/// Dio 기반 origin 강의(master) 원격 데이터 소스.
abstract class LectureOriginRemoteDataSource {
  Future<List<LectureDto>> fetchLectures(LectureOriginQueryRequest request);
  Future<LectureDto> createLecture(LecturePayloadDto payload);
  Future<LectureDto> updateLecture(UpdateLectureRequest request);
  Future<void> deleteLecture(DeleteLectureRequest request);
}

/// 실제 HTTP 통신을 수행하는 구현체.
class LectureOriginRemoteDataSourceImpl implements LectureOriginRemoteDataSource {
  LectureOriginRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<LectureDto>> fetchLectures(LectureOriginQueryRequest request) async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      ApiConstants.classroomTimetablePath(request.classroomId),
      queryParameters: request.toQueryParameters(),
    );
    final Map<String, dynamic> envelope =
        (response.data as Map<String, dynamic>?) ?? <String, dynamic>{};
    final List<dynamic> items = envelope['lectures'] as List<dynamic>? ?? <dynamic>[];
    return items
        .map(
          (dynamic item) => LectureDto.fromJson(item as Map<String, Object?>),
        )
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
    final Response<dynamic> response = await _dio.patch<dynamic>(
      '${ApiConstants.lectures}/${request.lectureId}',
      data: _buildPatchBody(request),
      options: _buildVersionOption(request.expectedVersion),
    );
    return LectureDto.fromJson(response.data as Map<String, Object?>);
  }

  @override
  Future<void> deleteLecture(DeleteLectureRequest request) async {
    await _dio.delete<void>(
      '${ApiConstants.lectures}/${request.lectureId}',
      queryParameters: <String, Object?>{
        if (request.applyToFollowing) 'applyToFollowing': true,
        if (request.applyToOverrides) 'applyToOverrides': true,
      },
      options: _buildVersionOption(request.expectedVersion),
    );
  }

  Options? _buildVersionOption(int? version) {
    if (version == null) {
      return null;
    }
    return Options(
      headers: <String, Object?>{
        ApiConstants.expectedVersionHeader: version,
      },
    );
  }

  Map<String, Object?> _buildPatchBody(UpdateLectureRequest request) {
    return <String, Object?>{
      'patch': request.payload.toJson(),
      'applyToFollowing': request.applyToFollowing,
      'applyToOverrides': request.applyToOverrides,
      if (request.expectedVersion != null)
        'expectedVersion': request.expectedVersion,
    };
  }

}
