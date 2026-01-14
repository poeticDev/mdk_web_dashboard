/// ROLE
/// - 도메인 리포지토리 계약을 정의한다
///
/// RESPONSIBILITY
/// - Foundation 기준 강의실 목록 조회 인터페이스를 제공한다
///
/// DEPENDS ON
/// - foundation_classrooms_entity
library;

import 'package:web_dashboard/domains/foundation/domain/entities/foundation_classrooms_entity.dart';

abstract class FoundationClassroomsRepository {
  Future<FoundationClassroomsEntity> fetchClassrooms(
    FoundationClassroomsQuery query,
  );
}
