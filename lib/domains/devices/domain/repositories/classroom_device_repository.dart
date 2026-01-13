/// ROLE
/// - 도메인 리포지토리 계약을 정의한다
///
/// RESPONSIBILITY
/// - 데이터 접근 인터페이스를 제공한다
///
/// DEPENDS ON
/// - device_entity
library;

import 'package:web_dashboard/domains/devices/domain/entities/device_entity.dart';

/// 강의실별 장비 목록 조회 계약.
abstract class ClassroomDeviceRepository {
  Future<List<DeviceEntity>> fetchDevices(String classroomId);
}
