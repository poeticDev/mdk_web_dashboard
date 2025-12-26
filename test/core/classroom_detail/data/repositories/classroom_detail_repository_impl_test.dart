import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_dashboard/core/classroom_detail/data/datasources/classroom_detail_remote_data_source.dart';
import 'package:web_dashboard/core/classroom_detail/data/dtos/classroom_detail_dto.dart';
import 'package:web_dashboard/core/classroom_detail/data/mappers/classroom_detail_mapper.dart';
import 'package:web_dashboard/core/classroom_detail/data/repositories/classroom_detail_repository_impl.dart';
import 'package:web_dashboard/core/classroom_detail/domain/entities/classroom_detail_entity.dart';

void main() {
  late _FakeRemoteDataSource remoteDataSource;
  const ClassroomDetailMapper mapper = ClassroomDetailMapper();
  late _TestClock clock;
  late ClassroomDetailRepositoryImpl repository;

  setUp(() {
    remoteDataSource = _FakeRemoteDataSource();
    clock = _TestClock();
    repository = ClassroomDetailRepositoryImpl(
      remoteDataSource: remoteDataSource,
      mapper: mapper,
      cacheTtl: const Duration(minutes: 1),
      clock: clock.now,
    );
  });

  test('fetchById returns mapped entity from remote', () async {
    remoteDataSource.nextResponse = _buildDto(id: 'room-1');

    final ClassroomDetailEntity actual =
        await repository.fetchById('room-1');

    expect(actual.id, 'room-1');
    expect(actual.name, '공학관 A101');
    expect(actual.devices.length, 1);
    expect(remoteDataSource.fetchCount, 1);
  });

  test('fetchById reuses cached value within TTL', () async {
    remoteDataSource.nextResponse = _buildDto(id: 'room-cache');

    await repository.fetchById('room-cache');
    await repository.fetchById('room-cache');

    expect(remoteDataSource.fetchCount, 1);
  });

  test('fetchById re-fetches after cache expires', () async {
    repository = ClassroomDetailRepositoryImpl(
      remoteDataSource: remoteDataSource,
      mapper: mapper,
      cacheTtl: const Duration(seconds: 10),
      clock: clock.now,
    );
    remoteDataSource.nextResponse = _buildDto(id: 'room-refresh');

    await repository.fetchById('room-refresh');
    clock.advance(const Duration(seconds: 11));
    await repository.fetchById('room-refresh');

    expect(remoteDataSource.fetchCount, 2);
  });

  test('fetchById throws not found for 404', () async {
    remoteDataSource.error = DioException(
      requestOptions: RequestOptions(path: '/classrooms/room-missing'),
      response: Response<dynamic>(
        statusCode: 404,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    expect(
      () => repository.fetchById('room-missing'),
      throwsA(isA<ClassroomDetailNotFoundException>()),
    );
  });

  test('fetchById wraps format issues as unexpected', () async {
    remoteDataSource.nextResponse = _buildDto(id: 'room-type', type: 'unknown');

    expect(
      () => repository.fetchById('room-type'),
      throwsA(isA<ClassroomDetailUnexpectedException>()),
    );
  });
}

class _FakeRemoteDataSource implements ClassroomDetailRemoteDataSource {
  ClassroomDetailResponseDto? nextResponse;
  Object? error;
  int fetchCount = 0;

  @override
  Future<ClassroomDetailResponseDto> fetchDetail(String classroomId) async {
    fetchCount++;
    if (error != null) {
      throw error!;
    }
    return nextResponse ?? _buildDto(id: classroomId);
  }

  @override
  Future<List<ClassroomDetailResponseDto>> fetchBatch(
    List<String> classroomIds,
  ) async {
    return classroomIds
        .map((String classroomId) => _buildDto(id: classroomId))
        .toList();
  }
}

class _TestClock {
  DateTime _value = DateTime.utc(2025, 1, 1, 9);

  DateTime now() => _value;

  void advance(Duration delta) {
    _value = _value.add(delta);
  }
}

ClassroomDetailResponseDto _buildDto({
  required String id,
  String type = 'hyflex',
}) {
  return ClassroomDetailResponseDto(
    id: id,
    name: '공학관 A101',
    code: 'A101',
    floor: 1,
    capacity: 40,
    type: type,
    building: const BuildingDto(id: 'b-1', name: '공학관', code: 'ENG'),
    department: const DepartmentDto(id: 'd-1', name: '스마트보안학과'),
    devices: const <ClassroomDeviceDto>[
      ClassroomDeviceDto(
        id: 'device-1',
        name: '조명',
        type: 'lighting',
        isEnabled: true,
      ),
    ],
    config: const ClassroomConfigDto(
      autoPowerOnLecture: true,
      autoPowerOnTime: '07:30',
      autoPowerOffTime: '21:30',
    ),
  );
}
