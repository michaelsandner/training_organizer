import 'package:equatable/equatable.dart';
import 'package:training_organizer/performance_data/domain/ical_parser/ical_import_result.dart';
import 'package:training_organizer/performance_data/domain/performance_data.dart';

enum PerformanceDataExportState {
  none,
  exportSuccessful,
  exportFailed,
}

class PerformanceDataState with EquatableMixin {
  final PerformanceData? performanceData;
  final bool showLoadingSpinner;
  final String? errorMessage;
  final PerformanceDataExportState exportState;
  final int selectedYear;
  final IcalImportResult? icalImportResult;

  const PerformanceDataState({
    required this.performanceData,
    required this.showLoadingSpinner,
    required this.exportState,
    required this.selectedYear,
    this.errorMessage,
    this.icalImportResult,
  });

  factory PerformanceDataState.initial() {
    return PerformanceDataState(
      performanceData: null,
      showLoadingSpinner: false,
      exportState: PerformanceDataExportState.none,
      errorMessage: null,
      selectedYear: DateTime.now().year,
      icalImportResult: null,
    );
  }

  PerformanceDataState copyWith({
    PerformanceData? performanceData,
    bool? showLoadingSpinner,
    String? errorMessage,
    PerformanceDataExportState? exportState,
    int? selectedYear,
    IcalImportResult? icalImportResult,
    bool clearIcalImportResult = false,
  }) {
    return PerformanceDataState(
      performanceData: performanceData ?? this.performanceData,
      showLoadingSpinner: showLoadingSpinner ?? this.showLoadingSpinner,
      exportState: exportState ?? this.exportState,
      errorMessage: errorMessage,
      selectedYear: selectedYear ?? this.selectedYear,
      icalImportResult: clearIcalImportResult
          ? null
          : (icalImportResult ?? this.icalImportResult),
    );
  }

  @override
  List<Object?> get props => [
        performanceData,
        showLoadingSpinner,
        errorMessage,
        exportState,
        selectedYear,
        icalImportResult,
      ];
}
