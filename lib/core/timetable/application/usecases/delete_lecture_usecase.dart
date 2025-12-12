import 'package:web_dashboard/core/timetable/domain/repositories/lecture_repository.dart';

/// 강의 일정을 삭제하는 UseCase.
class DeleteLectureUseCase {
  const DeleteLectureUseCase(this._repository);

  final LectureRepository _repository;

  Future<void> execute(DeleteLectureInput input) {
    return _repository.deleteLecture(input);
  }
}
