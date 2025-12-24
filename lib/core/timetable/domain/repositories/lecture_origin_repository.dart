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

/// Origin 강의(master) CRUD 책임을 정의하는 계약.
abstract class LectureOriginRepository {
  Future<List<LectureEntity>> fetchLectures(LectureOriginQuery query);
  Future<LectureEntity> createLecture(LectureOriginWriteInput input);
  Future<LectureEntity> updateLecture(LectureOriginUpdateInput input);
  Future<void> deleteLecture(LectureOriginDeleteInput input);
}

/// Origin 강의 조회에 사용되는 필터.
class LectureOriginQuery {
  const LectureOriginQuery({
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

/// Origin 강의 생성/전체 수정에 사용되는 입력 값.
class LectureOriginWriteInput {
  const LectureOriginWriteInput({
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

/// Origin 강의 부분 수정 입력. override 플래그를 포함한다.
class LectureOriginUpdateInput {
  const LectureOriginUpdateInput({
    required this.lectureId,
    required this.payload,
    this.expectedVersion,
    this.updatedFields,
    this.applyToFollowing = false,
    this.applyToOverrides = false,
  });

  final String lectureId;
  final LectureOriginWriteInput payload;
  final int? expectedVersion;
  final Set<LectureField>? updatedFields;
  final bool applyToFollowing;
  final bool applyToOverrides;
}

/// Origin 강의 삭제 입력. applyToFollowing 플래그를 포함한다.
class LectureOriginDeleteInput {
  const LectureOriginDeleteInput({
    required this.lectureId,
    required this.expectedVersion,
    this.applyToFollowing = false,
    this.applyToOverrides = false,
  });

  final String lectureId;
  final int expectedVersion;
  final bool applyToFollowing;
  final bool applyToOverrides;
}
