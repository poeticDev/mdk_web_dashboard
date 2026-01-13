/// ROLE
/// - 유즈케이스를 제공한다
///
/// RESPONSIBILITY
/// - 도메인 요청을 실행한다
///
/// DEPENDS ON
/// - lecture_occurrence_entity
/// - lecture_occurrence_repository
library;

import 'package:web_dashboard/domains/schedule/domain/entities/lecture_occurrence_entity.dart';
import 'package:web_dashboard/domains/schedule/domain/repositories/lecture_occurrence_repository.dart';

class CreateLectureOccurrenceUseCase {
  const CreateLectureOccurrenceUseCase(this._repository);

  final LectureOccurrenceRepository _repository;

  Future<LectureOccurrenceEntity> execute(
    LectureOccurrenceWriteInput input,
  ) {
    return _repository.createOccurrence(input);
  }
}
