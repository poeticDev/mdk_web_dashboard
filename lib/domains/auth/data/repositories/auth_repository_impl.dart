/// ROLE
/// - 인증 리포지토리 구현체를 제공한다
///
/// RESPONSIBILITY
/// - 원격 데이터 소스를 통해 인증 작업을 수행한다
///
/// DEPENDS ON
/// - auth_remote_data_source
/// - auth_user
library;

import 'package:web_dashboard/domains/auth/data/datasources/auth_remote_data_source.dart';
import 'package:web_dashboard/domains/auth/domain/entities/auth_user.dart';
import 'package:web_dashboard/domains/auth/domain/repositories/auth_repository.dart';
import 'package:web_dashboard/domains/auth/domain/value_objects/login_credentials.dart';

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
