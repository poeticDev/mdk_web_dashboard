enum LectureType {
  lecture('LECTURE'),
  event('EVENT'),
  exam('EXAM');

  const LectureType(this.apiValue);

  final String apiValue;

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
