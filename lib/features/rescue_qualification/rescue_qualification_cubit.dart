import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/features/overview/trainees_state.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/features/rescue_qualification/rescue_qualification_state.dart';

class RescueQualificationCubit extends Cubit<RescueQualificationState> {
  RescueQualificationCubit() : super(RescueQualificationState.initial());

  void setFilter(FilterableGroup filter) {
    emit(state.copyWith(selectedFilter: filter));
  }

  void setQualification(RescueQualificationType qualification) {
    emit(state.copyWith(selectedQualification: qualification));
  }

  void toggleTraineeSelection(Trainee trainee) {
    final updated = Set<Trainee>.from(state.selectedTrainees);
    if (updated.contains(trainee)) {
      updated.remove(trainee);
    } else {
      updated.add(trainee);
    }
    emit(state.copyWith(selectedTrainees: updated));
  }
}
