import 'package:flutter_test/flutter_test.dart';
import 'package:web_dashboard/core/timetable/data/datasources/lecture_remote_data_source.dart';
import 'package:web_dashboard/core/timetable/data/dtos/lecture_dto.dart';
import 'package:web_dashboard/core/timetable/data/dtos/lecture_request_dtos.dart';
import 'package:web_dashboard/core/timetable/data/mappers/lecture_mapper.dart';
import 'package:web_dashboard/core/timetable/data/repositories/lecture_repository_impl.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_type.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_repository.dart';

void main() {
  late _FakeRemoteDataSource remote;
  const LectureMapper mapper = LectureMapper();
  late LectureRepositoryImpl repository;

  setUp(() {
    remote = _FakeRemoteDataSource();
    repository = LectureRepositoryImpl(
      remoteDataSource: remote,
      mapper: mapper,
    );
  });

  test('fetchLectures converts result to entities', () async {
    remote.fetchResult = <LectureDto>[
      LectureDto(
        id: '1',
        title: '강의 A',
        type: 'LECTURE',
        status: 'ACTIVE',
        classroomId: 'room-1',
        startTime: DateTime.utc(2025, 1, 1, 9),
        endTime: DateTime.utc(2025, 1, 1, 10),
        version: 1,
        createdAt: DateTime.utc(2025, 1, 1, 8),
        updatedAt: DateTime.utc(2025, 1, 1, 8),
      ),
    ];

    final List result = await repository.fetchLectures(
      LectureQuery(
        from: DateTime.utc(2025, 1, 1),
        to: DateTime.utc(2025, 1, 7),
        classroomId: 'room-1',
        timezone: 'Asia/Seoul',
        type: LectureType.lecture,
      ),
    );

    expect(remote.lastQuery?.type, 'LECTURE');
    expect(result.length, 1);
    expect(result.first.title, '강의 A');
  });

  test('createLecture forwards payload', () async {
    remote.singleResult = LectureDto(
      id: '55',
      title: '신규 강의',
      type: 'EVENT',
      status: 'ACTIVE',
      classroomId: 'room-1',
      startTime: DateTime.utc(2025, 1, 1, 9),
      endTime: DateTime.utc(2025, 1, 1, 10),
      version: 1,
      createdAt: DateTime.utc(2025, 1, 1, 8),
      updatedAt: DateTime.utc(2025, 1, 1, 8),
    );

    final entity = await repository.createLecture(
      LectureWriteInput(
        title: '신규 강의',
        type: LectureType.event,
        classroomId: 'room-1',
        start: DateTime.utc(2025, 1, 1, 9),
        end: DateTime.utc(2025, 1, 1, 10),
      ),
    );

    expect(remote.lastPayload?.title, '신규 강의');
    expect(entity.type, LectureType.event);
  });

  test('updateLecture builds UpdateLectureRequest', () async {
    remote.singleResult = LectureDto(
      id: '55',
      title: '수정 강의',
      type: 'LECTURE',
      status: 'ACTIVE',
      classroomId: 'room-1',
      startTime: DateTime.utc(2025, 1, 1, 9),
      endTime: DateTime.utc(2025, 1, 1, 10),
      version: 2,
      createdAt: DateTime.utc(2025, 1, 1, 8),
      updatedAt: DateTime.utc(2025, 1, 1, 8),
    );

    final entity = await repository.updateLecture(
      UpdateLectureInput(
        lectureId: '55',
        expectedVersion: 1,
        payload: LectureWriteInput(
          title: '수정 강의',
          type: LectureType.lecture,
          classroomId: 'room-1',
          start: DateTime.utc(2025, 1, 1, 9),
          end: DateTime.utc(2025, 1, 1, 10),
        ),
      ),
    );

    expect(remote.lastUpdate?.lectureId, '55');
    expect(remote.lastUpdate?.expectedVersion, 1);
    expect(entity.title, '수정 강의');
  });

  test('deleteLecture delegates to remote', () async {
    await repository.deleteLecture(
      const DeleteLectureInput(
        lectureId: '77',
        expectedVersion: 3,
      ),
    );

    expect(remote.lastDelete?.lectureId, '77');
    expect(remote.lastDelete?.expectedVersion, 3);
  });
}

class _FakeRemoteDataSource implements LectureRemoteDataSource {
  LectureQueryRequest? lastQuery;
  LecturePayloadDto? lastPayload;
  UpdateLectureRequest? lastUpdate;
  DeleteLectureRequest? lastDelete;
  List<LectureDto> fetchResult = <LectureDto>[];
  LectureDto? singleResult;

  @override
  Future<List<LectureDto>> fetchLectures(LectureQueryRequest request) async {
    lastQuery = request;
    return fetchResult;
  }

  @override
  Future<LectureDto> createLecture(LecturePayloadDto payload) async {
    lastPayload = payload;
    return singleResult ?? fetchResult.first;
  }

  @override
  Future<LectureDto> updateLecture(UpdateLectureRequest request) async {
    lastUpdate = request;
    return singleResult ?? fetchResult.first;
  }

  @override
  Future<void> deleteLecture(DeleteLectureRequest request) async {
    lastDelete = request;
  }
}
