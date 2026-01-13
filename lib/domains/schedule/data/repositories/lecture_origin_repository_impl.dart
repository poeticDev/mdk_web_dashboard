/// ROLE
/// - 리포지토리 구현체를 제공한다
///
/// RESPONSIBILITY
/// - 데이터 소스를 통해 데이터를 조회한다
/// - 도메인 모델로 변환한다
///
/// DEPENDS ON
/// - lecture_origin_remote_data_source
/// - lecture_request_dtos
/// - lecture_mapper
/// - lecture_entity
/// - lecture_origin_repository
library;

import 'package:web_dashboard/domains/schedule/data/datasources/lecture_origin_remote_data_source.dart';
import 'package:web_dashboard/domains/schedule/data/dtos/lecture_request_dtos.dart';
import 'package:web_dashboard/domains/schedule/data/mappers/lecture_mapper.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/domains/schedule/domain/repositories/lecture_origin_repository.dart';

/// Origin 레이어의 RemoteDataSource와 도메인 모델 사이를 연결하는 구현체.
class LectureOriginRepositoryImpl implements LectureOriginRepository {
  LectureOriginRepositoryImpl({
    required LectureOriginRemoteDataSource remoteDataSource,
    required LectureMapper mapper,
  })  : _remoteDataSource = remoteDataSource,
        _mapper = mapper;

  final LectureOriginRemoteDataSource _remoteDataSource;
  final LectureMapper _mapper;

  @override
  Future<List<LectureEntity>> fetchLectures(LectureOriginQuery query) async {
    final LectureOriginQueryRequest request = _mapper.toQueryRequest(query);
    final List<LectureEntity> entities =
        (await _remoteDataSource.fetchLectures(request))
            .map(_mapper.toEntity)
            .toList();
    return entities;
  }

  @override
  Future<LectureEntity> createLecture(LectureOriginWriteInput input) async {
    final LecturePayloadDto payload = _mapper.toPayload(input);
    final dto = await _remoteDataSource.createLecture(payload);
    return _mapper.toEntity(dto);
  }

  @override
  Future<LectureEntity> updateLecture(LectureOriginUpdateInput input) async {
    final UpdateLectureRequest request = _mapper.toUpdateRequest(input);
    final dto = await _remoteDataSource.updateLecture(request);
    return _mapper.toEntity(dto);
  }

  @override
  Future<void> deleteLecture(LectureOriginDeleteInput input) async {
    final DeleteLectureRequest request = _mapper.toDeleteRequest(input);
    await _remoteDataSource.deleteLecture(request);
  }
}
