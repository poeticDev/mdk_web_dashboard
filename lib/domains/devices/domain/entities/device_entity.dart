/// ROLE
/// - 도메인 엔티티를 정의한다
///
/// RESPONSIBILITY
/// - 핵심 필드를 보관한다
/// - 도메인 모델을 제공한다
///
/// DEPENDS ON
/// - 없음
library;

/// 강의실에 배치된 장비 정보를 표현하는 엔티티.
class DeviceEntity {
  const DeviceEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.isEnabled,
    this.manufacturer,
    this.model,
    this.serialNumber,
    this.ipAddress,
    this.port,
    this.protocol,
    this.address,
  });

  final String id;
  final String name;
  final String type;
  final bool isEnabled;
  final String? manufacturer;
  final String? model;
  final String? serialNumber;
  final String? ipAddress;
  final int? port;
  final String? protocol;
  final String? address;
}
