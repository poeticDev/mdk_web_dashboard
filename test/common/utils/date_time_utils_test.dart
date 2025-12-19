import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:web_dashboard/common/utils/date_time_utils.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  group('DateTimeUtils.parseUtc', () {
    test('converts offset string to utc', () {
      final DateTime parsed =
          DateTimeUtils.parseUtc('2025-01-01T09:00:00+09:00');
      expect(parsed.isUtc, isTrue);
      expect(parsed.hour, 0); // 09:00 KST -> 00:00 UTC
    });

    test('falls back to epoch on invalid input', () {
      final DateTime parsed = DateTimeUtils.parseUtc('invalid');
      expect(parsed.year, 1970);
    });
  });

  group('DateTimeUtils.formatLocal', () {
    test('formats without converting when flag disabled', () {
      final DateTime value = DateTime.utc(2025, 1, 1, 3, 30);
      final String formatted = DateTimeUtils.formatLocal(
        value,
        pattern: 'yyyy-MM-dd HH:mm',
        locale: 'en',
        convertToLocal: false,
      );
      expect(formatted, '2025-01-01 03:30');
    });
  });

  group('DateTimeUtils.formatRange', () {
    test('composes range string', () {
      final DateTime start = DateTime.utc(2025, 1, 1, 0);
      final DateTime end = DateTime.utc(2025, 1, 1, 2);
      final String formatted = DateTimeUtils.formatRange(
        start,
        end,
        startPattern: 'HH:mm',
        endPattern: 'HH:mm',
        convertToLocal: false,
      );
      expect(formatted, '00:00 ~ 02:00');
    });
  });
}
