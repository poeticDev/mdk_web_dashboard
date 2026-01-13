/// ROLE
/// - 인증 리포지토리 계약을 정의한다
///
/// RESPONSIBILITY
/// - 로그인/로그아웃/현재 사용자 조회 인터페이스를 제공한다
///
/// DEPENDS ON
/// - auth_user
/// - login_credentials
library;

import 'package:web_dashboard/domains/auth/domain/entities/auth_user.dart';
import 'package:web_dashboard/domains/auth/domain/value_objects/login_credentials.dart';

abstract class AuthRepository {
  Future<AuthUser> login(LoginCredentials credentials);

  Future<AuthUser?> fetchCurrentUser();

  Future<void> logout();
}
