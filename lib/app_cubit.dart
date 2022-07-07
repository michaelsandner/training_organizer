import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState.initial());
}
