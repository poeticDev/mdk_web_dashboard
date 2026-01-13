/// ROLE
/// - Current Lecture SSE DTO를 정의한다
///
/// RESPONSIBILITY
/// - 구독 요청/응답 모델링
/// - 스냅샷/델타 payload 모델링
///
/// DEPENDS ON
/// - date_time_utils
library;

import 'package:flutter/foundation.dart';
import 'package:web_dashboard/common/utils/date_time_utils.dart';

@immutable
class OccurrenceNowSubscriptionRequestDto {
  const OccurrenceNowSubscriptionRequestDto({
    required this.classroomIds,
    required this.include,
  });

  final List<String> classroomIds;
  final List<String> include;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'classroomIds': classroomIds,
      'include': include,
    };
  }
}

@immutable
class OccurrenceNowSubscriptionResponseDto {
  const OccurrenceNowSubscriptionResponseDto({required this.subscriptionId});

  factory OccurrenceNowSubscriptionResponseDto.fromJson(
    Map<String, Object?> json,
  ) {
    return OccurrenceNowSubscriptionResponseDto(
      subscriptionId: json['subscriptionId']?.toString() ?? '',
    );
  }

  final String subscriptionId;
}

@immutable
class OccurrenceNowSnapshotPayloadDto {
  const OccurrenceNowSnapshotPayloadDto({
    required this.currents,
    this.scheduleSummary,
  });

  factory OccurrenceNowSnapshotPayloadDto.fromJson(Map<String, Object?> json) {
    return OccurrenceNowSnapshotPayloadDto(
      scheduleSummary: _parseNullable<ScheduleSummaryDto>(
        json['scheduleSummary'],
        ScheduleSummaryDto.fromJson,
      ),
      currents: _parseList<OccurrenceNowCurrentDto>(
        json['currents'],
        OccurrenceNowCurrentDto.fromJson,
      ),
    );
  }

  final List<OccurrenceNowCurrentDto> currents;
  final ScheduleSummaryDto? scheduleSummary;
}

@immutable
class OccurrenceNowDeltaPayloadDto {
  const OccurrenceNowDeltaPayloadDto({
    required this.currents,
    this.scheduleSummary,
  });

  factory OccurrenceNowDeltaPayloadDto.fromJson(Map<String, Object?> json) {
    return OccurrenceNowDeltaPayloadDto(
      scheduleSummary: _parseNullable<ScheduleSummaryDto>(
        json['scheduleSummary'],
        ScheduleSummaryDto.fromJson,
      ),
      currents: _parseList<OccurrenceNowCurrentDto>(
        json['currents'],
        OccurrenceNowCurrentDto.fromJson,
      ),
    );
  }

  final List<OccurrenceNowCurrentDto> currents;
  final ScheduleSummaryDto? scheduleSummary;
}

@immutable
class ScheduleSummaryDto {
  const ScheduleSummaryDto({
    required this.total,
    required this.inLecture,
    required this.noSchedule,
    required this.updatedAt,
  });

  factory ScheduleSummaryDto.fromJson(Map<String, Object?> json) {
    return ScheduleSummaryDto(
      total: json['total'] as int? ?? 0,
      inLecture: json['inLecture'] as int? ?? 0,
      noSchedule: json['noSchedule'] as int? ?? 0,
      updatedAt: DateTimeUtils.toLocal(
        DateTimeUtils.parseUtcFromJson(json['updatedAt']),
      ),
    );
  }

  final int total;
  final int inLecture;
  final int noSchedule;
  final DateTime updatedAt;
}

@immutable
class OccurrenceNowCurrentDto {
  const OccurrenceNowCurrentDto({
    required this.classroomId,
    required this.occurrenceId,
    required this.lectureId,
    required this.title,
    required this.instructorName,
    required this.startAt,
    required this.endAt,
    required this.status,
    this.departmentName,
    this.colorHex,
  });

  factory OccurrenceNowCurrentDto.fromJson(Map<String, Object?> json) {
    return OccurrenceNowCurrentDto(
      classroomId: json['classroomId']?.toString() ?? '',
      occurrenceId: json['occurrenceId']?.toString() ?? '',
      lectureId: json['lectureId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      instructorName: json['instructorName']?.toString() ?? '',
      startAt: DateTimeUtils.toLocal(
        DateTimeUtils.parseUtcFromJson(json['startAt']),
      ),
      endAt: DateTimeUtils.toLocal(
        DateTimeUtils.parseUtcFromJson(json['endAt']),
      ),
      status: json['status']?.toString() ?? 'scheduled',
      departmentName: json['departmentName']?.toString(),
      colorHex: json['colorHex']?.toString(),
    );
  }

  final String classroomId;
  final String occurrenceId;
  final String lectureId;
  final String title;
  final String instructorName;
  final DateTime startAt;
  final DateTime endAt;
  final String status;
  final String? departmentName;
  final String? colorHex;
}

T? _parseNullable<T>(
  Object? raw,
  T Function(Map<String, Object?> json) mapper,
) {
  if (raw is Map<String, Object?>) {
    return mapper(raw);
  }
  return null;
}

List<T> _parseList<T>(
  Object? raw,
  T Function(Map<String, Object?> json) mapper,
) {
  if (raw is List<Object?>) {
    return raw
        .whereType<Map<String, Object?>>()
        .map((Map<String, Object?> item) => mapper(item))
        .toList();
  }
  return <T>[];
}
