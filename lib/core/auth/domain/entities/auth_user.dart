import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

enum UserRole {
  admin,
  operator,
  @JsonValue('limited_operator')
  limitedOperator,
  viewer,
  unknown
}

@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    required String username,
    @Default(<UserRole>[]) List<UserRole> roles,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}
