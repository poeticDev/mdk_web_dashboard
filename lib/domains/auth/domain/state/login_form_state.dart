/// ROLE
/// - 로그인 폼 상태 모델을 정의한다
///
/// RESPONSIBILITY
/// - 입력값과 제출 가능 여부를 보관한다
///
/// DEPENDS ON
/// - freezed_annotation
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_form_state.freezed.dart';

@freezed
abstract class LoginFormState with _$LoginFormState {
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
