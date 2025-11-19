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
