import 'package:flutter/material.dart';

class ExerciseViewToggleRow extends StatelessWidget {
  final bool showListView;
  final ValueChanged<bool> onViewChanged;

  const ExerciseViewToggleRow({
    super.key,
    required this.showListView,
    required this.onViewChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          const Text(
            'Ansicht: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ToggleButtons(
            isSelected: [!showListView, showListView],
            onPressed: (index) => onViewChanged(index == 1),
            borderRadius: BorderRadius.circular(8),
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(Icons.swipe, size: 18),
                    SizedBox(width: 4),
                    Text('Swipe'),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(Icons.list, size: 18),
                    SizedBox(width: 4),
                    Text('Liste'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
