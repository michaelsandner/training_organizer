import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:training_organizer/features/edit/add_certification_dialog.dart';
import 'package:training_organizer/features/edit/certification_cubit.dart';
import 'package:training_organizer/features/edit/certification_state.dart';
import 'package:training_organizer/shared/widgets/qualification_icon.dart';

class CreateCertification extends StatelessWidget {
  const CreateCertification({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CertificationCubit, CertificationState>(
      builder: (context, state) {
        final cubit = context.read<CertificationCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            if (state.qualifications.isNotEmpty) ...[
              const Text(
                'Abzeichen',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...List.generate(state.qualifications.length, (index) {
                final qualification = state.qualifications[index];
                final dateText = qualification.date != null
                    ? DateFormat('dd.MM.yyyy').format(qualification.date!)
                    : '';
                return ListTile(
                  leading: QualificationIcon(qualification: qualification),
                  title: Text(qualification.fullName),
                  subtitle: dateText.isNotEmpty ? Text(dateText) : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => cubit.removeQualification(index),
                  ),
                );
              }),
              const Divider(),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AddCertificationDialog(
                      qualificationFactory: cubit.qualificationFactory,
                      onConfirm: (name, date) {
                        cubit.addQualification(name, date);
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Abzeichen hinzufügen'),
              ),
            ),
          ],
        );
      },
    );
  }
}
