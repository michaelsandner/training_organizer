import 'package:equatable/equatable.dart';
import 'package:training_organizer/domain/performance_data/category_position.dart';

/// A single category in the performance data hierarchy.
/// May contain sub-categories (children) or be a leaf element (anzahl != null).
/// Leaf elements can additionally hold a list of [CategoryPosition] items.
class PerformanceCategory with EquatableMixin {
  final String name;
  final int? anzahl;
  final String? hint;
  final List<PerformanceCategory> children;
  final List<CategoryPosition> positionen;

  const PerformanceCategory({
    required this.name,
    this.anzahl,
    this.hint,
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
      hint: children.isEmpty ? json['hint'] as String? : null,
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
    if (isLeaf && hint != null) {
      map['hint'] = hint;
    }
    if (isLeaf && positionen.isNotEmpty) {
      map['positionen'] = positionen.map((p) => p.toJson()).toList();
    }
    return map;
  }

  PerformanceCategory copyWith({
    String? name,
    int? anzahl,
    String? hint,
    List<PerformanceCategory>? children,
    List<CategoryPosition>? positionen,
  }) {
    return PerformanceCategory(
      name: name ?? this.name,
      anzahl: anzahl ?? this.anzahl,
      hint: hint ?? this.hint,
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

  /// Recursively searches for a leaf category with the given [name].
  int? findCountByName(String name) {
    if (isLeaf && this.name == name) return anzahl ?? 0;
    for (final child in children) {
      final result = child.findCountByName(name);
      if (result != null) return result;
    }
    return null;
  }

  /// Adds [amount] to the count of the leaf category with the given [name].
  PerformanceCategory addToCountByName(String name, int amount) {
    if (isLeaf && this.name == name) {
      return copyWith(anzahl: (anzahl ?? 0) + amount);
    }
    if (children.isNotEmpty) {
      final updatedChildren =
          children.map((c) => c.addToCountByName(name, amount)).toList();
      return copyWith(children: updatedChildren);
    }
    return this;
  }

  /// Adds a new [CategoryPosition] to the leaf category with the given [name].
  PerformanceCategory addPositionByName(
    String name,
    CategoryPosition position,
  ) {
    if (isLeaf && this.name == name) {
      final updatedPositionen = List<CategoryPosition>.from(positionen)
        ..add(position);
      final newAnzahl =
          updatedPositionen.fold<int>(0, (sum, p) => sum + p.anzahl);
      return copyWith(positionen: updatedPositionen, anzahl: newAnzahl);
    }
    if (children.isNotEmpty) {
      final updatedChildren =
          children.map((c) => c.addPositionByName(name, position)).toList();
      return copyWith(children: updatedChildren);
    }
    return this;
  }

  @override
  List<Object?> get props => [name, anzahl, hint, children, positionen];
}
