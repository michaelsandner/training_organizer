import 'package:intl/intl.dart';

class Trainee {
  final String surname;
  final String forename;
  final String email;
  final DateTime? dateOfBirth;
  final String? trainingGroup;

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  Trainee({
    this.surname = '',
    this.forename = '',
    this.email = '',
    this.dateOfBirth,
    this.trainingGroup,
  });

  factory Trainee.fromJson(dynamic json) {
    return Trainee(
        surname: json['surname'] ?? '',
        forename: json['forename'] ?? '',
        email: json['email'] ?? '',
        dateOfBirth: json['dateOfBirth'] != null
            ? DateTime.parse(json['dateOfBirth'])
            : null,
        trainingGroup: json['trainingGroup']);
  }

  Map<String, dynamic> toJson() => {
        'surname': surname,
        'forename': forename,
        'email': email,
        'dateOfBirth':
            dateOfBirth != null ? formatter.format(dateOfBirth!) : null,
        'trainingGroup': trainingGroup,
      };
}
