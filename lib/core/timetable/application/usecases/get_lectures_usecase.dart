import 'package:web_dashboard/core/timetable/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_repository.dart';

/// 강의 일정 목록을 조회하는 UseCase.
class GetLecturesUseCase {
  const GetLecturesUseCase(this._repository);

  final LectureRepository _repository;

  Future<List<LectureEntity>> execute(LectureQuery query) {
    return _repository.fetchLectures(query);
  }
}
