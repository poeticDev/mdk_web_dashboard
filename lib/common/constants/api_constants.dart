class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'http://localhost:3000/api';
  static const Duration connectTimeout = Duration(seconds: 8);
  static const Duration receiveTimeout = Duration(seconds: 8);

  static const String login = '/login';
  static const String me = '/me';
  static const String logout = '/logout';
}
