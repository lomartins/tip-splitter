import 'package:flutter/material.dart';
import 'package:tip_splitter/l10n/app_localizations.dart';

import 'widgets/currency_card.dart';
import 'widgets/default_tip_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            CurrencyCard(),
            SizedBox(height: 12),
            DefaultTipCard(),
          ],
        ),
      ),
    );
  }
}
