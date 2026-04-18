import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_collection_cubit.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_collection_state.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_list_view.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_body.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_cubit.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_export_dialog.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_import_warning_dialog.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_load_page.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_save_page.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_state.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_view_toggle_row.dart';

class ExercisePlanPage extends StatefulWidget {
  const ExercisePlanPage({super.key});

  @override
  State<ExercisePlanPage> createState() => _ExercisePlanPageState();
}

class _ExercisePlanPageState extends State<ExercisePlanPage> {
  bool _collapseAll = false;
  bool _showListView = false;

  void _toggleCollapseAll() {
    setState(() {
      _collapseAll = !_collapseAll;
    });
  }

  void _onSave(BuildContext context) {
    final planString =
        context.read<ExercisePlanCubit>().state.planString;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ExerciseCollectionCubit>(),
          child: ExercisePlanSavePage(currentPlanString: planString),
        ),
      ),
    );
  }

  void _onLoad(BuildContext context) async {
    final planString = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ExerciseCollectionCubit>(),
          child: const ExercisePlanLoadPage(),
        ),
      ),
    );
    if (planString != null && context.mounted) {
      context.read<ExercisePlanCubit>().applyPlanString(planString);
      setState(() {
        _showListView = false;
      });
    }
  }

  void _onExport(BuildContext context) async {
    final fileName = await showDialog<String>(
      context: context,
      builder: (_) => const ExercisePlanExportDialog(),
    );
    if (fileName != null && context.mounted) {
      context.read<ExerciseCollectionCubit>().exportCollections(fileName);
    }
  }

  void _onImport(BuildContext context) async {
    final collectionCubit = context.read<ExerciseCollectionCubit>();
    final hasExisting = collectionCubit.state.collections.isNotEmpty;

    if (hasExisting) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => const ExercisePlanImportWarningDialog(),
      );
      if (confirmed != true) return;
    }

    if (!context.mounted) return;

    await collectionCubit.importCollections();

    if (context.mounted &&
        collectionCubit.state.errorMessage != null) {
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Text(collectionCubit.state.errorMessage!),
          backgroundColor: Colors.red.shade100,
          leading: const Icon(Icons.error_outline, color: Colors.red),
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: const Text('Dismiss'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExercisePlanCubit, ExercisePlanState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.exercises.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_showListView) {
          return Column(
            children: [
              ExerciseViewToggleRow(
                showListView: _showListView,
                onViewChanged: (value) {
                  setState(() {
                    _showListView = value;
                  });
                },
                onSave: () => _onSave(context),
                onLoad: () => _onLoad(context),
                onExport: () => _onExport(context),
                onImport: () => _onImport(context),
              ),
              const Expanded(child: ExerciseListView()),
            ],
          );
        }
        return ExercisePlanBody(
          state: state,
          showListView: _showListView,
          collapseAll: _collapseAll,
          onViewChanged: (value) {
            setState(() {
              _showListView = value;
            });
          },
          onToggleCollapseAll: _toggleCollapseAll,
          onSave: () => _onSave(context),
          onLoad: () => _onLoad(context),
          onExport: () => _onExport(context),
          onImport: () => _onImport(context),
        );
      },
    );
  }
}
