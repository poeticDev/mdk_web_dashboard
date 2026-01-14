/// ROLE
/// - 도메인 리포지토리 계약을 정의한다
///
/// RESPONSIBILITY
/// - Foundation 기준 강의실 목록 조회 인터페이스를 제공한다
///
/// DEPENDS ON
/// - foundation_classrooms_read_model
library;

import 'package:web_dashboard/domains/foundation/application/read_models/foundation_classrooms_read_model.dart';

abstract class FoundationClassroomsReadRepository {
  Future<FoundationClassroomsReadModel> fetchClassrooms(
    FoundationClassroomsQuery query,
  );
}
