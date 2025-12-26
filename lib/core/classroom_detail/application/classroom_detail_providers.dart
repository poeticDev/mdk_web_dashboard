import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/core/classroom_detail/domain/entities/classroom_detail_entity.dart';
import 'package:web_dashboard/core/classroom_detail/domain/repositories/classroom_detail_repository.dart';
import 'package:web_dashboard/di/service_locator.dart';

class ClassroomDetailParams {
  const ClassroomDetailParams({required this.classroomId});

  final String classroomId;
}

final Provider<ClassroomDetailParams> classroomDetailParamsProvider =
    Provider<ClassroomDetailParams>(
  (Ref ref) => throw UnimplementedError('ClassroomDetailParams must be overridden'),
);

final Provider<ClassroomDetailRepository> classroomDetailRepositoryProvider =
    Provider<ClassroomDetailRepository>(
  (Ref ref) => di<ClassroomDetailRepository>(),
);

class ClassroomSummaryViewModel {
  const ClassroomSummaryViewModel({
    required this.roomName,
    this.buildingName,
    this.departmentName,
    this.code,
    this.capacity,
    required this.type,
  });

  final String roomName;
  final String? buildingName;
  final String? departmentName;
  final String? code;
  final int? capacity;
  final ClassroomType type;
}

class ClassroomDeviceViewModel {
  const ClassroomDeviceViewModel({
    required this.id,
    required this.name,
    required this.type,
    required this.isEnabled,
  });

  final String id;
  final String name;
  final String type;
  final bool isEnabled;
}

final classroomDetailInfoProvider =
    FutureProvider.autoDispose.family<ClassroomDetailEntity, String>(
  (Ref ref, String classroomId) async {
    final ClassroomDetailRepository repository =
        ref.read(classroomDetailRepositoryProvider);
    return repository.fetchById(classroomId);
  },
);

final classroomSummaryViewModelProvider =
    Provider.autoDispose.family<AsyncValue<ClassroomSummaryViewModel>, String>(
  (Ref ref, String classroomId) {
    final AsyncValue<ClassroomDetailEntity> detail =
        ref.watch(classroomDetailInfoProvider(classroomId));
    return detail.whenData(
      (ClassroomDetailEntity entity) => ClassroomSummaryViewModel(
        roomName: entity.name,
        buildingName: entity.building?.name,
        departmentName: entity.department?.name,
        code: entity.code,
        capacity: entity.capacity,
        type: entity.type,
      ),
    );
  },
);

final classroomDeviceCatalogProvider = Provider.autoDispose
    .family<AsyncValue<List<ClassroomDeviceViewModel>>, String>(
  (Ref ref, String classroomId) {
    final AsyncValue<ClassroomDetailEntity> detail =
        ref.watch(classroomDetailInfoProvider(classroomId));
    return detail.whenData(
      (ClassroomDetailEntity entity) => entity.devices
          .map(
            (ClassroomDeviceEntity device) => ClassroomDeviceViewModel(
              id: device.id,
              name: device.name,
              type: device.type,
              isEnabled: device.isEnabled,
            ),
          )
          .toList(),
    );
  },
);
