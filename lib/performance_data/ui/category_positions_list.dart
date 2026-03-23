import 'package:flutter/material.dart';
import 'package:training_organizer/domain/category_position.dart';
import 'package:training_organizer/performance_data/ui/category_position_row.dart';

/// Displays a list of positions with a header and an add button.
class CategoryPositionsList extends StatelessWidget {
  final List<CategoryPosition> positionen;
  final List<int> categoryPath;
  final Color accentColor;
  final void Function(List<int> categoryPath, int positionIndex,
      CategoryPosition updatedPosition) onPositionChanged;
  final void Function(List<int> categoryPath) onPositionAdded;
  final void Function(List<int> categoryPath, int positionIndex)
      onPositionRemoved;

  const CategoryPositionsList({
    super.key,
    required this.positionen,
    required this.categoryPath,
    required this.accentColor,
    required this.onPositionChanged,
    required this.onPositionAdded,
    required this.onPositionRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(
                  'Positionen',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.add_circle_outline,
                      color: accentColor, size: 22),
                  tooltip: 'Position hinzufügen',
                  onPressed: () => onPositionAdded(categoryPath),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          for (int i = 0; i < positionen.length; i++)
            CategoryPositionRow(
              position: positionen[i],
              index: i,
              accentColor: accentColor,
              categoryPath: categoryPath,
              onChanged: onPositionChanged,
              onRemoved: onPositionRemoved,
            ),
        ],
      ),
    );
  }
}
