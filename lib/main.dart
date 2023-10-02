import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/cubit/app_cubit.dart';
import 'package:training_organizer/cubit/file_cubit.dart';
import 'package:training_organizer/view/pdf_view/pdf_view.dart';
import 'package:training_organizer/view/statistics_view/statistics_view.dart';
import 'package:training_organizer/view/trainee_view/trainee_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit()..init(),
        ),
        BlocProvider(
          create: (context) => FileCubit(),
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
  const MyHomePage({Key? key, required this.title}) : super(key: key);
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
