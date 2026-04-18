import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_collection_cubit.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_collection_list_item.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_collection_state.dart';

class ExercisePlanSavePage extends StatefulWidget {
  final String currentPlanString;

  const ExercisePlanSavePage({
    super.key,
    required this.currentPlanString,
  });

  @override
  State<ExercisePlanSavePage> createState() => _ExercisePlanSavePageState();
}

class _ExercisePlanSavePageState extends State<ExercisePlanSavePage> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainingsplan speichern'),
      ),
      body: BlocBuilder<ExerciseCollectionCubit, ExerciseCollectionState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                          hintText: 'Name des Trainingsplans',
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _nameController.text.trim().isEmpty
                          ? null
                          : () {
                              context
                                  .read<ExerciseCollectionCubit>()
                                  .saveCollection(
                                    _nameController.text.trim(),
                                    widget.currentPlanString,
                                  );
                              _nameController.clear();
                              setState(() {});
                            },
                      child: const Text('Speichern'),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: state.collections.isEmpty
                    ? const Center(
                        child: Text('Keine gespeicherten Trainingspläne'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: state.collections.length,
                        itemBuilder: (context, index) {
                          return ExerciseCollectionListItem(
                            collection: state.collections[index],
                            onDelete: () {
                              context
                                  .read<ExerciseCollectionCubit>()
                                  .deleteCollection(index);
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
