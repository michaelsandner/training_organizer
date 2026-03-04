import 'package:equatable/equatable.dart';
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

  const PerformanceDataState({
    required this.performanceData,
    required this.showLoadingSpinner,
    required this.exportState,
    this.errorMessage,
  });

  factory PerformanceDataState.initial() {
    return const PerformanceDataState(
      performanceData: null,
      showLoadingSpinner: false,
      exportState: PerformanceDataExportState.none,
      errorMessage: null,
    );
  }

  PerformanceDataState copyWith({
    PerformanceData? performanceData,
    bool? showLoadingSpinner,
    String? errorMessage,
    PerformanceDataExportState? exportState,
  }) {
    return PerformanceDataState(
      performanceData: performanceData ?? this.performanceData,
      showLoadingSpinner: showLoadingSpinner ?? this.showLoadingSpinner,
      exportState: exportState ?? this.exportState,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        performanceData,
        showLoadingSpinner,
        errorMessage,
        exportState,
      ];
}
