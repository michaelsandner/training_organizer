import 'package:flutter/material.dart';
import 'package:training_organizer/features/exercise_plan/domain/exercise.dart';
import 'package:training_organizer/features/exercise_plan/domain/exercise_type.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_carousel_item.dart';

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
  State<ExerciseCarouselRow> createState() => _ExerciseCarouselRowState();
}

class _ExerciseCarouselRowState extends State<ExerciseCarouselRow> {
  late PageController _pageController;

  List<Exercise> get _exercisesForType =>
      widget.allExercises.where((e) => e.type == widget.selectedType).toList();

  int get _initialPage => _exercisesForType
      .indexWhere((e) => e.id == widget.selectedExerciseId)
      .clamp(0, _exercisesForType.isEmpty ? 0 : _exercisesForType.length - 1);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void didUpdateWidget(covariant ExerciseCarouselRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedType != widget.selectedType) {
      _pageController.dispose();
      _pageController = PageController(initialPage: _initialPage);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercisesForType = _exercisesForType;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.selectedType.color, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTypeDropdown(context),
          if (exercisesForType.isNotEmpty)
            _buildCarousel(exercisesForType)
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
        color: widget.selectedType.color.withAlpha(50),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<ExerciseType>(
              value: widget.selectedType,
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
                if (type != null) widget.onTypeChanged(type);
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: widget.onRemove,
            tooltip: 'Entfernen',
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel(List<Exercise> exercises) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        itemCount: exercises.length,
        onPageChanged: (page) {
          widget.onExerciseChanged(exercises[page].id);
        },
        itemBuilder: (context, pageIndex) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ExerciseCarouselItem(
              exercise: exercises[pageIndex],
              distance: widget.distance,
              color: widget.selectedType.color,
              onDistanceChanged: widget.onDistanceChanged,
            ),
          );
        },
      ),
    );
  }
}
