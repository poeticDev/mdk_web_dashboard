/// ROLE
/// - Occurrence SSE 원격 데이터 소스를 제공한다
///
/// RESPONSIBILITY
/// - 구독 생성 및 SSE 스트림 연결을 수행한다
/// - 이벤트를 DTO로 변환한다
///
/// DEPENDS ON
/// - dio
/// - sse_client
/// - api_constants
/// - occurrence_now_sse_dto
/// - occurrence_now_sse_event
/// - sse_envelope_dto
library;

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:web_dashboard/common/constants/api_constants.dart';
import 'package:web_dashboard/common/network/sse_client.dart';
import 'package:web_dashboard/domains/realtime/data/dtos/occurrence_now_sse_dto.dart';
import 'package:web_dashboard/domains/realtime/data/dtos/occurrence_now_sse_event.dart';
import 'package:web_dashboard/domains/realtime/data/dtos/sse_envelope_dto.dart';

const String _occurrenceSnapshotEvent = 'occurrence.now.snapshot';
const String _occurrenceDeltaEvent = 'occurrence.now.delta';

abstract class OccurrenceNowSseRemoteDataSource {
  Future<OccurrenceNowSubscriptionResponseDto> createSubscription(
    OccurrenceNowSubscriptionRequestDto request,
  );

  Stream<OccurrenceNowSseEvent> connect({
    required String subscriptionId,
    String? lastEventId,
  });

  void disconnect();
}

class OccurrenceNowSseRemoteDataSourceImpl
    implements OccurrenceNowSseRemoteDataSource {
  OccurrenceNowSseRemoteDataSourceImpl({
    required Dio dio,
    required SseClient sseClient,
  })  : _dio = dio,
        _sseClient = sseClient;

  final Dio _dio;
  final SseClient _sseClient;

  @override
  Future<OccurrenceNowSubscriptionResponseDto> createSubscription(
    OccurrenceNowSubscriptionRequestDto request,
  ) async {
    final Response<dynamic> response = await _dio.post<dynamic>(
      ApiConstants.occurrenceNowSubscriptions,
      data: request.toJson(),
    );
    final Map<String, Object?> payload =
        response.data as Map<String, Object?>? ?? <String, Object?>{};
    return OccurrenceNowSubscriptionResponseDto.fromJson(payload);
  }

  @override
  Stream<OccurrenceNowSseEvent> connect({
    required String subscriptionId,
    String? lastEventId,
  }) {
    final Uri url = _buildStreamUri(subscriptionId, lastEventId);
    final Stream<OccurrenceNowSseEvent?> mapped = _sseClient
        .connect(
          url: url,
          eventTypes: const <String>[
            _occurrenceSnapshotEvent,
            _occurrenceDeltaEvent,
          ],
          lastEventId: lastEventId,
        )
        .map(_mapEvent);
    return mapped
        .where((OccurrenceNowSseEvent? event) => event != null)
        .cast<OccurrenceNowSseEvent>();
  }

  @override
  void disconnect() {
    _sseClient.close();
  }

  OccurrenceNowSseEvent? _mapEvent(SseClientEvent event) {
    final Map<String, Object?> data = _decodeJson(event.data);
    if (event.type == _occurrenceSnapshotEvent) {
      final SseEnvelopeDto<OccurrenceNowSnapshotPayloadDto> envelope =
          SseEnvelopeDto<OccurrenceNowSnapshotPayloadDto>.fromJson(
        data,
        OccurrenceNowSnapshotPayloadDto.fromJson,
      );
      return OccurrenceNowSseEvent.snapshot(envelope);
    }
    if (event.type == _occurrenceDeltaEvent) {
      final SseEnvelopeDto<OccurrenceNowDeltaPayloadDto> envelope =
          SseEnvelopeDto<OccurrenceNowDeltaPayloadDto>.fromJson(
        data,
        OccurrenceNowDeltaPayloadDto.fromJson,
      );
      return OccurrenceNowSseEvent.delta(envelope);
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
      '${ApiConstants.baseUrl}${ApiConstants.occurrenceNowStream}',
    );
    final Map<String, String> query = <String, String>{
      'subscriptionId': subscriptionId,
      if (lastEventId != null && lastEventId.isNotEmpty)
        'lastEventId': lastEventId,
    };
    return base.replace(queryParameters: query);
  }
}
