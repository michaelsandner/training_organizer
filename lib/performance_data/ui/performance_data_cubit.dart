import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/data/performance_data_file_handler.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/performance_data/domain/badge_import_result.dart';
import 'package:training_organizer/performance_data/domain/category_position.dart';
import 'package:training_organizer/performance_data/domain/ical_parser/ical_parser.dart';
import 'package:training_organizer/performance_data/ui/performance_data_state.dart';

class PerformanceDataCubit extends Cubit<PerformanceDataState> {
  final PerformanceDataFileHandler _fileHandler;
  final IcalParser _icalParser;

  PerformanceDataCubit(this._fileHandler, {IcalParser? icalParser})
      : _icalParser = icalParser ?? IcalParser(),
        super(PerformanceDataState.initial());

  Future<void> importData() async {
    try {
      emit(state.copyWith(showLoadingSpinner: true, errorMessage: null));
      final data = await _fileHandler.importPerformanceData();
      if (data != null) {
        emit(state.copyWith(
          performanceData: data,
          showLoadingSpinner: false,
        ));
      } else {
        emit(state.copyWith(showLoadingSpinner: false));
      }
    } catch (e) {
      emit(state.copyWith(
        showLoadingSpinner: false,
        errorMessage: 'Import fehlgeschlagen: ${e.toString()}',
      ));
    }
  }

  Future<void> exportData() async {
    final data = state.performanceData;
    if (data == null) return;

    try {
      await _fileHandler.exportPerformanceData(data);
      emit(state.copyWith(
        exportState: PerformanceDataExportState.exportSuccessful,
      ));
    } catch (e) {
      emit(state.copyWith(
        exportState: PerformanceDataExportState.exportFailed,
        errorMessage: 'Export fehlgeschlagen: ${e.toString()}',
      ));
    } finally {
      emit(state.copyWith(
        exportState: PerformanceDataExportState.none,
      ));
    }
  }

  void updateCount(List<int> path, int newCount) {
    final data = state.performanceData;
    if (data == null) return;

    final updatedData = data.updateCount(path, newCount);
    emit(state.copyWith(performanceData: updatedData));
  }

  /// Updates a single position inside a leaf category.
  void updatePosition(List<int> categoryPath, int positionIndex,
      CategoryPosition updatedPosition) {
    final data = state.performanceData;
    if (data == null) return;

    final updatedData =
        data.updatePosition(categoryPath, positionIndex, updatedPosition);
    emit(state.copyWith(performanceData: updatedData));
  }

  /// Adds a new empty position to a leaf category.
  void addPosition(List<int> categoryPath) {
    final data = state.performanceData;
    if (data == null) return;

    final updatedData = data.addPosition(categoryPath);
    emit(state.copyWith(performanceData: updatedData));
  }

  /// Removes a position from a leaf category.
  void removePosition(List<int> categoryPath, int positionIndex) {
    final data = state.performanceData;
    if (data == null) return;

    final updatedData = data.removePosition(categoryPath, positionIndex);
    emit(state.copyWith(performanceData: updatedData));
  }

  void setSelectedYear(int year) {
    emit(state.copyWith(selectedYear: year));
  }

  Future<void> importIcal() async {
    try {
      final content = await _pickIcalFile();
      if (content == null) return;

      final result = _icalParser.parse(content, state.selectedYear);
      emit(state.copyWith(icalImportResult: result));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'iCal-Import fehlgeschlagen: ${e.toString()}',
      ));
    }
  }

  void applyIcalImport() {
    final data = state.performanceData;
    final result = state.icalImportResult;
    if (data == null || result == null) return;

    var updatedData = data;
    // Aggregate entries by target category and description
    final aggregated = <String, _AggregatedEntry>{};
    for (final entry in result.applyEntries) {
      if (entry.value > 0) {
        final key = '${entry.targetCategoryName}|${entry.beschreibung}';
        final existing = aggregated[key];
        if (existing != null) {
          aggregated[key] = _AggregatedEntry(
            targetCategoryName: entry.targetCategoryName,
            value: existing.value + entry.value,
            beschreibung: [existing.beschreibung, entry.beschreibung]
                .where((s) => s.isNotEmpty)
                .toSet()
                .join(', '),
            teilnehmende: [existing.teilnehmende, entry.teilnehmende]
                .where((s) => s.isNotEmpty)
                .toSet()
                .join(', '),
          );
        } else {
          aggregated[key] = _AggregatedEntry(
            targetCategoryName: entry.targetCategoryName,
            value: entry.value,
            beschreibung: entry.beschreibung,
            teilnehmende: entry.teilnehmende,
          );
        }
      }
    }
    for (final entry in aggregated.values) {
      updatedData = updatedData.addPositionByName(
        entry.targetCategoryName,
        CategoryPosition(
          anzahl: entry.value,
          teilnehmende: entry.teilnehmende,
          beschreibung: entry.beschreibung,
        ),
      );
    }

    emit(state.copyWith(
      performanceData: updatedData,
      clearIcalImportResult: true,
    ));
  }

  void dismissIcalImport() {
    emit(state.copyWith(clearIcalImportResult: true));
  }

  void importBadges(List<Trainee> trainees) {
    if (trainees.isEmpty) {
      emit(state.copyWith(
        errorMessage: 'Keine Mitgliedsdaten importiert',
      ));
      return;
    }

    if (state.performanceData == null) return;

    const badgeMapping = {
      rettungsschwimmerBronze: 'DRSA-Bronze',
      rettungsschwimmerSilber: 'DRSA-Silber',
      rettungsschwimmerGold: 'DRSA-Gold',
      bronze: 'DSA-Bronze',
      silber: 'DSA-Silber',
      gold: 'DSA-Gold',
    };

    final year = state.selectedYear;
    final entries = <BadgeImportEntry>[];

    for (final entry in badgeMapping.entries) {
      final count = trainees
          .where(
              (t) => t.qualifications.hasQualificationFromYear(entry.key, year))
          .length;
      if (count > 0) {
        entries.add(BadgeImportEntry(
          targetCategoryName: entry.value,
          count: count,
        ));
      }
    }

    // pirat → sonstige Schwimmabzeichen with beschreibung "Pirat"
    final piratCount = trainees
        .where((t) => t.qualifications.hasQualificationFromYear(pirat, year))
        .length;
    if (piratCount > 0) {
      entries.add(BadgeImportEntry(
        targetCategoryName: 'sonstige Schwimmabzeichen',
        count: piratCount,
        beschreibung: 'Pirat',
      ));
    }

    emit(state.copyWith(
      badgeImportResult: BadgeImportResult(entries: entries),
    ));
  }

  void applyBadgeImport() {
    var data = state.performanceData;
    final result = state.badgeImportResult;
    if (data == null || result == null) return;

    for (final entry in result.entries) {
      data = data!.addPositionByName(
        entry.targetCategoryName,
        CategoryPosition(anzahl: entry.count, beschreibung: 'intern'),
      );
    }

    emit(state.copyWith(
      performanceData: data,
      clearBadgeImportResult: true,
    ));
  }

  void dismissBadgeImport() {
    emit(state.copyWith(clearBadgeImportResult: true));
  }

  Future<String?> _pickIcalFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['ics'],
    );

    if (result == null) return null;

    if (kIsWeb) {
      return String.fromCharCodes(result.files.single.bytes!);
    } else {
      final file = File(result.files.single.path!);
      return file.readAsString();
    }
  }
}

class _AggregatedEntry {
  final String targetCategoryName;
  final int value;
  final String beschreibung;
  final String teilnehmende;

  const _AggregatedEntry({
    required this.targetCategoryName,
    required this.value,
    required this.beschreibung,
    this.teilnehmende = '',
  });
}
