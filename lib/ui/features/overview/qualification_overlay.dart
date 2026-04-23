import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:training_organizer/model/trainee.dart';
import 'package:training_organizer/ui/shared/widgets/qualification_icon.dart';

class QualificationOverlay extends StatelessWidget {
  final Trainee trainee;
  final Widget child;
  const QualificationOverlay({
    required this.child,
    required this.trainee,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            final qualifications =
                trainee.qualifications.getOnlyHighestQualifications();
            return AlertDialog(
              title: const Text('Ausbildungen'),
              content: qualifications.isEmpty
                  ? const Text('Keine Ausbildungen vorhanden')
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(qualifications.length, (index) {
                        final qualification = qualifications[index];
                        final dateText = qualification.date != null
                            ? DateFormat('dd.MM.yyyy')
                                .format(qualification.date!)
                            : '';
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading:
                              QualificationIcon(qualification: qualification),
                          title: Text(qualification.fullName),
                          subtitle: dateText.isNotEmpty
                              ? Text(dateText)
                              : null,
                        );
                      }),
                    ),
            );
          }),
      child: child,
    );
  }
}
