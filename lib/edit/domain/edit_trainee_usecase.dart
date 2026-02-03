import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/trainee.dart';

class EditTraineeUsecase {
  final List<Trainee> _trainees;
  EditTraineeUsecase(this._trainees);

  List<Trainee> addTrainee(Trainee trainee) {
    if (_trainees.contains(trainee)) {
      return _trainees;
    }
    _trainees.add(trainee);
    return _trainees;
  }

  List<Trainee> removeTrainee(Trainee trainee) {
    _trainees.removeWhere((element) => element == trainee);
    return _trainees;
  }

  void changeTraineeGroup(Trainee trainee, Group newGroup) {
    _trainees.removeWhere((element) => element == trainee);
    _trainees.add(trainee.copyWithNewGroup(newGroup));
  }
}
