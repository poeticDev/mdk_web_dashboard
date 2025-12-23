import 'package:web_dashboard/core/timetable/data/datasources/lecture_occurrence_remote_data_source.dart';
import 'package:web_dashboard/core/timetable/data/dtos/occurrence_query_request.dart';
import 'package:web_dashboard/core/timetable/data/mappers/lecture_occurrence_mapper.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_occurrence_entity.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_occurrence_query.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_occurrence_repository.dart';

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
}
