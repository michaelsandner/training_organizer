import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/edit/domain/add_qualification_usecase.dart';
import 'package:training_organizer/edit/ui/certification_cubit.dart';
import 'package:training_organizer/edit/ui/create_certification.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/services/date_service.dart';

class AddTrainee extends StatefulWidget {
  /// null if new trainee is added
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

  late final CertificationCubit _certificationCubit;

  bool isMember = false;
  bool isTrainer = false;

  @override
  void initState() {
    super.initState();
    _certificationCubit =
        CertificationCubit(widget.trainee, AddQualificationUseCase());
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
      isMember = widget.trainee!.isMember;
      isTrainer = widget.trainee!.isTrainer;
    }
  }

  @override
  void dispose() {
    _certificationCubit.close();
    super.dispose();
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
      isMember = false;
      isTrainer = false;
      _certificationCubit.reset();
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

    Trainee createTraineeFromInputs() {
      return Trainee(
        forename: foreNameController.text.trim(),
        surname: sureNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        dateOfBirth:
            DateService.formatToGerman(dateOfBirthController.text.trim()),
        registrationDate:
            DateService.formatToGerman(registrationDateController.text.trim()),
        comment: commentController.text.trim(),
        trainingGroup: group ?? Group.waitingList,
        qualifications:
            _certificationCubit.createQualifications(widget.trainee),
        isMember: isMember,
        isTrainer: isTrainer,
      );
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

    return BlocProvider<CertificationCubit>.value(
      value: _certificationCubit,
      child: Scaffold(
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
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FilterChip(
                      selected: isMember,
                      label: const Text('ist Mitglied'),
                      onSelected: (bool value) => setState(() {
                        isMember = value;
                      }),
                    ),
                    const SizedBox(width: 10),
                    FilterChip(
                      selected: isTrainer,
                      label: const Text('ist Trainer*in'),
                      onSelected: (bool value) => setState(() {
                        isTrainer = value;
                      }),
                    ),
                  ],
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
                const CreateCertification(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: onPressed,
                        child: widget.trainee != null
                            ? const Text('Editieren')
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
      ),
    );
  }
}
