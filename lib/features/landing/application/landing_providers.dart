/// ROLE
/// - 랜딩 기능에서 사용하는 provider 모음을 제공한다
///
/// RESPONSIBILITY
/// - 강의실 조회 리포지토리 의존성을 주입한다
///
/// DEPENDS ON
/// - riverpod_annotation
/// - foundation_classrooms_read_repository
/// - service_locator
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_dashboard/di/service_locator.dart';
import 'package:web_dashboard/domains/foundation/domain/repositories/foundation_classrooms_read_repository.dart';

part 'landing_providers.g.dart';

@riverpod
FoundationClassroomsReadRepository landingFoundationClassroomsReadRepository(
  Ref ref,
) {
  return di<FoundationClassroomsReadRepository>();
}
