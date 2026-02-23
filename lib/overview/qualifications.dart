import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/trainee.dart';

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
        children: List.generate(trainee.qualifications.qualifications.length,
            (index) {
          final currentqualification =
              trainee.qualifications.qualifications[index];

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
      child: _QualificationIcon(qualification: qualification),
    );
  }
}

class _QualificationIcon extends StatelessWidget {
  final Qualification qualification;
  const _QualificationIcon({required this.qualification});

  @override
  Widget build(BuildContext context) {
    if (qualification.iconName == null) {
      return qualification.icon;
    }
    if (!qualification.isUp2Date) {
      return Stack(
        children: [
          SvgPicture.asset(
            qualification.iconName!,
            width: 25,
            height: 25,
          ),
          const Icon(Icons.warning_amber, color: Colors.red, size: 25)
        ],
      );
    }
    return SvgPicture.asset(
      qualification.iconName!,
      width: 25,
      height: 25,
    );
  }
}
