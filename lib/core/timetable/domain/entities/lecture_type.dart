/// 서버의 LectureType 문자열을 표현하는 도메인 enum.
enum LectureType {
  lecture('LECTURE'),
  event('EVENT'),
  exam('EXAM');

  const LectureType(this.apiValue);

  final String apiValue;

  /// API 문자열을 enum으로 변환한다. 기본값은 `lecture`이다.
  static LectureType fromApi(String value) {
    switch (value.toUpperCase()) {
      case 'EVENT':
        return LectureType.event;
      case 'EXAM':
        return LectureType.exam;
      default:
        return LectureType.lecture;
    }
  }
}
