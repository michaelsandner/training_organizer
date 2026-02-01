import 'package:flutter/material.dart';
import 'package:training_organizer/email/ui/email_state.dart';

class EmailListTile extends StatelessWidget {
  final String title;
  final EmailRecipientGroup? group;
  final bool isSelected;
  final Function(bool) onChanged;

  const EmailListTile({
    super.key,
    required this.isSelected,
    required this.title,
    required this.group,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(title),
      value: isSelected,
      onChanged: (bool? newValue) {
        onChanged(newValue ?? false);
      },
      dense: true,
    );
  }
}
