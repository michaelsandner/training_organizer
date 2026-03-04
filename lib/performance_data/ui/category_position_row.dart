import 'package:flutter/material.dart';
import 'package:training_organizer/performance_data/domain/category_position.dart';

/// A single editable row for a [CategoryPosition].
class CategoryPositionRow extends StatelessWidget {
  final CategoryPosition position;
  final int index;
  final Color accentColor;
  final List<int> categoryPath;
  final void Function(List<int> categoryPath, int positionIndex,
      CategoryPosition updatedPosition) onChanged;
  final void Function(List<int> categoryPath, int positionIndex) onRemoved;

  const CategoryPositionRow({
    super.key,
    required this.position,
    required this.index,
    required this.accentColor,
    required this.categoryPath,
    required this.onChanged,
    required this.onRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: TextFormField(
              key: ValueKey('pos_anz_${categoryPath.join('_')}_$index'),
              initialValue: position.anzahl.toString(),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
              decoration: const InputDecoration(
                labelText: 'Anz.',
                labelStyle: TextStyle(fontSize: 10),
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              ),
              onChanged: (value) {
                final parsed = int.tryParse(value);
                if (parsed != null) {
                  onChanged(
                      categoryPath, index, position.copyWith(anzahl: parsed));
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              key: ValueKey('pos_tn_${categoryPath.join('_')}_$index'),
              initialValue: position.teilnehmende,
              decoration: const InputDecoration(
                labelText: 'Teilnehmende',
                labelStyle: TextStyle(fontSize: 10),
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              onFieldSubmitted: (value) {
                onChanged(categoryPath, index,
                    position.copyWith(teilnehmende: value));
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              key: ValueKey('pos_desc_${categoryPath.join('_')}_$index'),
              initialValue: position.beschreibung,
              decoration: const InputDecoration(
                labelText: 'Beschreibung',
                labelStyle: TextStyle(fontSize: 10),
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              onFieldSubmitted: (value) {
                onChanged(categoryPath, index,
                    position.copyWith(beschreibung: value));
              },
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline,
                color: Colors.red, size: 20),
            tooltip: 'Position entfernen',
            onPressed: () => onRemoved(categoryPath, index),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
