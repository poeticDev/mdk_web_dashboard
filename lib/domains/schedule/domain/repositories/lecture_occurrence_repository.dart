/// ROLE
/// - 도메인 리포지토리 계약을 정의한다
///
/// RESPONSIBILITY
/// - 데이터 접근 인터페이스를 제공한다
///
/// DEPENDS ON
/// - lecture_occurrence_entity
/// - lecture_occurrence_query
/// - lecture_status
library;

import 'package:web_dashboard/domains/schedule/domain/entities/lecture_occurrence_entity.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_occurrence_query.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_status.dart';

abstract class LectureOccurrenceRepository {
  Future<List<LectureOccurrenceEntity>> fetchOccurrences(
    LectureOccurrenceQuery query,
  );
  Future<LectureOccurrenceEntity> createOccurrence(
    LectureOccurrenceWriteInput input,
  );
  Future<LectureOccurrenceEntity> updateOccurrence(
    LectureOccurrenceUpdateInput input,
  );
  Future<void> deleteOccurrence(LectureOccurrenceDeleteInput input);
}

class LectureOccurrenceWriteInput {
  const LectureOccurrenceWriteInput({
    required this.lectureId,
    required this.classroomId,
    required this.start,
    required this.end,
    this.colorHex,
    this.notes,
  });

  final String lectureId;
  final String classroomId;
  final DateTime start;
  final DateTime end;
  final String? colorHex;
  final String? notes;
}

class LectureOccurrenceUpdateInput {
  const LectureOccurrenceUpdateInput({
    required this.occurrenceId,
    this.start,
    this.end,
    this.status,
    this.cancelReason,
    this.scope = 'single',
    this.applyToOverrides = false,
    this.expectedVersion,
    this.titleOverride,
    this.colorHexOverride,
    this.notesOverride,
    this.departmentIdOverride,
    this.instructorUserIdOverride,
  });

  final String occurrenceId;
  final DateTime? start;
  final DateTime? end;
  final LectureStatus? status;
  final String? cancelReason;
  final String scope;
  final bool applyToOverrides;
  final int? expectedVersion;
  final String? titleOverride;
  final String? colorHexOverride;
  final String? notesOverride;
  final String? departmentIdOverride;
  final String? instructorUserIdOverride;
}

class LectureOccurrenceDeleteInput {
  const LectureOccurrenceDeleteInput({
    required this.occurrenceId,
    this.applyToFollowing = false,
    this.applyToOverrides = false,
  });

  final String occurrenceId;
  final bool applyToFollowing;
  final bool applyToOverrides;
}
