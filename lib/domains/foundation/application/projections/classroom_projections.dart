/// ROLE
/// - 강의실 엔티티를 요약 뷰로 변환한다
///
/// RESPONSIBILITY
/// - classroom summary 투영을 제공한다
///
/// DEPENDS ON
/// - classroom_entity
/// - classroom_summary
/// - id_name_code
library;

import 'package:web_dashboard/common/models/id_name_code.dart';
import 'package:web_dashboard/domains/foundation/application/read_models/classroom_summary.dart';
import 'package:web_dashboard/domains/foundation/domain/entities/classroom_entity.dart';

extension ClassroomProjections on ClassroomEntity {
  ClassroomSummary toSummary() {
    return ClassroomSummary(
      id: id,
      name: name,
      code: code,
      building: building == null
          ? null
          : IdNameCode(
              id: building!.id,
              name: building!.name,
              code: building!.code,
            ),
      department: department == null
          ? null
          : IdNameCode(
              id: department!.id,
              name: department!.name,
              code: department!.code,
            ),
    );
  }
}
