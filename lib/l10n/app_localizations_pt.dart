// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Dividir a Conta';

  @override
  String get billAmount => 'VALOR DA CONTA';

  @override
  String get splitBetween => 'DIVIDIR ENTRE';

  @override
  String personSuffix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' pessoas',
      one: ' pessoa',
    );
    return '$_temp0';
  }

  @override
  String get tipPercentage => 'PORCENTAGEM DA GORJETA';

  @override
  String get eachPersonPays => 'CADA PESSOA PAGA';

  @override
  String get bill => 'Conta';

  @override
  String tipWithPct(String pct) {
    return 'Gorjeta ($pct%)';
  }

  @override
  String get total => 'Total';

  @override
  String get settings => 'Configurações';

  @override
  String get currency => 'MOEDA';

  @override
  String get customCurrency => 'Personalizado…';

  @override
  String get customSymbol => 'Símbolo personalizado';

  @override
  String get defaultTip => 'GORJETA PADRÃO';
}
