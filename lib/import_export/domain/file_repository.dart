import 'package:training_organizer/model/trainee.dart';

abstract interface class FileRepository {
  Future<List<Trainee>> importTrainees();
  Future<void> exportTrainees(List<Trainee> trainees);
}
