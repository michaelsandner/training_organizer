import 'package:flutter/material.dart';

class ExerciseImagePlaceholder extends StatelessWidget {
  final Color color;
  final double size;
  final double iconSize;
  final double borderRadius;

  const ExerciseImagePlaceholder({
    super.key,
    required this.color,
    this.size = 64,
    this.iconSize = 32,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Icon(
        Icons.pool,
        size: iconSize,
        color: color,
      ),
    );
  }
}
