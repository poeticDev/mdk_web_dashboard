import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_dashboard/domains/auth/application/auth_providers.dart';
import 'package:web_dashboard/domains/auth/domain/entities/auth_user.dart';
import 'package:web_dashboard/domains/auth/domain/errors/auth_exception.dart';
import 'package:web_dashboard/domains/auth/domain/state/auth_state.dart';
import 'package:web_dashboard/domains/auth/domain/value_objects/login_credentials.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  AuthState build() => AuthState.initial();

  Future<void> loadCurrentUser() async {
    state = state.copyWith(isLoadingMe: true, errorMessage: null);
    try {
      final AuthUser? user = await ref
          .watch(authRepositoryProvider)
          .fetchCurrentUser();
      state = state.copyWith(
        currentUser: user,
        isAuthenticated: user != null,
        isLoadingMe: false,
      );
    } on AuthException catch (error) {
      if (error.code == 'session_expired') {
        handleSessionExpired();
        return;
      }
      state = state.copyWith(
        isLoadingMe: false,
        errorMessage: error.message,
        currentUser: null,
        isAuthenticated: false,
      );
    } catch (_) {
      state = state.copyWith(
        isLoadingMe: false,
        errorMessage: '사용자 정보를 불러오지 못했습니다.',
        currentUser: null,
        isAuthenticated: false,
      );
    }
  }

  Future<void> login(LoginCredentials credentials) async {
    state = state.copyWith(errorMessage: null);
    try {
      final AuthUser user = await ref
          .watch(authRepositoryProvider)
          .login(credentials);
      state = state.copyWith(
        currentUser: user,
        isAuthenticated: true,
        errorMessage: null,
      );
    } on AuthException catch (error) {
      state = state.copyWith(
        currentUser: null,
        isAuthenticated: false,
        errorMessage: error.message,
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    await ref.watch(authRepositoryProvider).logout();
    state = AuthState.initial();
  }

  void handleSessionExpired() {
    state = state.copyWith(
      currentUser: null,
      isAuthenticated: false,
      errorMessage: AuthException.sessionExpiredMessage,
      isLoadingMe: false,
    );
  }
}
