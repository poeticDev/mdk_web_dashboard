import 'package:web_dashboard/common/utils/date_time_utils.dart';

/// /lectures 응답 구조를 표현하는 DTO.
class LectureDto {
  LectureDto({
    required this.id,
    required this.title,
    required this.type,
    required this.classroomId,
    required this.startTime,
    required this.endTime,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.status = 'ACTIVE',
    this.classroomName,
    this.externalCode,
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
  final String? classroomName;
  final String? externalCode;
  final String? departmentId;
  final String? departmentName;
  final String? instructorId;
  final String? instructorName;
  final DateTime startTime;
  final DateTime endTime;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? colorHex;
  final String? recurrenceRule;
  final List<DateTime> recurrenceExceptions;
  final String? notes;

  /// JSON 맵을 DTO로 변환한다.
  factory LectureDto.fromJson(Map<String, Object?> json) {
    final List<Object?> rawExceptions =
        json['recurrenceExceptions'] as List<Object?>? ?? <Object?>[];

    return LectureDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      type: json['type']?.toString() ?? 'LECTURE',
      status: json['status']?.toString() ?? 'ACTIVE',
      classroomId: json['classroomId']?.toString() ?? '',
      classroomName: json['classroomName']?.toString(),
      externalCode: json['externalCode']?.toString(),
      departmentId: json['departmentId']?.toString(),
      departmentName: json['departmentName']?.toString(),
      instructorId: json['instructorId']?.toString(),
      instructorName: json['instructorName']?.toString(),
      startTime: DateTimeUtils.parseUtcFromJson(json['startTime']),
      endTime: DateTimeUtils.parseUtcFromJson(json['endTime']),
      version: int.tryParse(json['version']?.toString() ?? '') ?? 0,
      createdAt: DateTimeUtils.parseUtcFromJson(json['createdAt']),
      updatedAt: DateTimeUtils.parseUtcFromJson(json['updatedAt']),
      colorHex: json['colorHex']?.toString(),
      recurrenceRule: json['recurrenceRule']?.toString(),
      recurrenceExceptions: rawExceptions
          .map((Object? value) => DateTimeUtils.parseUtcFromJson(value))
          .toList(),
      notes: json['notes']?.toString(),
    );
  }

  /// API 전송용 JSON으로 직렬화한다.
  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'title': title,
      'type': type,
      'status': status,
      'classroomId': classroomId,
      'classroomName': classroomName,
      'externalCode': externalCode,
      'departmentId': departmentId,
      'departmentName': departmentName,
      'instructorId': instructorId,
      'instructorName': instructorName,
      'startTime': startTime.toUtc().toIso8601String(),
      'endTime': endTime.toUtc().toIso8601String(),
      'version': version,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'colorHex': colorHex,
      'recurrenceRule': recurrenceRule,
      'recurrenceExceptions': recurrenceExceptions
          .map((DateTime date) => date.toUtc().toIso8601String())
          .toList(),
      'notes': notes,
    };
  }
}
