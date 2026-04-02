import 'package:flutter/material.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_carousel.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_carousel_name_row.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_carousel_type_row.dart';

class ExerciseCarouselRow extends StatefulWidget {
  final int index;
  final ExerciseType selectedType;
  final int selectedExerciseId;
  final int distance;
  final List<Exercise> allExercises;
  final ValueChanged<ExerciseType> onTypeChanged;
  final ValueChanged<int> onExerciseChanged;
  final ValueChanged<int> onDistanceChanged;
  final VoidCallback onRemove;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final bool collapseAll;

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
    this.onMoveUp,
    this.onMoveDown,
    this.collapseAll = false,
  });

  @override
  State<ExerciseCarouselRow> createState() => _ExerciseCarouselRowState();
}

class _ExerciseCarouselRowState extends State<ExerciseCarouselRow> {
  bool _collapsed = false;

  List<Exercise> get _exercisesForType =>
      widget.allExercises.where((e) => e.type == widget.selectedType).toList();

  @override
  void didUpdateWidget(covariant ExerciseCarouselRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.collapseAll != widget.collapseAll) {
      setState(() {
        _collapsed = widget.collapseAll;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercisesForType = _exercisesForType;
    Exercise? selectedExercise;
    if (exercisesForType.isNotEmpty) {
      selectedExercise = exercisesForType.firstWhere(
        (e) => e.id == widget.selectedExerciseId,
        orElse: () => exercisesForType.first,
      );
    } else {
      selectedExercise = null;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.selectedType.color, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: widget.selectedType.color.withAlpha(50),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExerciseCarouselTypeRow(
                  selectedType: widget.selectedType,
                  onTypeChanged: widget.onTypeChanged,
                  onMoveUp: widget.onMoveUp,
                  onMoveDown: widget.onMoveDown,
                  onRemove: widget.onRemove,
                ),
                const SizedBox(height: 4),
                ExerciseCarouselNameRow(
                  exerciseName:
                      selectedExercise != null ? selectedExercise.name : '-',
                  collapsed: _collapsed,
                  onToggleCollapse: () =>
                      setState(() => _collapsed = !_collapsed),
                ),
              ],
            ),
          ),
          if (!_collapsed)
            if (exercisesForType.isNotEmpty)
              ExerciseCarousel(
                exercises: exercisesForType,
                selectedExerciseId: widget.selectedExerciseId,
                selectedType: widget.selectedType,
                distance: widget.distance,
                onExerciseChanged: widget.onExerciseChanged,
                onDistanceChanged: widget.onDistanceChanged,
              )
            else
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Keine Übungen für diesen Typ vorhanden'),
              ),
        ],
      ),
    );
  }
}
