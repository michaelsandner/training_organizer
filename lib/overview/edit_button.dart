import 'package:flutter/material.dart';
import 'package:training_organizer/edit/ui/add_trainee.dart';
import 'package:training_organizer/model/trainee.dart';

class EditButton extends StatefulWidget {
  final Trainee trainee;

  const EditButton({required this.trainee, super.key});

  @override
  State<EditButton> createState() => _EditButtonState();
}

class _EditButtonState extends State<EditButton> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    _emailController.text = widget.trainee.email;
    _phoneController.text = widget.trainee.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddTrainee(
                    trainee: widget.trainee,
                  ))),
      icon: const Icon(Icons.edit),
      color: Colors.orange,
    );
  }
}
