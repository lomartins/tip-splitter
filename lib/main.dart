import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/shared_preferences_settings_repository.dart';
import 'domain/models/currency.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final locale = WidgetsBinding.instance.platformDispatcher.locale;
  final defaultCurrency = locale.languageCode == 'pt' ? Currency.brl : Currency.usd;
  runApp(TipSplitterApp(
    settingsRepository: SharedPreferencesSettingsRepository(prefs, defaultCurrency: defaultCurrency),
  ));
}
