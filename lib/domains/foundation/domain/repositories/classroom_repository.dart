/// ROLE
/// - 도메인 리포지토리 계약을 정의한다
///
/// RESPONSIBILITY
/// - 데이터 접근 인터페이스를 제공한다
///
/// DEPENDS ON
/// - classroom_entity
library;

import 'package:web_dashboard/domains/foundation/domain/entities/classroom_entity.dart';

/// 강의실 기본 정보를 조회하는 계약.
abstract class ClassroomRepository {
  Future<ClassroomEntity> fetchById(String classroomId);
}
