import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tip_splitter/bloc/tip/tip_bloc.dart';
import 'package:tip_splitter/bloc/tip/tip_event.dart';
import 'package:tip_splitter/bloc/tip/tip_state.dart';

void main() {
  group('TipBloc', () {
    test('initial state uses initialTipPct', () {
      final bloc = TipBloc(initialTipPct: 18);
      expect(bloc.state, const TipState(tipPct: 18));
    });

    blocTest<TipBloc, TipState>(
      'BillChanged updates bill and recomputes result',
      build: () => TipBloc(initialTipPct: 20),
      act: (b) => b.add(const BillChanged(5000)),
      expect: () => [const TipState(bill: 5000, tipPct: 20)],
      verify: (b) {
        expect(b.state.result.tipAmount, 1000);
        expect(b.state.result.total, 6000);
      },
    );

    blocTest<TipBloc, TipState>(
      'PresetSelected sets tipPct',
      build: () => TipBloc(initialTipPct: 10),
      act: (b) => b.add(const PresetSelected(20)),
      expect: () => [const TipState(tipPct: 20)],
    );

    blocTest<TipBloc, TipState>(
      'TipPctChanged clamps to [0,100]',
      build: TipBloc.new,
      act: (b) {
        b.add(const TipPctChanged(150));
        b.add(const TipPctChanged(-10));
      },
      expect: () => [
        const TipState(tipPct: 100),
        const TipState(tipPct: 0),
      ],
    );

    blocTest<TipBloc, TipState>(
      'PeopleIncremented and PeopleDecremented',
      build: TipBloc.new,
      act: (b) {
        b.add(const PeopleIncremented());
        b.add(const PeopleIncremented());
        b.add(const PeopleDecremented());
      },
      expect: () => [
        const TipState(people: 2),
        const TipState(people: 3),
        const TipState(people: 2),
      ],
    );

    blocTest<TipBloc, TipState>(
      'PeopleDecremented clamps at 1',
      build: TipBloc.new,
      act: (b) => b.add(const PeopleDecremented()),
      expect: () => <TipState>[],
    );

    blocTest<TipBloc, TipState>(
      'PeopleChanged below 1 clamps to 1',
      build: () => TipBloc()..add(const PeopleIncremented()),
      act: (b) => b.add(const PeopleChanged(0)),
      skip: 1,
      expect: () => [const TipState(people: 1)],
    );

    blocTest<TipBloc, TipState>(
      'BillChanged ignores negative',
      build: TipBloc.new,
      act: (b) => b.add(const BillChanged(-500)),
      expect: () => <TipState>[],
    );
  });
}
