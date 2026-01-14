/// ROLE
/// - 인증 사용자 정보를 표현하는 엔티티다
///
/// RESPONSIBILITY
/// - 사용자 식별/표시 정보를 보관한다
/// - 역직렬화 생성자를 제공한다
///
/// DEPENDS ON
/// - freezed_annotation
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

enum UserRole {
  @JsonValue('ADMIN')
  admin,
  @JsonValue('OPERATOR')
  operator,
  @JsonValue('LIMITED_OPERATOR')
  limitedOperator,
  @JsonValue('VIEWER')
  viewer,
  @JsonValue('UNKNOWN')
  unknown
}

@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    required String username,
    String? displayName,
    String? siteId,
    String? buildingId,
    String? departmentId,
    @Default(<UserRole>[]) List<UserRole> roles,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}
