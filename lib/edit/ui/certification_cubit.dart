import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/edit/domain/add_qualification_usecase.dart';
import 'package:training_organizer/edit/ui/certification_state.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/trainee.dart';

class CertificationCubit extends Cubit<CertificationState> {
  final AddQualificationUseCase _addQualificationUseCase;

  CertificationCubit(Trainee? trainee, this._addQualificationUseCase)
      : super(
          trainee != null
              ? CertificationState(
                  isPiratChecked: trainee.hasQualification('Pirat'),
                  isBronzeChecked: trainee.hasQualification('Bronze'),
                  isSilverChecked: trainee.hasQualification('Silber'),
                  isGoldChecked: trainee.hasQualification('Gold'),
                  isRSBronzeChecked:
                      trainee.hasQualification('RettungsschwimmerBronze'),
                )
              : const CertificationState(),
        );

  void togglePirat(bool value) => emit(state.copyWith(isPiratChecked: value));

  void toggleBronze(bool value) => emit(state.copyWith(isBronzeChecked: value));

  void toggleSilber(bool value) => emit(state.copyWith(isSilverChecked: value));

  void toggleGold(bool value) => emit(state.copyWith(isGoldChecked: value));

  void toggleRsBronze(bool value) =>
      emit(state.copyWith(isRSBronzeChecked: value));

  void toggleCurrentQualificationDate(bool value) =>
      emit(state.copyWith(enableCurrentqualificationDate: value));

  void reset() => emit(const CertificationState());

  List<Qualification> createQualifications(Trainee? trainee) {
    return _addQualificationUseCase.execute(
      currentQualifications: trainee?.qualifications ?? [],
      shouldSetCurrentDate: state.enableCurrentqualificationDate,
      shouldAddPirat: state.isPiratChecked,
      shouldAddBronze: state.isBronzeChecked,
      shouldAddSilber: state.isSilverChecked,
      shouldAddGold: state.isGoldChecked,
      shouldAddRsBronze: state.isRSBronzeChecked,
    );
  }
}
