import 'package:flutter/material.dart';

class IcalImportRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlighted;

  const IcalImportRow({
    super.key,
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: highlighted ? FontWeight.bold : FontWeight.normal,
              color: highlighted ? Colors.blue : null,
            ),
          ),
        ],
      ),
    );
  }
}
