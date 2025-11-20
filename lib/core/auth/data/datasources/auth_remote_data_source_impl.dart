import 'package:dio/dio.dart';
import 'package:web_dashboard/common/constants/api_constants.dart';
import 'package:web_dashboard/core/auth/data/datasources/auth_remote_data_source.dart';
import 'package:web_dashboard/core/auth/domain/entities/auth_user.dart';
import 'package:web_dashboard/core/auth/domain/errors/auth_exception.dart';
import 'package:web_dashboard/core/auth/domain/value_objects/login_credentials.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<AuthUser> login(LoginCredentials credentials) async {
    try {
      final Response<dynamic> response = await _dio.post<dynamic>(
        ApiConstants.login,
        data: <String, String>{
          'username': credentials.username,
          'password': credentials.password,
        },
      );
      return _parseUser(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw _mapLoginException(error);
    }
  }

  @override
  Future<AuthUser?> fetchCurrentUser() async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        ApiConstants.me,
      );
      if (response.data == null) {
        return null;
      }
      return _parseUser(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw AuthException.sessionExpired();
      }
      throw _mapCommonException(error);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post<dynamic>(ApiConstants.logout);
    } on DioException catch (error) {
      throw _mapCommonException(error);
    }
  }

  AuthUser _parseUser(Map<String, dynamic> payload) {
    final Map<String, dynamic>? nestedUser =
        payload['user'] as Map<String, dynamic>?;
    final Map<String, dynamic> source = nestedUser ?? payload;
    final Map<String, dynamic> normalized = <String, dynamic>{
      'id': '${source['id']}',
      'username': _extractUsername(source),
      'roles': _extractRoles(source['roles']),
    };
    return AuthUser.fromJson(normalized);
  }

  String _extractUsername(Map<String, dynamic> source) {
    final String? username =
        (source['username'] ?? source['userName']) as String?;
    if (username == null || username.isEmpty) {
      throw AuthException.unknown('사용자 이름이 응답에 없습니다.');
    }
    return username;
  }

  List<String> _extractRoles(dynamic rawRoles) {
    if (rawRoles is List) {
      return rawRoles
          .whereType<String>()
          .map((String role) => role.toLowerCase())
          .toList();
    }
    return <String>[];
  }

  AuthException _mapLoginException(DioException error) {
    final int? statusCode = error.response?.statusCode;
    if (statusCode == 401) {
      return AuthException.invalidCredentials();
    }
    if (statusCode == 429) {
      return AuthException.sessionLimitExceeded();
    }
    return _mapCommonException(error);
  }

  AuthException _mapCommonException(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return AuthException.networkUnavailable();
    }
    if (error.response?.statusCode == 500) {
      return AuthException.serverError();
    }
    final dynamic data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final String? message = data['message']?.toString();
      if (message != null && message.isNotEmpty) {
        return AuthException.unknown(message);
      }
    }
    return AuthException.unknown();
  }
}
