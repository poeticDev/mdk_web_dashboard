import 'package:web_dashboard/domains/foundation/domain/entities/building_entity.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/classroom_type.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/room_config_entity.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/department_directory_entity.dart';

/// 강의실 기본 정보를 표현하는 엔티티.
class ClassroomEntity {
  const ClassroomEntity({
    required this.id,
    required this.name,
    required this.type,
    this.code,
    this.floor,
    this.capacity,
    this.building,
    this.department,
    this.config,
  });

  final String id;
  final String name;
  final ClassroomType type;
  final String? code;
  final int? floor;
  final int? capacity;
  final BuildingEntity? building;
  final DepartmentDirectoryEntity? department;
  final RoomConfigEntity? config;
}
