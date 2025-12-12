class LectureDto {
  LectureDto({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.classroomId,
    required this.classroomName,
    required this.startTime,
    required this.endTime,
    this.departmentId,
    this.departmentName,
    this.instructorId,
    this.instructorName,
    this.colorHex,
    this.recurrenceRule,
    List<DateTime> recurrenceExceptions = const <DateTime>[],
    this.notes,
  }) : recurrenceExceptions = List<DateTime>.unmodifiable(recurrenceExceptions);

  final String id;
  final String title;
  final String type;
  final String status;
  final String classroomId;
  final String classroomName;
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

  factory LectureDto.fromJson(Map<String, Object?> json) {
    final List<Object?> rawExceptions =
        json['recurrenceExceptions'] as List<Object?>? ?? <Object?>[];
    return LectureDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      type: json['type']?.toString() ?? 'LECTURE',
      status: json['status']?.toString() ?? 'ACTIVE',
      classroomId: json['classroomId']?.toString() ?? '',
      classroomName: json['classroomName']?.toString() ?? '',
      departmentId: json['departmentId']?.toString(),
      departmentName: json['departmentName']?.toString(),
      instructorId: json['instructorId']?.toString(),
      instructorName: json['instructorName']?.toString(),
      startTime: DateTime.parse(json['startTime']!.toString()),
      endTime: DateTime.parse(json['endTime']!.toString()),
      colorHex: json['colorHex']?.toString(),
      recurrenceRule: json['recurrenceRule']?.toString(),
      recurrenceExceptions: rawExceptions
          .whereType<String>()
          .map(DateTime.parse)
          .toList(),
      notes: json['notes']?.toString(),
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
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
