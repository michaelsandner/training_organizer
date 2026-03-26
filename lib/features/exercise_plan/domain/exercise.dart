import 'package:equatable/equatable.dart';
import 'package:training_organizer/features/exercise_plan/domain/exercise_type.dart';

class Exercise with EquatableMixin {
  final int id;
  final String name;
  final String description;
  final ExerciseType type;
  final String? imageName;
  final String unit;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.imageName,
    required this.unit,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: ExerciseType.fromString(json['type'] as String),
      imageName: json['imageName'] as String?,
      unit: json['unit'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'imageName': imageName,
      'unit': unit,
    };
  }

  @override
  List<Object?> get props => [id, name, description, type, imageName, unit];
}
