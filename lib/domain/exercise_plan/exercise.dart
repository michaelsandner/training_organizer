import 'package:equatable/equatable.dart';
import 'package:training_organizer/domain/exercise_plan/exercise_type.dart';

class Exercise with EquatableMixin {
  final int id;
  final String name;
  final String description;
  final ExerciseType type;
  final String? imageName;
  final String? link;
  final String unit;
  final String? material;
  final String? varianten;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.imageName,
    this.link,
    required this.unit,
    this.material,
    this.varianten,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: ExerciseType.fromString(json['type'] as String),
      imageName: json['imageName'] as String?,
      link: json['link'] as String?,
      unit: json['unit'] as String? ?? '',
      material: json['material'] as String?,
      varianten: json['varianten'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.toStorageString(),
      'imageName': imageName,
      'link': link,
      'unit': unit,
      'material': material,
      'varianten': varianten,
    };
  }

  @override
  List<Object?> get props =>
      [id, name, description, type, imageName, link, unit, material, varianten];
}
