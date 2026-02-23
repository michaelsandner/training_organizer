import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/trainee.dart';

class TraineesFilterService {
  static List<Trainee> getTraineesOfGroup(List<Trainee> trainees, Group group) {
    return trainees.where((element) => element.trainingGroup == group).toList();
  }

  static List<Trainee> getAllSaturdayTrainees(List<Trainee> trainees) {
    return trainees
        .where((element) =>
            element.trainingGroup == Group.group1 ||
            element.trainingGroup == Group.group2 ||
            element.trainingGroup == Group.group3 ||
            element.trainingGroup == Group.group4 ||
            element.trainingGroup == Group.group5)
        .toList();
  }

  static List<Trainee> getAllKids(List<Trainee> trainees) {
    return trainees
        .where((element) =>
            element.trainingGroup == Group.group1 ||
            element.trainingGroup == Group.group2 ||
            element.trainingGroup == Group.group3 ||
            element.trainingGroup == Group.group4 ||
            element.trainingGroup == Group.group5 ||
            element.trainingGroup == Group.wednesday)
        .toList();
  }

  static List<Trainee> getAllTrainers(List<Trainee> trainees) {
    return trainees.where((element) => element.isTrainer).toList();
  }

  static int getCountOfTraineesWithQualification(
      List<Trainee> trainees, String qualification) {
    return trainees
        .where(
            (element) => element.qualifications.hasQualification(qualification))
        .length;
  }
}
