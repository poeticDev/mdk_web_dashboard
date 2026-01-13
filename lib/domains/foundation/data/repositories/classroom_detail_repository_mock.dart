import 'dart:async';

import 'package:web_dashboard/domains/devices/domain/entities/device_entity.dart';
import 'package:web_dashboard/domains/devices/domain/repositories/classroom_device_repository.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/building_entity.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/classroom_entity.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/classroom_type.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/department_directory_entity.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/room_config_entity.dart';
import 'package:web_dashboard/domains/foundation/domain/repositories/classroom_repository.dart';

class ClassroomDetailRepositoryMock
    implements ClassroomRepository, ClassroomDeviceRepository {
  const ClassroomDetailRepositoryMock();

  static const ClassroomEntity _mockEntity = ClassroomEntity(
    id: 'room-mock',
    name: '공학관 A101',
    code: 'A101',
    floor: 1,
    capacity: 40,
    type: ClassroomType.hyflex,
    building: BuildingEntity(id: 'building-1', name: '공학관', code: 'ENG'),
    department: DepartmentDirectoryEntity(id: 'dept-1', name: '스마트보안학과'),
    config: RoomConfigEntity(autoPowerOnLecture: true),
  );
  static const List<DeviceEntity> _mockDevices = <DeviceEntity>[
    DeviceEntity(
      id: 'device-light',
      name: '조명 스위치',
      type: 'lighting',
      isEnabled: true,
    ),
    DeviceEntity(
      id: 'device-projector',
      name: '프로젝터',
      type: 'av',
      isEnabled: true,
    ),
  ];

  @override
  Future<ClassroomEntity> fetchById(String classroomId) async {
    return _mockEntity.copyWithId(classroomId);
  }

  @override
  Future<List<DeviceEntity>> fetchDevices(String classroomId) async {
    return _mockDevices;
  }
}

extension on ClassroomEntity {
  ClassroomEntity copyWithId(String id) {
    return ClassroomEntity(
      id: id,
      name: name,
      code: code,
      floor: floor,
      capacity: capacity,
      type: type,
      building: building,
      department: department,
      config: config,
    );
  }
}
