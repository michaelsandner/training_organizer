import 'package:flutter/material.dart';
import 'package:training_organizer/performance_data/domain/category_position.dart';
import 'package:training_organizer/performance_data/domain/performance_category.dart';
import 'package:training_organizer/performance_data/ui/performance_category_tile.dart';

class ParentCategoryTile extends StatelessWidget {
  final PerformanceCategory category;
  final List<int> path;
  final int level;
  final void Function(List<int> categoryPath, int positionIndex,
      CategoryPosition updatedPosition) onPositionChanged;
  final void Function(List<int> categoryPath) onPositionAdded;
  final void Function(List<int> categoryPath, int positionIndex)
      onPositionRemoved;

  const ParentCategoryTile({
    super.key,
    required this.category,
    required this.path,
    required this.level,
    required this.onPositionChanged,
    required this.onPositionAdded,
    required this.onPositionRemoved,
  });

  Color get _accentColor => levelColors[level % levelColors.length];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: level * 20.0, top: 4, bottom: 4, right: 4),
      child: Card(
        elevation: level == 0 ? 3 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: _accentColor.withAlpha(80), width: 1),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: Icon(
              level == 0 ? Icons.folder : Icons.subdirectory_arrow_right,
              color: _accentColor,
            ),
            title: Text(
              category.name,
              style: TextStyle(
                fontWeight: level < 2 ? FontWeight.bold : FontWeight.w500,
                fontSize: 16.0 - level * 0.5,
                color: _accentColor,
              ),
            ),
            initiallyExpanded: level < 2,
            children: [
              for (int i = 0; i < category.children.length; i++)
                PerformanceCategoryTile(
                  category: category.children[i],
                  path: [...path, i],
                  level: level + 1,
                  onPositionChanged: onPositionChanged,
                  onPositionAdded: onPositionAdded,
                  onPositionRemoved: onPositionRemoved,
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
