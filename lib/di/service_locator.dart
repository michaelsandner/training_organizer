import 'package:get_it/get_it.dart';
import 'package:training_organizer/data/email_handler.dart';
import 'package:training_organizer/data/exercise_collection_file_handler.dart';
import 'package:training_organizer/data/file_handler.dart';
import 'package:training_organizer/data/local_storage_repository.dart';
import 'package:training_organizer/data/local_storage_service.dart';
import 'package:training_organizer/data/performance_data_file_handler.dart';
import 'package:training_organizer/domain/repositories/exercise_collection_repository.dart';
import 'package:training_organizer/domain/usecases/filter_trainees_usecase.dart';
import 'package:training_organizer/domain/usecases/send_email_usecase.dart';
import 'package:training_organizer/data/exercise_data_repository.dart';
import 'package:training_organizer/domain/repositories/exercise_repository.dart';

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
  getIt.registerLazySingleton<ExerciseCollectionRepository>(
      () => ExerciseCollectionFileHandler());

  // Domain layer
  getIt.registerFactory<FilterTraineesUseCase>(() => FilterTraineesUseCase());
  getIt.registerFactory<SendEmailUseCase>(
      () => SendEmailUseCase(getIt<EmailHandler>()));
}
