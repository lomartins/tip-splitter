import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tip_splitter/l10n/app_localizations.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../../bloc/tip/tip_bloc.dart';
import '../../../bloc/tip/tip_event.dart';
import '../../common/currency_input_formatter.dart';

class BillAmountCard extends StatefulWidget {
  const BillAmountCard({super.key});

  @override
  State<BillAmountCard> createState() => _BillAmountCardState();
}

class _BillAmountCardState extends State<BillAmountCard> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final symbol = context.select<SettingsCubit, String>(
      (c) => c.state.currency.symbol,
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.billAmount,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [CurrencyInputFormatter()],
              style: const TextStyle(fontSize: 36),
              decoration: InputDecoration(
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsetsGeometry.directional(start: 12.0),
                  child: Text(
                    '$symbol ',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w400,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                hintText: '0.00',
                hintStyle: TextStyle(color: colorScheme.outline),
              ),
              onChanged: (v) {
                final digitsOnly = v.replaceAll(RegExp(r'[^\d]'), '');
                final cents = int.tryParse(digitsOnly) ?? 0;
                context.read<TipBloc>().add(BillChanged(cents));
              },
            ),
          ],
        ),
      ),
    );
  }
}
