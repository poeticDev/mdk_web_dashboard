import 'package:get_it/get_it.dart';
import 'package:web_dashboard/core/auth/domain/entities/auth_user.dart';
import 'package:web_dashboard/core/auth/domain/repositories/auth_repository.dart';
import 'package:web_dashboard/core/auth/domain/value_objects/login_credentials.dart';

final GetIt di = GetIt.instance;

Future<void> initDependencies() async {
  if (!di.isRegistered<AuthRepository>()) {
    di.registerLazySingleton<AuthRepository>(
      () => _UnimplementedAuthRepository(),
    );
  }
}

class _UnimplementedAuthRepository implements AuthRepository {
  @override
  Future<AuthUser?> fetchCurrentUser() =>
      Future<AuthUser?>.error(_buildError('fetchCurrentUser'));

  @override
  Future<AuthUser> login(LoginCredentials credentials) =>
      Future<AuthUser>.error(_buildError('login'));

  @override
  Future<void> logout() => Future<void>.error(_buildError('logout'));

  Exception _buildError(String method) =>
      UnimplementedError('AuthRepository.$method는 아직 구현되지 않았습니다.');
}
