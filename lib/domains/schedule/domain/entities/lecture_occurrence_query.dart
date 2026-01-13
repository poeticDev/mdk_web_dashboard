/// ROLE
/// - 도메인 엔티티를 정의한다
///
/// RESPONSIBILITY
/// - 핵심 필드를 보관한다
/// - 도메인 모델을 제공한다
///
/// DEPENDS ON
/// - 없음
library;

/// Occurrence 조회에 사용되는 파라미터.
class LectureOccurrenceQuery {
  const LectureOccurrenceQuery({
    required this.classroomId,
    required this.from,
    required this.to,
  });

  final String classroomId;
  final DateTime from;
  final DateTime to;
}
