import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/app_drawer.dart';
import 'package:training_organizer/blocklist/ui/pdf_view.dart';
import 'package:training_organizer/features/overview/trainees_cubit.dart';
import 'package:training_organizer/data/email_handler.dart';
import 'package:training_organizer/data/file_handler.dart';
import 'package:training_organizer/data/local_storage_service.dart';
import 'package:training_organizer/data/performance_data_file_handler.dart';
import 'package:training_organizer/features/edit/trainee_view.dart';
import 'package:training_organizer/domain/send_email_usecase.dart';
import 'package:training_organizer/features/email/email_cubit.dart';
import 'package:training_organizer/import_export/ui/file_cubit.dart';
import 'package:training_organizer/domain/filter_trainees_usecase.dart';
import 'package:training_organizer/features/overview/selection/filter_trainees_cubit.dart';
import 'package:training_organizer/features/performance_data/performance_data_cubit.dart';
import 'package:training_organizer/features/statistic/statistics_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => EmailHandler()),
          RepositoryProvider(create: (context) => FileExporter()),
          RepositoryProvider(create: (context) => PerformanceDataFileHandler()),
          RepositoryProvider(create: (context) => LocalStorageService()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) {
              return TraineesCubit(
                localStorageRepository: context.read<LocalStorageService>(),
              )..init();
            }),
            BlocProvider(
                lazy: false,
                create: (context) {
                  final filterCubit =
                      FilterTraineesCubit(FilterTraineesUseCase());
                  context
                      .read<TraineesCubit>()
                      .setFilterTraineesCubit(filterCubit);
                  return filterCubit;
                }),
            BlocProvider(
              create: (context) {
                return FileCubit(context.read<FileExporter>());
              },
            ),
            BlocProvider(create: (context) {
              final sendEmail = SendEmailUseCase(context.read<EmailHandler>());
              return EmailCubit(sendEmail);
            }),
            BlocProvider(
              create: (context) => PerformanceDataCubit(
                context.read<PerformanceDataFileHandler>(),
                localStorageRepository: context.read<LocalStorageService>(),
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
        ));
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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: const TabBar(tabs: [
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
          ]),
        ),
        drawer: const AppDrawer(),
        body: Center(
          child: TabBarView(
            children: [
              const TraineeView(),
              PdfView(),
              const StatisticsView(),
            ],
          ),
        ),
      ),
    );
  }
}
