import 'package:flutter/material.dart';
import 'package:training_organizer/domain/performance_data/performance_category.dart';
import 'package:training_organizer/domain/performance_data/category_position.dart';
import 'package:training_organizer/ui/features/performance_data/leaf_category_tile.dart';
import 'package:training_organizer/ui/features/performance_data/parent_category_tile.dart';

/// Colours used for the different hierarchy levels in the category tree.
const levelColors = [
  Color(0xFF1565C0),
  Color(0xFF2E7D32),
  Color(0xFFE65100),
  Color(0xFF6A1B9A),
];

/// Widget that displays a single category element in the tree structure.
/// Delegates to [LeafCategoryTile] or [ParentCategoryTile] based on category type.
class PerformanceCategoryTile extends StatelessWidget {
  final PerformanceCategory category;
  final List<int> path;
  final int level;
  final void Function(List<int> categoryPath, int positionIndex,
      CategoryPosition updatedPosition) onPositionChanged;
  final void Function(List<int> categoryPath) onPositionAdded;
  final void Function(List<int> categoryPath, int positionIndex)
      onPositionRemoved;

  const PerformanceCategoryTile({
    super.key,
    required this.category,
    required this.path,
    required this.level,
    required this.onPositionChanged,
    required this.onPositionAdded,
    required this.onPositionRemoved,
  });

  @override
  Widget build(BuildContext context) {
    if (category.isLeaf) {
      return LeafCategoryTile(
        category: category,
        path: path,
        level: level,
        onPositionChanged: onPositionChanged,
        onPositionAdded: onPositionAdded,
        onPositionRemoved: onPositionRemoved,
      );
    }
    return ParentCategoryTile(
      category: category,
      path: path,
      level: level,
      onPositionChanged: onPositionChanged,
      onPositionAdded: onPositionAdded,
      onPositionRemoved: onPositionRemoved,
    );
  }
}
