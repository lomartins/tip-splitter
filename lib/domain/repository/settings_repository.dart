import '../../bloc/settings/settings_state.dart';
import '../models/currency.dart';

abstract interface class SettingsRepository {
  Future<SettingsState> load();
  Future<void> saveCurrency(Currency currency);
  Future<void> saveDefaultTipPct(double pct);
}
