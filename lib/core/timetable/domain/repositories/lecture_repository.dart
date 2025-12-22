import 'package:web_dashboard/core/timetable/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_status.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_type.dart';

/// 업데이트 시 어떤 필드가 변했는지 나타내는 열거형.
enum LectureField {
  title,
  type,
  classroomId,
  startTime,
  endTime,
  departmentId,
  instructorId,
  colorHex,
  recurrenceRule,
  notes,
}

/// 강의 일정 CRUD를 담당하는 도메인 레이어 계약.
abstract class LectureRepository {
  Future<List<LectureEntity>> fetchLectures(LectureQuery query);
  Future<LectureEntity> createLecture(LectureWriteInput input);
  Future<LectureEntity> updateLecture(UpdateLectureInput input);
  Future<void> deleteLecture(DeleteLectureInput input);
}

/// GET /lectures 호출을 위한 필터 파라미터.
class LectureQuery {
  const LectureQuery({
    required this.from,
    required this.to,
    required this.classroomId,
    this.timezone,
    this.departmentId,
    this.instructorId,
    this.type,
    this.status,
  });

  final DateTime from;
  final DateTime to;
  final String classroomId;
  final String? timezone;
  final String? departmentId;
  final String? instructorId;
  final LectureType? type;
  final LectureStatus? status;
}

/// 신규/수정 요청에 사용되는 입력 값.
class LectureWriteInput {
  const LectureWriteInput({
    required this.title,
    required this.type,
    required this.classroomId,
    required this.start,
    required this.end,
    this.externalCode,
    this.departmentId,
    this.instructorId,
    this.colorHex,
    this.recurrenceRule,
    this.notes,
  });

  final String title;
  final LectureType type;
  final String classroomId;
  final String? externalCode;
  final String? departmentId;
  final String? instructorId;
  final DateTime start;
  final DateTime end;
  final String? colorHex;
  final String? recurrenceRule;
  final String? notes;
}

/// 반복 일정 수정 시 개별/시리즈 선택을 포함한 입력 값.
class UpdateLectureInput {
  const UpdateLectureInput({
    required this.lectureId,
    required this.payload,
    this.expectedVersion,
    this.updatedFields,
  });

  final String lectureId;
  final LectureWriteInput payload;
  final int? expectedVersion;
  final Set<LectureField>? updatedFields;
}

/// 삭제 요청 시 반복 일정 범위를 제어하는 입력 값.
class DeleteLectureInput {
  const DeleteLectureInput({
    required this.lectureId,
    required this.expectedVersion,
  });

  final String lectureId;
  final int expectedVersion;
}
