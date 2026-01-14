/// ROLE
/// - 강의실 요약 읽기 모델을 정의한다
///
/// RESPONSIBILITY
/// - 대시보드용 요약 필드를 제공한다
/// - 연관 엔티티의 요약 정보를 보관한다
///
/// DEPENDS ON
/// - id_name_code
library;

import 'package:web_dashboard/common/models/id_name_code.dart';

class ClassroomSummary {
  const ClassroomSummary({
    required this.id,
    required this.name,
    this.code,
    this.building,
    this.department,
  });

  final String id;
  final String name;
  final String? code;
  final IdNameCode? building;
  final IdNameCode? department;
}
