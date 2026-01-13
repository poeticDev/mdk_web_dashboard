import 'package:web_dashboard/domains/devices/domain/entities/device_entity.dart';

/// 강의실별 장비 목록 조회 계약.
abstract class ClassroomDeviceRepository {
  Future<List<DeviceEntity>> fetchDevices(String classroomId);
}
