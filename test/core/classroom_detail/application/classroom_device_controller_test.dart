import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_dashboard/core/classroom_detail/application/devices/classroom_device_controller.dart';
import 'package:web_dashboard/core/classroom_detail/application/classroom_detail_providers.dart';
import 'package:web_dashboard/core/classroom_detail/domain/entities/classroom_detail_entity.dart';
import 'package:web_dashboard/core/classroom_detail/domain/repositories/classroom_detail_repository.dart';

void main() {
  test('toggleDevice updates device state', () async {
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        classroomDetailRepositoryProvider.overrideWithValue(
          _FakeRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(classroomDetailInfoProvider('room-1').future);
    final ProviderSubscription<ClassroomDeviceControllerState> subscription =
        container.listen<ClassroomDeviceControllerState>(
      classroomDeviceControllerProvider('room-1'),
      (_, __) {},
    );
    addTearDown(subscription.close);
    final ClassroomDeviceController controller = container.read(
      classroomDeviceControllerProvider('room-1').notifier,
    );
    expect(
      container.read(classroomDeviceControllerProvider('room-1')).devices.first.isEnabled,
      true,
    );

    await controller.toggleDevice('dev-1', false);

    final ClassroomDeviceControllerState state = container.read(
      classroomDeviceControllerProvider('room-1'),
    );
    expect(state.devices.first.isEnabled, false);
  });
}

class _FakeRepository implements ClassroomDetailRepository {
  @override
  Future<ClassroomDetailEntity> fetchById(String classroomId) async {
    return ClassroomDetailEntity(
      id: classroomId,
      name: 'Mock Room',
      type: ClassroomType.pbl,
      devices: const <ClassroomDeviceEntity>[
        ClassroomDeviceEntity(
          id: 'dev-1',
          name: 'Light',
          type: 'lighting',
          isEnabled: true,
        ),
      ],
    );
  }
}
