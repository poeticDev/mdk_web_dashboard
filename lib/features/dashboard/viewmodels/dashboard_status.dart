/// ROLE
/// - 대시보드 상태 enum을 정의한다
///
/// RESPONSIBILITY
/// - 연동 상태/사용 상태를 분리한다
///
/// DEPENDS ON
/// - 없음
library;

/// 강의실 연동 상태.
enum DashboardLinkStatus {
  linked('linked'),
  unlinked('unlinked');

  const DashboardLinkStatus(this.value);

  final String value;
}

/// 강의실 사용 상태.
enum DashboardActivityStatus {
  inUse('inUse'),
  idle('idle');

  const DashboardActivityStatus(this.value);

  final String value;
}
