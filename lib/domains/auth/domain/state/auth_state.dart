/// ROLE
/// - 인증 상태 모델을 정의한다
///
/// RESPONSIBILITY
/// - 현재 사용자/로딩/오류 상태를 보관한다
///
/// DEPENDS ON
/// - freezed_annotation
/// - auth_user
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web_dashboard/domains/auth/domain/entities/auth_user.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    AuthUser? currentUser,
    @Default(false) bool isAuthenticated,
    @Default(false) bool isLoadingMe,
    String? errorMessage,
  }) = _AuthState;

  factory AuthState.initial() => const AuthState();

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}
