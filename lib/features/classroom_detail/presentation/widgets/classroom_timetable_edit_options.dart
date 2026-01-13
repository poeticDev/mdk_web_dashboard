// 시간표 편집 옵션 UI를 제공한다.
import 'package:web_dashboard/domains/schedule/domain/repositories/lecture_origin_repository.dart';

enum LectureEditScopeOption {
  occurrenceOnly,
  followingSeries,
  entireSeries,
}

enum LectureDeleteScopeOption {
  occurrenceOnly,
  followingSeries,
  entireSeries,
}

class LectureEditCommand {
  const LectureEditCommand({
    required this.occurrenceId,
    required this.lectureId,
    required this.payload,
    required this.scope,
    required this.includeOverrides,
    required this.expectedVersion,
    this.allowsFullOverride = true,
  });

  final String occurrenceId;
  final String lectureId;
  final LectureOriginWriteInput payload;
  final LectureEditScopeOption scope;
  final bool includeOverrides;
  final int? expectedVersion;
  final bool allowsFullOverride;
}

class LectureDeleteCommand {
  const LectureDeleteCommand({
    required this.occurrenceId,
    required this.lectureId,
    required this.scope,
    required this.expectedVersion,
    this.includeOverrides = false,
  });

  final String occurrenceId;
  final String lectureId;
  final LectureDeleteScopeOption scope;
  final int? expectedVersion;
  final bool includeOverrides;
}
