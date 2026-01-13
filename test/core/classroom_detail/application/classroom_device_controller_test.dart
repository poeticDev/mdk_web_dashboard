import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_dashboard/domains/devices/domain/entities/device_entity.dart';
import 'package:web_dashboard/domains/devices/domain/repositories/classroom_device_repository.dart';
import 'package:web_dashboard/features/classroom_detail/application/devices/classroom_device_controller.dart';
import 'package:web_dashboard/features/classroom_detail/application/classroom_detail_providers.dart';

void main() {
  test('toggleDevice updates device state', () async {
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        classroomDeviceRepositoryProvider.overrideWithValue(
          _FakeRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(classroomDeviceCatalogProvider('room-1').future);
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
      container
          .read(classroomDeviceControllerProvider('room-1'))
          .devices
          .first
          .isEnabled,
      true,
    );

    await controller.toggleDevice('dev-1', false);

    final ClassroomDeviceControllerState state = container.read(
      classroomDeviceControllerProvider('room-1'),
    );
    expect(state.devices.first.isEnabled, false);
  });
}

class _FakeRepository implements ClassroomDeviceRepository {
  @override
  Future<List<DeviceEntity>> fetchDevices(String classroomId) async {
    return const <DeviceEntity>[
      DeviceEntity(
        id: 'dev-1',
        name: 'Light',
        type: 'lighting',
        isEnabled: true,
      ),
    ];
  }
}
