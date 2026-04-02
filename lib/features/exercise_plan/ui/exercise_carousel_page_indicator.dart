import 'package:flutter/material.dart';

class ExerciseCarouselPageIndicator extends StatelessWidget {
  final int pageCount;
  final int currentPage;
  final Color color;

  const ExerciseCarouselPageIndicator({
    super.key,
    required this.pageCount,
    required this.currentPage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
              color: index == currentPage ? color : color.withAlpha(80),
            ),
          );
        }),
      ),
    );
  }
}
