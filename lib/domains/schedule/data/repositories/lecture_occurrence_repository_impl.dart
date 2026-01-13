/// ROLE
/// - 리포지토리 구현체를 제공한다
///
/// RESPONSIBILITY
/// - 데이터 소스를 통해 데이터를 조회한다
/// - 도메인 모델로 변환한다
///
/// DEPENDS ON
/// - lecture_occurrence_remote_data_source
/// - lecture_occurrence_dto
/// - occurrence_query_request
/// - lecture_occurrence_mapper
/// - lecture_occurrence_entity
/// - lecture_occurrence_query
library;

import 'package:web_dashboard/domains/schedule/data/datasources/lecture_occurrence_remote_data_source.dart';
import 'package:web_dashboard/domains/schedule/data/dtos/lecture_occurrence_dto.dart';
import 'package:web_dashboard/domains/schedule/data/dtos/occurrence_query_request.dart';
import 'package:web_dashboard/domains/schedule/data/mappers/lecture_occurrence_mapper.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_occurrence_entity.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_occurrence_query.dart';
import 'package:web_dashboard/domains/schedule/domain/repositories/lecture_occurrence_repository.dart';

class LectureOccurrenceRepositoryImpl implements LectureOccurrenceRepository {
  LectureOccurrenceRepositoryImpl({
    required LectureOccurrenceRemoteDataSource remoteDataSource,
    required LectureOccurrenceMapper mapper,
  })  : _remoteDataSource = remoteDataSource,
        _mapper = mapper;

  final LectureOccurrenceRemoteDataSource _remoteDataSource;
  final LectureOccurrenceMapper _mapper;

  @override
  Future<List<LectureOccurrenceEntity>> fetchOccurrences(
    LectureOccurrenceQuery query,
  ) async {
    final OccurrenceQueryRequest request = OccurrenceQueryRequest(
      classroomId: query.classroomId,
      from: query.from,
      to: query.to,
    );
    final results = await _remoteDataSource.fetchOccurrences(request);
    return results.map(_mapper.toEntity).toList();
  }

  @override
  Future<LectureOccurrenceEntity> createOccurrence(
    LectureOccurrenceWriteInput input,
  ) async {
    final OccurrenceCreateRequest request = OccurrenceCreateRequest(
      lectureId: input.lectureId,
      classroomId: input.classroomId,
      startAt: input.start,
      endAt: input.end,
      colorHex: input.colorHex,
      notes: input.notes,
    );
    final LectureOccurrenceDto dto =
        await _remoteDataSource.createOccurrence(request);
    return _mapper.toEntity(dto);
  }

  @override
  Future<LectureOccurrenceEntity> updateOccurrence(
    LectureOccurrenceUpdateInput input,
  ) async {
    final OccurrenceUpdateRequest request = OccurrenceUpdateRequest(
      occurrenceId: input.occurrenceId,
      startAt: input.start,
      endAt: input.end,
      status: input.status?.apiValue,
      cancelReason: input.cancelReason,
      scope: input.scope,
      applyToOverrides: input.applyToOverrides,
      // expectedVersion: input.expectedVersion,
      titleOverride: input.titleOverride,
      colorHexOverride: input.colorHexOverride,
      notesOverride: input.notesOverride,
      departmentIdOverride: input.departmentIdOverride,
      instructorUserIdOverride: input.instructorUserIdOverride,
    );
    final LectureOccurrenceDto dto =
        await _remoteDataSource.updateOccurrence(request);
    return _mapper.toEntity(dto);
  }

  @override
  Future<void> deleteOccurrence(LectureOccurrenceDeleteInput input) async {
    final OccurrenceDeleteRequest request = OccurrenceDeleteRequest(
      occurrenceId: input.occurrenceId,
      applyToFollowing: input.applyToFollowing,
      applyToOverrides: input.applyToOverrides,
    );
    await _remoteDataSource.deleteOccurrence(request);
  }

}
