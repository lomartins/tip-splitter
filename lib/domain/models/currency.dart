import 'package:equatable/equatable.dart';

class Currency extends Equatable {
  const Currency({required this.code, required this.symbol});

  final String code;
  final String symbol;

  static const usd = Currency(code: 'USD', symbol: r'$');
  static const eur = Currency(code: 'EUR', symbol: '€');
  static const gbp = Currency(code: 'GBP', symbol: '£');
  static const jpy = Currency(code: 'JPY', symbol: '¥');
  static const brl = Currency(code: 'BRL', symbol: r'R$');

  static const presets = <Currency>[usd, eur, gbp, jpy, brl];

  static const customCode = 'CUSTOM';

  bool get isCustom => code == customCode;

  Currency copyWith({String? code, String? symbol}) =>
      Currency(code: code ?? this.code, symbol: symbol ?? this.symbol);

  @override
  List<Object?> get props => [code, symbol];
}
