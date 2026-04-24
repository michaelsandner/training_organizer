import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:training_organizer/model/qualifications/qualification_factory.dart';

/// Dialog for adding a new certification to a trainee.
/// Shows a dropdown of all available qualifications, a date picker, and an
/// intern/extern toggle.
class AddCertificationDialog extends StatefulWidget {
  final void Function(String name, DateTime? date, bool isAchievedIntern)
      onConfirm;
  final QualificationFactory qualificationFactory;

  const AddCertificationDialog({
    super.key,
    required this.onConfirm,
    required this.qualificationFactory,
  });

  @override
  State<AddCertificationDialog> createState() =>
      _AddCertificationDialogState();
}

class _AddCertificationDialogState extends State<AddCertificationDialog> {
  String? _selectedQualification;
  DateTime? _selectedDate;
  bool _isAchievedIntern = true;
  final _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  String _getDisplayName(String name) {
    final qualification =
        widget.qualificationFactory.createQualification(name, null);
    return qualification.fullName;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd.MM.yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Abzeichen hinzufügen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Abzeichen',
            ),
            initialValue: _selectedQualification,
            items: allQualificationNames
                .map((name) => DropdownMenuItem<String>(
                      value: name,
                      child: Text(_getDisplayName(name)),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedQualification = value;
              });
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _dateController,
            decoration: const InputDecoration(
              labelText: 'Datum',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: _pickDate,
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Intern erworben'),
            value: _isAchievedIntern,
            onChanged: (value) {
              setState(() {
                _isAchievedIntern = value;
              });
            },
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: _selectedQualification == null
              ? null
              : () {
                  widget.onConfirm(
                      _selectedQualification!, _selectedDate, _isAchievedIntern);
                  Navigator.of(context).pop();
                },
          child: const Text('Hinzufügen'),
        ),
      ],
    );
  }
}
