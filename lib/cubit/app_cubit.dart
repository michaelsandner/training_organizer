import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/model/training_group.dart';
import 'package:training_organizer/services/file_service.dart';
import 'package:url_launcher/url_launcher.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState.initial());

  void init() {
    emit(state.copyWith(selectedTrainees: state.trainees));
  }

  void addTrainee(Trainee trainee) {
    final updatedTraineeList = [...state.trainees];

    if (state.trainees.contains(trainee)) {
      return;
    }
    updatedTraineeList.add(trainee);

    emit(state.copyWith(trainees: updatedTraineeList));
    setSelectedGroup(FilterableGroup.all);
  }

  void editTrainee(Trainee trainee, String? newPhone, String? newEmail) {
    final selectedGrouop = state.selectedGroup;
    List<Trainee> updatedTraineeList = [...state.trainees];
    updatedTraineeList.removeWhere((element) => element == trainee);
    updatedTraineeList.add(trainee.copyWith(phone: newPhone, email: newEmail));
    emit(state.copyWith(trainees: updatedTraineeList));
    setSelectedGroup(FilterableGroup.active);
    setSelectedGroup(selectedGrouop);
  }

  bool isDowngradePossible(Trainee trainee) {
    return trainee.trainingGroup != Group.waitingList &&
        trainee.trainingGroup != Group.group5;
  }

  bool isUpgradePossible(Trainee trainee) {
    return trainee.trainingGroup != Group.active;
  }

  void upgradeTrainee(Trainee trainee) {
    final currentList = [...state.trainees];

    currentList.removeWhere((element) => element == trainee);

    final updatedTrainee =
        trainee.copyWithNewGroup(getUpgradedGroup(trainee.trainingGroup));

    currentList.add(updatedTrainee);

    emit(state.copyWith(
      trainees: currentList,
    ));
    setSelectedGroup(getFilteredGroup(updatedTrainee.trainingGroup));
  }

  void downgradeTrainee(Trainee trainee) {
    var currentList = [...state.trainees];

    currentList.removeWhere((element) => element == trainee);

    final updatedTrainee =
        trainee.copyWithNewGroup(getDowngradedGroup(trainee.trainingGroup));

    currentList.add(updatedTrainee);

    emit(state.copyWith(
      trainees: currentList,
    ));
    setSelectedGroup(getFilteredGroup(updatedTrainee.trainingGroup));
  }

  Future<void> loadFile() async {
    String? json = await FileService.importFile();

    if (json != null) {
      Map<String, dynamic> inputMap = jsonDecode(json);

      var list = inputMap['trainees'] as List;
      List<Trainee> traineeList = list.map((t) => Trainee.fromJson(t)).toList();

      emit(state.copyWith(trainees: traineeList));
      setSelectedGroup(FilterableGroup.all);
    }
  }

  Future<void> saveFile() async {
    Map<String, dynamic> map = {
      'trainees': state.trainees,
    };
    String json = jsonEncode(map);

    await FileService.exportFile(json);
  }

  Group getUpgradedGroup(Group currentGroup) {
    final current =
        trainingGroups.singleWhere((element) => element.group == currentGroup);
    if (current.nextGroup == null) {
      return currentGroup;
    }
    return current.nextGroup!;
  }

  Group getDowngradedGroup(Group currentGroup) {
    final current =
        trainingGroups.singleWhere((element) => element.group == currentGroup);
    if (current.lastGroup == null) {
      return currentGroup;
    }
    return current.lastGroup!;
  }

  void setSelectedGroup(FilterableGroup? selectedValue) {
    if (selectedValue == null || selectedValue == FilterableGroup.all) {
      emit(state.copyWith(
          selectedGroup: selectedValue, selectedTrainees: state.trainees));
    } else {
      final filteredItems = state.trainees
          .where((element) => element.trainingGroup == getGroup(selectedValue))
          .toList();

      if (selectedValue != FilterableGroup.waitingList) {
        filteredItems.sort((a, b) => a.surname.compareTo(b.surname));
      }

      emit(state.copyWith(
          selectedGroup: selectedValue, selectedTrainees: filteredItems));
    }
  }

  FilterableGroup getFilteredGroup(Group group) {
    switch (group) {
      case Group.waitingList:
        return FilterableGroup.waitingList;
      case Group.group1:
        return FilterableGroup.group1;
      case Group.group2:
        return FilterableGroup.group2;
      case Group.group3:
        return FilterableGroup.group3;
      case Group.group4:
        return FilterableGroup.group4;
      case Group.group5:
        return FilterableGroup.group5;
      case Group.wednesday:
        return FilterableGroup.wednesday;
      case Group.active:
        return FilterableGroup.active;
    }
  }

  Group getGroup(FilterableGroup filterableGroup) {
    switch (filterableGroup) {
      case FilterableGroup.waitingList:
        return Group.waitingList;
      case FilterableGroup.group1:
        return Group.group1;
      case FilterableGroup.group2:
        return Group.group2;
      case FilterableGroup.group3:
        return Group.group3;
      case FilterableGroup.group4:
        return Group.group4;
      case FilterableGroup.group5:
        return Group.group5;
      case FilterableGroup.wednesday:
        return Group.wednesday;
      case FilterableGroup.active:
        return Group.active;
      default:
        return Group.waitingList;
    }
  }

  String getSelectedGroupName() {
    return getNameForFilteredGroupEnum(state.selectedGroup);
  }

  String getNameForFilteredGroupEnum(FilterableGroup? filterableGroup) {
    if (filterableGroup == null || filterableGroup == FilterableGroup.all) {
      return 'All';
    }

    final group = getGroup(filterableGroup);

    final current =
        trainingGroups.singleWhere((element) => element.group == group);
    return current.name;
  }

  String getNameForGroupEnum(Group? group) {
    final current =
        trainingGroups.singleWhere((element) => element.group == group);
    return current.name;
  }

  Future<void> sendMailToSelectedGroup() async {
    String email = '';
    for (var element in state.selectedTrainees) {
      email += ',${element.email}';
    }

    final Uri uri = Uri.parse('mailto:$email');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> sendMail(String email, String foreName) async {
    Uri uri = Uri.parse('mailto:$email');

    if (state.selectedGroup == FilterableGroup.waitingList) {
      final String subject = Uri.encodeComponent(
          'Aufnahme für das Schimmtraining der Wasserwacht Langenzenn');
      final String body = Uri.encodeComponent('''hallo zusammen :)
        leider hat es etwas gedauert aber nun freuen wir uns euch mitteilen zu dürfen, dass $foreName endlich bei uns im Schwimmtraining mitmachen darf.
        Dafür würden wir $foreName gerne zum Schnuppertraining am XXX um 17:00 Uhr am Hallenbad Langenzenn einladen.
        Wir treffen uns kurz vorher um ein paar Fragen auszutauschen und gemeinsam die Abläufe zu erklären.
        Bitte gebt uns bescheid ob ihr noch Interesse habt und ob ihr am Termin teilnehmen könnt.

        Viele Grüße

        Euer Wasserwacht-Team
         ''');
      uri = Uri.parse('mailto:$email?subject=$subject&body=$body');
    }
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> sendMailAccecptedToWaitingList(
      String email, String foreName) async {
    Uri uri = Uri.parse('mailto:$email');
    final String subject =
        Uri.encodeComponent('Bestätigung Aufnahme Warteliste OG Langenzenn');
    final String body = Uri.encodeComponent('''hallo zusammen,
        hiermit bestätigen wir euch die Aufnahme von $foreName auf unsere Warteliste zum .

        Viele Grüße

        Euer Wasserwacht-Team
         ''');
    uri = Uri.parse('mailto:$email?subject=$subject&body=$body');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
