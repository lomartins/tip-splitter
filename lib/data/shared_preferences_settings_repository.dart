import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/settings/settings_state.dart';
import '../domain/models/currency.dart';
import '../domain/repository/settings_repository.dart';

class SharedPreferencesSettingsRepository implements SettingsRepository {
  const SharedPreferencesSettingsRepository(this._prefs, {this.defaultCurrency = Currency.usd});

  final SharedPreferences _prefs;
  final Currency defaultCurrency;

  static const _keyCurrencyCode = 'currency_code';
  static const _keyCurrencySymbol = 'currency_symbol';
  static const _keyDefaultTipPct = 'default_tip_pct';

  @override
  Future<SettingsState> load() async {
    final code = _prefs.getString(_keyCurrencyCode);
    final symbol = _prefs.getString(_keyCurrencySymbol);
    final tipPct = _prefs.getDouble(_keyDefaultTipPct);

    final currency = (code != null && symbol != null)
        ? Currency(code: code, symbol: symbol)
        : defaultCurrency;

    return SettingsState(
      currency: currency,
      defaultTipPct: tipPct ?? const SettingsState().defaultTipPct,
    );
  }

  @override
  Future<void> saveCurrency(Currency currency) async {
    await _prefs.setString(_keyCurrencyCode, currency.code);
    await _prefs.setString(_keyCurrencySymbol, currency.symbol);
  }

  @override
  Future<void> saveDefaultTipPct(double pct) async {
    await _prefs.setDouble(_keyDefaultTipPct, pct);
  }
}