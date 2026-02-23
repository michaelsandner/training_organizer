import 'package:equatable/equatable.dart';

class CertificationState with EquatableMixin {
  final bool isPiratChecked;
  final bool isBronzeChecked;
  final bool isSilverChecked;
  final bool isGoldChecked;
  final bool isRSBronzeChecked;
  final bool enableCurrentqualificationDate;

  const CertificationState({
    this.isPiratChecked = false,
    this.isBronzeChecked = false,
    this.isSilverChecked = false,
    this.isGoldChecked = false,
    this.isRSBronzeChecked = false,
    this.enableCurrentqualificationDate = false,
  });

  CertificationState copyWith({
    bool? isPiratChecked,
    bool? isBronzeChecked,
    bool? isSilverChecked,
    bool? isGoldChecked,
    bool? isRSBronzeChecked,
    bool? enableCurrentqualificationDate,
  }) {
    return CertificationState(
      isPiratChecked: isPiratChecked ?? this.isPiratChecked,
      isBronzeChecked: isBronzeChecked ?? this.isBronzeChecked,
      isSilverChecked: isSilverChecked ?? this.isSilverChecked,
      isGoldChecked: isGoldChecked ?? this.isGoldChecked,
      isRSBronzeChecked: isRSBronzeChecked ?? this.isRSBronzeChecked,
      enableCurrentqualificationDate:
          enableCurrentqualificationDate ?? this.enableCurrentqualificationDate,
    );
  }

  @override
  List<Object?> get props => [
        isPiratChecked,
        isBronzeChecked,
        isSilverChecked,
        isGoldChecked,
        isRSBronzeChecked,
        enableCurrentqualificationDate,
      ];
}
