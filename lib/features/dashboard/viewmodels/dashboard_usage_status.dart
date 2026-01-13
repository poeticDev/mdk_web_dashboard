/// ROLE
/// - 대시보드 사용 상태 enum을 정의한다
///
/// RESPONSIBILITY
/// - 사용 중/미사용/미연동 상태를 구분한다
///
/// DEPENDS ON
/// - 없음
library;

/// 대시보드 카드 사용 상태.
enum DashboardUsageStatus {
  inUse('inUse'),
  idle('idle'),
  unlinked('unlinked');

  const DashboardUsageStatus(this.value);

  final String value;
}
