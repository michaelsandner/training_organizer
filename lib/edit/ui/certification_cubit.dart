import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/edit/domain/add_qualification_usecase.dart';
import 'package:training_organizer/edit/ui/certification_state.dart';
import 'package:training_organizer/model/qualifications.dart';
import 'package:training_organizer/model/trainee.dart';

class CertificationCubit extends Cubit<CertificationState> {
  final AddQualificationUseCase _addQualificationUseCase;

  CertificationCubit(Trainee? trainee, this._addQualificationUseCase)
      : super(
          trainee != null
              ? CertificationState(
                  isPiratChecked:
                      trainee.qualifications.hasQualification('Pirat'),
                  isBronzeChecked:
                      trainee.qualifications.hasQualification('Bronze'),
                  isSilverChecked:
                      trainee.qualifications.hasQualification('Silber'),
                  isGoldChecked:
                      trainee.qualifications.hasQualification('Gold'),
                  isRSBronzeChecked: trainee.qualifications
                      .hasQualification('RettungsschwimmerBronze'),
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

  Qualifications createQualifications(Trainee? trainee) {
    return _addQualificationUseCase.execute(
      currentQualifications: trainee?.qualifications ?? const Qualifications(),
      shouldSetCurrentDate: state.enableCurrentqualificationDate,
      shouldAddPirat: state.isPiratChecked,
      shouldAddBronze: state.isBronzeChecked,
      shouldAddSilber: state.isSilverChecked,
      shouldAddGold: state.isGoldChecked,
      shouldAddRsBronze: state.isRSBronzeChecked,
    );
  }
}
