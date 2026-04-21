import 'package:flutter/material.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/ui/shared/widgets/qualification_icon.dart';

class Qualifications extends StatelessWidget {
  final Trainee trainee;
  const Qualifications({
    required this.trainee,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: List.generate(
            trainee.qualifications.getOnlyHighestQualifications().length,
            (index) {
          final currentqualification =
              trainee.qualifications.getOnlyHighestQualifications()[index];

          return Tooltip(
            message: currentqualification.date == null
                ? '${currentqualification.fullName} \n Datum: - '
                : '${currentqualification.fullName} \n Datum: ${currentqualification.date!.year.toString()}',
            child:
                _PaddedQualificationIcon(qualification: currentqualification),
          );
        }),
      ),
    );
  }
}

class _PaddedQualificationIcon extends StatelessWidget {
  final Qualification qualification;
  const _PaddedQualificationIcon({required this.qualification});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: QualificationIcon(qualification: qualification),
    );
  }
}
