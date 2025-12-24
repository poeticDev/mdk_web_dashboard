import 'package:web_dashboard/core/timetable/domain/entities/lecture_occurrence_entity.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_occurrence_query.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_status.dart';

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
    this.applyToFollowing = false,
  });

  final String occurrenceId;
  final DateTime? start;
  final DateTime? end;
  final LectureStatus? status;
  final String? cancelReason;
  final bool applyToFollowing;
}

class LectureOccurrenceDeleteInput {
  const LectureOccurrenceDeleteInput({
    required this.occurrenceId,
    this.applyToFollowing = false,
  });

  final String occurrenceId;
  final bool applyToFollowing;
}
