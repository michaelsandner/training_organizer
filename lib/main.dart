import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/app_drawer.dart';
import 'package:training_organizer/blocklist/ui/pdf_view.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/edit/ui/trainee_view.dart';
import 'package:training_organizer/email/adpater/email_handler.dart';
import 'package:training_organizer/email/domain/send_email_usecase.dart';
import 'package:training_organizer/email/ui/email_cubit.dart';
import 'package:training_organizer/import_export/adapter/file_handler.dart';
import 'package:training_organizer/import_export/ui/file_cubit.dart';
import 'package:training_organizer/statistic/ui/statistics_view.dart';

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
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) {
              final sendEmailUseCase =
                  SendEmailUseCase(context.read<EmailHandler>());
              return AppCubit(sendEmailUseCase)..init();
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
