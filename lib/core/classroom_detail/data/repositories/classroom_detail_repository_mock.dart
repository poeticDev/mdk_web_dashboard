import 'dart:async';

import 'package:web_dashboard/core/classroom_detail/domain/entities/classroom_detail_entity.dart';
import 'package:web_dashboard/core/classroom_detail/domain/repositories/classroom_detail_repository.dart';

class ClassroomDetailRepositoryMock implements ClassroomDetailRepository {
  const ClassroomDetailRepositoryMock();

  static const ClassroomDetailEntity _mockEntity = ClassroomDetailEntity(
    id: 'room-mock',
    name: '공학관 A101',
    code: 'A101',
    floor: 1,
    capacity: 40,
    type: ClassroomType.hyflex,
    building: BuildingSummaryEntity(id: 'building-1', name: '공학관', code: 'ENG'),
    department: DepartmentSummaryEntity(id: 'dept-1', name: '스마트보안학과'),
    devices: <ClassroomDeviceEntity>[
      ClassroomDeviceEntity(
        id: 'device-light',
        name: '조명 스위치',
        type: 'lighting',
        isEnabled: true,
      ),
      ClassroomDeviceEntity(
        id: 'device-projector',
        name: '프로젝터',
        type: 'av',
        isEnabled: true,
      ),
    ],
    config: ClassroomConfigEntity(autoPowerOnLecture: true),
  );

  @override
  Future<ClassroomDetailEntity> fetchById(String classroomId) async {
    return _mockEntity.copyWithId(classroomId);
  }
}

extension on ClassroomDetailEntity {
  ClassroomDetailEntity copyWithId(String id) {
    return ClassroomDetailEntity(
      id: id,
      name: name,
      code: code,
      floor: floor,
      capacity: capacity,
      type: type,
      building: building,
      department: department,
      devices: devices,
      config: config,
    );
  }
}
