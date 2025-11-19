class AuthException implements Exception {
  const AuthException(this.message, {this.code});

  final String message;
  final String? code;

  factory AuthException.invalidCredentials() => const AuthException(
    '아이디 또는 비밀번호가 올바르지 않습니다.',
    code: 'invalid_credentials',
  );

  factory AuthException.sessionExpired() =>
      const AuthException('세션이 만료되었습니다. 다시 로그인해주세요.', code: 'session_expired');

  factory AuthException.sessionLimitExceeded() => const AuthException(
    '동시 접속 한도를 초과했습니다. 다른 세션을 종료한 뒤 다시 시도하세요.',
    code: 'session_limit_exceeded',
  );

  factory AuthException.serverError() =>
      const AuthException('서버에서 오류가 발생했습니다.', code: 'server_error');

  factory AuthException.networkUnavailable() =>
      const AuthException('서버와 통신할 수 없습니다.', code: 'network_unavailable');

  factory AuthException.unknown([String? message]) =>
      AuthException(message ?? '알 수 없는 오류가 발생했습니다.', code: 'unknown');

  @override
  String toString() => 'AuthException(message: $message, code: $code)';
}
