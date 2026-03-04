import 'package:equatable/equatable.dart';
import 'package:training_organizer/performance_data/domain/category_position.dart';

/// A single category in the performance data hierarchy.
/// May contain sub-categories (children) or be a leaf element (anzahl != null).
/// Leaf elements can additionally hold a list of [CategoryPosition] items.
class PerformanceCategory with EquatableMixin {
  final String name;
  final int? anzahl;
  final List<PerformanceCategory> children;
  final List<CategoryPosition> positionen;

  const PerformanceCategory({
    required this.name,
    this.anzahl,
    this.children = const [],
    this.positionen = const [],
  });

  bool get isLeaf => children.isEmpty;

  factory PerformanceCategory.fromJson(Map<String, dynamic> json) {
    final childrenJson = json['children'] as List<dynamic>?;
    final children = childrenJson
            ?.map(
                (e) => PerformanceCategory.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final positionenJson = json['positionen'] as List<dynamic>?;
    final positionen = positionenJson
            ?.map((e) => CategoryPosition.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    // When positions exist, the count is derived from their sum.
    int? anzahl;
    if (children.isEmpty) {
      if (positionen.isNotEmpty) {
        anzahl = positionen.fold<int>(0, (sum, p) => sum + p.anzahl);
      } else {
        anzahl = json['anzahl'] as int?;
      }
    }

    return PerformanceCategory(
      name: json['name'] as String,
      anzahl: anzahl,
      children: children,
      positionen: children.isEmpty ? positionen : const [],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'name': name};
    if (children.isNotEmpty) {
      map['children'] = children.map((c) => c.toJson()).toList();
    }
    if (isLeaf && anzahl != null) {
      map['anzahl'] = anzahl;
    }
    if (isLeaf && positionen.isNotEmpty) {
      map['positionen'] = positionen.map((p) => p.toJson()).toList();
    }
    return map;
  }

  PerformanceCategory copyWith({
    String? name,
    int? anzahl,
    List<PerformanceCategory>? children,
    List<CategoryPosition>? positionen,
  }) {
    return PerformanceCategory(
      name: name ?? this.name,
      anzahl: anzahl ?? this.anzahl,
      children: children ?? this.children,
      positionen: positionen ?? this.positionen,
    );
  }

  /// Recursively updates the count at the given remaining path.
  /// The [categoryPath] is a list of indices that navigates through the children to the target category.
  PerformanceCategory updateCount(List<int> categoryPath, int newCount) {
    if (categoryPath.isEmpty) {
      return copyWith(anzahl: newCount);
    }
    final updatedChildren = List<PerformanceCategory>.from(children);
    updatedChildren[categoryPath.first] = updatedChildren[categoryPath.first]
        .updateCount(categoryPath.sublist(1), newCount);
    return copyWith(children: updatedChildren);
  }

  /// Recursively navigates [categoryPath] to the leaf, then updates
  /// the position at [positionIndex] with [updatedPosition].
  PerformanceCategory updatePosition(
    List<int> categoryPath,
    int positionIndex,
    CategoryPosition updatedPosition,
  ) {
    if (categoryPath.isEmpty) {
      final updatedPositionen = List<CategoryPosition>.from(positionen);
      updatedPositionen[positionIndex] = updatedPosition;
      final newAnzahl =
          updatedPositionen.fold<int>(0, (sum, p) => sum + p.anzahl);
      return copyWith(positionen: updatedPositionen, anzahl: newAnzahl);
    }
    final updatedChildren = List<PerformanceCategory>.from(children);
    updatedChildren[categoryPath.first] = updatedChildren[categoryPath.first]
        .updatePosition(
            categoryPath.sublist(1), positionIndex, updatedPosition);
    return copyWith(children: updatedChildren);
  }

  /// Recursively navigates [categoryPath] to the leaf, then appends
  /// a new empty [CategoryPosition].
  PerformanceCategory addPosition(List<int> categoryPath) {
    if (categoryPath.isEmpty) {
      final updatedPositionen = List<CategoryPosition>.from(positionen)
        ..add(const CategoryPosition());
      final newAnzahl =
          updatedPositionen.fold<int>(0, (sum, p) => sum + p.anzahl);
      return copyWith(positionen: updatedPositionen, anzahl: newAnzahl);
    }
    final updatedChildren = List<PerformanceCategory>.from(children);
    updatedChildren[categoryPath.first] = updatedChildren[categoryPath.first]
        .addPosition(categoryPath.sublist(1));
    return copyWith(children: updatedChildren);
  }

  /// Recursively navigates [categoryPath] to the leaf, then removes
  /// the position at [positionIndex].
  PerformanceCategory removePosition(
    List<int> categoryPath,
    int positionIndex,
  ) {
    if (categoryPath.isEmpty) {
      final updatedPositionen = List<CategoryPosition>.from(positionen)
        ..removeAt(positionIndex);
      final newAnzahl =
          updatedPositionen.fold<int>(0, (sum, p) => sum + p.anzahl);
      return copyWith(positionen: updatedPositionen, anzahl: newAnzahl);
    }
    final updatedChildren = List<PerformanceCategory>.from(children);
    updatedChildren[categoryPath.first] = updatedChildren[categoryPath.first]
        .removePosition(categoryPath.sublist(1), positionIndex);
    return copyWith(children: updatedChildren);
  }

  @override
  List<Object?> get props => [name, anzahl, children, positionen];
}
