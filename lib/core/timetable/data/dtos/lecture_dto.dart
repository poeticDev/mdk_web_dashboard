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
    this.status = 'scheduled',
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

  factory LectureDto.fromJson(Map<String, Object?> json) {
    final List<DateTime> parsedExceptions = _extractRecurrenceExceptions(json);
    return LectureDto(
      id: _string(json, 'lectureId') ?? _string(json, 'id') ?? '',
      title: _string(json, 'title') ?? '',
      type: _string(json, 'type') ?? 'lecture',
      status: _string(json, 'status') ?? 'scheduled',
      classroomId: _string(json, 'classroomId') ?? '',
      classroomName: _string(json, 'classroomName'),
      externalCode: _string(json, 'externalCode'),
      departmentId: _string(json, 'departmentId'),
      departmentName: _string(json, 'departmentName'),
      instructorId:
          _string(json, 'instructorUserId') ?? _string(json, 'instructorId'),
      instructorName: _string(json, 'instructorName'),
      startTime: DateTimeUtils.toLocal(
        DateTimeUtils.parseUtcFromJson(json['startTime']),
      ),
      endTime: DateTimeUtils.toLocal(
        DateTimeUtils.parseUtcFromJson(json['endTime']),
      ),
      version: int.tryParse(_string(json, 'version') ?? '') ?? 0,
      createdAt: DateTimeUtils.toLocal(
        DateTimeUtils.parseUtcFromJson(json['createdAt']),
      ),
      updatedAt: DateTimeUtils.toLocal(
        DateTimeUtils.parseUtcFromJson(json['updatedAt']),
      ),
      colorHex: _string(json, 'colorHex'),
      recurrenceRule: _extractRecurrenceRule(json),
      recurrenceExceptions: parsedExceptions,
      notes: _string(json, 'notes'),
    );
  }

  Map<String, Object?> toJson() {
    final Map<String, Object?> json = <String, Object?>{
      'lectureId': id,
      'title': title,
      'type': type,
      'classroomId': classroomId,
      'startTime': startTime.toUtc().toIso8601String(),
      'endTime': endTime.toUtc().toIso8601String(),
      'version': version,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
    _write(json, 'status', status);
    _write(json, 'classroomName', classroomName);
    _write(json, 'externalCode', externalCode);
    _write(json, 'departmentId', departmentId);
    _write(json, 'departmentName', departmentName);
    _write(json, 'instructorUserId', instructorId);
    _write(json, 'instructorName', instructorName);
    _write(json, 'colorHex', colorHex);
    final Map<String, Object?>? recurrence = _buildRecurrenceJson();
    if (recurrence != null) {
      json['recurrence'] = recurrence;
    }
    if (notes != null) {
      json['notes'] = notes;
    }
    return json;
  }

  static String? _string(Map<String, Object?> json, String key) {
    final Object? value = json[key];
    return value == null ? null : value.toString();
  }

  static List<DateTime> _extractRecurrenceExceptions(
    Map<String, Object?> json,
  ) {
    if (json['recurrence'] is Map<String, Object?>) {
      final Map<String, Object?> recurrence =
          json['recurrence']! as Map<String, Object?>;
      final List<DateTime> exDates =
          _parseDateList(recurrence['exDates'] as List<Object?>?);
      if (exDates.isNotEmpty) {
        return exDates;
      }
    }
    return _parseDateList(json['recurrenceExceptions'] as List<Object?>?);
  }

  static List<DateTime> _parseDateList(List<Object?>? raw) {
    final List<Object?> safeList = raw ?? <Object?>[];
    return safeList
        .map(
          (Object? value) => DateTimeUtils.toLocal(
            DateTimeUtils.parseUtcFromJson(value),
          ),
        )
        .toList();
  }

  static String? _extractRecurrenceRule(Map<String, Object?> json) {
    if (json['recurrence'] is Map<String, Object?>) {
      final Map<String, Object?> recurrence =
          json['recurrence']! as Map<String, Object?>;
      final String? rule = _string(recurrence, 'rrule');
      if (rule != null && rule.isNotEmpty) {
        return rule;
      }
    }
    return _string(json, 'recurrenceRule');
  }

  Map<String, Object?>? _buildRecurrenceJson() {
    final String? rule = recurrenceRule;
    if (rule == null || rule.trim().isEmpty) {
      return null;
    }
    final List<String> exDates = recurrenceExceptions
        .map((DateTime date) => date.toUtc().toIso8601String())
        .toList();
    return <String, Object?>{
      'rrule': rule,
      if (exDates.isNotEmpty) 'exDates': exDates,
    };
  }

  static void _write(
    Map<String, Object?> target,
    String key,
    Object? value,
  ) {
    if (value == null) {
      return;
    }
    target[key] = value;
  }
}
