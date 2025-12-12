enum LectureStatus {
  scheduled('ACTIVE'),
  canceled('CANCELED');

  const LectureStatus(this.apiValue);

  final String apiValue;

  bool get isCanceled => this == LectureStatus.canceled;

  static LectureStatus fromApi(String value) {
    return value.toUpperCase() == 'CANCELED'
        ? LectureStatus.canceled
        : LectureStatus.scheduled;
  }
}
