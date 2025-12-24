/// 조회 API에 전달할 쿼리 파라미터 묶음.
class LectureOriginQueryRequest {
  const LectureOriginQueryRequest({
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
  final String? type;
  final String? status;

  Map<String, Object?> toQueryParameters() {
    return <String, Object?>{
      'from': from.toUtc().toIso8601String(),
      'to': to.toUtc().toIso8601String(),
      if (timezone != null) 'tz': timezone,
      if (departmentId != null) 'departmentId': departmentId,
      if (instructorId != null) 'instructorId': instructorId,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
    };
  }
}

/// 생성/수정 API 요청 본문을 구성하는 DTO.
class LecturePayloadDto {
  const LecturePayloadDto({
    this.title,
    this.type,
    this.classroomId,
    this.startTime,
    this.endTime,
    this.externalCode,
    this.departmentId,
    this.instructorId,
    this.colorHex,
    this.recurrenceRule,
    this.recurrenceExceptionDates,
    this.notes,
  });

  final String? title;
  final String? type;
  final String? classroomId;
  final String? externalCode;
  final String? departmentId;
  final String? instructorId;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? colorHex;
  final String? recurrenceRule;
  final List<DateTime>? recurrenceExceptionDates;
  final String? notes;

  factory LecturePayloadDto.create({
    required String title,
    required String type,
    required String classroomId,
    required DateTime startTime,
    required DateTime endTime,
    String? externalCode,
    String? departmentId,
    String? instructorId,
    String? colorHex,
    String? recurrenceRule,
    List<DateTime>? recurrenceExceptionDates,
    String? notes,
  }) {
    return LecturePayloadDto(
      title: title,
      type: type,
      classroomId: classroomId,
      startTime: startTime,
      endTime: endTime,
      externalCode: externalCode,
      departmentId: departmentId,
      instructorId: instructorId,
      colorHex: colorHex,
      recurrenceRule: recurrenceRule,
      recurrenceExceptionDates: recurrenceExceptionDates,
      notes: notes,
    );
  }

  Map<String, Object?> toJson() {
    final Map<String, Object?> json = <String, Object?>{};
    void put(String key, Object? value) {
      if (value == null) {
        return;
      }
      if (value is DateTime) {
        json[key] = value.toUtc().toIso8601String();
        return;
      }
      json[key] = value;
    }

    put('title', title);
    put('type', type);
    put('classroomId', classroomId);
    put('externalCode', externalCode);
    put('departmentId', departmentId);
    put('instructorUserId', instructorId);
    put('startTime', startTime);
    put('endTime', endTime);
    put('colorHex', colorHex);
    _writeRecurrence(json);
    put('notes', notes);
    return json;
  }

  void _writeRecurrence(Map<String, Object?> json) {
    if (recurrenceRule == null) {
      return;
    }
    final List<DateTime>? exceptions = recurrenceExceptionDates;
    json['recurrence'] = <String, Object?>{
      'rrule': recurrenceRule,
      if (exceptions != null && exceptions.isNotEmpty)
        'exDates': exceptions
            .map((DateTime date) => date.toUtc().toIso8601String())
            .toList(),
    };
  }
}

/// PATCH /lectures/{id} 호출 시 필요한 정보.
class UpdateLectureRequest {
  const UpdateLectureRequest({
    required this.lectureId,
    required this.payload,
    this.expectedVersion,
    this.applyToFollowing = false,
    this.applyToOverrides = false,
  });

  final String lectureId;
  final LecturePayloadDto payload;
  final int? expectedVersion;
  final bool applyToFollowing;
  final bool applyToOverrides;
}

/// DELETE /lectures/{id} 요청 파라미터.
class DeleteLectureRequest {
  const DeleteLectureRequest({
    required this.lectureId,
    required this.expectedVersion,
    this.applyToFollowing = false,
  });

  final String lectureId;
  final int expectedVersion;
  final bool applyToFollowing;
}
