/// ROLE
/// - 리포지토리 구현체를 제공한다
///
/// RESPONSIBILITY
/// - 데이터 소스를 통해 데이터를 조회한다
/// - 도메인 모델로 변환한다
///
/// DEPENDS ON
/// - foundation_classrooms_remote_data_source
/// - foundation_classrooms_request
/// - foundation_classrooms_mapper
/// - foundation_classrooms_entity
library;

import 'package:web_dashboard/domains/foundation/data/datasources/foundation_classrooms_remote_data_source.dart';
import 'package:web_dashboard/domains/foundation/data/dtos/foundation_classrooms_dto.dart';
import 'package:web_dashboard/domains/foundation/data/dtos/foundation_classrooms_request.dart';
import 'package:web_dashboard/domains/foundation/data/mappers/foundation_classrooms_mapper.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/foundation_classrooms_entity.dart';
import 'package:web_dashboard/domains/foundation/domain/repositories/foundation_classrooms_repository.dart';

class FoundationClassroomsRepositoryImpl
    implements FoundationClassroomsRepository {
  FoundationClassroomsRepositoryImpl({
    required FoundationClassroomsRemoteDataSource remoteDataSource,
    required FoundationClassroomsMapper mapper,
  })  : _remoteDataSource = remoteDataSource,
        _mapper = mapper;

  final FoundationClassroomsRemoteDataSource _remoteDataSource;
  final FoundationClassroomsMapper _mapper;

  @override
  Future<FoundationClassroomsEntity> fetchClassrooms(
    FoundationClassroomsQuery query,
  ) async {
    final FoundationClassroomsRequest request = FoundationClassroomsRequest(
      foundationType: query.type.apiValue,
      foundationId: query.foundationId,
    );
    final FoundationClassroomsResponseDto dto =
        await _remoteDataSource.fetchClassrooms(request);
    return _mapper.toEntity(dto);
  }
}
