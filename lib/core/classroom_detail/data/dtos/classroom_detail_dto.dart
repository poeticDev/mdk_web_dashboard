import 'package:flutter/foundation.dart';

/// 강의실 상세 API 응답을 옮겨 담는 루트 DTO.
@immutable
class ClassroomDetailResponseDto {
  const ClassroomDetailResponseDto({
    required this.id,
    required this.name,
    required this.type,
    this.code,
    this.floor,
    this.capacity,
    this.building,
    this.department,
    this.devices = const <ClassroomDeviceDto>[],
    this.config,
  });

  factory ClassroomDetailResponseDto.fromJson(Map<String, Object?> json) {
    return ClassroomDetailResponseDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      code: json['code'] as String?,
      floor: json['floor'] as int?,
      capacity: json['capacity'] as int?,
      building: _parseNullable<BuildingDto>(
        json['building'],
        BuildingDto.fromJson,
      ),
      department: _parseNullable<DepartmentDto>(
        json['department'],
        DepartmentDto.fromJson,
      ),
      devices: _parseList<ClassroomDeviceDto>(
        json['devices'],
        ClassroomDeviceDto.fromJson,
      ),
      config: _parseNullable<ClassroomConfigDto>(
        json['config'],
        ClassroomConfigDto.fromJson,
      ),
    );
  }

  final String id;
  final String name;
  final String type;
  final String? code;
  final int? floor;
  final int? capacity;
  final BuildingDto? building;
  final DepartmentDto? department;
  final List<ClassroomDeviceDto> devices;
  final ClassroomConfigDto? config;
}

/// 건물 요약 정보를 표현하는 DTO.
@immutable
class BuildingDto {
  const BuildingDto({required this.id, required this.name, this.code});

  factory BuildingDto.fromJson(Map<String, Object?> json) {
    return BuildingDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      code: json['code'] as String?,
    );
  }

  final String id;
  final String name;
  final String? code;
}

/// 소속 학과/조직 요약 정보를 표현하는 DTO.
@immutable
class DepartmentDto {
  const DepartmentDto({
    required this.id,
    required this.name,
    this.code,
    this.scope,
  });

  factory DepartmentDto.fromJson(Map<String, Object?> json) {
    return DepartmentDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      code: json['code'] as String?,
      scope: json['scope'] as String?,
    );
  }

  final String id;
  final String name;
  final String? code;
  final String? scope;
}

/// 강의실에 배치된 디바이스 정보를 표현하는 DTO.
@immutable
class ClassroomDeviceDto {
  const ClassroomDeviceDto({
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

  factory ClassroomDeviceDto.fromJson(Map<String, Object?> json) {
    return ClassroomDeviceDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      isEnabled: json['isEnabled'] as bool? ?? false,
      manufacturer: json['manufacturer'] as String?,
      model: json['model'] as String?,
      serialNumber: json['serialNumber'] as String?,
      ipAddress: json['ipAddress'] as String?,
      port: json['port'] as int?,
      protocol: json['protocol'] as String?,
      address: json['address'] as String?,
    );
  }

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

/// 강의실 자동화/환경설정 정보를 표현하는 DTO.
@immutable
class ClassroomConfigDto {
  const ClassroomConfigDto({
    required this.autoPowerOnLecture,
    this.autoPowerOnTime,
    this.autoPowerOffTime,
    this.autoStopAfterMinutes,
    this.tempHighThreshold,
    this.tempLowThreshold,
  });

  factory ClassroomConfigDto.fromJson(Map<String, Object?> json) {
    return ClassroomConfigDto(
      autoPowerOnLecture: json['autoPowerOnLecture'] as bool? ?? false,
      autoPowerOnTime: json['autoPowerOnTime'] as String?,
      autoPowerOffTime: json['autoPowerOffTime'] as String?,
      autoStopAfterMinutes: json['autoStopAfterMinutes'] as int?,
      tempHighThreshold: (json['tempHighThreshold'] as num?)?.toDouble(),
      tempLowThreshold: (json['tempLowThreshold'] as num?)?.toDouble(),
    );
  }

  final bool autoPowerOnLecture;
  final String? autoPowerOnTime;
  final String? autoPowerOffTime;
  final int? autoStopAfterMinutes;
  final double? tempHighThreshold;
  final double? tempLowThreshold;
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
