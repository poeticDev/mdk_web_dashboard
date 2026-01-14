/// ROLE
/// - 대시보드 상태 컨트롤러를 제공한다
///
/// RESPONSIBILITY
/// - SSE 이벤트를 상태로 반영한다
/// - 로딩/에러/필터 상태를 관리한다
///
/// DEPENDS ON
/// - riverpod_annotation
/// - auth_controller
/// - dashboard_state
/// - dashboard_sse_mapper
/// - foundation_classrooms_repository
/// - room_state_sse_remote_data_source
/// - occurrence_now_sse_remote_data_source
/// - room_state_sse_dto
/// - occurrence_now_sse_dto
library;

import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_dashboard/domains/auth/application/auth_controller.dart';
import 'package:web_dashboard/domains/auth/domain/entities/auth_user.dart';
import 'package:web_dashboard/domains/realtime/data/datasources/occurrence_now_sse_remote_data_source.dart';
import 'package:web_dashboard/domains/realtime/data/datasources/room_state_sse_remote_data_source.dart';
import 'package:web_dashboard/domains/realtime/data/dtos/occurrence_now_sse_dto.dart';
import 'package:web_dashboard/domains/realtime/data/dtos/occurrence_now_sse_event.dart';
import 'package:web_dashboard/domains/realtime/data/dtos/room_state_sse_dto.dart';
import 'package:web_dashboard/domains/realtime/data/dtos/room_state_sse_event.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/foundation_classrooms_entity.dart';
import 'package:web_dashboard/domains/foundation/domain/repositories/foundation_classrooms_repository.dart';
import 'package:web_dashboard/features/dashboard/application/dashboard_providers.dart';
import 'package:web_dashboard/features/dashboard/application/mappers/dashboard_sse_mapper.dart';
import 'package:web_dashboard/features/dashboard/application/state/dashboard_state.dart';
import 'package:web_dashboard/features/dashboard/viewmodels/dashboard_classroom_card_view_model.dart';
import 'package:web_dashboard/features/dashboard/viewmodels/dashboard_metrics_view_model.dart';
import 'package:web_dashboard/features/dashboard/viewmodels/dashboard_usage_status.dart';

part 'dashboard_controller.g.dart';

@riverpod
class DashboardController extends _$DashboardController {
  static const List<String> _roomStateSensors = <String>['presence'];
  static const List<String> _roomStateEquipment = <String>['power'];
  static const List<String> _occurrenceInclude = <String>['scheduleSummary'];

  final Map<String, DashboardClassroomCardViewModel> _cardsById =
      <String, DashboardClassroomCardViewModel>{};
  final Set<String> _roomStateSnapshotIds = <String>{};
  final List<String> _cardOrder = <String>[];
  StreamSubscription<RoomStateSseEvent>? _roomStateSubscription;
  StreamSubscription<OccurrenceNowSseEvent>? _occurrenceSubscription;
  bool _hasInitialized = false;
  bool _roomStateStreaming = false;
  bool _occurrenceStreaming = false;
  String? _lastRoomStateEventId;
  String? _lastOccurrenceEventId;

  DashboardSseMapper get _mapper => ref.read(dashboardSseMapperProvider);
  FoundationClassroomsRepository get _foundationRepository =>
      ref.read(foundationClassroomsRepositoryProvider);
  RoomStateSseRemoteDataSource get _roomStateDataSource =>
      ref.read(roomStateSseRemoteDataSourceProvider);
  OccurrenceNowSseRemoteDataSource get _occurrenceDataSource =>
      ref.read(occurrenceNowSseRemoteDataSourceProvider);

  @override
  DashboardState build() {
    ref.onDispose(() => _disposeStreams(notify: false));
    return DashboardState.initial();
  }

  Future<void> initialize() async {
    if (!_markInitialized()) {
      return;
    }
    startLoading();
    final FoundationSelection? selection = _resolveFoundationSelection(
      ref.read(authControllerProvider).currentUser,
    );
    if (selection == null) {
      _finishWithError('기본 foundation 정보를 찾을 수 없습니다.');
      return;
    }
    try {
      final FoundationClassroomsEntity response =
          await _foundationRepository.fetchClassrooms(
        FoundationClassroomsQuery(
          type: selection.type,
          foundationId: selection.foundationId,
        ),
      );
      _applyFoundationCards(response.classrooms, selection);
      await _connectRoomState(response.classrooms);
      await _connectOccurrences(response.classrooms);
    } catch (_) {
      _disposeStreams();
      _finishWithError('대시보드 데이터를 불러오지 못했습니다.');
    }
  }

  void setBaseCards(List<DashboardClassroomCardViewModel> cards) {
    _cardsById
      ..clear()
      ..addEntries(
        cards.map(
          (DashboardClassroomCardViewModel card) => MapEntry(
            card.id,
            _normalizeInitialCard(card),
          ),
        ),
      );
    _cardOrder
      ..clear()
      ..addAll(cards.map((DashboardClassroomCardViewModel card) => card.id));
    _emitFilteredState(state.filters);
  }

  void startLoading() => _updateLoadingState(isLoading: true);

  void finishLoading() => _updateLoadingState(isLoading: false);

  void setStreaming(bool isStreaming) {
    state = state.copyWith(isStreaming: isStreaming);
  }

  void setErrorMessage(String? message) {
    state = state.copyWith(errorMessage: message);
  }

  void updateQuery(String query) {
    _updateFilters(state.filters.copyWith(query: query));
  }

  void clearUsageFilters() {
    _updateFilters(
      state.filters.copyWith(usageStatuses: <DashboardUsageStatus>{}),
    );
  }

  void toggleUsageStatus(DashboardUsageStatus status) {
    final Set<DashboardUsageStatus> next = Set<DashboardUsageStatus>.from(
      state.filters.usageStatuses,
    );
    if (next.contains(status)) {
      next.remove(status);
    } else {
      next.add(status);
    }
    _updateFilters(state.filters.copyWith(usageStatuses: next));
  }

  void updateBuildingFilters(Set<String> buildingIds) {
    _updateFilters(state.filters.copyWith(buildingIds: buildingIds));
  }

  void updateDepartmentFilters(Set<String> departmentIds) {
    _updateFilters(state.filters.copyWith(departmentIds: departmentIds));
  }

  void applyRoomStateSnapshot(RoomStateSnapshotPayloadDto payload) {
    for (final RoomStateClassroomSnapshotDto snapshot in payload.classrooms) {
      _roomStateSnapshotIds.add(snapshot.classroomId);
      final DashboardRoomStateViewModel roomState =
          _mapper.mapRoomStateSnapshot(snapshot);
      _cardsById.update(
        snapshot.classroomId,
        (DashboardClassroomCardViewModel current) => _withRoomState(
          current,
          roomState,
        ),
        ifAbsent: () => _createEmptyCard(snapshot.classroomId, roomState),
      );
    }
    _updateMetricsFromRoomState(payload.occupancySummary);
    _refreshUsageStatuses();
    _emitFilteredState(state.filters);
  }

  void applyRoomStateDelta(RoomStateDeltaPayloadDto payload) {
    for (final RoomStateUpdateDto update in payload.updates) {
      final DashboardClassroomCardViewModel? current =
          _cardsById[update.classroomId];
      if (current == null) {
        continue;
      }
      final DashboardRoomStateViewModel merged =
          _mapper.mergeRoomStateUpdate(current.roomState, update);
      _cardsById[update.classroomId] = _withRoomState(current, merged);
    }
    _updateMetricsFromRoomState(payload.occupancySummary);
    _refreshUsageStatuses();
    _emitFilteredState(state.filters);
  }

  void applyOccurrenceSnapshot(OccurrenceNowSnapshotPayloadDto payload) {
    final Set<String> currentIds = _collectCurrentIds(payload.currents);
    _clearMissingCurrents(currentIds);
    _applyCurrentLectures(payload.currents);
    _updateMetricsFromSchedule(payload.scheduleSummary);
    _refreshUsageStatuses();
    _emitFilteredState(state.filters);
  }

  void applyOccurrenceDelta(OccurrenceNowDeltaPayloadDto payload) {
    for (final OccurrenceNowCurrentDto current in payload.currents) {
      final DashboardClassroomCardViewModel? existing =
          _cardsById[current.classroomId];
      if (existing == null) {
        continue;
      }
      final DashboardCurrentLectureViewModel currentLecture =
          _mapper.mapCurrentLecture(current);
      _cardsById[current.classroomId] = _withCurrentLecture(
        existing,
        currentLecture,
      );
    }
    _updateMetricsFromSchedule(payload.scheduleSummary);
    _refreshUsageStatuses();
    _emitFilteredState(state.filters);
  }

  Future<void> _connectRoomState(
    List<FoundationClassroomSummaryEntity> classrooms,
  ) async {
    final List<String> ids = _extractClassroomIds(classrooms);
    if (ids.isEmpty) {
      return;
    }
    final RoomStateSubscriptionResponseDto subscription =
        await _createRoomStateSubscription(ids);
    _roomStateSubscription?.cancel();
    _roomStateSubscription = _roomStateDataSource
        .connect(
          subscriptionId: subscription.subscriptionId,
          lastEventId: _lastRoomStateEventId,
        )
        .listen(
          _handleRoomStateEvent,
          onError: (_) => _handleRoomStateError(),
        );
    _roomStateStreaming = true;
    _updateStreamingState();
  }

  Future<void> _connectOccurrences(
    List<FoundationClassroomSummaryEntity> classrooms,
  ) async {
    final List<String> ids = _extractClassroomIds(classrooms);
    if (ids.isEmpty) {
      return;
    }
    final OccurrenceNowSubscriptionResponseDto subscription =
        await _createOccurrenceSubscription(ids);
    _occurrenceSubscription?.cancel();
    _occurrenceSubscription = _occurrenceDataSource
        .connect(
          subscriptionId: subscription.subscriptionId,
          lastEventId: _lastOccurrenceEventId,
        )
        .listen(
          _handleOccurrenceEvent,
          onError: (_) => _handleOccurrenceError(),
        );
    _occurrenceStreaming = true;
    _updateStreamingState();
  }

  void _handleRoomStateEvent(RoomStateSseEvent event) {
    _lastRoomStateEventId = event.eventId ?? _lastRoomStateEventId;
    if (event.type == RoomStateSseEventType.snapshot &&
        event.snapshotPayload != null) {
      applyRoomStateSnapshot(event.snapshotPayload!);
      return;
    }
    if (event.type == RoomStateSseEventType.delta &&
        event.deltaPayload != null) {
      applyRoomStateDelta(event.deltaPayload!);
    }
  }

  void _handleOccurrenceEvent(OccurrenceNowSseEvent event) {
    _lastOccurrenceEventId = event.eventId ?? _lastOccurrenceEventId;
    if (event.type == OccurrenceNowSseEventType.snapshot &&
        event.snapshotPayload != null) {
      applyOccurrenceSnapshot(event.snapshotPayload!);
      return;
    }
    if (event.type == OccurrenceNowSseEventType.delta &&
        event.deltaPayload != null) {
      applyOccurrenceDelta(event.deltaPayload!);
    }
  }

  void _handleRoomStateError() {
    _roomStateStreaming = false;
    _updateStreamingState();
  }

  void _handleOccurrenceError() {
    _occurrenceStreaming = false;
    _updateStreamingState();
  }

  void _updateStreamingState() {
    setStreaming(_roomStateStreaming && _occurrenceStreaming);
  }

  bool _markInitialized() {
    if (_hasInitialized) {
      return false;
    }
    _hasInitialized = true;
    return true;
  }

  void _finishWithError(String message) {
    setErrorMessage(message);
    finishLoading();
  }

  void _applyFoundationCards(
    List<FoundationClassroomSummaryEntity> classrooms,
    FoundationSelection selection,
  ) {
    final List<DashboardClassroomCardViewModel> cards = classrooms
        .map(
          (FoundationClassroomSummaryEntity classroom) => _mapToCard(
            classroom,
            selection,
          ),
        )
        .toList();
    setBaseCards(cards);
    finishLoading();
  }

  List<String> _extractClassroomIds(
    List<FoundationClassroomSummaryEntity> classrooms,
  ) {
    return classrooms
        .map((FoundationClassroomSummaryEntity entity) => entity.id)
        .toList();
  }

  Future<RoomStateSubscriptionResponseDto> _createRoomStateSubscription(
    List<String> classroomIds,
  ) {
    return _roomStateDataSource.createSubscription(
      RoomStateSubscriptionRequestDto(
        classroomIds: classroomIds,
        sensors: _roomStateSensors,
        equipment: _roomStateEquipment,
      ),
    );
  }

  Future<OccurrenceNowSubscriptionResponseDto> _createOccurrenceSubscription(
    List<String> classroomIds,
  ) {
    return _occurrenceDataSource.createSubscription(
      OccurrenceNowSubscriptionRequestDto(
        classroomIds: classroomIds,
        include: _occurrenceInclude,
      ),
    );
  }

  FoundationSelection? _resolveFoundationSelection(AuthUser? user) {
    if (user == null) {
      return null;
    }
    if (user.buildingId != null && user.buildingId!.isNotEmpty) {
      return FoundationSelection(
        type: FoundationType.building,
        foundationId: user.buildingId!,
      );
    }
    if (user.departmentId != null && user.departmentId!.isNotEmpty) {
      return FoundationSelection(
        type: FoundationType.department,
        foundationId: user.departmentId!,
      );
    }
    if (user.siteId != null && user.siteId!.isNotEmpty) {
      return FoundationSelection(
        type: FoundationType.site,
        foundationId: user.siteId!,
      );
    }
    return null;
  }

  DashboardClassroomCardViewModel _mapToCard(
    FoundationClassroomSummaryEntity classroom,
    FoundationSelection selection,
  ) {
    return DashboardClassroomCardViewModel(
      id: classroom.id,
      name: classroom.name,
      code: classroom.code,
      siteId: selection.type == FoundationType.site
          ? selection.foundationId
          : null,
      buildingId: classroom.building?.id,
      buildingName: classroom.building?.name,
      buildingCode: classroom.building?.code,
      departmentId: classroom.department?.id,
      departmentName: classroom.department?.name,
      departmentCode: classroom.department?.code,
      usageStatus: DashboardUsageStatus.unlinked,
    );
  }

  void _disposeStreams({bool notify = true}) {
    _roomStateSubscription?.cancel();
    _occurrenceSubscription?.cancel();
    _roomStateDataSource.disconnect();
    _occurrenceDataSource.disconnect();
    _roomStateStreaming = false;
    _occurrenceStreaming = false;
    if (notify) {
      _updateStreamingState();
    }
  }

  void _updateLoadingState({required bool isLoading}) {
    state = state.copyWith(isLoading: isLoading);
  }

  void _updateFilters(DashboardFilterState filters) {
    _emitFilteredState(filters);
  }

  void _emitFilteredState(DashboardFilterState filters) {
    final List<DashboardClassroomCardViewModel> ordered = _orderedCards();
    final List<DashboardClassroomCardViewModel> filtered = _applyFilters(
      ordered,
      filters,
    );
    state = state.copyWith(filters: filters, cards: filtered);
  }

  void _updateMetricsFromSchedule(ScheduleSummaryDto? summary) {
    if (summary == null) {
      return;
    }
    final DashboardScheduleSummaryViewModel scheduleSummary =
        _mapper.mapScheduleSummary(summary);
    final DashboardMetricsViewModel merged = _mergeMetrics(
      scheduleSummary: scheduleSummary,
    );
    state = state.copyWith(metrics: merged);
  }

  void _updateMetricsFromRoomState(RoomStateOccupancySummaryDto? summary) {
    if (summary == null) {
      return;
    }
    final DashboardOccupancySummaryViewModel occupancySummary =
        _mapper.mapOccupancySummary(summary);
    final DashboardMetricsViewModel merged = _mergeMetrics(
      occupancySummary: occupancySummary,
    );
    state = state.copyWith(metrics: merged);
  }

  DashboardMetricsViewModel _mergeMetrics({
    DashboardScheduleSummaryViewModel? scheduleSummary,
    DashboardOccupancySummaryViewModel? occupancySummary,
  }) {
    final DashboardMetricsViewModel? current = state.metrics;
    final DashboardScheduleSummaryViewModel? nextSchedule =
        scheduleSummary ?? current?.scheduleSummary;
    final DashboardOccupancySummaryViewModel? nextOccupancy =
        occupancySummary ?? current?.occupancySummary;
    return DashboardMetricsViewModel(
      totalCount: _resolveTotalCount(nextSchedule, current),
      inUseCount: _resolveInUseCount(nextSchedule, current),
      idleCount: _resolveIdleCount(nextSchedule, current),
      unlinkedCount: _resolveUnlinkedCount(nextOccupancy, current),
      timestamp: _resolveMetricsTimestamp(nextSchedule, nextOccupancy, current),
      scheduleSummary: nextSchedule,
      occupancySummary: nextOccupancy,
    );
  }

  DateTime _resolveMetricsTimestamp(
    DashboardScheduleSummaryViewModel? scheduleSummary,
    DashboardOccupancySummaryViewModel? occupancySummary,
    DashboardMetricsViewModel? current,
  ) {
    if (scheduleSummary != null) {
      return scheduleSummary.updatedAt;
    }
    if (occupancySummary != null) {
      return occupancySummary.updatedAt;
    }
    return current?.timestamp ?? DateTime.now();
  }

  void _refreshUsageStatuses() {
    for (final String id in _cardOrder) {
      final DashboardClassroomCardViewModel? card = _cardsById[id];
      if (card == null) {
        continue;
      }
      final DashboardUsageStatus status = _mapper.resolveUsageStatus(
        hasRoomStateSnapshot: _roomStateSnapshotIds.contains(id),
        roomState: card.roomState,
        currentLecture: card.currentLecture,
      );
      _cardsById[id] = _withUsageStatus(card, status);
    }
  }
  List<DashboardClassroomCardViewModel> _orderedCards() {
    return _cardOrder
        .map((String id) => _cardsById[id])
        .whereType<DashboardClassroomCardViewModel>()
        .toList();
  }

  List<DashboardClassroomCardViewModel> _applyFilters(
    List<DashboardClassroomCardViewModel> cards,
    DashboardFilterState filters,
  ) {
    return cards.where((DashboardClassroomCardViewModel card) {
      if (!_matchesQuery(card, filters.query)) {
        return false;
      }
      if (!_matchesUsageStatus(card, filters.usageStatuses)) {
        return false;
      }
      if (!_matchesIdFilter(card.buildingId, filters.buildingIds)) {
        return false;
      }
      if (!_matchesIdFilter(card.departmentId, filters.departmentIds)) {
        return false;
      }
      return true;
    }).toList();
  }

  bool _matchesQuery(DashboardClassroomCardViewModel card, String query) {
    if (query.trim().isEmpty) {
      return true;
    }
    final String keyword = query.toLowerCase().trim();
    return _containsText(card.name, keyword) ||
        _containsText(card.code, keyword) ||
        _containsText(card.buildingName, keyword) ||
        _containsText(card.buildingCode, keyword) ||
        _containsText(card.departmentName, keyword) ||
        _containsText(card.departmentCode, keyword);
  }

  bool _containsText(String? value, String keyword) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return value.toLowerCase().contains(keyword);
  }

  bool _matchesUsageStatus(
    DashboardClassroomCardViewModel card,
    Set<DashboardUsageStatus> statuses,
  ) {
    if (statuses.isEmpty) {
      return true;
    }
    return statuses.contains(card.usageStatus);
  }

  bool _matchesIdFilter(String? id, Set<String> filters) {
    if (filters.isEmpty) {
      return true;
    }
    if (id == null || id.isEmpty) {
      return false;
    }
    return filters.contains(id);
  }

  DashboardClassroomCardViewModel _normalizeInitialCard(
    DashboardClassroomCardViewModel card,
  ) {
    return _cloneCard(card, usageStatus: DashboardUsageStatus.unlinked);
  }

  DashboardClassroomCardViewModel _withRoomState(
    DashboardClassroomCardViewModel card,
    DashboardRoomStateViewModel? roomState,
  ) => _cloneCard(card, roomState: roomState);

  DashboardClassroomCardViewModel _withCurrentLecture(
    DashboardClassroomCardViewModel card,
    DashboardCurrentLectureViewModel? currentLecture,
  ) => _cloneCard(card, currentLecture: currentLecture);

  DashboardClassroomCardViewModel _withUsageStatus(
    DashboardClassroomCardViewModel card,
    DashboardUsageStatus usageStatus,
  ) => _cloneCard(card, usageStatus: usageStatus);

  DashboardClassroomCardViewModel _cloneCard(
    DashboardClassroomCardViewModel card, {
    DashboardUsageStatus? usageStatus,
    DashboardCurrentLectureViewModel? currentLecture,
    DashboardRoomStateViewModel? roomState,
  }) =>
      DashboardClassroomCardViewModel(
        id: card.id,
        name: card.name,
        code: card.code,
        siteId: card.siteId,
        buildingId: card.buildingId,
        buildingName: card.buildingName,
        buildingCode: card.buildingCode,
        departmentId: card.departmentId,
        departmentName: card.departmentName,
        departmentCode: card.departmentCode,
        usageStatus: usageStatus ?? card.usageStatus,
        currentLecture: currentLecture ?? card.currentLecture,
        roomState: roomState ?? card.roomState,
      );

  Set<String> _collectCurrentIds(List<OccurrenceNowCurrentDto> currents) {
    return currents
        .map((OccurrenceNowCurrentDto current) => current.classroomId)
        .toSet();
  }

  void _clearMissingCurrents(Set<String> currentIds) {
    for (final DashboardClassroomCardViewModel card in _orderedCards()) {
      if (!currentIds.contains(card.id)) {
        _cardsById[card.id] = _withCurrentLecture(card, null);
      }
    }
  }

  void _applyCurrentLectures(List<OccurrenceNowCurrentDto> currents) {
    for (final OccurrenceNowCurrentDto current in currents) {
      final DashboardCurrentLectureViewModel currentLecture =
          _mapper.mapCurrentLecture(current);
      _cardsById.update(
        current.classroomId,
        (DashboardClassroomCardViewModel card) => _withCurrentLecture(
          card,
          currentLecture,
        ),
        ifAbsent: () => _createEmptyCard(current.classroomId, null),
      );
    }
  }

  int _resolveTotalCount(
    DashboardScheduleSummaryViewModel? summary,
    DashboardMetricsViewModel? current,
  ) {
    return summary?.total ?? current?.totalCount ?? 0;
  }

  int _resolveInUseCount(
    DashboardScheduleSummaryViewModel? summary,
    DashboardMetricsViewModel? current,
  ) {
    return summary?.inLecture ?? current?.inUseCount ?? 0;
  }

  int _resolveIdleCount(
    DashboardScheduleSummaryViewModel? summary,
    DashboardMetricsViewModel? current,
  ) {
    return summary?.noSchedule ?? current?.idleCount ?? 0;
  }

  int _resolveUnlinkedCount(
    DashboardOccupancySummaryViewModel? summary,
    DashboardMetricsViewModel? current,
  ) {
    return summary?.notLinked ?? current?.unlinkedCount ?? 0;
  }

  DashboardClassroomCardViewModel _createEmptyCard(
    String id,
    DashboardRoomStateViewModel? roomState,
  ) {
    return DashboardClassroomCardViewModel(
      id: id,
      name: id,
      usageStatus: DashboardUsageStatus.unlinked,
      roomState: roomState,
    );
  }
}

class FoundationSelection {
  const FoundationSelection({
    required this.type,
    required this.foundationId,
  });

  final FoundationType type;
  final String foundationId;
}
