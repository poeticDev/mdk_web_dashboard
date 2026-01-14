/// ROLE
/// - 대시보드 강의실 카드 뷰모델을 정의한다
///
/// RESPONSIBILITY
/// - 카드 UI에 필요한 데이터를 구조화한다
///
/// DEPENDS ON
/// - lecture_status
/// - dashboard_status
library;

import 'package:flutter/foundation.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_status.dart';
import 'package:web_dashboard/features/dashboard/viewmodels/dashboard_status.dart';

@immutable
class DashboardClassroomCardViewModel {
  const DashboardClassroomCardViewModel({
    required this.id,
    required this.name,
    required this.linkStatus,
    this.code,
    this.siteId,
    this.buildingId,
    this.buildingName,
    this.buildingCode,
    this.departmentId,
    this.departmentName,
    this.departmentCode,
    this.activityStatus,
    this.currentLecture,
    this.roomState,
  });

  final String id;
  final String name;
  final String? code;
  final String? siteId;
  final String? buildingId;
  final String? buildingName;
  final String? buildingCode;
  final String? departmentId;
  final String? departmentName;
  final String? departmentCode;
  final DashboardLinkStatus linkStatus;
  final DashboardActivityStatus? activityStatus;
  final DashboardCurrentLectureViewModel? currentLecture;
  final DashboardRoomStateViewModel? roomState;
}

@immutable
class DashboardCurrentLectureViewModel {
  const DashboardCurrentLectureViewModel({
    required this.title,
    required this.instructorName,
    required this.startAt,
    required this.endAt,
    required this.status,
  });

  final String title;
  final String instructorName;
  final DateTime startAt;
  final DateTime endAt;
  final LectureStatus status;

  bool get isCanceled => status.isCanceled;
}

@immutable
class DashboardRoomStateViewModel {
  const DashboardRoomStateViewModel({
    required this.status,
    this.isOccupied,
    this.isEquipmentOn,
    this.updatedAt,
  });

  final bool? isOccupied;
  final bool? isEquipmentOn;
  final DateTime? updatedAt;
  final DashboardRoomStateStatusViewModel status;
}

@immutable
class DashboardRoomStateStatusViewModel {
  const DashboardRoomStateStatusViewModel({
    required this.isStale,
    required this.hasError,
    required this.hasSensorError,
    required this.hasEquipmentError,
  });

  final bool isStale;
  final bool hasError;
  final bool hasSensorError;
  final bool hasEquipmentError;

  bool get hasAnyError => hasError || hasSensorError || hasEquipmentError;
}
