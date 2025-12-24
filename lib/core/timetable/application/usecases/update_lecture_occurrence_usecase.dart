import 'package:web_dashboard/core/timetable/domain/entities/lecture_occurrence_entity.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_occurrence_repository.dart';

class UpdateLectureOccurrenceUseCase {
  const UpdateLectureOccurrenceUseCase(this._repository);

  final LectureOccurrenceRepository _repository;

  Future<LectureOccurrenceEntity> execute(
    LectureOccurrenceUpdateInput input,
  ) {
    return _repository.updateOccurrence(input);
  }
}
