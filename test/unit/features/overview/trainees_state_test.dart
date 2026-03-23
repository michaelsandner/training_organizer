import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/features/overview/trainees_state.dart';
import 'package:training_organizer/model/trainee.dart';

void main() {
  group('TraineesState', () {
    group('Given each trainee has an email adress', () {
      group('When getAllEmailAdresses', () {
        test('Then all email adresses should be returned', () {
          final inputState = TraineesState(
            trainees: [
              Trainee(email: 'aaa@b.de'),
              Trainee(email: 'bbb@a.de'),
            ],
          );

          expect(inputState.getAllEmailAdresses(), ['aaa@b.de', 'bbb@a.de']);
        });
      });
    });
  });
}
