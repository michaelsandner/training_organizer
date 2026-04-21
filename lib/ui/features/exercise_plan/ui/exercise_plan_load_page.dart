import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/ui/features/exercise_plan/ui/exercise_collection_cubit.dart';
import 'package:training_organizer/ui/features/exercise_plan/ui/exercise_collection_list_item.dart';
import 'package:training_organizer/ui/features/exercise_plan/ui/exercise_collection_state.dart';

class ExercisePlanLoadPage extends StatefulWidget {
  const ExercisePlanLoadPage({super.key});

  @override
  State<ExercisePlanLoadPage> createState() => _ExercisePlanLoadPageState();
}

class _ExercisePlanLoadPageState extends State<ExercisePlanLoadPage> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainingsplan laden'),
      ),
      body: BlocBuilder<ExerciseCollectionCubit, ExerciseCollectionState>(
        builder: (context, state) {
          return Column(
            children: [
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
                            isSelected: _selectedIndex == index,
                            onTap: () {
                              setState(() {
                                _selectedIndex =
                                    _selectedIndex == index ? null : index;
                              });
                            },
                            onDelete: () {
                              context
                                  .read<ExerciseCollectionCubit>()
                                  .deleteCollection(index);
                              if (_selectedIndex == index) {
                                setState(() {
                                  _selectedIndex = null;
                                });
                              } else if (_selectedIndex != null &&
                                  _selectedIndex! > index) {
                                setState(() {
                                  _selectedIndex = _selectedIndex! - 1;
                                });
                              }
                            },
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _selectedIndex == null
                        ? null
                        : () {
                            final collection =
                                state.collections[_selectedIndex!];
                            Navigator.of(context).pop(collection.planString);
                          },
                    child: const Text('Laden'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
