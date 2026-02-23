import 'package:flutter/material.dart';

class BasicTraineeInfo extends StatelessWidget {
  final TextEditingController foreNameController;
  final TextEditingController sureNameController;
  final TextEditingController emailController;
  final TextEditingController dateOfBirthController;
  final TextEditingController registrationDateController;
  final TextEditingController commentController;

  const BasicTraineeInfo({
    super.key,
    required this.foreNameController,
    required this.sureNameController,
    required this.emailController,
    required this.dateOfBirthController,
    required this.registrationDateController,
    required this.commentController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: foreNameController,
          decoration: const InputDecoration(hintText: 'Vorname'),
          keyboardType: TextInputType.name,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Bitte Vorname angeben';
            }
            return null;
          },
        ),
        TextFormField(
          controller: sureNameController,
          decoration: const InputDecoration(hintText: 'Nachname'),
          keyboardType: TextInputType.name,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Bitte Nachname angeben';
            }
            return null;
          },
        ),
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(hintText: 'Email'),
          keyboardType: TextInputType.emailAddress,
        ),
        TextFormField(
          controller: dateOfBirthController,
          decoration: const InputDecoration(labelText: 'Geb. Datum'),
          readOnly: true,
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              dateOfBirthController.text =
                  '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
            }
          },
        ),
        TextFormField(
          controller: registrationDateController,
          decoration: const InputDecoration(labelText: 'Anmeldedatum'),
          readOnly: true,
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2023),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              registrationDateController.text =
                  '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
            }
          },
        ),
        TextFormField(
          controller: commentController,
          decoration: const InputDecoration(hintText: 'Kommentar'),
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }
}
