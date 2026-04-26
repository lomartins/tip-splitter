import 'package:equatable/equatable.dart';

sealed class TipEvent extends Equatable {
  const TipEvent();
  @override
  List<Object?> get props => [];
}

class BillChanged extends TipEvent {
  const BillChanged(this.bill);
  final int bill;
  @override
  List<Object?> get props => [bill];
}

class TipPctChanged extends TipEvent {
  const TipPctChanged(this.tipPct);
  final double tipPct;
  @override
  List<Object?> get props => [tipPct];
}

class PresetSelected extends TipEvent {
  const PresetSelected(this.tipPct);
  final double tipPct;
  @override
  List<Object?> get props => [tipPct];
}

class PeopleChanged extends TipEvent {
  const PeopleChanged(this.people);
  final int people;
  @override
  List<Object?> get props => [people];
}

class PeopleIncremented extends TipEvent {
  const PeopleIncremented();
}

class PeopleDecremented extends TipEvent {
  const PeopleDecremented();
}
