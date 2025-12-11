import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'route_paths.dart';

/// 앱 라우트별 메타데이터를 정의해 AppBar 등에서 재사용한다.
enum AppPageMeta {
  login(
    routeName: RouteNames.login,
    title: '로그인',
    showBackButton: false,
    showUserBanner: false,
    showThemeToggle: false,
  ),
  dashboard(routeName: RouteNames.dashboard, title: '대시보드'),
  classroomDetail(routeName: RouteNames.classroomDetail, title: '강의실 상세');

  const AppPageMeta({
    required this.routeName,
    required this.title,
    this.showBackButton = true,
    this.showThemeToggle = true,
    this.showUserBanner = true,
  });

  final String routeName;
  final String title;
  final bool showBackButton;
  final bool showThemeToggle;
  final bool showUserBanner;

  static AppPageMeta? maybeOfRoute(String? routeName) {
    if (routeName == null) {
      return null;
    }
    return AppPageMeta.values.firstWhere(
      (AppPageMeta meta) => meta.routeName == routeName,
      orElse: () => AppPageMeta.dashboard,
    );
  }
}

/// 현재 GoRouterState 또는 BuildContext에서 페이지 메타를 조회하는 헬퍼.
AppPageMeta resolvePageMeta({GoRouterState? state, BuildContext? context}) {
  if (state != null) {
    return AppPageMeta.maybeOfRoute(state.name) ?? AppPageMeta.dashboard;
  }
  if (context != null) {
    try {
      final GoRouterState derivedState = GoRouterState.of(context);
      return AppPageMeta.maybeOfRoute(derivedState.name) ??
          AppPageMeta.dashboard;
    } on GoError {
      // ignore and fall through to default below
    }
  }
  return AppPageMeta.dashboard;
}
