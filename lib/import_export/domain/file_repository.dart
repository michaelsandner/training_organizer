import 'package:training_organizer/model/trainee.dart';

abstract interface class FileRepository {
  Future<List<Trainee>> importTrainees();
  Future<void> exportTrainees(List<Trainee> trainees);

  /// Exports the list of attendees of the rescue certification as a CSV file.
  /// The CSV file will contain the all necessary collumns to import it to the BRK Dokumentengenerator
  Future<void> exportCertificationAttendeesAsCsv(
      List<Trainee> trainees, String qualificationSuffix);
}
