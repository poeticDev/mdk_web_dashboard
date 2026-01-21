/// ROLE
/// - provider 모음을 제공한다
///
/// RESPONSIBILITY
/// - 의존성을 주입한다
///
/// DEPENDS ON
/// - flutter_riverpod
/// - device_entity
/// - classroom_device_repository
/// - classroom_entity
/// - classroom_type
/// - classroom_repository
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/domains/devices/domain/entities/device_entity.dart';
import 'package:web_dashboard/domains/devices/domain/repositories/classroom_device_repository.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/classroom_entity.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/classroom_type.dart';
import 'package:web_dashboard/domains/foundation/domain/repositories/classroom_repository.dart';
import 'package:web_dashboard/di/service_locator.dart';

class ClassroomDetailParams {
  const ClassroomDetailParams({required this.classroomId});

  final String classroomId;
}

final Provider<ClassroomDetailParams> classroomDetailParamsProvider =
    Provider<ClassroomDetailParams>(
      (Ref ref) =>
          throw UnimplementedError('ClassroomDetailParams must be overridden'),
    );

final Provider<ClassroomRepository> classroomRepositoryProvider =
    Provider<ClassroomRepository>(
      (Ref ref) => di<ClassroomRepository>(),
    );

final Provider<ClassroomDeviceRepository> classroomDeviceRepositoryProvider =
    Provider<ClassroomDeviceRepository>(
      (Ref ref) => di<ClassroomDeviceRepository>(),
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

  ClassroomDeviceViewModel copyWith({bool? isEnabled}) {
    return ClassroomDeviceViewModel(
      id: id,
      name: name,
      type: type,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

/// 강의실 기본 정보를 원격 저장소에서 조회하는 최상위 provider.
final classroomDetailInfoProvider = FutureProvider.autoDispose
    .family<ClassroomEntity, String>((Ref ref, String classroomId) async {
      final ClassroomRepository repository = ref.read(
        classroomRepositoryProvider,
      );
      return repository.fetchById(classroomId);
    });

/// 헤더 타이틀 영역에 필요한 요약 정보만 추려내는 provider.
final classroomSummaryViewModelProvider = Provider.autoDispose
    .family<AsyncValue<ClassroomSummaryViewModel>, String>((
      Ref ref,
      String classroomId,
    ) {
      final AsyncValue<ClassroomEntity> detail = ref.watch(
        classroomDetailInfoProvider(classroomId),
      );
      return detail.whenData(
        (ClassroomEntity entity) => ClassroomSummaryViewModel(
          roomName: entity.name,
          buildingName: entity.building?.name,
          departmentName: entity.department?.name,
          code: entity.code,
          capacity: entity.capacity,
          type: entity.type,
        ),
      );
    });

/// 헤더 장비 패널에서 초기 장비 목록을 그릴 때 사용하는 파생 provider.
final classroomDeviceCatalogProvider = FutureProvider.autoDispose
    .family<List<ClassroomDeviceViewModel>, String>((
      Ref ref,
      String classroomId,
    ) async {
      final ClassroomDeviceRepository repository = ref.read(
        classroomDeviceRepositoryProvider,
      );
      final List<DeviceEntity> devices =
          await repository.fetchDevices(classroomId);
      return devices
          .map(
            (DeviceEntity device) => ClassroomDeviceViewModel(
              id: device.id,
              name: device.name,
              type: device.type,
              isEnabled: device.isEnabled,
            ),
          )
          .toList();
    });
