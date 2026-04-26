import 'package:equatable/equatable.dart';

import '../../domain/models/currency.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.currency = Currency.usd,
    this.defaultTipPct = 15,
  });

  final Currency currency;
  final double defaultTipPct;

  SettingsState copyWith({Currency? currency, double? defaultTipPct}) =>
      SettingsState(
        currency: currency ?? this.currency,
        defaultTipPct: defaultTipPct ?? this.defaultTipPct,
      );

  @override
  List<Object?> get props => [currency, defaultTipPct];
}
