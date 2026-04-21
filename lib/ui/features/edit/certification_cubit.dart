import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/ui/features/edit/certification_state.dart';
import 'package:training_organizer/model/qualifications.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';
import 'package:training_organizer/model/trainee.dart';

class CertificationCubit extends Cubit<CertificationState> {
  final QualificationFactory _qualificationFactory;

  QualificationFactory get qualificationFactory => _qualificationFactory;

  CertificationCubit(Trainee? trainee, this._qualificationFactory)
      : super(
          CertificationState(
            qualifications: trainee != null
                ? List<Qualification>.from(
                    trainee.qualifications.qualifications)
                : [],
          ),
        );

  void addQualification(String name, DateTime? date) {
    final qualification = _qualificationFactory.createQualification(name, date);
    final updatedList = [...state.qualifications, qualification];
    emit(CertificationState(qualifications: updatedList));
  }

  void removeQualification(int index) {
    final updatedList = List<Qualification>.from(state.qualifications);
    updatedList.removeAt(index);
    emit(CertificationState(qualifications: updatedList));
  }

  void reset() => emit(const CertificationState());

  Qualifications getQualifications() {
    return Qualifications(qualifications: state.qualifications);
  }
}
