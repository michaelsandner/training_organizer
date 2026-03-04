import 'package:equatable/equatable.dart';
import 'package:training_organizer/performance_data/domain/performance_category.dart';
import 'package:training_organizer/performance_data/domain/category_position.dart';

/// Root object of the performance data.
/// Contains a list of top-level (level 1) categories.
class PerformanceData with EquatableMixin {
  final List<PerformanceCategory> categories;

  const PerformanceData({required this.categories});

  factory PerformanceData.empty() {
    return const PerformanceData(categories: []);
  }

  factory PerformanceData.fromJson(Map<String, dynamic> json) {
    final list = json['categories'] as List<dynamic>? ?? [];
    return PerformanceData(
      categories: list
          .map((e) => PerformanceCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories.map((c) => c.toJson()).toList(),
    };
  }

  PerformanceData copyWith({List<PerformanceCategory>? categories}) {
    return PerformanceData(categories: categories ?? this.categories);
  }

  /// Updates the count of an element identified by its index path.
  PerformanceData updateCount(List<int> path, int newCount) {
    if (path.isEmpty) return this;
    final updatedCategories = List<PerformanceCategory>.from(categories);
    updatedCategories[path.first] =
        updatedCategories[path.first].updateCount(path.sublist(1), newCount);
    return PerformanceData(categories: updatedCategories);
  }

  /// Updates a single position inside a leaf category.
  /// [categoryPath] navigates to the leaf, [positionIndex] selects the position.
  PerformanceData updatePosition(
    List<int> categoryPath,
    int positionIndex,
    CategoryPosition updatedPosition,
  ) {
    if (categoryPath.isEmpty) return this;
    final updatedCategories = List<PerformanceCategory>.from(categories);
    updatedCategories[categoryPath.first] =
        updatedCategories[categoryPath.first].updatePosition(
      categoryPath.sublist(1),
      positionIndex,
      updatedPosition,
    );
    return PerformanceData(categories: updatedCategories);
  }

  /// Adds an empty position to the leaf category at [categoryPath].
  PerformanceData addPosition(List<int> categoryPath) {
    if (categoryPath.isEmpty) return this;
    final updatedCategories = List<PerformanceCategory>.from(categories);
    updatedCategories[categoryPath.first] =
        updatedCategories[categoryPath.first]
            .addPosition(categoryPath.sublist(1));
    return PerformanceData(categories: updatedCategories);
  }

  /// Removes the position at [positionIndex] from the leaf at [categoryPath].
  PerformanceData removePosition(List<int> categoryPath, int positionIndex) {
    if (categoryPath.isEmpty) return this;
    final updatedCategories = List<PerformanceCategory>.from(categories);
    updatedCategories[categoryPath.first] =
        updatedCategories[categoryPath.first]
            .removePosition(categoryPath.sublist(1), positionIndex);
    return PerformanceData(categories: updatedCategories);
  }

  @override
  List<Object?> get props => [categories];
}
