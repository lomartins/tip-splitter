import 'package:flutter/material.dart';

import 'tap_to_edit_field.dart';

class TipPercentSelector extends StatelessWidget {
  const TipPercentSelector({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.sliderMin = 0.0,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final double sliderMin;

  static const _presets = [10.0, 15.0, 20.0];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCustom = !_presets.any((p) => (value - p).abs() < 0.01);
    final selectedPresets = _presets.where((p) => (value - p).abs() < 0.01).toSet();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TapToEditField(
                value: value.toStringAsFixed(0),
                suffix: '%',
                onSubmitted: (s) {
                  final v = double.tryParse(s);
                  if (v != null) onChanged(v);
                },
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isCustom ? colorScheme.primary : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SegmentedButton<double>(
              segments: [
                for (final p in _presets)
                  ButtonSegment(
                    value: p,
                    label: Text('${p.toStringAsFixed(0)}%'),
                  ),
              ],
              selected: selectedPresets,
              emptySelectionAllowed: true,
              onSelectionChanged: (s) {
                if (s.isNotEmpty) onChanged(s.first);
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '${sliderMin.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Slider(
                    value: value.clamp(sliderMin, 50),
                    min: sliderMin,
                    max: 50,
                    divisions: (50 - sliderMin).toInt(),
                    onChanged: onChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '50%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
