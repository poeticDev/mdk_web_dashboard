import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_dashboard/domains/realtime/data/datasources/occurrence_now_sse_remote_data_source.dart';
import 'package:web_dashboard/domains/realtime/data/dtos/occurrence_now_sse_dto.dart';
import 'package:web_dashboard/domains/realtime/data/dtos/occurrence_now_sse_event.dart';
import 'package:web_dashboard/domains/realtime/data/dtos/sse_envelope_dto.dart';
import 'package:web_dashboard/features/classroom_detail/application/classroom_now_controller.dart';
import 'package:web_dashboard/features/classroom_detail/application/classroom_now_providers.dart';
import 'package:web_dashboard/features/classroom_detail/application/state/classroom_now_state.dart';

void main() {
  group('classroomNowController', () {
    test('returns isInSession=false when no occurrence', () async {
      final StreamController<OccurrenceNowSseEvent> controller =
          StreamController<OccurrenceNowSseEvent>.broadcast();
      final ProviderContainer container = ProviderContainer(
        overrides: [
          classroomOccurrenceNowSseRemoteDataSourceProvider.overrideWithValue(
            _FakeOccurrenceNowSseRemoteDataSource(controller.stream),
          ),
        ],
      );
      addTearDown(() {
        controller.close();
        container.dispose();
      });

      final ClassroomNowController notifier = container.read(
        classroomNowControllerProvider('room-1').notifier,
      );
      await notifier.initialize();
      controller.add(
        _snapshotEvent(const <OccurrenceNowCurrentDto>[]),
      );
      await Future<void>.delayed(Duration.zero);

      final ClassroomNowState result = container.read(
        classroomNowControllerProvider('room-1'),
      );

      expect(result.isInSession, isFalse);
    });

    test('maps occurrence data to view model', () async {
      final StreamController<OccurrenceNowSseEvent> controller =
          StreamController<OccurrenceNowSseEvent>.broadcast();
      final ProviderContainer container = ProviderContainer(
        overrides: [
          classroomOccurrenceNowSseRemoteDataSourceProvider.overrideWithValue(
            _FakeOccurrenceNowSseRemoteDataSource(controller.stream),
          ),
        ],
      );
      addTearDown(() {
        controller.close();
        container.dispose();
      });

      final ClassroomNowController notifier = container.read(
        classroomNowControllerProvider('room-1').notifier,
      );
      await notifier.initialize();
      controller.add(
        _snapshotEvent(
          <OccurrenceNowCurrentDto>[
            OccurrenceNowCurrentDto(
              classroomId: 'room-1',
              occurrenceId: 'occ-1',
              lectureId: 'lec-1',
              title: 'AI 개론',
              instructorName: '홍길동',
              startAt: DateTime.utc(2025, 1, 1, 9),
              endAt: DateTime.utc(2025, 1, 1, 10),
              status: 'scheduled',
              departmentName: null,
              colorHex: null,
            ),
          ],
        ),
      );
      await Future<void>.delayed(Duration.zero);

      final ClassroomNowState result = container.read(
        classroomNowControllerProvider('room-1'),
      );

      expect(result.isInSession, isTrue);
      expect(result.currentCourseName, 'AI 개론');
    });
  });
}

class _FakeOccurrenceNowSseRemoteDataSource
    implements OccurrenceNowSseRemoteDataSource {
  _FakeOccurrenceNowSseRemoteDataSource(this.stream);

  final Stream<OccurrenceNowSseEvent> stream;

  @override
  Future<OccurrenceNowSubscriptionResponseDto> createSubscription(
    OccurrenceNowSubscriptionRequestDto request,
  ) async {
    return const OccurrenceNowSubscriptionResponseDto(
      subscriptionId: 'sub-1',
    );
  }

  @override
  Stream<OccurrenceNowSseEvent> connect({
    required String subscriptionId,
    String? lastEventId,
  }) {
    return stream;
  }

  @override
  void disconnect() {}
}

OccurrenceNowSseEvent _snapshotEvent(List<OccurrenceNowCurrentDto> currents) {
  final SseEnvelopeDto<OccurrenceNowSnapshotPayloadDto> envelope =
      SseEnvelopeDto<OccurrenceNowSnapshotPayloadDto>(
    eventId: 'event-1',
    subscriptionId: 'sub-1',
    timestamp: DateTime.now(),
    payload: OccurrenceNowSnapshotPayloadDto(currents: currents),
  );
  return OccurrenceNowSseEvent.snapshot(envelope);
}
