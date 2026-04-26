// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tip Splitter';

  @override
  String get billAmount => 'BILL AMOUNT';

  @override
  String get splitBetween => 'SPLIT BETWEEN';

  @override
  String personSuffix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' people',
      one: ' person',
    );
    return '$_temp0';
  }

  @override
  String get tipPercentage => 'TIP PERCENTAGE';

  @override
  String get eachPersonPays => 'EACH PERSON PAYS';

  @override
  String get bill => 'Bill';

  @override
  String tipWithPct(String pct) {
    return 'Tip ($pct%)';
  }

  @override
  String get total => 'Total';

  @override
  String get settings => 'Settings';

  @override
  String get currency => 'CURRENCY';

  @override
  String get customCurrency => 'Custom…';

  @override
  String get customSymbol => 'Custom symbol';

  @override
  String get defaultTip => 'DEFAULT TIP';
}
