/// ROLE
/// - 로그인 이후 랜딩 흐름을 제어하는 컨트롤러
///
/// RESPONSIBILITY
/// - 강의실 목록을 조회하고 라우팅 결정을 갱신한다
/// - 진행 단계/메시지/오류 상태를 관리한다
///
/// DEPENDS ON
/// - riverpod_annotation
/// - auth_controller
/// - landing_state
/// - foundation_classrooms_read_repository
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_dashboard/domains/auth/application/auth_controller.dart';
import 'package:web_dashboard/domains/auth/domain/entities/auth_user.dart';
import 'package:web_dashboard/domains/foundation/application/read_models/foundation_classrooms_read_model.dart';
import 'package:web_dashboard/domains/foundation/domain/repositories/foundation_classrooms_read_repository.dart';
import 'package:web_dashboard/features/landing/application/landing_providers.dart';
import 'package:web_dashboard/features/landing/application/state/landing_state.dart';

part 'landing_controller.g.dart';

@riverpod
class LandingController extends _$LandingController {
  static const String _messageCheckingSession = '세션 확인 중...';
  static const String _messageLoadingClassrooms = '강의실 정보를 불러오는 중...';
  static const String _messageDecidingRoute = '이동 경로를 준비 중...';
  static const String _errorMissingUser = '로그인 정보가 없습니다.';
  static const String _errorMissingFoundation = '기본 foundation 정보를 찾을 수 없습니다.';
  static const String _errorLoadingClassrooms = '강의실 목록을 불러오지 못했습니다.';
  static const String _errorEmptyClassrooms = '등록된 강의실이 없습니다.';

  static const List<FoundationType> _defaultPriority =
      <FoundationType>[FoundationType.department, FoundationType.site];

  bool _hasInitialized = false;

  @override
  LandingState build() => LandingState.initial().copyWith(
        step: LandingStep.checkingSession,
        message: _messageCheckingSession,
      );

  Future<void> initialize() async {
    if (!_markInitialized()) {
      return;
    }
    final AuthUser? user = ref.read(authControllerProvider).currentUser;
    if (user == null) {
      _setError(_errorMissingUser);
      return;
    }
    final FoundationSelection? selection = _resolveSelection(user);
    if (selection == null) {
      _setError(_errorMissingFoundation);
      return;
    }
    await _loadClassrooms(selection);
  }

  void executeRetry() {
    _hasInitialized = false;
    state = LandingState.initial().copyWith(
      step: LandingStep.checkingSession,
      message: _messageCheckingSession,
      errorMessage: null,
      nextRoute: null,
    );
    initialize();
  }

  void clearNextRoute() {
    if (state.nextRoute == null) {
      return;
    }
    state = state.copyWith(nextRoute: null);
  }

  bool _markInitialized() {
    if (_hasInitialized) {
      return false;
    }
    _hasInitialized = true;
    return true;
  }

  Future<void> _loadClassrooms(FoundationSelection selection) async {
    _updateStep(LandingStep.loadingClassrooms, _messageLoadingClassrooms);
    try {
      final FoundationClassroomsReadRepository repository =
          ref.read(landingFoundationClassroomsReadRepositoryProvider);
      final FoundationClassroomsReadModel response =
          await repository.fetchClassrooms(
        FoundationClassroomsQuery(
          type: selection.type,
          foundationId: selection.foundationId,
        ),
      );
      final LandingRoute nextRoute = _resolveNextRoute(response);
      state = state.copyWith(
        step: LandingStep.decidingRoute,
        message: _messageDecidingRoute,
        nextRoute: nextRoute,
        errorMessage: null,
      );
    } catch (_) {
      _setError(_errorLoadingClassrooms);
    }
  }

  LandingRoute _resolveNextRoute(FoundationClassroomsReadModel response) {
    if (response.classrooms.isEmpty) {
      _setError(_errorEmptyClassrooms);
      return const LandingRoute.dashboard();
    }
    if (response.classrooms.length == 1) {
      return LandingRoute.classroomDetail(
        classroomId: response.classrooms.first.id,
      );
    }
    return const LandingRoute.dashboard();
  }

  FoundationSelection? _resolveSelection(AuthUser user) {
    for (final FoundationType type in _defaultPriority) {
      final String? foundationId = _extractFoundationId(user, type);
      if (foundationId != null && foundationId.isNotEmpty) {
        return FoundationSelection(type: type, foundationId: foundationId);
      }
    }
    return null;
  }

  String? _extractFoundationId(AuthUser user, FoundationType type) {
    switch (type) {
      case FoundationType.department:
        return user.departmentId;
      case FoundationType.site:
        return user.siteId;
      case FoundationType.building:
        return user.buildingId;
    }
  }

  void _updateStep(LandingStep step, String message) {
    state = state.copyWith(
      step: step,
      message: message,
      errorMessage: null,
    );
  }

  void _setError(String message) {
    state = state.copyWith(
      step: LandingStep.error,
      message: null,
      errorMessage: message,
      nextRoute: null,
    );
  }
}

class FoundationSelection {
  const FoundationSelection({
    required this.type,
    required this.foundationId,
  });

  final FoundationType type;
  final String foundationId;
}
