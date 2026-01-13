import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_dashboard/domains/devices/domain/entities/device_entity.dart';
import 'package:web_dashboard/domains/devices/domain/repositories/classroom_device_repository.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/building_entity.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/classroom_entity.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/classroom_type.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/department_directory_entity.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/room_config_entity.dart';
import 'package:web_dashboard/domains/foundation/domain/repositories/classroom_repository.dart';
import 'package:web_dashboard/features/classroom_detail/application/classroom_detail_providers.dart';

void main() {
  group('classroomDetailInfoProvider', () {
    test('fetches entity by id via repository', () async {
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          classroomRepositoryProvider.overrideWithValue(
            _FakeRepository(),
          ),
          classroomDeviceRepositoryProvider.overrideWithValue(
            _FakeRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final ClassroomEntity entity = await container
          .read(classroomDetailInfoProvider('room-123').future);

      expect(entity.id, 'room-123');
      expect(entity.name, 'Mock Room');
    });
  });

  group('classroomSummaryViewModelProvider', () {
    test('maps detail entity to summary view model', () async {
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          classroomRepositoryProvider.overrideWithValue(
            _FakeRepository(),
          ),
          classroomDeviceRepositoryProvider.overrideWithValue(
            _FakeRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(classroomDetailInfoProvider('room-abc').future);
      final AsyncValue<ClassroomSummaryViewModel> summaryValue = container.read(
        classroomSummaryViewModelProvider('room-abc'),
      );
      final ClassroomSummaryViewModel? summary = summaryValue.value;

      expect(summary, isNotNull);
      expect(summary!.roomName, 'Mock Room');
      expect(summary.capacity, 30);
      expect(summary.buildingName, '메인관');
    });
  });

  group('classroomDeviceCatalogProvider', () {
    test('maps detail entity to device view models', () async {
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          classroomRepositoryProvider.overrideWithValue(
            _FakeRepository(),
          ),
          classroomDeviceRepositoryProvider.overrideWithValue(
            _FakeRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(classroomDetailInfoProvider('room-xyz').future);
      final List<ClassroomDeviceViewModel> devices = await container
          .read(classroomDeviceCatalogProvider('room-xyz').future);

      expect(devices, hasLength(1));
      expect(devices.first.name, '조명');
    });
  });
}

class _FakeRepository implements ClassroomRepository, ClassroomDeviceRepository {
  @override
  Future<ClassroomEntity> fetchById(String classroomId) async {
    return ClassroomEntity(
      id: classroomId,
      name: 'Mock Room',
      capacity: 30,
      type: ClassroomType.pbl,
      building: const BuildingEntity(id: 'b-1', name: '메인관'),
      department:
          const DepartmentDirectoryEntity(id: 'd-1', name: '컴퓨터공학과'),
      config: const RoomConfigEntity(autoPowerOnLecture: true),
    );
  }

  @override
  Future<List<DeviceEntity>> fetchDevices(String classroomId) async {
    return const <DeviceEntity>[
      DeviceEntity(
        id: 'dev-1',
        name: '조명',
        type: 'lighting',
        isEnabled: true,
      ),
    ];
  }
}
