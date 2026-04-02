import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/features/overview/trainees_state.dart';
import 'package:training_organizer/data/local_storage_repository.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/model/training_group.dart';
import 'package:training_organizer/features/overview/selection/filter_trainees_cubit.dart';

class TraineesCubit extends Cubit<TraineesState> {
  final LocalStorageRepository? _localStorageRepository;
  FilterTraineesCubit? _filterTraineesCubit;

  TraineesCubit({
    LocalStorageRepository? localStorageRepository,
  })  : _localStorageRepository = localStorageRepository,
        super(TraineesState.initial());

  void setFilterTraineesCubit(FilterTraineesCubit filterTraineesCubit) {
    _filterTraineesCubit = filterTraineesCubit;
  }

  Future<void> init() async {
    if (_localStorageRepository != null) {
      final trainees = await _localStorageRepository.loadTrainees();
      if (trainees != null && trainees.isNotEmpty) {
        emit(state.copyWith(trainees: trainees));
        _filterTraineesCubit?.setSelectedGroup(FilterableGroup.all, trainees);
      }
    }
  }

  void updateTraineeList(List<Trainee> trainees) {
    emit(state.copyWith(trainees: trainees));
    _saveTrainees(trainees);
    _filterTraineesCubit?.setSelectedGroup(FilterableGroup.all, trainees);
  }

  void processTrainee(Trainee? oldTrainee, Trainee newTrainee) {
    if (oldTrainee == null) {
      addTrainee(newTrainee);
    } else {
      replaceTrainee(oldTrainee, newTrainee);
    }
  }

  void addTrainee(Trainee trainee) {
    final updatedTraineeList = [...state.trainees];

    if (state.trainees.contains(trainee)) {
      return;
    }
    updatedTraineeList.add(trainee);

    emit(state.copyWith(trainees: updatedTraineeList));
    _saveTrainees(updatedTraineeList);
    _filterTraineesCubit?.setSelectedGroup(
        FilterableGroup.all, updatedTraineeList);
  }

  void removeTrainee(Trainee trainee) {
    final selectedGroup =
        _filterTraineesCubit?.state.selectedGroup ?? FilterableGroup.all;
    final updatedTraineeList = [...state.trainees];
    updatedTraineeList.removeWhere((element) => element == trainee);
    emit(state.copyWith(trainees: updatedTraineeList));
    _saveTrainees(updatedTraineeList);
    _filterTraineesCubit?.setSelectedGroup(selectedGroup, updatedTraineeList);
  }

  void replaceTrainee(Trainee oldTrainee, Trainee newTrainee) {
    final selectedGroup =
        _filterTraineesCubit?.state.selectedGroup ?? FilterableGroup.all;
    final updatedTraineeList = [...state.trainees];
    final index =
        updatedTraineeList.indexWhere((element) => element == oldTrainee);
    if (index >= 0) {
      updatedTraineeList[index] = newTrainee;
    } else {
      updatedTraineeList.add(newTrainee);
    }
    emit(state.copyWith(trainees: updatedTraineeList));
    _saveTrainees(updatedTraineeList);
    _filterTraineesCubit?.setSelectedGroup(selectedGroup, updatedTraineeList);
  }

  bool isDowngradePossible(Trainee trainee) {
    return trainee.trainingGroup != Group.waitingList &&
        trainee.trainingGroup != Group.group5;
  }

  bool isUpgradePossible(Trainee trainee) {
    return trainee.trainingGroup != Group.leisure;
  }

  void upgradeTrainee(Trainee trainee) {
    _changeTraineeGroup(trainee, getUpgradedGroup(trainee.trainingGroup));
  }

  void downgradeTrainee(Trainee trainee) {
    _changeTraineeGroup(trainee, getDowngradedGroup(trainee.trainingGroup));
  }

  void _changeTraineeGroup(Trainee trainee, Group newGroup) {
    final currentList = [...state.trainees];

    currentList.removeWhere((element) => element == trainee);
    currentList.add(trainee.copyWithNewGroup(newGroup));

    emit(state.copyWith(trainees: currentList));
    _saveTrainees(currentList);
    if (_filterTraineesCubit != null) {
      _filterTraineesCubit!.setSelectedGroup(
        _filterTraineesCubit!.getFilteredGroup(newGroup),
        currentList,
      );
    }
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

  String getNameForGroupEnum(Group? group) {
    final current =
        trainingGroups.singleWhere((element) => element.group == group);
    return current.name;
  }

  void _saveTrainees(List<Trainee> trainees) {
    // Fire-and-forget: save failures do not affect in-memory state
    _localStorageRepository?.saveTrainees(trainees);
  }
}
