import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/ui/features/overview/trainees_state.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/domain/usecases/filter_trainees_usecase.dart';
import 'package:training_organizer/ui/features/overview/selection/filter_trainees_state.dart';

class FilterTraineesCubit extends Cubit<FilterTraineesState> {
  final FilterTraineesUseCase _filterTraineesUseCase;

  FilterTraineesCubit(this._filterTraineesUseCase)
      : super(FilterTraineesState.initial());

  void setSelectedGroup(
      FilterableGroup? selectedValue, List<Trainee> allTrainees) {
    final effectiveGroup = selectedValue ?? FilterableGroup.all;
    final filtered = _filterTraineesUseCase.execute(allTrainees, effectiveGroup);

    emit(state.copyWith(
      selectedGroup: effectiveGroup,
      selectedTrainees: filtered,
    ));
  }

  FilterableGroup getFilteredGroup(Group group) =>
      _filterTraineesUseCase.getFilteredGroup(group);

  Group getGroup(FilterableGroup filterableGroup) =>
      _filterTraineesUseCase.getGroup(filterableGroup);

  String getSelectedGroupName() =>
      _filterTraineesUseCase.getNameForFilteredGroup(state.selectedGroup);

  String getNameForFilteredGroupEnum(FilterableGroup? filterableGroup) =>
      _filterTraineesUseCase.getNameForFilteredGroup(filterableGroup);
}
