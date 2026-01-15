/// ROLE
/// - 대시보드 헤더 레이아웃 상수를 정의한다
///
/// RESPONSIBILITY
/// - 헤더 구성 요소의 크기/간격을 표준화한다
///
/// DEPENDS ON
/// - 없음
library;

const double headerGap = 16;
const double metricMinWidth = 180;
const double searchMinWidth = metricMinWidth;
const double searchMaxWidth = 240;
const double clockMinWidth = 320;
const double headerCardRadius = 18;
const double headerCardPadding = 18;
const Duration clockTick = Duration(seconds: 1);
const Duration kstOffset = Duration(hours: 9);
