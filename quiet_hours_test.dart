import 'package:flutter_test/flutter_test.dart';
import 'package:workout_lock/utils/quiet_hours.dart';

void main() {
  group('isWithinQuietHours', () {
    test('same-day window', () {
      expect(isWithinQuietHours(10 * 60, 9 * 60, 17 * 60), true);
      expect(isWithinQuietHours(8 * 60, 9 * 60, 17 * 60), false);
      expect(isWithinQuietHours(17 * 60, 9 * 60, 17 * 60), false);
    });

    test('cross-midnight window', () {
      const start = 22 * 60;
      const end = 7 * 60;
      expect(isWithinQuietHours(23 * 60, start, end), true);
      expect(isWithinQuietHours(3 * 60, start, end), true);
      expect(isWithinQuietHours(12 * 60, start, end), false);
    });

    test('start == end means disabled', () {
      expect(isWithinQuietHours(720, 600, 600), false);
    });
  });

  group('isWeekendLocal', () {
    test('Saturday', () {
      expect(isWeekendLocal(DateTime(2026, 3, 21)), true);
    });
    test('Monday', () {
      expect(isWeekendLocal(DateTime(2026, 3, 23)), false);
    });
  });
}
