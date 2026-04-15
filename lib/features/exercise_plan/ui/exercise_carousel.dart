import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_carousel_item.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_carousel_page_indicator.dart';

class ExerciseCarousel extends StatefulWidget {
  final List<Exercise> exercises;
  final int selectedExerciseId;
  final ExerciseType selectedType;
  final int distance;
  final ValueChanged<int> onExerciseChanged;
  final ValueChanged<int> onDistanceChanged;

  const ExerciseCarousel({
    super.key,
    required this.exercises,
    required this.selectedExerciseId,
    required this.selectedType,
    required this.distance,
    required this.onExerciseChanged,
    required this.onDistanceChanged,
  });

  @override
  State<ExerciseCarousel> createState() => _ExerciseCarouselState();
}

class _ExerciseCarouselState extends State<ExerciseCarousel> {
  late PageController _pageController;
  late int _currentPage;
  Key _pageViewKey = UniqueKey();

  int get _initialPage {
    final idx = widget.exercises
        .indexWhere((e) => e.id == widget.selectedExerciseId);
    if (widget.exercises.isEmpty) return 0;
    if (idx < 0) return 0;
    return idx.clamp(0, widget.exercises.length - 1);
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
  void didUpdateWidget(covariant ExerciseCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedType != widget.selectedType) {
      _resetPageController();
    } else if (oldWidget.selectedExerciseId != widget.selectedExerciseId) {
      final newPage = _initialPage;
      if (newPage != _currentPage) {
        _resetPageController();
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.exercises.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Keine Übungen für diesen Typ vorhanden'),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 200,
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
              itemCount: widget.exercises.length,
              onPageChanged: (page) {
                setState(() => _currentPage = page);
                widget.onExerciseChanged(widget.exercises[page].id);
              },
              itemBuilder: (context, pageIndex) {
                if (pageIndex < 0 || pageIndex >= widget.exercises.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ExerciseCarouselItem(
                    exercise: widget.exercises[pageIndex],
                    distance: widget.distance,
                    color: widget.selectedType.color,
                    onDistanceChanged: widget.onDistanceChanged,
                  ),
                );
              },
            ),
          ),
        ),
        if (widget.exercises.length > 1)
          ExerciseCarouselPageIndicator(
            pageCount: widget.exercises.length,
            currentPage: _currentPage,
            color: widget.selectedType.color,
          ),
      ],
    );
  }
}
