import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tip_splitter/bloc/settings/settings_cubit.dart';
import 'package:tip_splitter/bloc/settings/settings_state.dart';
import 'package:tip_splitter/domain/repository/settings_repository.dart';
import 'package:tip_splitter/domain/models/currency.dart';

class _FakeSettingsRepository implements SettingsRepository {
  @override
  Future<SettingsState> load() async => const SettingsState();

  @override
  Future<void> saveCurrency(Currency currency) async {}

  @override
  Future<void> saveDefaultTipPct(double pct) async {}
}

void main() {
  group('SettingsCubit', () {
    test('initial state defaults to USD and 15%', () {
      final c = SettingsCubit(_FakeSettingsRepository());
      expect(c.state, const SettingsState());
      expect(c.state.currency, Currency.usd);
      expect(c.state.defaultTipPct, 15);
    });

    blocTest<SettingsCubit, SettingsState>(
      'setCurrency emits new currency',
      build: () => SettingsCubit(_FakeSettingsRepository()),
      act: (c) => c.setCurrency(Currency.eur),
      expect: () => [const SettingsState(currency: Currency.eur)],
    );

    blocTest<SettingsCubit, SettingsState>(
      'setDefaultTipPct emits clamped value',
      build: () => SettingsCubit(_FakeSettingsRepository()),
      act: (c) {
        c.setDefaultTipPct(25);
        c.setDefaultTipPct(150);
      },
      expect: () => [
        const SettingsState(defaultTipPct: 25),
        const SettingsState(defaultTipPct: 100),
      ],
    );
  });
}