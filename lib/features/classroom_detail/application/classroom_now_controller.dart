/// ROLE
/// - 강의실 상세 실시간 강의 상태를 제어한다
///
/// RESPONSIBILITY
/// - SSE 구독 생성/연결을 수행한다
/// - 스냅샷/델타 이벤트를 상태로 반영한다
///
/// DEPENDS ON
/// - riverpod_annotation
/// - occurrence_now_sse_remote_data_source
/// - occurrence_now_sse_dto
/// - occurrence_now_sse_event
/// - classroom_now_state
library;

import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_dashboard/domains/realtime/data/datasources/occurrence_now_sse_remote_data_source.dart';
import 'package:web_dashboard/domains/realtime/data/dtos/occurrence_now_sse_dto.dart';
import 'package:web_dashboard/domains/realtime/data/dtos/occurrence_now_sse_event.dart';
import 'package:web_dashboard/features/classroom_detail/application/classroom_now_providers.dart';
import 'package:web_dashboard/features/classroom_detail/application/state/classroom_now_state.dart';

part 'classroom_now_controller.g.dart';

@riverpod
class ClassroomNowController extends _$ClassroomNowController {
  static const List<String> _include = <String>['scheduleSummary'];
  static const String _errorLoadFailed = '실시간 강의를 불러오지 못했습니다.';

  StreamSubscription<OccurrenceNowSseEvent>? _subscription;
  String? _lastEventId;
  bool _hasInitialized = false;
  late final String _classroomId;

  OccurrenceNowSseRemoteDataSource get _dataSource =>
      ref.read(classroomOccurrenceNowSseRemoteDataSourceProvider);

  @override
  ClassroomNowState build(String classroomId) {
    _classroomId = classroomId;
    ref.onDispose(_dispose);
    return ClassroomNowState.initial();
  }

  Future<void> initialize() async {
    if (!_markInitialized()) {
      return;
    }
    state = state.copyWith(
      isLoading: true,
      isStreaming: false,
      errorMessage: null,
    );
    try {
      final OccurrenceNowSubscriptionResponseDto subscription =
          await _dataSource.createSubscription(
        OccurrenceNowSubscriptionRequestDto(
          classroomIds: <String>[_classroomId],
          include: _include,
        ),
      );
      await _subscription?.cancel();
      _subscription = _dataSource
          .connect(
            subscriptionId: subscription.subscriptionId,
            lastEventId: _lastEventId,
          )
          .listen(
            _handleEvent,
            onError: (_) => _handleError(),
          );
      state = state.copyWith(isLoading: false, isStreaming: true);
    } catch (_) {
      _handleError();
    }
  }

  void executeRetry() {
    _hasInitialized = false;
    _lastEventId = null;
    _dispose();
    state = ClassroomNowState.initial();
    initialize();
  }

  bool _markInitialized() {
    if (_hasInitialized) {
      return false;
    }
    _hasInitialized = true;
    return true;
  }

  void _handleEvent(OccurrenceNowSseEvent event) {
    _lastEventId = event.eventId;
    final OccurrenceNowCurrentDto? current = _extractCurrent(event);
    if (current == null || _isCancelled(current)) {
      _setIdle();
      return;
    }
    state = state.copyWith(
      isLoading: false,
      isStreaming: true,
      isInSession: true,
      currentCourseName: current.title,
      instructorName: current.instructorName,
      startTime: current.startAt,
      endTime: current.endAt,
      errorMessage: null,
    );
  }

  OccurrenceNowCurrentDto? _extractCurrent(OccurrenceNowSseEvent event) {
    if (event.type == OccurrenceNowSseEventType.snapshot) {
      return _findCurrent(event.snapshotPayload?.currents);
    }
    if (event.type == OccurrenceNowSseEventType.delta) {
      return _findCurrent(event.deltaPayload?.currents);
    }
    return null;
  }

  OccurrenceNowCurrentDto? _findCurrent(
    List<OccurrenceNowCurrentDto>? currents,
  ) {
    if (currents == null) {
      return null;
    }
    for (final OccurrenceNowCurrentDto current in currents) {
      if (current.classroomId == _classroomId) {
        return current;
      }
    }
    return null;
  }

  bool _isCancelled(OccurrenceNowCurrentDto current) {
    return current.status.toLowerCase() == 'cancelled';
  }

  void _setIdle() {
    state = state.copyWith(
      isLoading: false,
      isStreaming: true,
      isInSession: false,
      currentCourseName: null,
      instructorName: null,
      startTime: null,
      endTime: null,
      errorMessage: null,
    );
  }

  void _handleError() {
    state = state.copyWith(
      isLoading: false,
      isStreaming: false,
      errorMessage: _errorLoadFailed,
    );
  }

  void _dispose() {
    _subscription?.cancel();
    _subscription = null;
    _dataSource.disconnect();
  }
}
