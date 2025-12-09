import 'dart:collection';

import 'package:flutter/material.dart';

/// 교실 상태 뱃지에서 사용할 세션 상태 구분값.
enum ClassroomSessionStatus { inUse, idle, disconnected }

/// UI에 표시할 시간 레이블 묶음.
class SessionTimeRange {
  const SessionTimeRange({required this.start, required this.end});

  final TimeOfDay start;
  final TimeOfDay end;

  String label(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );
    final String startLabel = localizations.formatTimeOfDay(start);
    final String endLabel = localizations.formatTimeOfDay(end);
    return '$startLabel ~ $endLabel';
  }
}

/// 개별 강의실 헤더에 노출되는 요약 정보.
class ClassroomSummaryInfo {
  const ClassroomSummaryInfo({
    required this.roomName,
    required this.department,
    required this.currentCourse,
    required this.professor,
    required this.sessionTime,
    required this.status,
    required this.capacity,
    required this.currentOccupancy,
  }) : assert(capacity > 0, 'capacity must be greater than zero');

  final String roomName;
  final String department;
  final String currentCourse;
  final String professor;
  final SessionTimeRange sessionTime;
  final ClassroomSessionStatus status;
  final int capacity;
  final int currentOccupancy;

  double get occupancyRate => currentOccupancy / capacity;

  String get occupancyLabel => '$currentOccupancy / $capacity명';
}

/// 제어 패널 토글 상태.
class DeviceToggleStatus {
  const DeviceToggleStatus({
    required this.id,
    required this.label,
    required this.icon,
    required this.isOn,
    this.description,
  });

  final String id;
  final String label;
  final IconData icon;
  final bool isOn;
  final String? description;

  DeviceToggleStatus copyWith({bool? isOn}) => DeviceToggleStatus(
    id: id,
    label: label,
    icon: icon,
    description: description,
    isOn: isOn ?? this.isOn,
  );
}

/// 환경 센서 지표 카드 데이터.
class EnvironmentMetric {
  const EnvironmentMetric({
    required this.id,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
  });

  final String id;
  final String label;
  final String value;
  final String unit;
  final IconData icon;
}

/// 헤더 섹션 전체 데이터를 묶는 불변 뷰 모델.
class ClassroomDetailHeaderData {
  ClassroomDetailHeaderData({
    required this.summary,
    required List<DeviceToggleStatus> deviceToggles,
    required List<EnvironmentMetric> environmentMetrics,
  }) : deviceToggles = UnmodifiableListView<DeviceToggleStatus>(
         List<DeviceToggleStatus>.from(deviceToggles),
       ),
       environmentMetrics = UnmodifiableListView<EnvironmentMetric>(
         List<EnvironmentMetric>.from(environmentMetrics),
       );

  final ClassroomSummaryInfo summary;
  final UnmodifiableListView<DeviceToggleStatus> deviceToggles;
  final UnmodifiableListView<EnvironmentMetric> environmentMetrics;
}

extension ClassroomSessionStatusLabel on ClassroomSessionStatus {
  String get label {
    switch (this) {
      case ClassroomSessionStatus.inUse:
        return '사용 중';
      case ClassroomSessionStatus.idle:
        return '미사용';
      case ClassroomSessionStatus.disconnected:
        return '미연동';
    }
  }
}
