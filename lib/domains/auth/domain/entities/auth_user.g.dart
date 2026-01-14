// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
  id: json['id'] as String,
  username: json['username'] as String,
  displayName: json['displayName'] as String?,
  siteId: json['siteId'] as String?,
  buildingId: json['buildingId'] as String?,
  departmentId: json['departmentId'] as String?,
  roles:
      (json['roles'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$UserRoleEnumMap, e))
          .toList() ??
      const <UserRole>[],
);

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'displayName': instance.displayName,
  'siteId': instance.siteId,
  'buildingId': instance.buildingId,
  'departmentId': instance.departmentId,
  'roles': instance.roles.map((e) => _$UserRoleEnumMap[e]!).toList(),
};

const _$UserRoleEnumMap = {
  UserRole.admin: 'ADMIN',
  UserRole.operator: 'OPERATOR',
  UserRole.limitedOperator: 'LIMITED_OPERATOR',
  UserRole.viewer: 'VIEWER',
  UserRole.unknown: 'UNKNOWN',
};
