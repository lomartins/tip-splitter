import 'package:flutter/material.dart';
import 'package:tip_splitter/l10n/app_localizations.dart';

import '../settings/settings_screen.dart';
import 'widgets/bill_amount_card.dart';
import 'widgets/people_card.dart';
import 'widgets/result_card.dart';
import 'widgets/tip_percent_card.dart';

class TipScreen extends StatelessWidget {
  const TipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Builder(
          builder: (context) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.receipt_long,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Text(AppLocalizations.of(context)!.appTitle,
                  style: const TextStyle(fontWeight: FontWeight.w400)),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const SettingsScreen(),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            BillAmountCard(),
            SizedBox(height: 12),
            TipPercentCard(),
            SizedBox(height: 12),
            PeopleCard(),
            SizedBox(height: 12),
            ResultCard(),
          ],
        ),
      ),
    );
  }
}
