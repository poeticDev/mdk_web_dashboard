/// ROLE
/// - RoomState SSE 메시지를 정의한다
///
/// RESPONSIBILITY
/// - 스냅샷/델타 이벤트를 구분한다
///
/// DEPENDS ON
/// - sse_envelope_dto
/// - room_state_sse_dto
library;

import 'package:web_dashboard/domains/realtime/data/dtos/room_state_sse_dto.dart';
import 'package:web_dashboard/domains/realtime/data/dtos/sse_envelope_dto.dart';

enum RoomStateSseEventType { snapshot, delta }

class RoomStateSseEvent {
  const RoomStateSseEvent.snapshot(this.envelope)
      : type = RoomStateSseEventType.snapshot,
        deltaEnvelope = null;

  const RoomStateSseEvent.delta(this.deltaEnvelope)
      : type = RoomStateSseEventType.delta,
        envelope = null;

  final RoomStateSseEventType type;
  final SseEnvelopeDto<RoomStateSnapshotPayloadDto>? envelope;
  final SseEnvelopeDto<RoomStateDeltaPayloadDto>? deltaEnvelope;

  RoomStateSnapshotPayloadDto? get snapshotPayload => envelope?.payload;
  RoomStateDeltaPayloadDto? get deltaPayload => deltaEnvelope?.payload;
  String? get eventId => envelope?.eventId ?? deltaEnvelope?.eventId;
}
