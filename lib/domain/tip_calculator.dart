import 'models/tip_result.dart';

TipResult calculateTip({
  required int bill,
  required double tipPct,
  required int people,
}) {
  if (bill <= 0 || people <= 0) return TipResult.zero;
  final tipAmount = (bill * tipPct / 100).round();
  final total = bill + tipAmount;
  final perPerson = (total / people).ceil();
  return TipResult(tipAmount: tipAmount, total: total, perPerson: perPerson);
}
