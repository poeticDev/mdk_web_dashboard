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
