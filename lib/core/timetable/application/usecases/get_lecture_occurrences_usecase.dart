import 'package:web_dashboard/core/timetable/domain/entities/lecture_occurrence_entity.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_occurrence_query.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_occurrence_repository.dart';

class GetLectureOccurrencesUseCase {
  const GetLectureOccurrencesUseCase(this._repository);

  final LectureOccurrenceRepository _repository;

  Future<List<LectureOccurrenceEntity>> execute(
    LectureOccurrenceQuery query,
  ) {
    return _repository.fetchOccurrences(query);
  }
}
