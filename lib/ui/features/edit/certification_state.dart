import 'package:equatable/equatable.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';

class CertificationState with EquatableMixin {
  final List<Qualification> qualifications;

  const CertificationState({this.qualifications = const []});

  CertificationState copyWith({
    List<Qualification>? qualifications,
  }) {
    return CertificationState(
      qualifications: qualifications ?? this.qualifications,
    );
  }

  @override
  List<Object?> get props => [qualifications];
}
