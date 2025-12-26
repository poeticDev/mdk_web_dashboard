import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_dashboard/core/classroom_detail/application/classroom_detail_providers.dart';
import 'package:web_dashboard/core/classroom_detail/domain/entities/classroom_detail_entity.dart';
import 'package:web_dashboard/core/classroom_detail/domain/repositories/classroom_detail_repository.dart';

void main() {
  group('classroomDetailInfoProvider', () {
    test('fetches entity by id via repository', () async {
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          classroomDetailRepositoryProvider.overrideWithValue(
            _FakeRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final ClassroomDetailEntity entity = await container
          .read(classroomDetailInfoProvider('room-123').future);

      expect(entity.id, 'room-123');
      expect(entity.name, 'Mock Room');
      expect(entity.devices.length, 1);
    });
  });

  group('classroomSummaryViewModelProvider', () {
    test('maps detail entity to summary view model', () async {
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          classroomDetailRepositoryProvider.overrideWithValue(
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
          classroomDetailRepositoryProvider.overrideWithValue(
            _FakeRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(classroomDetailInfoProvider('room-xyz').future);
      final AsyncValue<List<ClassroomDeviceViewModel>> devicesValue = container
          .read(classroomDeviceCatalogProvider('room-xyz'));
      final List<ClassroomDeviceViewModel>? devices = devicesValue.value;

      expect(devices, isNotNull);
      expect(devices, hasLength(1));
      expect(devices!.first.name, '조명');
    });
  });
}

class _FakeRepository implements ClassroomDetailRepository {
  @override
  Future<ClassroomDetailEntity> fetchById(String classroomId) async {
    return ClassroomDetailEntity(
      id: classroomId,
      name: 'Mock Room',
      capacity: 30,
      type: ClassroomType.pbl,
      building: const BuildingSummaryEntity(id: 'b-1', name: '메인관'),
      department: const DepartmentSummaryEntity(id: 'd-1', name: '컴퓨터공학과'),
      devices: const <ClassroomDeviceEntity>[
        ClassroomDeviceEntity(
          id: 'dev-1',
          name: '조명',
          type: 'lighting',
          isEnabled: true,
        ),
      ],
      config: const ClassroomConfigEntity(autoPowerOnLecture: true),
    );
  }
}
