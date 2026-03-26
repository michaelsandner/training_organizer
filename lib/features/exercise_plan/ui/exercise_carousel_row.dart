import 'package:flutter/material.dart';
import 'package:training_organizer/features/exercise_plan/domain/exercise.dart';
import 'package:training_organizer/features/exercise_plan/domain/exercise_type.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_carousel_item.dart';

class ExerciseCarouselRow extends StatelessWidget {
  final int index;
  final ExerciseType selectedType;
  final int selectedExerciseId;
  final int distance;
  final List<Exercise> allExercises;
  final ValueChanged<ExerciseType> onTypeChanged;
  final ValueChanged<int> onExerciseChanged;
  final ValueChanged<int> onDistanceChanged;
  final VoidCallback onRemove;

  const ExerciseCarouselRow({
    super.key,
    required this.index,
    required this.selectedType,
    required this.selectedExerciseId,
    required this.distance,
    required this.allExercises,
    required this.onTypeChanged,
    required this.onExerciseChanged,
    required this.onDistanceChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final exercisesForType =
        allExercises.where((e) => e.type == selectedType).toList();

    final initialPage = exercisesForType
        .indexWhere((e) => e.id == selectedExerciseId)
        .clamp(0, exercisesForType.isEmpty ? 0 : exercisesForType.length - 1);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: selectedType.color, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTypeDropdown(context),
          if (exercisesForType.isNotEmpty)
            _buildCarousel(exercisesForType, initialPage)
          else
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Keine Übungen für diesen Typ vorhanden'),
            ),
        ],
      ),
    );
  }

  Widget _buildTypeDropdown(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: selectedType.color.withAlpha(50),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<ExerciseType>(
              value: selectedType,
              isExpanded: true,
              underline: const SizedBox(),
              items: ExerciseType.values
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: type.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(type.displayName),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: (type) {
                if (type != null) onTypeChanged(type);
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onRemove,
            tooltip: 'Entfernen',
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel(List<Exercise> exercises, int initialPage) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: PageController(initialPage: initialPage),
        itemCount: exercises.length,
        onPageChanged: (page) {
          onExerciseChanged(exercises[page].id);
        },
        itemBuilder: (context, pageIndex) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ExerciseCarouselItem(
              exercise: exercises[pageIndex],
              distance: distance,
              color: selectedType.color,
              onDistanceChanged: onDistanceChanged,
            ),
          );
        },
      ),
    );
  }
}
