class LectureQueryRequest {
  const LectureQueryRequest({
    required this.from,
    required this.to,
    required this.classroomId,
    this.departmentId,
    this.instructorId,
    this.type,
    this.status,
  });

  final DateTime from;
  final DateTime to;
  final String classroomId;
  final String? departmentId;
  final String? instructorId;
  final String? type;
  final String? status;

  Map<String, Object?> toQueryParameters() {
    return <String, Object?>{
      'from': from.toUtc().toIso8601String(),
      'to': to.toUtc().toIso8601String(),
      'classroomId': classroomId,
      if (departmentId != null) 'departmentId': departmentId,
      if (instructorId != null) 'instructorId': instructorId,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
    };
  }
}

class LecturePayloadDto {
  const LecturePayloadDto({
    required this.title,
    required this.type,
    required this.status,
    required this.classroomId,
    required this.startTime,
    required this.endTime,
    this.classroomName,
    this.departmentId,
    this.departmentName,
    this.instructorId,
    this.instructorName,
    this.colorHex,
    this.recurrenceRule,
    this.recurrenceExceptions = const <DateTime>[],
    this.notes,
  });

  final String title;
  final String type;
  final String status;
  final String classroomId;
  final String? classroomName;
  final String? departmentId;
  final String? departmentName;
  final String? instructorId;
  final String? instructorName;
  final DateTime startTime;
  final DateTime endTime;
  final String? colorHex;
  final String? recurrenceRule;
  final List<DateTime> recurrenceExceptions;
  final String? notes;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'title': title,
      'type': type,
      'status': status,
      'classroomId': classroomId,
      'classroomName': classroomName,
      'departmentId': departmentId,
      'departmentName': departmentName,
      'instructorId': instructorId,
      'instructorName': instructorName,
      'startTime': startTime.toUtc().toIso8601String(),
      'endTime': endTime.toUtc().toIso8601String(),
      'colorHex': colorHex,
      'recurrenceRule': recurrenceRule,
      'recurrenceExceptions': recurrenceExceptions
          .map((DateTime date) => date.toUtc().toIso8601String())
          .toList(),
      'notes': notes,
    };
  }
}

class UpdateLectureRequest {
  const UpdateLectureRequest({
    required this.lectureId,
    required this.payload,
    this.applyToSeries = false,
  });

  final String lectureId;
  final LecturePayloadDto payload;
  final bool applyToSeries;

  Map<String, Object?> toQueryParameters() {
    return applyToSeries ? <String, Object?>{'applyToSeries': true} : <String, Object?>{};
  }
}

class DeleteLectureRequest {
  const DeleteLectureRequest({
    required this.lectureId,
    this.deleteSeries = false,
  });

  final String lectureId;
  final bool deleteSeries;

  Map<String, Object?> toQueryParameters() {
    return deleteSeries ? <String, Object?>{'deleteSeries': true} : <String, Object?>{};
  }
}
