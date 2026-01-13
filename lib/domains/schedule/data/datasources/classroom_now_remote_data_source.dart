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
library;

import 'package:dio/dio.dart';
import 'package:web_dashboard/common/constants/api_constants.dart';
import 'package:web_dashboard/domains/schedule/data/dtos/lecture_occurrence_dto.dart';

abstract class ClassroomNowRemoteDataSource {
  Future<ClassroomNowResponseDto?> fetchCurrent({required String classroomId});
}

class ClassroomNowRemoteDataSourceImpl implements ClassroomNowRemoteDataSource {
  ClassroomNowRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<ClassroomNowResponseDto?> fetchCurrent({
    required String classroomId,
  }) async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      ApiConstants.dashboardsNow,
      queryParameters: <String, Object?>{
        'classroomIds': <String>[classroomId],
      },
    );
    final List<dynamic> payload =
        response.data as List<dynamic>? ?? <dynamic>[];
    final Map<String, Object?> match = payload
        .cast<Map<String, Object?>>()
        .firstWhere(
          (Map<String, Object?> entry) => entry['classroomId'] == classroomId,
          orElse: () => <String, Object?>{},
        );
    if (match.isEmpty) {
      return null;
    }
    final bool isIdle = match['isIdle'] as bool? ?? false;
    final Object? occurrenceJson = match['occurrence'];
    LectureOccurrenceDto? occurrence;
    if (occurrenceJson is Map<String, Object?>) {
      occurrence = LectureOccurrenceDto.fromJson(occurrenceJson);
    } else if (occurrenceJson != null) {
      throw const FormatException('Invalid occurrence data received');
    }
    return ClassroomNowResponseDto(isIdle: isIdle, occurrence: occurrence);
  }
}

class ClassroomNowResponseDto {
  const ClassroomNowResponseDto({required this.isIdle, this.occurrence});

  final bool isIdle;
  final LectureOccurrenceDto? occurrence;
}
