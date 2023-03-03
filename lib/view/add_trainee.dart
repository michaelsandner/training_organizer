import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/trainee.dart';

class AddTrainee extends StatefulWidget {
  @override
  State<AddTrainee> createState() => _AddTraineeState();
}

class _AddTraineeState extends State<AddTrainee> {
  TextEditingController sureNameController = TextEditingController();
  TextEditingController foreNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  Group? group = Group.waitingList;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final cubit = context.read<AppCubit>();

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(children: [
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
                controller: phoneController,
                decoration: const InputDecoration(hintText: 'Tel.'),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              TextFormField(
                controller: dateOfBirthController,
                decoration: const InputDecoration(hintText: 'Geb. Datum'),
                keyboardType: TextInputType.datetime,
              ),
              DropdownButton<Group>(
                value: group,
                items: Group.values
                    .map<DropdownMenuItem<Group>>((Group value) =>
                        DropdownMenuItem(
                            value: value,
                            child: Text(cubit.getNameForGroupEnum(value))))
                    .toList(),
                onChanged: (Group? value) => setState(() {
                  group = value;
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (formKey.currentState!.validate()) {
                        final newTrainee = Trainee(
                            forename: foreNameController.text.trim(),
                            surname: sureNameController.text.trim(),
                            email: emailController.text.trim(),
                            phone: phoneController.text.trim(),
                            dateOfBirth: dateOfBirthController.text.trim(),
                            trainingGroup: group ?? Group.waitingList);
                        cubit.addTrainee(newTrainee);
                        foreNameController.clear();
                        sureNameController.clear();
                        emailController.clear();
                        phoneController.clear();
                        dateOfBirthController.clear();
                        phoneController.clear();
                      }
                    },
                    child: const Text('Hinzufügen')),
              )
            ]),
          ),
        );
      },
    );
  }
}
