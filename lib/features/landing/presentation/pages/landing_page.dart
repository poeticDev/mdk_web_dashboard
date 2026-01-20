/// ROLE
/// - 로그인 이후 초기 라우팅을 담당하는 랜딩 화면을 제공한다
///
/// RESPONSIBILITY
/// - 강의실 목록 조회 진행 상태를 표시한다
/// - 결과에 따라 대시보드/상세 화면으로 이동한다
///
/// DEPENDS ON
/// - flutter/material
/// - flutter_riverpod
/// - go_router
/// - landing_controller
/// - landing_state
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:web_dashboard/features/landing/application/landing_controller.dart';
import 'package:web_dashboard/features/landing/application/state/landing_state.dart';
import 'package:web_dashboard/routes/route_paths.dart';

const double _contentSpacing = 12;
const double _loaderSize = 32;

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(landingControllerProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final LandingState state = ref.watch(landingControllerProvider);
    _handleNavigation(context, state);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: _loaderSize,
                height: _loaderSize,
                child: const CircularProgressIndicator(),
              ),
              const SizedBox(height: _contentSpacing),
              Text(
                state.hasError ? '처리 중 오류가 발생했습니다.' : _resolveMessage(state),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (state.hasError) ...<Widget>[
                const SizedBox(height: _contentSpacing),
                Text(
                  state.errorMessage ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: _contentSpacing),
                OutlinedButton(
                  onPressed: () {
                    _hasNavigated = false;
                    ref.read(landingControllerProvider.notifier).initialize();
                  },
                  child: const Text('다시 시도'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _resolveMessage(LandingState state) {
    if (state.message != null && state.message!.isNotEmpty) {
      return state.message!;
    }
    switch (state.step) {
      case LandingStep.checkingSession:
        return '세션을 확인하고 있습니다.';
      case LandingStep.loadingClassrooms:
        return '강의실 목록을 불러오는 중입니다.';
      case LandingStep.decidingRoute:
        return '화면을 준비하고 있습니다.';
      case LandingStep.error:
        return '오류가 발생했습니다.';
    }
  }

  void _handleNavigation(BuildContext context, LandingState state) {
    if (_hasNavigated || state.nextRoute == null || state.hasError) {
      return;
    }
    _hasNavigated = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final LandingRoute route = state.nextRoute!;
      route.when(
        dashboard: () => context.goNamed(RouteNames.dashboard),
        classroomDetail: (String classroomId) => context.goNamed(
          RouteNames.classroomDetail,
          pathParameters: <String, String>{'roomId': classroomId},
        ),
      );
    });
  }
}
