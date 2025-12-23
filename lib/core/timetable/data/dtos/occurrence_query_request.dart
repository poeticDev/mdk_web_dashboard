class OccurrenceQueryRequest {
  const OccurrenceQueryRequest({
    required this.classroomId,
    required this.from,
    required this.to,
  });

  final String classroomId;
  final DateTime from;
  final DateTime to;

  Map<String, Object?> toQueryParameters() {
    return <String, Object?>{
      'classroomId': classroomId,
      'from': from.toUtc().toIso8601String(),
      'to': to.toUtc().toIso8601String(),
    };
  }
}
