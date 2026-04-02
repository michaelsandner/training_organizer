import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_list_view.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_body.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_plan_cubit.dart';
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
        );
      },
    );
  }
}
