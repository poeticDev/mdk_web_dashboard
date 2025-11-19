import 'package:web_dashboard/core/auth/data/datasources/auth_remote_data_source.dart';
import 'package:web_dashboard/core/auth/domain/entities/auth_user.dart';
import 'package:web_dashboard/core/auth/domain/repositories/auth_repository.dart';
import 'package:web_dashboard/core/auth/domain/value_objects/login_credentials.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<AuthUser?> fetchCurrentUser() => _remoteDataSource.fetchCurrentUser();

  @override
  Future<AuthUser> login(LoginCredentials credentials) =>
      _remoteDataSource.login(credentials);

  @override
  Future<void> logout() => _remoteDataSource.logout();
}
