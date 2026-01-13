/// ROLE
/// - RoomState SSE DTO를 정의한다
///
/// RESPONSIBILITY
/// - 구독 요청/응답 모델링
/// - 스냅샷/델타 payload 모델링
///
/// DEPENDS ON
/// - date_time_utils
library;

import 'package:flutter/foundation.dart';
import 'package:web_dashboard/common/utils/date_time_utils.dart';

@immutable
class RoomStateSubscriptionRequestDto {
  const RoomStateSubscriptionRequestDto({
    required this.classroomIds,
    required this.sensors,
    required this.equipment,
  });

  final List<String> classroomIds;
  final List<String> sensors;
  final List<String> equipment;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'classroomIds': classroomIds,
      'sensors': sensors,
      'equipment': equipment,
    };
  }
}

@immutable
class RoomStateSubscriptionResponseDto {
  const RoomStateSubscriptionResponseDto({required this.subscriptionId});

  factory RoomStateSubscriptionResponseDto.fromJson(Map<String, Object?> json) {
    return RoomStateSubscriptionResponseDto(
      subscriptionId: json['subscriptionId']?.toString() ?? '',
    );
  }

  final String subscriptionId;
}

@immutable
class RoomStateSnapshotPayloadDto {
  const RoomStateSnapshotPayloadDto({
    required this.classrooms,
    this.occupancySummary,
  });

  factory RoomStateSnapshotPayloadDto.fromJson(Map<String, Object?> json) {
    return RoomStateSnapshotPayloadDto(
      occupancySummary: _parseNullable<RoomStateOccupancySummaryDto>(
        json['occupancySummary'],
        RoomStateOccupancySummaryDto.fromJson,
      ),
      classrooms: _parseList<RoomStateClassroomSnapshotDto>(
        json['classrooms'],
        RoomStateClassroomSnapshotDto.fromJson,
      ),
    );
  }

  final List<RoomStateClassroomSnapshotDto> classrooms;
  final RoomStateOccupancySummaryDto? occupancySummary;
}

@immutable
class RoomStateDeltaPayloadDto {
  const RoomStateDeltaPayloadDto({
    required this.updates,
    this.occupancySummary,
  });

  factory RoomStateDeltaPayloadDto.fromJson(Map<String, Object?> json) {
    return RoomStateDeltaPayloadDto(
      updates: _parseList<RoomStateUpdateDto>(
        json['updates'],
        RoomStateUpdateDto.fromJson,
      ),
      occupancySummary: _parseNullable<RoomStateOccupancySummaryDto>(
        json['occupancySummary'],
        RoomStateOccupancySummaryDto.fromJson,
      ),
    );
  }

  final List<RoomStateUpdateDto> updates;
  final RoomStateOccupancySummaryDto? occupancySummary;
}

@immutable
class RoomStateOccupancySummaryDto {
  const RoomStateOccupancySummaryDto({
    required this.occupied,
    required this.vacant,
    required this.notLinked,
    required this.updatedAt,
  });

  factory RoomStateOccupancySummaryDto.fromJson(Map<String, Object?> json) {
    return RoomStateOccupancySummaryDto(
      occupied: json['occupied'] as int? ?? 0,
      vacant: json['vacant'] as int? ?? 0,
      notLinked: json['notLinked'] as int? ?? 0,
      updatedAt: DateTimeUtils.toLocal(
        DateTimeUtils.parseUtcFromJson(json['updatedAt']),
      ),
    );
  }

  final int occupied;
  final int vacant;
  final int notLinked;
  final DateTime updatedAt;
}

@immutable
class RoomStateClassroomSnapshotDto {
  const RoomStateClassroomSnapshotDto({
    required this.classroomId,
    required this.sensors,
    required this.equipment,
    required this.lastUpdatedAt,
    required this.status,
  });

  factory RoomStateClassroomSnapshotDto.fromJson(Map<String, Object?> json) {
    return RoomStateClassroomSnapshotDto(
      classroomId: json['classroomId']?.toString() ?? '',
      sensors: _parseMapOf<RoomStateSensorSnapshotDto>(
        json['sensors'],
        RoomStateSensorSnapshotDto.fromJson,
      ),
      equipment: _parseMapOf<RoomStateEquipmentSnapshotDto>(
        json['equipment'],
        RoomStateEquipmentSnapshotDto.fromJson,
      ),
      lastUpdatedAt: DateTimeUtils.toLocal(
        DateTimeUtils.parseUtcFromJson(json['lastUpdatedAt']),
      ),
      status: RoomStateStatusDto.fromJson(_parseMap(json['status'])),
    );
  }

  final String classroomId;
  final Map<String, RoomStateSensorSnapshotDto> sensors;
  final Map<String, RoomStateEquipmentSnapshotDto> equipment;
  final DateTime lastUpdatedAt;
  final RoomStateStatusDto status;
}

@immutable
class RoomStateSensorSnapshotDto {
  const RoomStateSensorSnapshotDto({
    this.boolValue,
    this.numberValue,
    this.recordedAt,
    this.status,
  });

  factory RoomStateSensorSnapshotDto.fromJson(Map<String, Object?> json) {
    final Object? rawValue = json['value'];
    return RoomStateSensorSnapshotDto(
      boolValue: rawValue is bool ? rawValue : null,
      numberValue: rawValue is num ? rawValue.toDouble() : null,
      recordedAt: _parseDateTime(json['recordedAt']),
      status: json['status']?.toString(),
    );
  }

  final bool? boolValue;
  final double? numberValue;
  final DateTime? recordedAt;
  final String? status;
}

@immutable
class RoomStateEquipmentSnapshotDto {
  const RoomStateEquipmentSnapshotDto({
    this.isOn,
    this.updatedAt,
    this.status,
  });

  factory RoomStateEquipmentSnapshotDto.fromJson(Map<String, Object?> json) {
    return RoomStateEquipmentSnapshotDto(
      isOn: json['isOn'] as bool?,
      updatedAt: _parseDateTime(json['updatedAt']),
      status: json['status']?.toString(),
    );
  }

  final bool? isOn;
  final DateTime? updatedAt;
  final String? status;
}

@immutable
class RoomStateStatusDto {
  const RoomStateStatusDto({
    required this.isStale,
    required this.hasError,
    required this.hasSensorError,
    required this.hasEquipmentError,
  });

  factory RoomStateStatusDto.fromJson(Map<String, Object?> json) {
    return RoomStateStatusDto(
      isStale: json['isStale'] as bool? ?? false,
      hasError: json['hasError'] as bool? ?? false,
      hasSensorError: json['hasSensorError'] as bool? ?? false,
      hasEquipmentError: json['hasEquipmentError'] as bool? ?? false,
    );
  }

  final bool isStale;
  final bool hasError;
  final bool hasSensorError;
  final bool hasEquipmentError;
}

@immutable
class RoomStateUpdateDto {
  const RoomStateUpdateDto({
    required this.classroomId,
    required this.type,
    this.sensorType,
    this.equipmentType,
    this.boolValue,
    this.numberValue,
    this.isOn,
    this.recordedAt,
    this.updatedAt,
    this.status,
    this.deviceId,
  });

  factory RoomStateUpdateDto.fromJson(Map<String, Object?> json) {
    final Object? rawValue = json['value'];
    return RoomStateUpdateDto(
      classroomId: json['classroomId']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      sensorType: json['sensorType']?.toString(),
      equipmentType: json['equipmentType']?.toString(),
      boolValue: rawValue is bool ? rawValue : null,
      numberValue: rawValue is num ? rawValue.toDouble() : null,
      isOn: json['isOn'] as bool?,
      recordedAt: _parseDateTime(json['recordedAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      status: json['status']?.toString(),
      deviceId: json['deviceId']?.toString(),
    );
  }

  final String classroomId;
  final String type;
  final String? sensorType;
  final String? equipmentType;
  final bool? boolValue;
  final double? numberValue;
  final bool? isOn;
  final DateTime? recordedAt;
  final DateTime? updatedAt;
  final String? status;
  final String? deviceId;
}

DateTime? _parseDateTime(Object? raw) {
  if (raw == null) {
    return null;
  }
  return DateTimeUtils.toLocal(DateTimeUtils.parseUtcFromJson(raw));
}

Map<String, Object?> _parseMap(Object? raw) {
  if (raw is Map<String, Object?>) {
    return raw;
  }
  return <String, Object?>{};
}

Map<String, T> _parseMapOf<T>(
  Object? raw,
  T Function(Map<String, Object?> json) mapper,
) {
  if (raw is Map<String, Object?>) {
    return raw.map(
      (String key, Object? value) => MapEntry<String, T>(
        key,
        mapper(_parseMap(value)),
      ),
    );
  }
  return <String, T>{};
}

T? _parseNullable<T>(
  Object? raw,
  T Function(Map<String, Object?> json) mapper,
) {
  if (raw is Map<String, Object?>) {
    return mapper(raw);
  }
  return null;
}

List<T> _parseList<T>(
  Object? raw,
  T Function(Map<String, Object?> json) mapper,
) {
  if (raw is List<Object?>) {
    return raw
        .whereType<Map<String, Object?>>()
        .map((Map<String, Object?> item) => mapper(item))
        .toList();
  }
  return <T>[];
}
