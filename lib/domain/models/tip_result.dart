import 'package:equatable/equatable.dart';

class TipResult extends Equatable {
  const TipResult({
    required this.tipAmount,
    required this.total,
    required this.perPerson,
  });

  final int tipAmount;
  final int total;
  final int perPerson;

  static const zero = TipResult(tipAmount: 0, total: 0, perPerson: 0);

  @override
  List<Object?> get props => [tipAmount, total, perPerson];
}
