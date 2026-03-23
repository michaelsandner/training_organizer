import 'package:equatable/equatable.dart';

/// A single position within a leaf category.
/// Contains a count, participants and a description.
class CategoryPosition with EquatableMixin {
  final int anzahl;
  final String teilnehmende;
  final String beschreibung;

  const CategoryPosition({
    this.anzahl = 0,
    this.teilnehmende = '',
    this.beschreibung = '',
  });

  factory CategoryPosition.fromJson(Map<String, dynamic> json) {
    return CategoryPosition(
      anzahl: json['anzahl'] as int? ?? 0,
      teilnehmende: json['teilnehmende'] as String? ?? '',
      beschreibung: json['beschreibung'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'anzahl': anzahl,
      'teilnehmende': teilnehmende,
      'beschreibung': beschreibung,
    };
  }

  CategoryPosition copyWith({
    int? anzahl,
    String? teilnehmende,
    String? beschreibung,
  }) {
    return CategoryPosition(
      anzahl: anzahl ?? this.anzahl,
      teilnehmende: teilnehmende ?? this.teilnehmende,
      beschreibung: beschreibung ?? this.beschreibung,
    );
  }

  @override
  List<Object?> get props => [anzahl, teilnehmende, beschreibung];
}
