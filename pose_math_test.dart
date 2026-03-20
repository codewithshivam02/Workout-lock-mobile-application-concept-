import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:workout_lock/pose/pose_math.dart';

void main() {
  group('angleAtOffsets', () {
    test('right angle at origin', () {
      const a = Offset(1, 0);
      const b = Offset.zero;
      const c = Offset(0, 1);
      expect(angleAtOffsets(a, b, c), closeTo(90, 0.01));
    });

    test('straight line ~180°', () {
      const a = Offset(1, 0);
      const b = Offset.zero;
      const c = Offset(-1, 0);
      expect(angleAtOffsets(a, b, c), closeTo(180, 0.01));
    });

    test('acute angle', () {
      const a = Offset(1, 0);
      const b = Offset.zero;
      const c = Offset(1, 1);
      expect(angleAtOffsets(a, b, c), closeTo(45, 0.01));
    });
  });
}
