/// ROLE
/// - 강의실 상세에서 사용하는 provider 모음을 제공한다
///
/// RESPONSIBILITY
/// - 실시간 강의 데이터 소스를 주입한다
///
/// DEPENDS ON
/// - riverpod_annotation
/// - occurrence_now_sse_remote_data_source
/// - service_locator
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'package:web_dashboard/common/network/sse_client.dart';
import 'package:web_dashboard/di/service_locator.dart';
import 'package:web_dashboard/domains/realtime/data/datasources/occurrence_now_sse_remote_data_source.dart';

part 'classroom_now_providers.g.dart';

@riverpod
OccurrenceNowSseRemoteDataSource classroomOccurrenceNowSseRemoteDataSource(
  Ref ref,
) {
  return OccurrenceNowSseRemoteDataSourceImpl(
    dio: di<Dio>(),
    sseClient: createSseClient(),
  );
}
