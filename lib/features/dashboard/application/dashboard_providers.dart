/// ROLE
/// - 대시보드 provider 모음을 제공한다
///
/// RESPONSIBILITY
/// - 매퍼/컨트롤러 의존성을 주입한다
///
/// DEPENDS ON
/// - riverpod_annotation
/// - dashboard_sse_mapper
/// - foundation_classrooms_repository
/// - room_state_sse_remote_data_source
/// - occurrence_now_sse_remote_data_source
/// - service_locator
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_dashboard/di/service_locator.dart';
import 'package:web_dashboard/domains/foundation/domain/repositories/foundation_classrooms_repository.dart';
import 'package:web_dashboard/domains/realtime/data/datasources/occurrence_now_sse_remote_data_source.dart';
import 'package:web_dashboard/domains/realtime/data/datasources/room_state_sse_remote_data_source.dart';
import 'package:web_dashboard/features/dashboard/application/mappers/dashboard_sse_mapper.dart';

part 'dashboard_providers.g.dart';

@riverpod
DashboardSseMapper dashboardSseMapper(Ref ref) {
  return const DashboardSseMapper();
}

@riverpod
FoundationClassroomsRepository foundationClassroomsRepository(Ref ref) {
  return di<FoundationClassroomsRepository>();
}

@riverpod
RoomStateSseRemoteDataSource roomStateSseRemoteDataSource(Ref ref) {
  return di<RoomStateSseRemoteDataSource>();
}

@riverpod
OccurrenceNowSseRemoteDataSource occurrenceNowSseRemoteDataSource(Ref ref) {
  return di<OccurrenceNowSseRemoteDataSource>();
}
