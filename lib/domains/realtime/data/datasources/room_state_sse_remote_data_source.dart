/// ROLE
/// - RoomState SSE 원격 데이터 소스를 제공한다
///
/// RESPONSIBILITY
/// - 구독 생성 및 SSE 스트림 연결을 수행한다
/// - 이벤트를 DTO로 변환한다
///
/// DEPENDS ON
/// - dio
/// - sse_client
/// - api_constants
/// - room_state_sse_dto
/// - room_state_sse_event
/// - sse_envelope_dto
library;

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:web_dashboard/common/constants/api_constants.dart';
import 'package:web_dashboard/common/network/sse_client.dart';
import 'package:web_dashboard/domains/realtime/data/dtos/room_state_sse_dto.dart';
import 'package:web_dashboard/domains/realtime/data/dtos/room_state_sse_event.dart';
import 'package:web_dashboard/domains/realtime/data/dtos/sse_envelope_dto.dart';

const String _roomStateSnapshotEvent = 'roomState.snapshot';
const String _roomStateDeltaEvent = 'roomState.delta';

abstract class RoomStateSseRemoteDataSource {
  Future<RoomStateSubscriptionResponseDto> createSubscription(
    RoomStateSubscriptionRequestDto request,
  );

  Stream<RoomStateSseEvent> connect({
    required String subscriptionId,
    String? lastEventId,
  });

  void disconnect();
}

class RoomStateSseRemoteDataSourceImpl implements RoomStateSseRemoteDataSource {
  RoomStateSseRemoteDataSourceImpl({
    required Dio dio,
    required SseClient sseClient,
  })  : _dio = dio,
        _sseClient = sseClient;

  final Dio _dio;
  final SseClient _sseClient;

  @override
  Future<RoomStateSubscriptionResponseDto> createSubscription(
    RoomStateSubscriptionRequestDto request,
  ) async {
    final Response<dynamic> response = await _dio.post<dynamic>(
      ApiConstants.roomStateSubscriptions,
      data: request.toJson(),
    );
    final Map<String, Object?> payload =
        response.data as Map<String, Object?>? ?? <String, Object?>{};
    return RoomStateSubscriptionResponseDto.fromJson(payload);
  }

  @override
  Stream<RoomStateSseEvent> connect({
    required String subscriptionId,
    String? lastEventId,
  }) {
    final Uri url = _buildStreamUri(subscriptionId, lastEventId);
    return _sseClient
        .connect(
          url: url,
          eventTypes: const <String>[
            _roomStateSnapshotEvent,
            _roomStateDeltaEvent,
          ],
          lastEventId: lastEventId,
        )
        .map(_mapEvent)
        .whereType<RoomStateSseEvent>();
  }

  @override
  void disconnect() {
    _sseClient.close();
  }

  RoomStateSseEvent? _mapEvent(SseClientEvent event) {
    final Map<String, Object?> data = _decodeJson(event.data);
    if (event.type == _roomStateSnapshotEvent) {
      final SseEnvelopeDto<RoomStateSnapshotPayloadDto> envelope =
          SseEnvelopeDto<RoomStateSnapshotPayloadDto>.fromJson(
        data,
        RoomStateSnapshotPayloadDto.fromJson,
      );
      return RoomStateSseEvent.snapshot(envelope);
    }
    if (event.type == _roomStateDeltaEvent) {
      final SseEnvelopeDto<RoomStateDeltaPayloadDto> envelope =
          SseEnvelopeDto<RoomStateDeltaPayloadDto>.fromJson(
        data,
        RoomStateDeltaPayloadDto.fromJson,
      );
      return RoomStateSseEvent.delta(envelope);
    }
    return null;
  }

  Map<String, Object?> _decodeJson(String raw) {
    final Object? decoded = jsonDecode(raw);
    if (decoded is Map<String, Object?>) {
      return decoded;
    }
    return <String, Object?>{};
  }

  Uri _buildStreamUri(String subscriptionId, String? lastEventId) {
    final Uri base = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.roomStateStream}',
    );
    final Map<String, String> query = <String, String>{
      'subscriptionId': subscriptionId,
      if (lastEventId != null && lastEventId.isNotEmpty)
        'lastEventId': lastEventId,
    };
    return base.replace(queryParameters: query);
  }
}
