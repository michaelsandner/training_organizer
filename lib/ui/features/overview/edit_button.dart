import 'package:flutter/material.dart';
import 'package:training_organizer/ui/features/edit/add_trainee.dart';
import 'package:training_organizer/model/trainee.dart';

class EditButton extends StatelessWidget {
  final Trainee trainee;

  const EditButton({required this.trainee, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddTrainee(
                    trainee: trainee,
                  ))),
      icon: const Icon(Icons.edit),
      color: Colors.orange,
    );
  }
}
