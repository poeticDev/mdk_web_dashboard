/// ROLE
/// - 로그인 입력 값을 표현하는 값 객체다
///
/// RESPONSIBILITY
/// - 사용자명/비밀번호를 보관하고 유효성을 판단한다
///
/// DEPENDS ON
/// - freezed_annotation
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_credentials.freezed.dart';

@freezed
abstract class LoginCredentials with _$LoginCredentials {
  const LoginCredentials._();

  const factory LoginCredentials({
    required String username,
    required String password,
  }) = _LoginCredentials;

  bool get isValid => username.trim().isNotEmpty && password.trim().isNotEmpty;
}
