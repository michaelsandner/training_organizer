import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/ui/features/performance_data/performance_category_tile.dart';
import 'package:training_organizer/ui/features/performance_data/performance_data_cubit.dart';
import 'package:training_organizer/ui/features/performance_data/performance_data_empty_state.dart';
import 'package:training_organizer/ui/features/performance_data/performance_data_state.dart';

class PerformanceDataBody extends StatelessWidget {
  final PerformanceDataState state;

  const PerformanceDataBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.showLoadingSpinner) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.performanceData == null) {
      return const PerformanceDataEmptyState();
    }

    final categories = state.performanceData!.categories;
    if (categories.isEmpty) {
      return const Center(
        child: Text(
          'Keine Kategorien in der Datei gefunden.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return PerformanceCategoryTile(
          category: categories[index],
          path: [index],
          level: 0,
          onPositionChanged: (categoryPath, positionIndex, updatedPosition) {
            context.read<PerformanceDataCubit>().updatePosition(
                  categoryPath,
                  positionIndex,
                  updatedPosition,
                );
          },
          onPositionAdded: (categoryPath) {
            context.read<PerformanceDataCubit>().addPosition(categoryPath);
          },
          onPositionRemoved: (categoryPath, positionIndex) {
            context
                .read<PerformanceDataCubit>()
                .removePosition(categoryPath, positionIndex);
          },
        );
      },
    );
  }
}
