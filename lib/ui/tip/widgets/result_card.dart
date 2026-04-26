import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tip_splitter/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../../bloc/tip/tip_bloc.dart';
import '../../../bloc/tip/tip_state.dart';

class ResultCard extends StatefulWidget {
  const ResultCard({super.key});

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _sizeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 80),
      vsync: this,
    );
    _sizeAnim = Tween<double>(begin: 52.0, end: 54.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _pop() {
    _controller.forward(from: 0).then((_) {
      if (mounted) _controller.reverse();
    });
  }

  String _fmt(int v, String symbol) {
    final f = NumberFormat.currency(symbol: '$symbol ', decimalDigits: 2);
    return f.format(v / 100);
  }

  @override
  Widget build(BuildContext context) {
    final symbol =
        context.select<SettingsCubit, String>((c) => c.state.currency.symbol);
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<TipBloc, TipState>(
      listenWhen: (prev, curr) =>
          prev.result.perPerson != curr.result.perPerson,
      listener: (_, state) => _pop(),
      builder: (context, state) {
        final result = state.result;
        final tipPct = state.tipPct.toStringAsFixed(0);

        return Card(
          clipBehavior: Clip.hardEdge,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          color: colorScheme.primary,
          elevation: 2,
          child: Stack(
            children: [
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    color: Color(0x14FFFFFF),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -20,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: Color(0x0DFFFFFF),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.eachPersonPays,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedBuilder(
                      animation: _sizeAnim,
                      builder: (context, _) => Text(
                        _fmt(result.perPerson, symbol),
                        style: TextStyle(
                          fontSize: _sizeAnim.value,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: -1,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _divider(),
                    const SizedBox(height: 12),
                    _detailRow(AppLocalizations.of(context)!.bill, _fmt(state.bill, symbol)),
                    const SizedBox(height: 4),
                    _detailRow(AppLocalizations.of(context)!.tipWithPct(tipPct), _fmt(result.tipAmount, symbol)),
                    const SizedBox(height: 8),
                    _divider(),
                    const SizedBox(height: 8),
                    _detailRow(
                      AppLocalizations.of(context)!.total,
                      _fmt(result.total, symbol),
                      labelBold: true,
                      valueLarge: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _divider() => Container(
        height: 1,
        color: Colors.white.withValues(alpha: 0.2),
      );

  Widget _detailRow(
    String label,
    String value, {
    bool labelBold = false,
    bool valueLarge = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: labelBold
                ? Colors.white
                : Colors.white.withValues(alpha: 0.75),
            fontWeight: labelBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: valueLarge ? 17 : 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
