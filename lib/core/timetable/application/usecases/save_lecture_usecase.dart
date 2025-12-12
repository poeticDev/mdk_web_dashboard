import 'package:web_dashboard/core/timetable/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_repository.dart';

/// 강의 일정을 생성 혹은 수정하는 UseCase.
class SaveLectureUseCase {
  const SaveLectureUseCase(this._repository);

  final LectureRepository _repository;

  Future<LectureEntity> execute(SaveLectureCommand command) {
    if (command.lectureId == null) {
      return _repository.createLecture(command.payload);
    }
    return _repository.updateLecture(
      UpdateLectureInput(
        lectureId: command.lectureId!,
        payload: command.payload,
        applyToSeries: command.applyToSeries,
      ),
    );
  }
}

/// 저장 요청에 필요한 입력 값을 묶은 객체.
class SaveLectureCommand {
  const SaveLectureCommand({
    required this.payload,
    this.lectureId,
    this.applyToSeries = false,
  });

  final LectureWriteInput payload;
  final String? lectureId;
  final bool applyToSeries;
}
