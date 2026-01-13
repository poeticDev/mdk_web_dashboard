/// ROLE
/// - API DTO를 정의한다
///
/// RESPONSIBILITY
/// - 응답/요청 필드를 모델링한다
/// - JSON 변환을 제공한다
///
/// DEPENDS ON
/// - 없음
library;

class OccurrenceQueryRequest {
  const OccurrenceQueryRequest({
    required this.classroomId,
    required this.from,
    required this.to,
  });

  final String classroomId;
  final DateTime from;
  final DateTime to;

  Map<String, Object?> toQueryParameters() {
    return <String, Object?>{
      'classroomId': classroomId,
      'from': from.toUtc().toIso8601String(),
      'to': to.toUtc().toIso8601String(),
    };
  }
}

class OccurrenceCreateRequest {
  const OccurrenceCreateRequest({
    required this.lectureId,
    required this.classroomId,
    required this.startAt,
    required this.endAt,
    this.colorHex,
    this.notes,
  });

  final String lectureId;
  final String classroomId;
  final DateTime startAt;
  final DateTime endAt;
  final String? colorHex;
  final String? notes;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'lectureId': lectureId,
      'classroomId': classroomId,
      'startAt': startAt.toUtc().toIso8601String(),
      'endAt': endAt.toUtc().toIso8601String(),
      if (colorHex != null) 'colorHex': colorHex,
      if (notes != null) 'notes': notes,
    };
  }
}

class OccurrenceUpdateRequest {
  const OccurrenceUpdateRequest({
    required this.occurrenceId,
    this.startAt,
    this.endAt,
    this.status,
    this.cancelReason,
    this.scope = 'single',
    this.applyToOverrides = false,
    // this.expectedVersion,
    this.titleOverride,
    this.colorHexOverride,
    this.notesOverride,
    this.departmentIdOverride,
    this.instructorUserIdOverride,
  });

  final String occurrenceId;
  final DateTime? startAt;
  final DateTime? endAt;
  final String? status;
  final String? cancelReason;
  final String scope;
  final bool applyToOverrides;
  final String? titleOverride;
  final String? colorHexOverride;
  final String? notesOverride;
  final String? departmentIdOverride;
  final String? instructorUserIdOverride;

  Map<String, Object?> toJson() {
    final Map<String, Object?> body = <String, Object?>{
      'scope': scope,
      'applyToOverrides': applyToOverrides,
    };
    void put(String key, Object? value) {
      if (value == null) {
        return;
      }
      if (value is DateTime) {
        body[key] = value.toUtc().toIso8601String();
        return;
      }
      body[key] = value;
    }

    put('startAt', startAt);
    put('endAt', endAt);
    put('status', status);
    put('cancelReason', cancelReason);
    put('title', titleOverride);
    put('colorHex', colorHexOverride);
    put('notes', notesOverride);
    put('departmentId', departmentIdOverride);
    put('instructorUserId', instructorUserIdOverride);
    return body;
  }
}

class OccurrenceDeleteRequest {
  const OccurrenceDeleteRequest({
    required this.occurrenceId,
    this.applyToFollowing = false,
    this.applyToOverrides = false,
  });

  final String occurrenceId;
  final bool applyToFollowing;
  final bool applyToOverrides;

  Map<String, Object?> toQueryParameters() {
    return <String, Object?>{
      if (applyToFollowing) 'applyToFollowing': applyToFollowing,
      if (applyToOverrides) 'applyToOverrides': applyToOverrides,
    };
  }
}
