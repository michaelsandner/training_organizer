import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/app_drawer.dart';
import 'package:training_organizer/blocklist/ui/pdf_view.dart';
import 'package:training_organizer/data/file_handler.dart';
import 'package:training_organizer/data/local_storage_repository.dart';
import 'package:training_organizer/data/performance_data_file_handler.dart';
import 'package:training_organizer/di/service_locator.dart';
import 'package:training_organizer/domain/usecases/filter_trainees_usecase.dart';
import 'package:training_organizer/domain/usecases/send_email_usecase.dart';
import 'package:training_organizer/features/edit/trainee_view.dart';
import 'package:training_organizer/features/email/email_cubit.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_repository.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_cubit.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_page.dart';
import 'package:training_organizer/features/overview/selection/filter_trainees_cubit.dart';
import 'package:training_organizer/features/overview/trainees_cubit.dart';
import 'package:training_organizer/features/performance_data/performance_data_cubit.dart';
import 'package:training_organizer/features/statistic/statistics_view.dart';
import 'package:training_organizer/import_export/ui/file_cubit.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) {
          return TraineesCubit(
            localStorageRepository: getIt<LocalStorageRepository>(),
          )..init();
        }),
        BlocProvider(
            lazy: false,
            create: (context) {
              final filterCubit =
                  FilterTraineesCubit(getIt<FilterTraineesUseCase>());
              context.read<TraineesCubit>().setFilterTraineesCubit(filterCubit);
              return filterCubit;
            }),
        BlocProvider(
          create: (context) {
            return FileCubit(getIt<FileExporter>());
          },
        ),
        BlocProvider(create: (context) {
          return EmailCubit(getIt<SendEmailUseCase>());
        }),
        BlocProvider(
          create: (context) => PerformanceDataCubit(
            getIt<PerformanceDataFileHandler>(),
            localStorageRepository: getIt<LocalStorageRepository>(),
          )..init(),
        ),
        BlocProvider(
          create: (context) => ExercisePlanCubit(
            getIt<ExerciseRepository>(),
            localStorageRepository: getIt<LocalStorageRepository>(),
          )..init(),
        ),
      ],
      child: MaterialApp(
        title: 'Training Organizer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Training Organizer'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return const SizedBox(
                  width: double.infinity,
                  child: TabBar(
                    isScrollable: false,
                    tabs: [
                      Tab(
                        icon: Icon(Icons.accessibility),
                        text: 'Mitglieder',
                      ),
                      Tab(
                        icon: Icon(Icons.document_scanner),
                        text: 'Blocklisten',
                      ),
                      Tab(
                        icon: Icon(Icons.list),
                        text: 'Statistik',
                      ),
                      Tab(
                        icon: Icon(Icons.fitness_center),
                        text: 'Trainingsplan',
                      ),
                    ],
                    labelPadding: EdgeInsets.zero,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                );
              },
            ),
          ),
        ),
        drawer: const AppDrawer(),
        body: Center(
          child: TabBarView(
            children: [
              const TraineeView(),
              PdfView(),
              const StatisticsView(),
              const ExercisePlanPage(),
            ],
          ),
        ),
      ),
    );
  }
}
