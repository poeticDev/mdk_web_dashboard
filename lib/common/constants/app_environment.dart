/// 환경별 설정 값을 제공하는 상수 모음.
class AppEnvironment {
  const AppEnvironment._();

  static const int defaultServerPort = 3000;

  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://localhost:$defaultServerPort/api/v1',
  );
}
