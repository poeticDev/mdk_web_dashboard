import 'package:flutter/foundation.dart';

enum ClassroomType { pbl, studio, coding, hyflex }

class BuildingSummaryEntity {
  const BuildingSummaryEntity({
    required this.id,
    required this.name,
    this.code,
  });

  final String id;
  final String name;
  final String? code;
}

class DepartmentSummaryEntity {
  const DepartmentSummaryEntity({
    required this.id,
    required this.name,
    this.code,
    this.scope,
  });

  final String id;
  final String name;
  final String? code;
  final String? scope;
}

class ClassroomDeviceEntity {
  const ClassroomDeviceEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.isEnabled,
    this.manufacturer,
    this.model,
    this.serialNumber,
    this.ipAddress,
    this.port,
    this.protocol,
    this.address,
  });

  final String id;
  final String name;
  final String type;
  final bool isEnabled;
  final String? manufacturer;
  final String? model;
  final String? serialNumber;
  final String? ipAddress;
  final int? port;
  final String? protocol;
  final String? address;
}

class ClassroomConfigEntity {
  const ClassroomConfigEntity({
    this.autoPowerOnTime,
    this.autoPowerOffTime,
    required this.autoPowerOnLecture,
    this.autoStopAfterMinutes,
    this.tempHighThreshold,
    this.tempLowThreshold,
  });

  final String? autoPowerOnTime;
  final String? autoPowerOffTime;
  final bool autoPowerOnLecture;
  final int? autoStopAfterMinutes;
  final double? tempHighThreshold;
  final double? tempLowThreshold;
}

@immutable
class ClassroomDetailEntity {
  const ClassroomDetailEntity({
    required this.id,
    required this.name,
    this.code,
    this.floor,
    this.capacity,
    required this.type,
    this.building,
    this.department,
    this.devices = const <ClassroomDeviceEntity>[],
    this.config,
  });

  final String id;
  final String name;
  final String? code;
  final int? floor;
  final int? capacity;
  final ClassroomType type;
  final BuildingSummaryEntity? building;
  final DepartmentSummaryEntity? department;
  final List<ClassroomDeviceEntity> devices;
  final ClassroomConfigEntity? config;
}
