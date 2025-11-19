import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_form_state.freezed.dart';

@freezed
class LoginFormState with _$LoginFormState {
  const LoginFormState._();

  const factory LoginFormState({
    @Default('') String username,
    @Default('') String password,
    @Default(false) bool isSubmitting,
    String? errorMessage,
  }) = _LoginFormState;

  bool get canSubmit =>
      username.trim().isNotEmpty && password.trim().isNotEmpty && !isSubmitting;
}
