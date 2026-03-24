import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:training_organizer/model/qualifications/qualification.dart';
import 'package:training_organizer/model/qualifications/qualification_validity.dart';

class QualificationIcon extends StatelessWidget {
  final Qualification qualification;
  const QualificationIcon({required this.qualification, super.key});

  @override
  Widget build(BuildContext context) {
    if (qualification.iconName == null) {
      return qualification.icon;
    }
    if (qualification.isUp2Date == QualificationValidity.expired) {
      return Stack(
        children: [
          SvgPicture.asset(
            qualification.iconName!,
            width: 25,
            height: 25,
          ),
          const Icon(Icons.error_outline, color: Colors.red, size: 25)
        ],
      );
    }
    if (qualification.isUp2Date == QualificationValidity.expiring) {
      return Stack(
        children: [
          SvgPicture.asset(
            qualification.iconName!,
            width: 25,
            height: 25,
          ),
          const Icon(Icons.warning_amber, color: Colors.yellow, size: 25)
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
