import 'package:web_dashboard/core/timetable/data/dtos/lecture_dto.dart';
import 'package:web_dashboard/core/timetable/data/dtos/lecture_request_dtos.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_status.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_type.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_repository.dart';

/// DTO ↔ 도메인 변환 책임을 담당하는 매퍼.
class LectureMapper {
  const LectureMapper();

  /// API 응답 DTO를 도메인 엔티티로 변환한다.
  LectureEntity toEntity(LectureDto dto) {
    return LectureEntity(
      id: dto.id,
      title: dto.title,
      type: LectureType.fromApi(dto.type),
      classroomId: dto.classroomId,
      classroomName: dto.classroomName,
      departmentId: dto.departmentId,
      departmentName: dto.departmentName,
      instructorId: dto.instructorId,
      instructorName: dto.instructorName,
      start: dto.startTime,
      end: dto.endTime,
      lectureStatus: LectureStatus.fromApi(dto.status),
      externalCode: dto.externalCode,
      version: dto.version,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      colorHex: dto.colorHex,
      recurrenceRule: dto.recurrenceRule,
      recurrenceExceptions: dto.recurrenceExceptions,
      notes: dto.notes,
    );
  }

  LectureQueryRequest toQueryRequest(LectureQuery query) {
    return LectureQueryRequest(
      from: query.from,
      to: query.to,
      classroomId: query.classroomId,
      timezone: query.timezone,
      departmentId: query.departmentId,
      instructorId: query.instructorId,
      type: query.type?.apiValue,
      status: query.status?.apiValue,
    );
  }

  LecturePayloadDto toPayload(LectureWriteInput input) {
    return LecturePayloadDto(
      title: input.title,
      type: input.type.apiValue,
      classroomId: input.classroomId,
      externalCode: input.externalCode,
      departmentId: input.departmentId,
      instructorId: input.instructorId,
      startTime: input.start,
      endTime: input.end,
      colorHex: input.colorHex,
      recurrenceRule: input.recurrenceRule,
      notes: input.notes,
    );
  }

  UpdateLectureRequest toUpdateRequest(UpdateLectureInput input) {
    return UpdateLectureRequest(
      lectureId: input.lectureId,
      payload: toPayload(input.payload),
      expectedVersion: input.expectedVersion,
    );
  }

  DeleteLectureRequest toDeleteRequest(DeleteLectureInput input) {
    return DeleteLectureRequest(
      lectureId: input.lectureId,
      expectedVersion: input.expectedVersion,
    );
  }
}
