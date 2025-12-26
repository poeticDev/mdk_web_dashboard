import 'package:web_dashboard/core/classroom_detail/data/dtos/classroom_detail_dto.dart';
import 'package:web_dashboard/core/classroom_detail/domain/entities/classroom_detail_entity.dart';

/// 강의실 상세 DTO를 도메인 엔티티로 변환하는 책임을 가진 매퍼.
class ClassroomDetailMapper {
  const ClassroomDetailMapper();

  ClassroomDetailEntity toEntity(ClassroomDetailResponseDto dto) {
    return ClassroomDetailEntity(
      id: dto.id,
      name: dto.name,
      code: dto.code,
      floor: dto.floor,
      capacity: dto.capacity,
      type: _mapType(dto.type),
      building: dto.building != null ? _mapBuilding(dto.building!) : null,
      department:
          dto.department != null ? _mapDepartment(dto.department!) : null,
      devices: dto.devices.map(_mapDevice).toList(),
      config: dto.config != null ? _mapConfig(dto.config!) : null,
    );
  }

  ClassroomType _mapType(String raw) {
    switch (raw.toLowerCase()) {
      case 'pbl':
        return ClassroomType.pbl;
      case 'studio':
        return ClassroomType.studio;
      case 'coding':
        return ClassroomType.coding;
      case 'hyflex':
        return ClassroomType.hyflex;
      default:
        throw FormatException('Unknown classroom type: $raw');
    }
  }

  BuildingSummaryEntity _mapBuilding(BuildingDto dto) {
    return BuildingSummaryEntity(id: dto.id, name: dto.name, code: dto.code);
  }

  DepartmentSummaryEntity _mapDepartment(DepartmentDto dto) {
    return DepartmentSummaryEntity(
      id: dto.id,
      name: dto.name,
      code: dto.code,
      scope: dto.scope,
    );
  }

  ClassroomDeviceEntity _mapDevice(ClassroomDeviceDto dto) {
    return ClassroomDeviceEntity(
      id: dto.id,
      name: dto.name,
      type: dto.type,
      isEnabled: dto.isEnabled,
      manufacturer: dto.manufacturer,
      model: dto.model,
      serialNumber: dto.serialNumber,
      ipAddress: dto.ipAddress,
      port: dto.port,
      protocol: dto.protocol,
      address: dto.address,
    );
  }

  ClassroomConfigEntity _mapConfig(ClassroomConfigDto dto) {
    return ClassroomConfigEntity(
      autoPowerOnLecture: dto.autoPowerOnLecture,
      autoPowerOnTime: dto.autoPowerOnTime,
      autoPowerOffTime: dto.autoPowerOffTime,
      autoStopAfterMinutes: dto.autoStopAfterMinutes,
      tempHighThreshold: dto.tempHighThreshold,
      tempLowThreshold: dto.tempLowThreshold,
    );
  }
}
