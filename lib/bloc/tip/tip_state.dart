import 'package:equatable/equatable.dart';

import '../../domain/models/tip_result.dart';
import '../../domain/tip_calculator.dart';

class TipState extends Equatable {
  const TipState({
    this.bill = 0,
    this.tipPct = 15,
    this.people = 1,
  });

  final int bill;
  final double tipPct;
  final int people;

  TipResult get result =>
      calculateTip(bill: bill, tipPct: tipPct, people: people);

  TipState copyWith({int? bill, double? tipPct, int? people}) => TipState(
        bill: bill ?? this.bill,
        tipPct: tipPct ?? this.tipPct,
        people: people ?? this.people,
      );

  @override
  List<Object?> get props => [bill, tipPct, people];
}
