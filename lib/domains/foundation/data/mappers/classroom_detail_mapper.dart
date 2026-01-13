import 'package:web_dashboard/domains/devices/domain/entities/device_entity.dart';
import 'package:web_dashboard/domains/foundation/data/dtos/classroom_detail_dto.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/building_entity.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/classroom_entity.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/classroom_type.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/department_directory_entity.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/room_config_entity.dart';

/// 강의실 상세 DTO를 도메인 엔티티로 변환하는 책임을 가진 매퍼.
class ClassroomDetailMapper {
  const ClassroomDetailMapper();

  ClassroomEntity toClassroom(ClassroomDetailResponseDto dto) {
    return ClassroomEntity(
      id: dto.id,
      name: dto.name,
      code: dto.code,
      floor: dto.floor,
      capacity: dto.capacity,
      type: _mapType(dto.type),
      building: dto.building != null ? _mapBuilding(dto.building!) : null,
      department:
          dto.department != null ? _mapDepartment(dto.department!) : null,
      config: dto.config != null ? _mapConfig(dto.config!) : null,
    );
  }

  List<DeviceEntity> toDevices(ClassroomDetailResponseDto dto) {
    return dto.devices.map(_mapDevice).toList();
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

  BuildingEntity _mapBuilding(BuildingDto dto) {
    return BuildingEntity(id: dto.id, name: dto.name, code: dto.code);
  }

  DepartmentDirectoryEntity _mapDepartment(DepartmentDto dto) {
    return DepartmentDirectoryEntity(
      id: dto.id,
      name: dto.name,
      code: dto.code,
      scope: dto.scope,
    );
  }

  DeviceEntity _mapDevice(ClassroomDeviceDto dto) {
    return DeviceEntity(
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

  RoomConfigEntity _mapConfig(ClassroomConfigDto dto) {
    return RoomConfigEntity(
      autoPowerOnLecture: dto.autoPowerOnLecture,
      autoPowerOnTime: dto.autoPowerOnTime,
      autoPowerOffTime: dto.autoPowerOffTime,
      autoStopAfterMinutes: dto.autoStopAfterMinutes,
      tempHighThreshold: dto.tempHighThreshold,
      tempLowThreshold: dto.tempLowThreshold,
    );
  }
}
