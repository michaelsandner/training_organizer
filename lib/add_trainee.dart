import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/app_cubit.dart';
import 'package:training_organizer/app_state.dart';
import 'package:training_organizer/trainee.dart';

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
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte Email angeben';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(hintText: 'Tel.'),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte Tel. angeben';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: dateOfBirthController,
                decoration: const InputDecoration(hintText: 'Geb. Datum'),
                keyboardType: TextInputType.datetime,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte Geburtsdatum angeben';
                  }

                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (formKey.currentState!.validate()) {
                        final newTrainee = Trainee(
                            forename: foreNameController.text,
                            surname: sureNameController.text,
                            email: emailController.text,
                            dateOfBirth: dateOfBirthController.text,
                            trainingGroup: Group.waitingList);
                        cubit.addTrainee(newTrainee);
                        foreNameController.clear();
                        sureNameController.clear();
                        emailController.clear();
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
