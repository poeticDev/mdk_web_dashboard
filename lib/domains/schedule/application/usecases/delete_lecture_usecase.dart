/// ROLE
/// - 유즈케이스를 제공한다
///
/// RESPONSIBILITY
/// - 도메인 요청을 실행한다
///
/// DEPENDS ON
/// - lecture_origin_repository
library;

import 'package:web_dashboard/domains/schedule/domain/repositories/lecture_origin_repository.dart';

/// 강의 일정을 삭제하는 UseCase.
class DeleteLectureUseCase {
  const DeleteLectureUseCase(this._repository);

  final LectureOriginRepository _repository;

  Future<void> execute(LectureOriginDeleteInput input) {
    return _repository.deleteLecture(input);
  }
}
