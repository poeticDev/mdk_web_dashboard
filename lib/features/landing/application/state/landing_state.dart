/// ROLE
/// - 로그인 이후 랜딩 상태 모델을 정의한다
///
/// RESPONSIBILITY
/// - 진행 단계/메시지/오류 상태를 보관한다
/// - 다음 라우팅 결정을 표현한다
///
/// DEPENDS ON
/// - freezed_annotation
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'landing_state.freezed.dart';

enum LandingStep {
  checkingSession,
  loadingClassrooms,
  decidingRoute,
  error,
}

@freezed
abstract class LandingRoute with _$LandingRoute {
  const factory LandingRoute.dashboard() = _LandingRouteDashboard;
  const factory LandingRoute.classroomDetail({
    required String classroomId,
  }) = _LandingRouteClassroomDetail;
}

@freezed
abstract class LandingState with _$LandingState {
  const LandingState._();

  const factory LandingState({
    @Default(LandingStep.checkingSession) LandingStep step,
    String? message,
    String? errorMessage,
    LandingRoute? nextRoute,
  }) = _LandingState;

  factory LandingState.initial() => const LandingState();

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}
