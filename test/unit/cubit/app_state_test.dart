import 'package:flutter_test/flutter_test.dart';
import 'package:training_organizer/cubit/app_state.dart';
import 'package:training_organizer/model/trainee.dart';

void main() {
  group('AppState', () {
    group('Given each trainee has an email adress', () {
      group('When getAllEmailAdresses', () {
        test('Then all email adresses should be returned', () {
          final inputState = AppState(
            trainees: [
              Trainee(email: 'aaa@b.de'),
              Trainee(email: 'bbb@a.de'),
            ],
            selectedTrainees: const [],
            selectedGroup: FilterableGroup.all,
          );

          expect(inputState.getAllEmailAdresses(), ['aaa@b.de', 'bbb@a.de']);
        });
      });
    });
  });
}
