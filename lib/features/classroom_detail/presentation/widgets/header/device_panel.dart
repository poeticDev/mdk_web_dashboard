// 장비 상태 패널을 구성한다.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/common/widgets/custom_card.dart';
import 'package:web_dashboard/features/classroom_detail/application/classroom_detail_providers.dart';
import 'package:web_dashboard/features/classroom_detail/application/devices/classroom_device_controller.dart';
import 'package:web_dashboard/features/classroom_detail/presentation/widgets/header/header_shared_tiles.dart';

/// 제어 가능한 장비 목록을 노출하고 토글 명령을 컨트롤러에 위임한다.
class DevicePanel extends ConsumerWidget {
  const DevicePanel({required this.classroomId, super.key});

  final String classroomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ClassroomDeviceControllerState state = ref.watch(
      classroomDeviceControllerProvider(classroomId),
    );
    final ClassroomDeviceController controller = ref.read(
      classroomDeviceControllerProvider(classroomId).notifier,
    );
    if (state.devices.isEmpty) {
      return const HeaderErrorTile(message: '연동된 장비가 없습니다.');
    }
    return CustomCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        spacing: 6,
        children: <Widget>[
          if (state.isUpdating) const LinearProgressIndicator(minHeight: 2),
          ...state.devices.map(
            (ClassroomDeviceViewModel device) => SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(device.name),
              subtitle: Text(device.type),
              value: device.isEnabled,
              onChanged: (bool value) =>
                  controller.toggleDevice(device.id, value),
            ),
          ),
          if (state.errorMessage != null)
            Text(
              state.errorMessage!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
        ],
      ),
    );
  }
}
