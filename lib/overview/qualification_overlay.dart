import 'package:flutter/material.dart';
import 'package:training_organizer/model/trainee.dart';

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
            return AlertDialog(
              title: const Text('Ausbildungen'),
              content: SizedBox(
                height: 200,
                child: Column(
                  children:
                      List.generate(trainee.qualifications.length, (index) {
                    final currentqualification = trainee.qualifications[index];

                    return Row(
                      children: [
                        currentqualification.icon,
                        const SizedBox(
                          width: 10,
                        ),
                        if (currentqualification.date != null)
                          Text(currentqualification.date!.year.toString()),
                      ],
                    );
                  }),
                ),
              ),
            );
          }),
      child: child,
    );
  }
}
