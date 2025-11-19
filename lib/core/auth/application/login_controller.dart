import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_dashboard/core/auth/application/auth_controller.dart';
import 'package:web_dashboard/core/auth/domain/errors/auth_exception.dart';
import 'package:web_dashboard/core/auth/domain/state/login_form_state.dart';
import 'package:web_dashboard/core/auth/domain/value_objects/login_credentials.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  LoginFormState build() => const LoginFormState();

  void updateUsername(String value) {
    state = state.copyWith(username: value, errorMessage: null);
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value, errorMessage: null);
  }

  Future<void> executeLogin() async {
    if (!state.canSubmit) {
      state = state.copyWith(errorMessage: '아이디와 비밀번호를 모두 입력하세요.');
      return;
    }
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    final LoginCredentials credentials = LoginCredentials(
      username: state.username.trim(),
      password: state.password,
    );
    try {
      await ref.read(authControllerProvider.notifier).login(credentials);
      state = state.copyWith(isSubmitting: false);
    } on AuthException catch (error) {
      state = state.copyWith(isSubmitting: false, errorMessage: error.message);
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: '로그인 중 오류가 발생했습니다.',
      );
    }
  }

  void resetForm() {
    state = const LoginFormState();
  }

  void showSessionExpiredMessage() {
    state = state.copyWith(
      errorMessage: AuthException.sessionExpiredMessage,
      isSubmitting: false,
    );
  }
}
