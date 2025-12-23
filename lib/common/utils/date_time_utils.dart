import 'package:intl/intl.dart';

/// UTC 기반 DateTime 파싱/포매팅 유틸리티.
///
/// 서버는 모든 시간을 UTC로 내려주므로, UI에서는 `toLocal()`로 변환한 뒤
/// 표기/편집해야 시차(예: KST) 차이가 나지 않는다.
/// 반대로 서버로 전송할 때는 반드시 `toUtc()`로 변환할 것.
class DateTimeUtils {
  const DateTimeUtils._();

  static final DateTime _epochUtc =
      DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

  /// ISO 문자열을 UTC DateTime으로 파싱한다.
  static DateTime parseUtc(String value, {DateTime? fallback}) {
    final DateTime safeFallback = fallback ?? _epochUtc;
    if (value.trim().isEmpty) {
      return safeFallback;
    }
    try {
      final DateTime parsed = DateTime.parse(value.trim());
      return parsed.isUtc ? parsed : parsed.toUtc();
    } on FormatException {
      return safeFallback;
    }
  }

  /// JSON 값(문자열/DateTime/num 등)을 UTC로 파싱한다.
  static DateTime parseUtcFromJson(Object? raw, {DateTime? fallback}) {
    if (raw == null) {
      return fallback ?? _epochUtc;
    }
    if (raw is DateTime) {
      return raw.isUtc ? raw : raw.toUtc();
    }
    return parseUtc(raw.toString(), fallback: fallback);
  }

  /// UTC DateTime을 기기 로컬 시간대로 변환한다.
  static DateTime toLocal(DateTime utc) {
    return utc.isUtc ? utc.toLocal() : utc;
  }

  /// 로컬 시간대 기준 문자열로 포맷한다.
  static String formatLocal(
    DateTime dateTime, {
    String pattern = 'yyyy-MM-dd HH:mm',
    String? locale,
    bool convertToLocal = true,
  }) {
    final DateTime target = convertToLocal ? toLocal(dateTime) : dateTime;
    final DateFormat formatter = DateFormat(pattern, locale);
    return formatter.format(target);
  }

  /// UTC 시작/종료 시각을 지정 패턴으로 포맷해 구간 문자열을 반환한다.
  static String formatRange(
    DateTime startUtc,
    DateTime endUtc, {
    String startPattern = 'MM/dd HH:mm',
    String endPattern = 'HH:mm',
    String separator = ' ~ ',
    String? locale,
    bool convertToLocal = true,
  }) {
    final String startLabel = formatLocal(
      startUtc,
      pattern: startPattern,
      locale: locale,
      convertToLocal: convertToLocal,
    );
    final String endLabel = formatLocal(
      endUtc,
      pattern: endPattern,
      locale: locale,
      convertToLocal: convertToLocal,
    );
    return '$startLabel$separator$endLabel';
  }
}
