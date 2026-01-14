/// ROLE
/// - Occurrence SSE 메시지를 정의한다
///
/// RESPONSIBILITY
/// - 스냅샷/델타 이벤트를 구분한다
///
/// DEPENDS ON
/// - sse_envelope_dto
/// - occurrence_now_sse_dto
library;

import 'package:web_dashboard/domains/realtime/data/dtos/occurrence_now_sse_dto.dart';
import 'package:web_dashboard/domains/realtime/data/dtos/sse_envelope_dto.dart';

enum OccurrenceNowSseEventType { snapshot, delta }

class OccurrenceNowSseEvent {
  const OccurrenceNowSseEvent.snapshot(this.envelope)
      : type = OccurrenceNowSseEventType.snapshot,
        deltaEnvelope = null;

  const OccurrenceNowSseEvent.delta(this.deltaEnvelope)
      : type = OccurrenceNowSseEventType.delta,
        envelope = null;

  final OccurrenceNowSseEventType type;
  final SseEnvelopeDto<OccurrenceNowSnapshotPayloadDto>? envelope;
  final SseEnvelopeDto<OccurrenceNowDeltaPayloadDto>? deltaEnvelope;

  OccurrenceNowSnapshotPayloadDto? get snapshotPayload => envelope?.payload;
  OccurrenceNowDeltaPayloadDto? get deltaPayload => deltaEnvelope?.payload;
  String? get eventId => envelope?.eventId ?? deltaEnvelope?.eventId;
}
