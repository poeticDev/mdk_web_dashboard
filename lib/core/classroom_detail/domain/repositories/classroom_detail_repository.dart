import 'package:web_dashboard/core/classroom_detail/domain/entities/classroom_detail_entity.dart';

abstract class ClassroomDetailRepository {
  Future<ClassroomDetailEntity> fetchById(String classroomId);
}
