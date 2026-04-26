import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tip_splitter/l10n/app_localizations.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../../domain/models/currency.dart';

class CurrencyCard extends StatefulWidget {
  const CurrencyCard({super.key});

  @override
  State<CurrencyCard> createState() => _CurrencyCardState();
}

class _CurrencyCardState extends State<CurrencyCard> {
  late final TextEditingController _customController;

  @override
  void initState() {
    super.initState();
    final current = context.read<SettingsCubit>().state.currency;
    _customController = TextEditingController(
      text: current.isCustom ? current.symbol : '',
    );
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.watch<SettingsCubit>();
    final current = cubit.state.currency;
    final items = [
      ...Currency.presets,
      const Currency(code: Currency.customCode, symbol: ''),
    ];

    Currency? value = items.firstWhere(
      (c) => c.code == current.code,
      orElse: () => Currency.usd,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.currency,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<Currency>(
              isExpanded: true,
              value: value,
              items: [
                for (final c in items)
                  DropdownMenuItem(
                    value: c,
                    child: Text(c.isCustom ? AppLocalizations.of(context)!.customCurrency : '${c.code} (${c.symbol})'),
                  ),
              ],
              onChanged: (c) {
                if (c == null) return;
                if (c.isCustom) {
                  cubit.setCurrency(Currency(
                    code: Currency.customCode,
                    symbol: _customController.text.isEmpty
                        ? r'$'
                        : _customController.text,
                  ));
                } else {
                  cubit.setCurrency(c);
                }
              },
            ),
            if (current.isCustom) ...[
              const SizedBox(height: 8),
              TextField(
                controller: _customController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.customSymbol,
                  hintText: r'$',
                ),
                onChanged: (s) {
                  cubit.setCurrency(Currency(
                    code: Currency.customCode,
                    symbol: s.isEmpty ? r'$' : s,
                  ));
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}