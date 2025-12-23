import 'package:web_dashboard/common/utils/date_time_utils.dart';

class LectureOccurrenceDto {
  LectureOccurrenceDto({
    required this.id,
    required this.lectureId,
    required this.classroomId,
    required this.classroomName,
    required this.title,
    required this.type,
    required this.status,
    required this.isOverride,
    required this.sourceVersion,
    required this.startAt,
    required this.endAt,
    this.colorHex,
    this.notes,
    this.department,
    this.instructor,
  });

  final String id;
  final String lectureId;
  final String classroomId;
  final String classroomName;
  final String title;
  final String type;
  final String status;
  final bool isOverride;
  final int sourceVersion;
  final DateTime startAt;
  final DateTime endAt;
  final String? colorHex;
  final String? notes;
  final DepartmentSnapshotDto? department;
  final InstructorSnapshotDto? instructor;

  factory LectureOccurrenceDto.fromJson(Map<String, Object?> json) {
    return LectureOccurrenceDto(
      id: json['id']?.toString() ?? '',
      lectureId: json['lectureId']?.toString() ?? '',
      classroomId: json['classroomId']?.toString() ?? '',
      classroomName: json['classroomName']?.toString() ??
          json['classroomId']?.toString() ??
          '',
      title: json['title']?.toString() ?? '',
      type: json['type']?.toString() ?? 'lecture',
      status: json['status']?.toString() ?? 'scheduled',
      isOverride: json['isOverride'] as bool? ?? false,
      sourceVersion: int.tryParse(json['sourceVersion']?.toString() ?? '') ?? 0,
      startAt: DateTimeUtils.parseUtcFromJson(json['startAt']),
      endAt: DateTimeUtils.parseUtcFromJson(json['endAt']),
      colorHex: json['colorHex']?.toString(),
      notes: json['notes']?.toString(),
      department: json['department'] is Map<String, Object?>
          ? DepartmentSnapshotDto.fromJson(
              json['department']! as Map<String, Object?>,
            )
          : null,
      instructor: json['instructor'] is Map<String, Object?>
          ? InstructorSnapshotDto.fromJson(
              json['instructor']! as Map<String, Object?>,
            )
          : null,
    );
  }
}

class DepartmentSnapshotDto {
  DepartmentSnapshotDto({
    required this.id,
    required this.name,
    this.code,
  });

  final String id;
  final String name;
  final String? code;

  factory DepartmentSnapshotDto.fromJson(Map<String, Object?> json) {
    return DepartmentSnapshotDto(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString(),
    );
  }
}

class InstructorSnapshotDto {
  InstructorSnapshotDto({
    required this.id,
    required this.displayName,
    this.email,
  });

  final String id;
  final String displayName;
  final String? email;

  factory InstructorSnapshotDto.fromJson(Map<String, Object?> json) {
    return InstructorSnapshotDto(
      id: json['id']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
      email: json['email']?.toString(),
    );
  }
}
