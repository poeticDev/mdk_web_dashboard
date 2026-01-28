/// API 경로와 공통 네트워크 상수를 정의한다.
import 'package:web_dashboard/common/constants/app_environment.dart';

class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = AppEnvironment.baseUrl;
  static const Duration connectTimeout = Duration(seconds: 8);
  static const Duration receiveTimeout = Duration(seconds: 8);

  static const String login = '/login';
  static const String me = '/me';
  static const String logout = '/logout';
  static const String lectures = '/lectures/origin';
  static const String lectureOccurrences = '/lectures/occurrence';
  static const String classrooms = '/classrooms';
  static const String foundations = '/foundations';
  static const String departments = '/departments';
  static const String users = '/users';
  static const String roomStateSubscriptions = '/stream/room-states/subscriptions';
  static const String roomStateStream = '/stream/room-states';
  static const String occurrenceNowSubscriptions =
      '/stream/occurrences/now/subscriptions';
  static const String occurrenceNowStream = '/stream/occurrences/now';
  static const String expectedVersionHeader = 'x-expected-version';

  static String classroomTimetablePath(String classroomId) {
    return '$classrooms/$classroomId/timetable';
  }

  static String foundationClassroomsPath(
    String foundationType,
    String foundationId,
  ) {
    return '$foundations/$foundationType/$foundationId/classrooms';
  }
}
