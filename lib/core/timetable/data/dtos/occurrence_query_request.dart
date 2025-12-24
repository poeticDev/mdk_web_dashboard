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
    this.applyToFollowing = false,
  });

  final String occurrenceId;
  final DateTime? startAt;
  final DateTime? endAt;
  final String? status;
  final String? cancelReason;
  final bool applyToFollowing;

  Map<String, Object?> toJson() {
    final Map<String, Object?> body = <String, Object?>{
      'applyToFollowing': applyToFollowing,
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
    return body;
  }
}

class OccurrenceDeleteRequest {
  const OccurrenceDeleteRequest({
    required this.occurrenceId,
    this.applyToFollowing = false,
  });

  final String occurrenceId;
  final bool applyToFollowing;

  Map<String, Object?> toQueryParameters() {
    return <String, Object?>{
      if (applyToFollowing) 'applyToFollowing': applyToFollowing,
    };
  }
}
