import 'package:flutter_bloc/flutter_bloc.dart';

import 'tip_event.dart';
import 'tip_state.dart';

class TipBloc extends Bloc<TipEvent, TipState> {
  TipBloc({double initialTipPct = 15})
      : super(TipState(tipPct: initialTipPct.clamp(0, 100))) {
    on<BillChanged>((e, emit) {
      final v = e.bill >= 0 ? e.bill : state.bill;
      if (v == state.bill) return;
      emit(state.copyWith(bill: v));
    });

    on<TipPctChanged>((e, emit) {
      final v = e.tipPct.clamp(0, 100).toDouble();
      if (v == state.tipPct) return;
      emit(state.copyWith(tipPct: v));
    });

    on<PresetSelected>((e, emit) {
      final v = e.tipPct.clamp(0, 100).toDouble();
      if (v == state.tipPct) return;
      emit(state.copyWith(tipPct: v));
    });

    on<PeopleChanged>((e, emit) {
      final v = e.people < 1 ? 1 : e.people;
      if (v == state.people) return;
      emit(state.copyWith(people: v));
    });

    on<PeopleIncremented>((_, emit) {
      emit(state.copyWith(people: state.people + 1));
    });

    on<PeopleDecremented>((_, emit) {
      final v = state.people - 1;
      if (v < 1) return;
      emit(state.copyWith(people: v));
    });
  }
}
