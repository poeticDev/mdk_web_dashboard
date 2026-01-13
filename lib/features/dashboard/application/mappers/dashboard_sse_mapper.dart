/// ROLE
/// - 대시보드 SSE 데이터를 뷰모델로 매핑한다
///
/// RESPONSIBILITY
/// - RoomState/Occurrence payload 매핑
/// - 사용 상태 판단
///
/// DEPENDS ON
/// - lecture_status
/// - dashboard_viewmodels
/// - room_state_sse_dto
/// - occurrence_now_sse_dto
library;

import 'package:web_dashboard/domains/realtime/data/dtos/occurrence_now_sse_dto.dart';
import 'package:web_dashboard/domains/realtime/data/dtos/room_state_sse_dto.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_status.dart';
import 'package:web_dashboard/features/dashboard/viewmodels/dashboard_classroom_card_view_model.dart';
import 'package:web_dashboard/features/dashboard/viewmodels/dashboard_metrics_view_model.dart';
import 'package:web_dashboard/features/dashboard/viewmodels/dashboard_usage_status.dart';

const String _presenceSensorKey = 'presence';
const String _powerEquipmentKey = 'power';
const String _updateTypeSensor = 'sensor';
const String _updateTypeEquipment = 'equipment';

class DashboardSseMapper {
  const DashboardSseMapper();

  DashboardRoomStateViewModel mapRoomStateSnapshot(
    RoomStateClassroomSnapshotDto snapshot,
  ) {
    return DashboardRoomStateViewModel(
      status: _mapRoomStateStatus(snapshot.status),
      isOccupied: snapshot.sensors[_presenceSensorKey]?.boolValue,
      isEquipmentOn: snapshot.equipment[_powerEquipmentKey]?.isOn,
      updatedAt: snapshot.lastUpdatedAt,
    );
  }

  DashboardRoomStateViewModel mergeRoomStateUpdate(
    DashboardRoomStateViewModel? current,
    RoomStateUpdateDto update,
  ) {
    final DashboardRoomStateViewModel base = current ?? _emptyRoomState();
    if (update.type == _updateTypeSensor) {
      return _applySensorUpdate(base, update);
    }
    if (update.type == _updateTypeEquipment) {
      return _applyEquipmentUpdate(base, update);
    }
    return base;
  }

  DashboardCurrentLectureViewModel mapCurrentLecture(
    OccurrenceNowCurrentDto current,
  ) {
    return DashboardCurrentLectureViewModel(
      title: current.title,
      instructorName: current.instructorName,
      startAt: current.startAt,
      endAt: current.endAt,
      status: LectureStatus.fromApi(current.status),
    );
  }

  DashboardScheduleSummaryViewModel mapScheduleSummary(
    ScheduleSummaryDto summary,
  ) {
    return DashboardScheduleSummaryViewModel(
      total: summary.total,
      inLecture: summary.inLecture,
      noSchedule: summary.noSchedule,
      updatedAt: summary.updatedAt,
    );
  }

  DashboardOccupancySummaryViewModel mapOccupancySummary(
    RoomStateOccupancySummaryDto summary,
  ) {
    return DashboardOccupancySummaryViewModel(
      occupied: summary.occupied,
      vacant: summary.vacant,
      notLinked: summary.notLinked,
      updatedAt: summary.updatedAt,
    );
  }

  DashboardUsageStatus resolveUsageStatus({
    required bool hasRoomStateSnapshot,
    required DashboardRoomStateViewModel? roomState,
    required DashboardCurrentLectureViewModel? currentLecture,
  }) {
    if (!hasRoomStateSnapshot || roomState == null) {
      return DashboardUsageStatus.unlinked;
    }
    if (roomState.status.isStale) {
      return DashboardUsageStatus.unlinked;
    }
    if (currentLecture == null || currentLecture.isCanceled) {
      return DashboardUsageStatus.idle;
    }
    return DashboardUsageStatus.inUse;
  }

  DashboardRoomStateStatusViewModel _mapRoomStateStatus(
    RoomStateStatusDto status,
  ) {
    return DashboardRoomStateStatusViewModel(
      isStale: status.isStale,
      hasError: status.hasError,
      hasSensorError: status.hasSensorError,
      hasEquipmentError: status.hasEquipmentError,
    );
  }

  DashboardRoomStateViewModel _emptyRoomState() {
    return DashboardRoomStateViewModel(
      status: const DashboardRoomStateStatusViewModel(
        isStale: false,
        hasError: false,
        hasSensorError: false,
        hasEquipmentError: false,
      ),
    );
  }

  DashboardRoomStateViewModel _applySensorUpdate(
    DashboardRoomStateViewModel base,
    RoomStateUpdateDto update,
  ) {
    if (update.sensorType != _presenceSensorKey) {
      return base;
    }
    return DashboardRoomStateViewModel(
      status: base.status,
      isOccupied: update.boolValue ?? base.isOccupied,
      isEquipmentOn: base.isEquipmentOn,
      updatedAt: update.recordedAt ?? base.updatedAt,
    );
  }

  DashboardRoomStateViewModel _applyEquipmentUpdate(
    DashboardRoomStateViewModel base,
    RoomStateUpdateDto update,
  ) {
    if (update.equipmentType != _powerEquipmentKey) {
      return base;
    }
    return DashboardRoomStateViewModel(
      status: base.status,
      isOccupied: base.isOccupied,
      isEquipmentOn: update.isOn ?? base.isEquipmentOn,
      updatedAt: update.updatedAt ?? base.updatedAt,
    );
  }
}
