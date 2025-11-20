import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web_dashboard/core/auth/domain/entities/auth_user.dart';

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
