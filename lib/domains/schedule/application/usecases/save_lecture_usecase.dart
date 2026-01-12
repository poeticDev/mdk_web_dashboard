import 'package:web_dashboard/domains/schedule/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/domains/schedule/domain/repositories/lecture_origin_repository.dart';

/// 강의 일정을 생성 혹은 수정하는 UseCase.
class SaveLectureUseCase {
  const SaveLectureUseCase(this._repository);

  final LectureOriginRepository _repository;

  Future<LectureEntity> execute(SaveLectureCommand command) {
    if (command.lectureId == null) {
      return _repository.createLecture(command.payload);
    }
    return _repository.updateLecture(
      LectureOriginUpdateInput(
        lectureId: command.lectureId!,
        payload: command.payload,
        expectedVersion: command.expectedVersion,
        updatedFields: command.updatedFields,
        applyToFollowing: command.applyToFollowing,
        applyToOverrides: command.applyToOverrides,
      ),
    );
  }
}

/// 저장 요청에 필요한 입력 값을 묶은 객체.
class SaveLectureCommand {
  const SaveLectureCommand({
    required this.payload,
    this.lectureId,
    this.expectedVersion,
    this.updatedFields,
    this.applyToFollowing = false,
    this.applyToOverrides = false,
  });

  final LectureOriginWriteInput payload;
  final String? lectureId;
  final int? expectedVersion;
  final Set<LectureField>? updatedFields;
  final bool applyToFollowing;
  final bool applyToOverrides;
}
