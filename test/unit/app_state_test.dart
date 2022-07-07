import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/app_state.dart';
import 'package:training_organizer/trainee.dart';

void main() {
  test('get all email adresses', () {
    final inputState = AppState(trainees: [
      Trainee(email: 'aaa@b.de'),
      Trainee(email: 'bbb@a.de'),
    ]);

    expect(inputState.getAllEmailAdresses(), ['aaa@b.de', 'bbb@a.de']);
  });
}
