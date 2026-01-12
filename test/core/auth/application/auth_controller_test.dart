import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/domains/auth/application/auth_controller.dart';
import 'package:web_dashboard/domains/auth/application/auth_providers.dart';
import 'package:web_dashboard/domains/auth/domain/entities/auth_user.dart';
import 'package:web_dashboard/domains/auth/domain/errors/auth_exception.dart';
import 'package:web_dashboard/domains/auth/domain/repositories/auth_repository.dart';
import 'package:web_dashboard/domains/auth/domain/state/auth_state.dart';
import 'package:web_dashboard/domains/auth/domain/value_objects/login_credentials.dart';

void main() {
  group('AuthController', () {
    const AuthUser expectedUser = AuthUser(id: '1', username: 'mdk');

    test(
      'loadCurrentUser sets authenticated state when repository returns user',
      () async {
        // Arrange
        final ProviderContainer container = _createAuthContainer(
          fetchHandler: () async => expectedUser,
        );
        addTearDown(container.dispose);
        final AuthController controller = container.read(
          authControllerProvider.notifier,
        );

        // Act
        await controller.loadCurrentUser();

        // Assert
        final AuthState actualState = container.read(authControllerProvider);
        expect(actualState.isAuthenticated, isTrue);
        expect(actualState.currentUser, expectedUser);
        expect(actualState.isLoadingMe, isFalse);
      },
    );

    test('loadCurrentUser resets state when session expired', () async {
      // Arrange
      final ProviderContainer container = _createAuthContainer(
        fetchHandler: () =>
            Future<AuthUser?>.error(AuthException.sessionExpired()),
      );
      addTearDown(container.dispose);
      final AuthController controller = container.read(
        authControllerProvider.notifier,
      );

      // Act
      await controller.loadCurrentUser();

      // Assert
      final AuthState actualState = container.read(authControllerProvider);
      expect(actualState.isAuthenticated, isFalse);
      expect(actualState.errorMessage, AuthException.sessionExpiredMessage);
      expect(actualState.currentUser, isNull);
    });

    test('login updates current user when repository succeeds', () async {
      // Arrange
      final ProviderContainer container = _createAuthContainer(
        loginHandler: (LoginCredentials inputCredentials) async {
          expect(inputCredentials.username, 'mdk');
          expect(inputCredentials.password, '12344321!');
          return expectedUser;
        },
      );
      addTearDown(container.dispose);
      final AuthController controller = container.read(
        authControllerProvider.notifier,
      );

      // Act
      await controller.login(
        const LoginCredentials(username: 'mdk', password: '12344321!'),
      );

      // Assert
      final AuthState actualState = container.read(authControllerProvider);
      expect(actualState.isAuthenticated, isTrue);
      expect(actualState.currentUser, expectedUser);
    });

    test('logout clears state and calls repository logout', () async {
      // Arrange
      bool didLogout = false;
      final ProviderContainer container = _createAuthContainer(
        logoutHandler: () async {
          didLogout = true;
        },
      );
      addTearDown(container.dispose);
      final AuthController controller = container.read(
        authControllerProvider.notifier,
      );
      await controller.login(
        const LoginCredentials(username: 'mdk', password: '12344321!'),
      );

      // Act
      await controller.logout();

      // Assert
      final AuthState actualState = container.read(authControllerProvider);
      expect(actualState.isAuthenticated, isFalse);
      expect(actualState.currentUser, isNull);
      expect(didLogout, isTrue);
    });
  });
}

ProviderContainer _createAuthContainer({
  Future<AuthUser?> Function()? fetchHandler,
  Future<AuthUser> Function(LoginCredentials)? loginHandler,
  Future<void> Function()? logoutHandler,
}) {
  final AuthRepository repository = _MockAuthRepository(
    fetchHandler: fetchHandler,
    loginHandler: loginHandler,
    logoutHandler: logoutHandler,
  );
  return ProviderContainer(
    overrides: [authRepositoryProvider.overrideWithValue(repository)],
  );
}

class _MockAuthRepository implements AuthRepository {
  _MockAuthRepository({
    this.fetchHandler,
    this.loginHandler,
    this.logoutHandler,
  });

  final Future<AuthUser?> Function()? fetchHandler;
  final Future<AuthUser> Function(LoginCredentials)? loginHandler;
  final Future<void> Function()? logoutHandler;

  @override
  Future<AuthUser?> fetchCurrentUser() async {
    if (fetchHandler != null) {
      return fetchHandler!();
    }
    return null;
  }

  @override
  Future<AuthUser> login(LoginCredentials credentials) {
    if (loginHandler != null) {
      return loginHandler!(credentials);
    }
    return Future<AuthUser>.value(
      AuthUser(id: credentials.username, username: credentials.username),
    );
  }

  @override
  Future<void> logout() async {
    await logoutHandler?.call();
  }
}
