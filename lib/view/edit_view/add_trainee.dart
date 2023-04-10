import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/services/date_service.dart';

class AddTrainee extends StatefulWidget {
  final Trainee? trainee;
  const AddTrainee({this.trainee});

  @override
  State<AddTrainee> createState() => _AddTraineeState();
}

class _AddTraineeState extends State<AddTrainee> {
  TextEditingController sureNameController = TextEditingController();
  TextEditingController foreNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController registrationDateController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  Group? group = Group.waitingList;

  @override
  void initState() {
    super.initState();

    if (widget.trainee != null) {
      sureNameController.text = widget.trainee!.surname;
      foreNameController.text = widget.trainee!.forename;
      emailController.text = widget.trainee!.email;
      dateOfBirthController.text =
          DateService.parseToDate(widget.trainee!.dateOfBirth).toString();
      phoneController.text = widget.trainee!.phone;
      registrationDateController.text =
          DateService.parseToDate(widget.trainee!.registrationDate).toString();
      commentController.text = widget.trainee!.comment;
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final cubit = context.read<AppCubit>();

    void clearInputControllers() {
      foreNameController.clear();
      sureNameController.clear();
      emailController.clear();
      phoneController.clear();
      dateOfBirthController.clear();
      registrationDateController.clear();
      phoneController.clear();
      commentController.clear();
    }

    Future<void> showAcceptDialog(Trainee newTrainee) async {
      return showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Änderung'),
              content: Text(
                  'Möchtest du die Änderungen für ${foreNameController.text} ${sureNameController.text} durchführen?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    cubit.processTrainee(widget.trainee, newTrainee);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '${foreNameController.text} ${sureNameController.text} geändert'),
                      ),
                    );
                    clearInputControllers();
                  },
                  child: const Text('Ja'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Nein'),
                ),
              ],
            );
          });
    }

    Trainee createTraineeFromInputs() {
      return Trainee(
          forename: foreNameController.text.trim(),
          surname: sureNameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          dateOfBirth:
              DateService.formatToGerman(dateOfBirthController.text.trim()),
          registrationDate: DateService.formatToGerman(
              registrationDateController.text.trim()),
          comment: commentController.text.trim(),
          trainingGroup: group ?? Group.waitingList);
    }

    void onPressed() async {
      // Validate will return true if the form is valid, or false if
      // the form is invalid.
      if (formKey.currentState!.validate()) {
        final newTrainee = createTraineeFromInputs();

        if (widget.trainee == null) {
          cubit.processTrainee(widget.trainee, newTrainee);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${foreNameController.text} ${sureNameController.text} hinzugefügt'),
            ),
          );
          clearInputControllers();
        } else {
          await showAcceptDialog(newTrainee);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: widget.trainee == null
            ? const Text('Hinzufügen')
            : const Text('Bearbeiten'),
      ),
      body: Padding(
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
            DateTimePicker(
              dateMask: 'dd.MM.yyyy',
              initialDate: DateTime.now(),
              lastDate: DateTime.now(),
              firstDate: DateTime(1950),
              dateLabelText: 'Geb. Datum',
              controller: dateOfBirthController,
            ),
            DateTimePicker(
              dateMask: 'dd.MM.yyyy',
              initialDate: DateTime.now(),
              lastDate: DateTime.now(),
              firstDate: DateTime(2023),
              dateLabelText: 'Anmeldedatum',
              controller: registrationDateController,
            ),
            TextFormField(
              controller: commentController,
              decoration: const InputDecoration(hintText: 'Kommentar'),
              keyboardType: TextInputType.multiline,
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
                  onPressed: onPressed,
                  child: widget.trainee != null
                      ? const Text('Editiren')
                      : const Text('Hinzufügen')),
            )
          ]),
        ),
      ),
    );
  }
}
