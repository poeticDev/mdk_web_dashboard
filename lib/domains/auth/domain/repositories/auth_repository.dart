import 'package:web_dashboard/domains/auth/domain/entities/auth_user.dart';
import 'package:web_dashboard/domains/auth/domain/value_objects/login_credentials.dart';

abstract class AuthRepository {
  Future<AuthUser> login(LoginCredentials credentials);

  Future<AuthUser?> fetchCurrentUser();

  Future<void> logout();
}
