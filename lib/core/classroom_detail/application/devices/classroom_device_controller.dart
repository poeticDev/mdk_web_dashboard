import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/core/classroom_detail/application/classroom_detail_providers.dart';
import 'package:web_dashboard/core/classroom_detail/domain/entities/classroom_detail_entity.dart';

class ClassroomDeviceController extends Notifier<ClassroomDeviceControllerState> {
  ClassroomDeviceController(this.classroomId);

  final String classroomId;

  @override
  ClassroomDeviceControllerState build() {
    final AsyncValue<ClassroomDetailEntity> detail =
        ref.watch(classroomDetailInfoProvider(classroomId));
    final List<ClassroomDeviceViewModel> devices = detail.maybeWhen(
      data: (ClassroomDetailEntity entity) => entity.devices
          .map(
            (ClassroomDeviceEntity device) => ClassroomDeviceViewModel(
              id: device.id,
              name: device.name,
              type: device.type,
              isEnabled: device.isEnabled,
            ),
          )
          .toList(),
      orElse: () => <ClassroomDeviceViewModel>[],
    );
    return ClassroomDeviceControllerState(
      devices: devices,
      isUpdating: false,
      errorMessage: detail is AsyncError ? detail.error.toString() : null,
    );
  }

  Future<void> toggleDevice(String deviceId, bool nextState) async {
    state = state.copyWith(isUpdating: true, errorMessage: null);
    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      final List<ClassroomDeviceViewModel> updated = state.devices
          .map(
            (ClassroomDeviceViewModel device) =>
                device.id == deviceId ? device.copyWith(isEnabled: nextState) : device,
          )
          .toList();
      state = state.copyWith(devices: updated, isUpdating: false);
    } catch (error) {
      state = state.copyWith(
        isUpdating: false,
        errorMessage: '장비 제어에 실패했습니다.',
      );
    }
  }
}

class ClassroomDeviceControllerState {
  const ClassroomDeviceControllerState({
    required this.devices,
    this.isUpdating = false,
    this.errorMessage,
  });

  final List<ClassroomDeviceViewModel> devices;
  final bool isUpdating;
  final String? errorMessage;

  ClassroomDeviceControllerState copyWith({
    List<ClassroomDeviceViewModel>? devices,
    bool? isUpdating,
    String? errorMessage,
  }) {
    return ClassroomDeviceControllerState(
      devices: devices ?? this.devices,
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: errorMessage,
    );
  }
}

final classroomDeviceControllerProvider =
    NotifierProvider.autoDispose.family<
      ClassroomDeviceController,
      ClassroomDeviceControllerState,
      String>(
  ClassroomDeviceController.new,
);
