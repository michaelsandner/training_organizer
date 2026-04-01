import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_carousel_item.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_carousel_name_row.dart';

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
  late PageController _pageController;
  late int _currentPage;
  Key _pageViewKey = UniqueKey();

  List<Exercise> get _exercisesForType =>
      widget.allExercises.where((e) => e.type == widget.selectedType).toList();

  int get _initialPage {
    final idx =
        _exercisesForType.indexWhere((e) => e.id == widget.selectedExerciseId);
    if (_exercisesForType.isEmpty) return 0;
    if (idx < 0) return 0;
    return idx.clamp(0, _exercisesForType.length - 1);
  }

  void _resetPageController() {
    _pageController.dispose();
    _currentPage = _initialPage;
    _pageController = PageController(initialPage: _currentPage);
    _pageViewKey = UniqueKey();
  }

  @override
  void initState() {
    super.initState();
    _currentPage = _initialPage;
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void didUpdateWidget(covariant ExerciseCarouselRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedType != widget.selectedType) {
      _resetPageController();
    } else if (oldWidget.selectedExerciseId != widget.selectedExerciseId) {
      final newPage = _initialPage;
      if (newPage != _currentPage) {
        _resetPageController();
      }
    }
    if (oldWidget.collapseAll != widget.collapseAll) {
      setState(() {
        _collapsed = widget.collapseAll;
      });
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      Flexible(
                                        child: Text(
                                          type.displayName,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: (type) {
                          if (type != null) widget.onTypeChanged(type);
                        },
                      ),
                    ),
                    Row(
                      children: [
                        // Collapse/Expand Button
                        IconButton(
                          icon: Icon(_collapsed
                              ? Icons.expand_more
                              : Icons.expand_less),
                          tooltip: _collapsed ? 'Aufklappen' : 'Zuklappen',
                          onPressed: () =>
                              setState(() => _collapsed = !_collapsed),
                        ),
                        // Löschen
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: widget.onRemove,
                          tooltip: 'Entfernen',
                        ),
                      ],
                    ),
                  ],
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

  Widget _buildCarousel(List<Exercise> exercises) {
    if (exercises.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Keine Übungen für diesen Typ vorhanden'),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 140,
          width: double.infinity,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.stylus,
              },
            ),
            child: PageView.builder(
              key: _pageViewKey,
              controller: _pageController,
              itemCount: exercises.length,
              onPageChanged: (page) {
                setState(() => _currentPage = page);
                widget.onExerciseChanged(exercises[page].id);
              },
              itemBuilder: (context, pageIndex) {
                if (pageIndex < 0 || pageIndex >= exercises.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ExerciseCarouselItem(
                    exercise: exercises[pageIndex],
                    distance: widget.distance,
                    color: widget.selectedType.color,
                    onDistanceChanged: widget.onDistanceChanged,
                  ),
                );
              },
            ),
          ),
        ),
        if (exercises.length > 1) _buildPageIndicator(exercises.length),
      ],
    );
  }

  Widget _buildPageIndicator(int pageCount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(pageCount, (index) {
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == _currentPage
                  ? widget.selectedType.color
                  : widget.selectedType.color.withAlpha(80),
            ),
          );
        }),
      ),
    );
  }
}
