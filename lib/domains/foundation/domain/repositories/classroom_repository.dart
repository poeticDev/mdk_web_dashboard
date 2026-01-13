import 'package:web_dashboard/domains/foundation/domain/entities/classroom_entity.dart';

/// 강의실 기본 정보를 조회하는 계약.
abstract class ClassroomRepository {
  Future<ClassroomEntity> fetchById(String classroomId);
}
