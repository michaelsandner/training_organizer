import 'package:equatable/equatable.dart';

enum ExportState {
  none,
  exportSuccessful,
  exportFailed,
}

class FileState with EquatableMixin {
  final ExportState exportState;
  final bool showLoadingSpinner;

  const FileState({
    required this.exportState,
    required this.showLoadingSpinner,
  });

  factory FileState.initial() {
    return const FileState(
      exportState: ExportState.none,
      showLoadingSpinner: false,
    );
  }

  FileState copyWith({
    ExportState? exportState,
    bool? showLoadingSpinner,
  }) {
    return FileState(
      exportState: exportState ?? this.exportState,
      showLoadingSpinner: showLoadingSpinner ?? this.showLoadingSpinner,
    );
  }

  @override
  List<Object?> get props => [
        exportState,
        showLoadingSpinner,
      ];
}
