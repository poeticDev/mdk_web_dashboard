import 'package:web_dashboard/core/timetable/data/datasources/lecture_remote_data_source.dart';
import 'package:web_dashboard/core/timetable/data/dtos/lecture_request_dtos.dart';
import 'package:web_dashboard/core/timetable/data/mappers/lecture_mapper.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_repository.dart';

/// RemoteDataSource와 도메인 모델 사이를 연결하는 구현체.
class LectureRepositoryImpl implements LectureRepository {
  LectureRepositoryImpl({
    required LectureRemoteDataSource remoteDataSource,
    required LectureMapper mapper,
  })  : _remoteDataSource = remoteDataSource,
        _mapper = mapper;

  final LectureRemoteDataSource _remoteDataSource;
  final LectureMapper _mapper;

  @override
  Future<List<LectureEntity>> fetchLectures(LectureQuery query) async {
    final LectureQueryRequest request = _mapper.toQueryRequest(query);
    final List<LectureEntity> entities = (await _remoteDataSource
            .fetchLectures(request))
        .map(_mapper.toEntity)
        .toList();
    return entities;
  }

  @override
  Future<LectureEntity> createLecture(LectureWriteInput input) async {
    final LecturePayloadDto payload = _mapper.toPayload(input);
    final dto = await _remoteDataSource.createLecture(payload);
    return _mapper.toEntity(dto);
  }

  @override
  Future<LectureEntity> updateLecture(UpdateLectureInput input) async {
    final UpdateLectureRequest request = _mapper.toUpdateRequest(input);
    final dto = await _remoteDataSource.updateLecture(request);
    return _mapper.toEntity(dto);
  }

  @override
  Future<void> deleteLecture(DeleteLectureInput input) async {
    final DeleteLectureRequest request = _mapper.toDeleteRequest(input);
    await _remoteDataSource.deleteLecture(request);
  }
}
