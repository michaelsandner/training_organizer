import 'package:flutter/material.dart';

class ExercisePlanUnitSummaryRow extends StatelessWidget {
  final Map<String, int> unitSummary;

  const ExercisePlanUnitSummaryRow({
    super.key,
    required this.unitSummary,
  });

  @override
  Widget build(BuildContext context) {
    if (unitSummary.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Wrap(
        spacing: 16,
        children: unitSummary.entries
            .map(
              (e) => Text(
                '${e.value} ${e.key}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
            .toList(),
      ),
    );
  }
}
