import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tip_splitter/l10n/app_localizations.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../common/tip_percent_selector.dart';

class DefaultTipCard extends StatelessWidget {
  const DefaultTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    final pct = context.select<SettingsCubit, double>((c) => c.state.defaultTipPct);
    return TipPercentSelector(
      label: AppLocalizations.of(context)!.defaultTip,
      value: pct,
      onChanged: context.read<SettingsCubit>().setDefaultTipPct,
      sliderMin: 1.0,
    );
  }
}
