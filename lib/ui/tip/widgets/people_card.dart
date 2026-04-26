import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tip_splitter/l10n/app_localizations.dart';

import '../../../bloc/tip/tip_bloc.dart';
import '../../../bloc/tip/tip_event.dart';
import '../../common/tap_to_edit_field.dart';

class PeopleCard extends StatelessWidget {
  const PeopleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final people = context.select<TipBloc, int>((b) => b.state.people);
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.splitBetween,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                TapToEditField(
                  value: people.toString(),
                  suffix: AppLocalizations.of(context)!.personSuffix(people),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  onSubmitted: (s) {
                    final v = int.tryParse(s);
                    if (v != null) {
                      context.read<TipBloc>().add(PeopleChanged(v));
                    }
                  },
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    shape: CircleBorder(
                      side: BorderSide(color: colorScheme.outline),
                    ),
                    foregroundColor: colorScheme.primary,
                  ),
                  onPressed: people > 1
                      ? () => context
                          .read<TipBloc>()
                          .add(const PeopleDecremented())
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 32,
                  child: Text(
                    people.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  style: IconButton.styleFrom(
                    shape: CircleBorder(
                      side: BorderSide(color: colorScheme.outline),
                    ),
                    foregroundColor: colorScheme.primary,
                  ),
                  onPressed: people < 50
                      ? () => context
                          .read<TipBloc>()
                          .add(const PeopleIncremented())
                      : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}