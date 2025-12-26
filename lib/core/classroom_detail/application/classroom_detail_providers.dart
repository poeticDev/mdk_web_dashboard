import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/core/classroom_detail/data/datasources/classroom_now_remote_data_source.dart';
import 'package:web_dashboard/core/classroom_detail/domain/entities/classroom_detail_entity.dart';
import 'package:web_dashboard/core/classroom_detail/domain/repositories/classroom_detail_repository.dart';
import 'package:web_dashboard/core/timetable/application/timetable_providers.dart';
import 'package:web_dashboard/core/timetable/data/mappers/lecture_occurrence_mapper.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_occurrence_entity.dart';
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

final Provider<ClassroomDetailRepository> classroomDetailRepositoryProvider =
    Provider<ClassroomDetailRepository>(
      (Ref ref) => di<ClassroomDetailRepository>(),
    );

final Provider<ClassroomNowRemoteDataSource>
classroomNowRemoteDataSourceProvider = Provider<ClassroomNowRemoteDataSource>(
  (Ref ref) => di<ClassroomNowRemoteDataSource>(),
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

class ClassroomNowViewModel {
  const ClassroomNowViewModel({
    required this.isInSession,
    this.currentCourseName,
    this.instructorName,
    this.startTime,
    this.endTime,
  });

  final bool isInSession;
  final String? currentCourseName;
  final String? instructorName;
  final DateTime? startTime;
  final DateTime? endTime;
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
    .family<ClassroomDetailEntity, String>((Ref ref, String classroomId) async {
      final ClassroomDetailRepository repository = ref.read(
        classroomDetailRepositoryProvider,
      );
      return repository.fetchById(classroomId);
    });

/// 헤더 타이틀 영역에 실시간 강의 상태를 보여주는 provider.
final classroomNowViewModelProvider = FutureProvider.autoDispose
    .family<ClassroomNowViewModel, String>((Ref ref, String classroomId) async {
      final ClassroomNowRemoteDataSource dataSource = ref.read(
        classroomNowRemoteDataSourceProvider,
      );
      final LectureOccurrenceMapper mapper = ref.read(
        lectureOccurrenceMapperProvider,
      );
      final ClassroomNowResponseDto? response = await dataSource.fetchCurrent(
        classroomId: classroomId,
      );
      if (response == null || response.isIdle || response.occurrence == null) {
        return const ClassroomNowViewModel(isInSession: false);
      }
      final LectureOccurrenceEntity entity = mapper.toEntity(
        response.occurrence!,
      );
      return ClassroomNowViewModel(
        isInSession: true,
        currentCourseName: entity.title,
        instructorName: entity.instructorName,
        startTime: entity.start,
        endTime: entity.end,
      );
    });

/// 헤더 타이틀 영역에 필요한 요약 정보만 추려내는 provider.
final classroomSummaryViewModelProvider = Provider.autoDispose
    .family<AsyncValue<ClassroomSummaryViewModel>, String>((
      Ref ref,
      String classroomId,
    ) {
      final AsyncValue<ClassroomDetailEntity> detail = ref.watch(
        classroomDetailInfoProvider(classroomId),
      );
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
    });

/// 헤더 장비 패널에서 초기 장비 목록을 그릴 때 사용하는 파생 provider.
final classroomDeviceCatalogProvider = Provider.autoDispose
    .family<AsyncValue<List<ClassroomDeviceViewModel>>, String>((
      Ref ref,
      String classroomId,
    ) {
      final AsyncValue<ClassroomDetailEntity> detail = ref.watch(
        classroomDetailInfoProvider(classroomId),
      );
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
    });
