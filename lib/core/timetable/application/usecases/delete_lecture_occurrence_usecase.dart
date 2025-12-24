import 'package:web_dashboard/core/timetable/domain/repositories/lecture_occurrence_repository.dart';

class DeleteLectureOccurrenceUseCase {
  const DeleteLectureOccurrenceUseCase(this._repository);

  final LectureOccurrenceRepository _repository;

  Future<void> execute(LectureOccurrenceDeleteInput input) {
    return _repository.deleteOccurrence(input);
  }
}
