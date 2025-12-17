class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'http://localhost:3000/api/v1';
  static const Duration connectTimeout = Duration(seconds: 8);
  static const Duration receiveTimeout = Duration(seconds: 8);

  static const String login = '/login';
  static const String me = '/me';
  static const String logout = '/logout';
  static const String lectures = '/lectures';
  static const String classrooms = '/classrooms';
  static const String expectedVersionHeader = 'x-expected-version';

  static String classroomTimetablePath(String classroomId) {
    return '$classrooms/$classroomId/timetable';
  }
}
