import 'package:web_dashboard/core/timetable/domain/repositories/lecture_origin_repository.dart';

/// 강의 일정을 삭제하는 UseCase.
class DeleteLectureUseCase {
  const DeleteLectureUseCase(this._repository);

  final LectureOriginRepository _repository;

  Future<void> execute(LectureOriginDeleteInput input) {
    return _repository.deleteLecture(input);
  }
}
