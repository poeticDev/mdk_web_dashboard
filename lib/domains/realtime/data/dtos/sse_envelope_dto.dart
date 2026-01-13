/// ROLE
/// - SSE 공통 엔벨롭 DTO를 정의한다
///
/// RESPONSIBILITY
/// - 이벤트 메타데이터와 payload를 묶는다
/// - JSON 변환을 제공한다
///
/// DEPENDS ON
/// - date_time_utils
library;

import 'package:flutter/foundation.dart';
import 'package:web_dashboard/common/utils/date_time_utils.dart';

/// SSE 이벤트 공통 엔벨롭 DTO.
@immutable
class SseEnvelopeDto<T> {
  const SseEnvelopeDto({
    required this.eventId,
    required this.subscriptionId,
    required this.timestamp,
    required this.payload,
  });

  factory SseEnvelopeDto.fromJson(
    Map<String, Object?> json,
    T Function(Map<String, Object?> json) payloadMapper,
  ) {
    return SseEnvelopeDto<T>(
      eventId: json['eventId']?.toString() ?? '',
      subscriptionId: json['subscriptionId']?.toString() ?? '',
      timestamp: DateTimeUtils.toLocal(
        DateTimeUtils.parseUtcFromJson(json['ts']),
      ),
      payload: payloadMapper(_parseMap(json['payload'])),
    );
  }

  final String eventId;
  final String subscriptionId;
  final DateTime timestamp;
  final T payload;
}

Map<String, Object?> _parseMap(Object? raw) {
  if (raw is Map<String, Object?>) {
    return raw;
  }
  return <String, Object?>{};
}
