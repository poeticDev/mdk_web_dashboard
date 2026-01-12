import 'package:web_dashboard/domains/schedule/data/dtos/lecture_occurrence_dto.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_occurrence_entity.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_status.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_type.dart';

class LectureOccurrenceMapper {
  const LectureOccurrenceMapper();

  LectureOccurrenceEntity toEntity(LectureOccurrenceDto dto) {
    return LectureOccurrenceEntity(
      id: dto.id,
      lectureId: dto.lectureId,
      title: dto.title,
      type: LectureType.fromApi(dto.type),
      status: LectureStatus.fromApi(dto.status),
      isOverride: dto.isOverride,
      classroomId: dto.classroomId,
      classroomName: dto.classroomName,
      start: dto.startAt,
      end: dto.endAt,
      sourceVersion: dto.sourceVersion,
      colorHex: dto.colorHex,
      departmentId: dto.department?.id,
      departmentName: dto.department?.name,
      departmentCode: dto.department?.code,
      instructorId: dto.instructor?.id,
      instructorName: dto.instructor?.displayName,
      notes: dto.notes,
    );
  }
}
