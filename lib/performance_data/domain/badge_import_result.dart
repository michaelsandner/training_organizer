import 'package:equatable/equatable.dart';

class BadgeImportEntry with EquatableMixin {
  final String targetCategoryName;
  final int count;
  final String beschreibung;

  const BadgeImportEntry({
    required this.targetCategoryName,
    required this.count,
    this.beschreibung = '',
  });

  @override
  List<Object?> get props => [targetCategoryName, count, beschreibung];
}

class BadgeImportResult with EquatableMixin {
  final List<BadgeImportEntry> entries;

  const BadgeImportResult({required this.entries});

  @override
  List<Object?> get props => [entries];
}
