import 'package:equatable/equatable.dart';

class ExercisePlanCollection with EquatableMixin {
  final String name;
  final String planString;

  const ExercisePlanCollection({
    required this.name,
    required this.planString,
  });

  factory ExercisePlanCollection.fromJson(Map<String, dynamic> json) {
    return ExercisePlanCollection(
      name: json['name'] as String,
      planString: json['planString'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'planString': planString,
    };
  }

  @override
  List<Object?> get props => [name, planString];
}
