import 'package:flutter_test/flutter_test.dart';
import 'package:tip_splitter/domain/models/tip_result.dart';
import 'package:tip_splitter/domain/tip_calculator.dart';

void main() {
  group('calculateTip', () {
    test('zero bill returns zero result', () {
      expect(calculateTip(bill: 0, tipPct: 20, people: 2), TipResult.zero);
    });

    test('zero people returns zero result (guard)', () {
      expect(calculateTip(bill: 5000, tipPct: 20, people: 0), TipResult.zero);
    });

    test(r'basic case: $100 bill, 20% tip, 2 people', () {
      final r = calculateTip(bill: 10000, tipPct: 20, people: 2);
      expect(r.tipAmount, 2000);
      expect(r.total, 12000);
      expect(r.perPerson, 6000);
    });

    test('rounds tip to 2 decimals (nearest cent)', () {
      // 33.33 * 0.15 = 4.9995 -> 5.00
      final r = calculateTip(bill: 3333, tipPct: 15, people: 1);
      expect(r.tipAmount, 500);
      expect(r.total, 3833);
    });

    test('per-person rounds up to nearest cent', () {
      final r = calculateTip(bill: 1000, tipPct: 0, people: 3);
      expect(r.total, 1000);
      expect(r.perPerson, 334);
    });
  });
}
