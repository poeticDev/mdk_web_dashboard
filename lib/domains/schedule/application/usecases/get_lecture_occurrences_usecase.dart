/// ROLE
/// - 유즈케이스를 제공한다
///
/// RESPONSIBILITY
/// - 도메인 요청을 실행한다
///
/// DEPENDS ON
/// - lecture_occurrence_entity
/// - lecture_occurrence_query
/// - lecture_occurrence_repository
library;

import 'package:web_dashboard/domains/schedule/domain/entities/lecture_occurrence_entity.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_occurrence_query.dart';
import 'package:web_dashboard/domains/schedule/domain/repositories/lecture_occurrence_repository.dart';

class GetLectureOccurrencesUseCase {
  const GetLectureOccurrencesUseCase(this._repository);

  final LectureOccurrenceRepository _repository;

  Future<List<LectureOccurrenceEntity>> execute(
    LectureOccurrenceQuery query,
  ) {
    return _repository.fetchOccurrences(query);
  }
}
