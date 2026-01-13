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
