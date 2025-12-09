import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:web_dashboard/core/auth/application/auth_controller.dart';
import 'package:web_dashboard/core/auth/domain/errors/auth_exception.dart';
import 'package:web_dashboard/routes/route_paths.dart';
import 'package:web_dashboard/ui/dashboard/dashboard_page.dart';
import 'package:web_dashboard/ui/classroom_detail/classroom_detail_page.dart';
import 'package:web_dashboard/ui/login/login_page.dart';

final Provider<GoRouter> appRouterProvider = Provider<GoRouter>((Ref ref) {
  final authState = ref.watch(authControllerProvider);
  return GoRouter(
    initialLocation: RoutePaths.login,
    routes: <RouteBase>[
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (BuildContext context, GoRouterState state) => LoginPage(
          isSessionExpired: state.uri.queryParameters['expired'] == 'true',
        ),
      ),
      GoRoute(
        path: RoutePaths.dashboard,
        name: RouteNames.dashboard,
        builder: (BuildContext context, GoRouterState state) =>
            const DashboardPage(),
      ),
      
      // 상세 강의실 화면: /dashboard/:roomId 형태로 룸 ID를 파라미터로 전달.
      GoRoute(
        path: RoutePaths.classroomDetail,
        name: RouteNames.classroomDetail,
        builder: (BuildContext context, GoRouterState state) {
          final String roomId = state.pathParameters['roomId']!;
          return ClassroomDetailPage(roomId: roomId);
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final bool isAuthenticated = authState.isAuthenticated;
      final bool loggingIn = state.matchedLocation == RoutePaths.login;
      if (!isAuthenticated) {
        if (loggingIn) {
          return null;
        }
        final bool needsExpiredFlag =
            authState.errorMessage == AuthException.sessionExpiredMessage;
        if (needsExpiredFlag) {
          return '${RoutePaths.login}?expired=true';
        }
        return RoutePaths.login;
      }
      if (loggingIn) {
        return RoutePaths.dashboard;
      }
      return null;
    },
  );
});
