/// ROLE
/// - Foundation 기준 강의실 목록 응답 DTO를 정의한다
///
/// RESPONSIBILITY
/// - 응답/요청 필드를 모델링한다
/// - JSON 변환을 제공한다
///
/// DEPENDS ON
/// - flutter
library;

import 'package:flutter/foundation.dart';

/// Foundation 기준 강의실 목록 응답 DTO.
@immutable
class FoundationClassroomsResponseDto {
  const FoundationClassroomsResponseDto({
    required this.foundation,
    required this.classrooms,
    required this.meta,
  });

  factory FoundationClassroomsResponseDto.fromJson(
    Map<String, Object?> json,
  ) {
    return FoundationClassroomsResponseDto(
      foundation: FoundationSummaryDto.fromJson(
        _parseMap(json['foundation']),
      ),
      classrooms: _parseList<FoundationClassroomDto>(
        json['classrooms'],
        FoundationClassroomDto.fromJson,
      ),
      meta: FoundationClassroomsMetaDto.fromJson(
        _parseMap(json['meta']),
      ),
    );
  }

  final FoundationSummaryDto foundation;
  final List<FoundationClassroomDto> classrooms;
  final FoundationClassroomsMetaDto meta;
}

/// Foundation 요약 정보를 표현하는 DTO.
@immutable
class FoundationSummaryDto {
  const FoundationSummaryDto({
    required this.type,
    required this.id,
    required this.name,
    this.code,
  });

  factory FoundationSummaryDto.fromJson(Map<String, Object?> json) {
    return FoundationSummaryDto(
      type: json['type'] as String? ?? '',
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      code: json['code'] as String?,
    );
  }

  final String type;
  final String id;
  final String name;
  final String? code;
}

/// Foundation 조회 대상 강의실 DTO.
@immutable
class FoundationClassroomDto {
  const FoundationClassroomDto({
    required this.id,
    required this.name,
    this.code,
    this.building,
    this.department,
  });

  factory FoundationClassroomDto.fromJson(Map<String, Object?> json) {
    return FoundationClassroomDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      code: json['code'] as String?,
      building: _parseNullable<FoundationBuildingDto>(
        json['building'],
        FoundationBuildingDto.fromJson,
      ),
      department: _parseNullable<FoundationDepartmentDto>(
        json['department'],
        FoundationDepartmentDto.fromJson,
      ),
    );
  }

  final String id;
  final String name;
  final String? code;
  final FoundationBuildingDto? building;
  final FoundationDepartmentDto? department;
}

/// 강의실 소속 건물 요약 DTO.
@immutable
class FoundationBuildingDto {
  const FoundationBuildingDto({
    required this.id,
    required this.name,
    this.code,
  });

  factory FoundationBuildingDto.fromJson(Map<String, Object?> json) {
    return FoundationBuildingDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      code: json['code'] as String?,
    );
  }

  final String id;
  final String name;
  final String? code;
}

/// 강의실 소속 학과 요약 DTO.
@immutable
class FoundationDepartmentDto {
  const FoundationDepartmentDto({
    required this.id,
    required this.name,
    this.code,
  });

  factory FoundationDepartmentDto.fromJson(Map<String, Object?> json) {
    return FoundationDepartmentDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      code: json['code'] as String?,
    );
  }

  final String id;
  final String name;
  final String? code;
}

/// Foundation 목록 응답 메타 정보 DTO.
@immutable
class FoundationClassroomsMetaDto {
  const FoundationClassroomsMetaDto({required this.count});

  factory FoundationClassroomsMetaDto.fromJson(Map<String, Object?> json) {
    return FoundationClassroomsMetaDto(
      count: json['count'] as int? ?? 0,
    );
  }

  final int count;
}

Map<String, Object?> _parseMap(Object? raw) {
  if (raw is Map<String, Object?>) {
    return raw;
  }
  return <String, Object?>{};
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
