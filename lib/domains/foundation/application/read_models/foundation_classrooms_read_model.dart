/// ROLE
/// - Foundation 기준 강의실 읽기 모델을 정의한다
///
/// RESPONSIBILITY
/// - Foundation 요약 정보와 강의실 목록을 보관한다
/// - 조회 타입과 입력 파라미터를 제공한다
///
/// DEPENDS ON
/// - id_name_code
/// - classroom_summary
library;

import 'package:web_dashboard/common/models/id_name_code.dart';
import 'package:web_dashboard/domains/foundation/application/read_models/classroom_summary.dart';

/// Foundation 조회 타입.
enum FoundationType {
  site('site'),
  building('building'),
  department('department');

  const FoundationType(this.apiValue);

  final String apiValue;

  static FoundationType fromApi(String value) {
    switch (value.toLowerCase()) {
      case 'building':
        return FoundationType.building;
      case 'department':
        return FoundationType.department;
      case 'site':
      default:
        return FoundationType.site;
    }
  }
}

/// Foundation 요약 정보 읽기 모델.
class FoundationSummaryReadModel {
  const FoundationSummaryReadModel({
    required this.type,
    required this.summary,
  });

  final FoundationType type;
  final IdNameCode summary;
}

/// Foundation 기준 강의실 목록 읽기 모델.
class FoundationClassroomsReadModel {
  const FoundationClassroomsReadModel({
    required this.foundation,
    required this.classrooms,
    required this.count,
  });

  final FoundationSummaryReadModel foundation;
  final List<ClassroomSummary> classrooms;
  final int count;
}

/// Foundation 기준 강의실 조회 입력 값.
class FoundationClassroomsQuery {
  const FoundationClassroomsQuery({
    required this.type,
    required this.foundationId,
  });

  final FoundationType type;
  final String foundationId;
}
