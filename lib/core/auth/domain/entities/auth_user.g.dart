// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
  id: json['id'] as String,
  username: json['username'] as String,
  roles:
      (json['roles'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$UserRoleEnumMap, e))
          .toList() ??
      const <UserRole>[],
);

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'roles': instance.roles.map((e) => _$UserRoleEnumMap[e]!).toList(),
};

const _$UserRoleEnumMap = {
  UserRole.staff: 'staff',
  UserRole.faculty: 'faculty',
  UserRole.professor: 'professor',
  UserRole.student: 'student',
  UserRole.assistant: 'assistant',
  UserRole.admin: 'admin',
  UserRole.unknown: 'unknown',
};
