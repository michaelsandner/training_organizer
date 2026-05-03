import 'package:flutter/material.dart';
import 'package:training_organizer/ui/features/email/email_state.dart';

class EmailListTile extends StatelessWidget {
  final String title;
  final EmailRecipientGroup? group;
  final bool isSelected;
  final bool isEnabled;
  final Function(bool) onChanged;

  const EmailListTile({
    super.key,
    required this.isSelected,
    required this.title,
    required this.group,
    required this.onChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(title),
      value: isSelected,
      onChanged: isEnabled
          ? (bool? newValue) {
              onChanged(newValue ?? false);
            }
          : null,
      dense: true,
    );
  }
}
