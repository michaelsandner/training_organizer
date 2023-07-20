import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/badge.dart' as badge;
import 'package:training_organizer/model/badge.dart';
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

  late bool isBronzeChecked;
  late bool isSilverChecked;
  late bool isGoldChecked;
  bool enableCurrentBadgeDate = false;

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
      group = widget.trainee!.trainingGroup;
      setState(() {
        isBronzeChecked = widget.trainee!.hasBadge('Bronze');
        isSilverChecked = widget.trainee!.hasBadge('Silber');
        isGoldChecked = widget.trainee!.hasBadge('Gold');
      });
    } else {
      isBronzeChecked = false;
      isSilverChecked = false;
      isGoldChecked = false;
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
      setState(() {
        isBronzeChecked = false;
        isSilverChecked = false;
        isGoldChecked = false;
      });
    }

    Future<void> showAcceptDialog(Trainee newTrainee) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
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
        },
      );
    }

    Future<void> showDeleteDialog() async {
      return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Entfernen'),
              content: Text(
                  'Möchtest du ${foreNameController.text} ${sureNameController.text} wirklich entfernen?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    cubit.removeTrainee(widget.trainee!);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '${foreNameController.text} ${sureNameController.text} entfernt'),
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

    List<Qualification> createBadges() {
      DateTime? date;
      if (enableCurrentBadgeDate) {
        date = DateTime.now();
      }
      List<Qualification> badges = [];
      if (isBronzeChecked) {
        badges.add(Qualification(badgeType: BadgeType.bronze, date: date));
      }
      if (isSilverChecked) {
        badges.add(Qualification(badgeType: BadgeType.silber, date: date));
      }
      if (isGoldChecked) {
        badges.add(Qualification(badgeType: BadgeType.gold, date: date));
      }
      return badges;
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
          trainingGroup: group ?? Group.waitingList,
          badges: createBadges());
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
        child: SingleChildScrollView(
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
                focusColor: Colors.white,
                elevation: 15,
                icon: const Icon(Icons.arrow_downward),
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
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
              SwitchListTile(
                title: const Text(
                    'Setze heutiges Datum als Abnahmedatum für Abzeichen'),
                value: enableCurrentBadgeDate,
                onChanged: (bool value) {
                  setState(() {
                    enableCurrentBadgeDate = value;
                  });
                },
              ),
              CheckboxListTile(
                value: isBronzeChecked,
                title: const Text('Bronze'),
                secondary: BadgeType.bronze.icon,
                onChanged: (bool? value) => setState(() {
                  isBronzeChecked = value! ? value : false;
                }),
              ),
              CheckboxListTile(
                value: isSilverChecked,
                title: const Text('Silber'),
                secondary: BadgeType.silber.icon,
                onChanged: (bool? value) => setState(() {
                  isSilverChecked = value! ? value : false;
                }),
              ),
              CheckboxListTile(
                value: isGoldChecked,
                title: const Text('Gold'),
                secondary: BadgeType.gold.icon,
                onChanged: (bool? value) => setState(() {
                  isGoldChecked = value! ? value : false;
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: onPressed,
                      child: widget.trainee != null
                          ? const Text('Editiren')
                          : const Text('Hinzufügen'),
                    ),
                    if (widget.trainee != null)
                      ElevatedButton(
                        onPressed: showDeleteDialog,
                        child: const Text('Löschen'),
                      )
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
