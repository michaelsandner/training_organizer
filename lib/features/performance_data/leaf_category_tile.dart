import 'package:flutter/material.dart';
import 'package:training_organizer/domain/category_position.dart';
import 'package:training_organizer/domain/performance_category.dart';
import 'package:training_organizer/features/performance_data/category_positions_list.dart';
import 'package:training_organizer/features/performance_data/performance_category_tile.dart';

class LeafCategoryTile extends StatelessWidget {
  final PerformanceCategory category;
  final List<int> path;
  final int level;
  final void Function(List<int> categoryPath, int positionIndex,
      CategoryPosition updatedPosition) onPositionChanged;
  final void Function(List<int> categoryPath) onPositionAdded;
  final void Function(List<int> categoryPath, int positionIndex)
      onPositionRemoved;

  const LeafCategoryTile({
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
      padding: EdgeInsets.only(left: level * 20.0, top: 2, bottom: 2, right: 4),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: _accentColor.withAlpha(60)),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: Icon(Icons.drag_indicator, color: _accentColor, size: 20),
            title: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(fontSize: 14),
                      ),
                      if (category.hint != null && category.hint!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Tooltip(
                            message: category.hint!,
                            child: Icon(
                              Icons.info_outline,
                              size: 16,
                              color: _accentColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _accentColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _accentColor.withAlpha(80)),
                  ),
                  child: Text(
                    '${category.anzahl ?? 0}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _accentColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            initiallyExpanded: false,
            children: [
              CategoryPositionsList(
                positionen: category.positionen,
                categoryPath: path,
                accentColor: _accentColor,
                onPositionChanged: onPositionChanged,
                onPositionAdded: onPositionAdded,
                onPositionRemoved: onPositionRemoved,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
