/// ROLE
/// - 대시보드 provider 모음을 제공한다
///
/// RESPONSIBILITY
/// - 매퍼/컨트롤러 의존성을 주입한다
///
/// DEPENDS ON
/// - riverpod_annotation
/// - dashboard_sse_mapper
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_dashboard/features/dashboard/application/mappers/dashboard_sse_mapper.dart';

part 'dashboard_providers.g.dart';

@riverpod
DashboardSseMapper dashboardSseMapper(Ref ref) {
  return const DashboardSseMapper();
}
