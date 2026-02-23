import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_organizer/edit/ui/certification_cubit.dart';
import 'package:training_organizer/edit/ui/certification_state.dart';
import 'package:training_organizer/model/qualifications/bronze.dart';
import 'package:training_organizer/model/qualifications/gold.dart';
import 'package:training_organizer/model/qualifications/pirat.dart';
import 'package:training_organizer/model/qualifications/rs_bronze.dart';
import 'package:training_organizer/model/qualifications/silber.dart';

class CreateCertification extends StatelessWidget {
  const CreateCertification({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CertificationCubit, CertificationState>(
      builder: (context, state) {
        final cubit = context.read<CertificationCubit>();
        return Column(
          children: [
            SwitchListTile(
              title: const Text(
                  'Setze heutiges Datum als Abnahmedatum für Abzeichen'),
              value: state.enableCurrentqualificationDate,
              onChanged: cubit.toggleCurrentQualificationDate,
            ),
            CheckboxListTile(
              value: state.isPiratChecked,
              title: const Text('Pirat'),
              secondary: Pirat(null).icon,
              onChanged: (bool? value) => cubit.togglePirat(value ?? false),
            ),
            CheckboxListTile(
              value: state.isBronzeChecked,
              title: const Text('Bronze'),
              secondary: Bronze(null).icon,
              onChanged: (bool? value) => cubit.toggleBronze(value ?? false),
            ),
            CheckboxListTile(
              value: state.isSilverChecked,
              title: const Text('Silber'),
              secondary: Silber(null).icon,
              onChanged: (bool? value) => cubit.toggleSilber(value ?? false),
            ),
            CheckboxListTile(
              value: state.isGoldChecked,
              title: const Text('Gold'),
              secondary: Gold(null).icon,
              onChanged: (bool? value) => cubit.toggleGold(value ?? false),
            ),
            CheckboxListTile(
              value: state.isRSBronzeChecked,
              title: const Text('RS Bronze'),
              secondary: RsBronze(null).icon,
              onChanged: (bool? value) => cubit.toggleRsBronze(value ?? false),
            ),
          ],
        );
      },
    );
  }
}
