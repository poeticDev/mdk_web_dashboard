/// ROLE
/// - 유즈케이스를 제공한다
///
/// RESPONSIBILITY
/// - 도메인 요청을 실행한다
///
/// DEPENDS ON
/// - lecture_entity
/// - lecture_origin_repository
library;

import 'package:web_dashboard/domains/schedule/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/domains/schedule/domain/repositories/lecture_origin_repository.dart';

/// 강의 일정 목록을 조회하는 UseCase.
class GetLecturesUseCase {
  const GetLecturesUseCase(this._repository);

  final LectureOriginRepository _repository;

  Future<List<LectureEntity>> execute(LectureOriginQuery query) {
    return _repository.fetchLectures(query);
  }
}
