import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/domains/auth/application/auth_controller.dart';
import 'package:web_dashboard/domains/auth/application/login_controller.dart';
import 'package:web_dashboard/domains/auth/domain/errors/auth_exception.dart';
import 'package:web_dashboard/domains/auth/domain/state/auth_state.dart';
import 'package:web_dashboard/domains/auth/domain/state/login_form_state.dart';
import 'package:web_dashboard/domains/auth/domain/value_objects/login_credentials.dart';

void main() {
  group('LoginController', () {
    test('updateUsername and updatePassword should mutate state inputs', () {
      // Arrange
      final ProviderContainer container = _createLoginContainer();
      addTearDown(container.dispose);
      final LoginController controller = container.read(
        loginControllerProvider.notifier,
      );

      // Act
      controller.updateUsername('mdk');
      controller.updatePassword('12344321!');

      // Assert
      final LoginFormState actualState = container.read(
        loginControllerProvider,
      );
      expect(actualState.username, 'mdk');
      expect(actualState.password, '12344321!');
    });

    test(
      'executeLogin should show validation error when inputs are empty',
      () async {
        // Arrange
        final ProviderContainer container = _createLoginContainer();
        addTearDown(container.dispose);
        final LoginController controller = container.read(
          loginControllerProvider.notifier,
        );

        // Act
        await controller.executeLogin();

        // Assert
        final LoginFormState actualState = container.read(
          loginControllerProvider,
        );
        expect(actualState.errorMessage, '아이디와 비밀번호를 모두 입력하세요.');
        expect(actualState.isSubmitting, false);
      },
    );

    test(
      'executeLogin should call auth controller login and reset submitting state',
      () async {
        // Arrange
        bool wasCalled = false;
        final ProviderContainer container = _createLoginContainer(
          onLogin: (LoginCredentials inputCredentials) async {
            wasCalled = true;
            expect(inputCredentials.username, 'mdk');
            expect(inputCredentials.password, '12344321!');
          },
        );
        addTearDown(container.dispose);
        final LoginController controller = container.read(
          loginControllerProvider.notifier,
        );
        controller.updateUsername('mdk');
        controller.updatePassword('12344321!');

        // Act
        await controller.executeLogin();

        // Assert
        final LoginFormState actualState = container.read(
          loginControllerProvider,
        );
        expect(actualState.isSubmitting, false);
        expect(actualState.errorMessage, isNull);
        expect(wasCalled, isTrue);
      },
    );

    test('executeLogin should surface AuthException message', () async {
      // Arrange
      final ProviderContainer container = _createLoginContainer(
        onLoginThrow: AuthException.invalidCredentials,
      );
      addTearDown(container.dispose);
      final LoginController controller = container.read(
        loginControllerProvider.notifier,
      );
      controller.updateUsername('wrong');
      controller.updatePassword('creds');

      // Act
      await controller.executeLogin();

      // Assert
      final LoginFormState actualState = container.read(
        loginControllerProvider,
      );
      expect(actualState.errorMessage, '아이디 또는 비밀번호가 올바르지 않습니다.');
      expect(actualState.isSubmitting, false);
    });
  });
}

ProviderContainer _createLoginContainer({
  Future<void> Function(LoginCredentials)? onLogin,
  AuthException Function()? onLoginThrow,
}) {
  return ProviderContainer(
    overrides: [
      authControllerProvider.overrideWith(
        () => _StubAuthController(onLogin: onLogin, onLoginThrow: onLoginThrow),
      ),
    ],
  );
}

class _StubAuthController extends AuthController {
  _StubAuthController({this.onLogin, this.onLoginThrow});

  final Future<void> Function(LoginCredentials)? onLogin;
  final AuthException Function()? onLoginThrow;

  @override
  AuthState build() => const AuthState();

  @override
  Future<void> login(LoginCredentials credentials) async {
    if (onLoginThrow != null) {
      throw onLoginThrow!();
    }
    await onLogin?.call(credentials);
  }
}
