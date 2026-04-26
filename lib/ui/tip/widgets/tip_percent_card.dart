import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tip_splitter/l10n/app_localizations.dart';

import '../../../bloc/tip/tip_bloc.dart';
import '../../../bloc/tip/tip_event.dart';
import '../../common/tip_percent_selector.dart';

class TipPercentCard extends StatelessWidget {
  const TipPercentCard({super.key});

  @override
  Widget build(BuildContext context) {
    final tipPct = context.select<TipBloc, double>((b) => b.state.tipPct);
    return TipPercentSelector(
      label: AppLocalizations.of(context)!.tipPercentage,
      value: tipPct,
      onChanged: (v) => context.read<TipBloc>().add(TipPctChanged(v)),
    );
  }
}
