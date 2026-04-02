import 'package:equatable/equatable.dart';

enum ExportState {
  none,
  exportSuccessful,
  exportFailed,
}

class FileState with EquatableMixin {
  final ExportState exportState;
  final bool showLoadingSpinner;
  final String? errorMessage;

  const FileState({
    required this.exportState,
    required this.showLoadingSpinner,
    this.errorMessage,
  });

  factory FileState.initial() {
    return const FileState(
      exportState: ExportState.none,
      showLoadingSpinner: false,
      errorMessage: null,
    );
  }

  FileState copyWith({
    ExportState? exportState,
    bool? showLoadingSpinner,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return FileState(
      exportState: exportState ?? this.exportState,
      showLoadingSpinner: showLoadingSpinner ?? this.showLoadingSpinner,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        exportState,
        showLoadingSpinner,
        errorMessage,
      ];
}
