import 'package:get_it/get_it.dart';
import 'package:training_organizer/data/email_handler.dart';
import 'package:training_organizer/data/file_handler.dart';
import 'package:training_organizer/data/local_storage_repository.dart';
import 'package:training_organizer/data/local_storage_service.dart';
import 'package:training_organizer/data/performance_data_file_handler.dart';
import 'package:training_organizer/domain/filter_trainees_usecase.dart';
import 'package:training_organizer/domain/send_email_usecase.dart';
import 'package:training_organizer/features/exercise_plan/data/exercise_data_repository.dart';
import 'package:training_organizer/features/exercise_plan/domain/exercise_repository.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // Data layer
  getIt.registerLazySingleton<LocalStorageRepository>(
      () => LocalStorageService());
  getIt.registerLazySingleton<EmailHandler>(() => EmailHandler());
  getIt.registerLazySingleton<FileExporter>(() => FileExporter());
  getIt.registerLazySingleton<PerformanceDataFileHandler>(
      () => PerformanceDataFileHandler());
  getIt.registerLazySingleton<ExerciseRepository>(
      () => ExerciseDataRepository());

  // Domain layer
  getIt.registerFactory<FilterTraineesUseCase>(() => FilterTraineesUseCase());
  getIt.registerFactory<SendEmailUseCase>(
      () => SendEmailUseCase(getIt<EmailHandler>()));
}
