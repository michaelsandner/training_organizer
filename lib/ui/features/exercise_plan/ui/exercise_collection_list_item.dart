import 'package:flutter/material.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_plan_collection.dart';
import 'package:training_organizer/ui/features/exercise_plan/ui/exercise_plan_delete_dialog.dart';

class ExerciseCollectionListItem extends StatelessWidget {
  final ExercisePlanCollection collection;
  final VoidCallback onDelete;
  final bool isSelected;
  final VoidCallback? onTap;

  const ExerciseCollectionListItem({
    super.key,
    required this.collection,
    required this.onDelete,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.blue.shade100 : null,
      child: ListTile(
        title: Text(collection.name),
        subtitle: Text(collection.planString),
        selected: isSelected,
        onTap: onTap,
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => const ExercisePlanDeleteDialog(),
            );
            if (confirmed == true) {
              onDelete();
            }
          },
        ),
      ),
    );
  }
}
