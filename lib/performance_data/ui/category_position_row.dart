import 'package:flutter/material.dart';
import 'package:training_organizer/performance_data/domain/category_position.dart';

/// A single editable row for a [CategoryPosition].
class CategoryPositionRow extends StatefulWidget {
  final CategoryPosition position;
  final int index;
  final Color accentColor;
  final List<int> categoryPath;
  final void Function(List<int> categoryPath, int positionIndex,
      CategoryPosition updatedPosition) onChanged;
  final void Function(List<int> categoryPath, int positionIndex) onRemoved;

  const CategoryPositionRow({
    super.key,
    required this.position,
    required this.index,
    required this.accentColor,
    required this.categoryPath,
    required this.onChanged,
    required this.onRemoved,
  });

  @override
  State<CategoryPositionRow> createState() => _CategoryPositionRowState();
}

class _CategoryPositionRowState extends State<CategoryPositionRow> {
  late final TextEditingController _teilnehmendeController;
  late final TextEditingController _beschreibungController;
  late final FocusNode _participantsFocus;
  late final FocusNode _descriptionFocus;

  @override
  void initState() {
    super.initState();
    _teilnehmendeController =
        TextEditingController(text: widget.position.teilnehmende);
    _beschreibungController =
        TextEditingController(text: widget.position.beschreibung);

    _participantsFocus = FocusNode()
      ..addListener(() {
        // Saves on focus loss — even if the user taps Export without pressing Enter
        if (!_participantsFocus.hasFocus) {
          widget.onChanged(
            widget.categoryPath,
            widget.index,
            widget.position
                .copyWith(teilnehmende: _teilnehmendeController.text),
          );
        }
      });

    _descriptionFocus = FocusNode()
      ..addListener(() {
        if (!_descriptionFocus.hasFocus) {
          widget.onChanged(
            widget.categoryPath,
            widget.index,
            widget.position
                .copyWith(beschreibung: _beschreibungController.text),
          );
        }
      });
  }

  @override
  void didUpdateWidget(CategoryPositionRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update the controller when the field is not focused,
    // to avoid overwriting ongoing user input.
    if (!_participantsFocus.hasFocus &&
        oldWidget.position.teilnehmende != widget.position.teilnehmende) {
      _teilnehmendeController.text = widget.position.teilnehmende;
    }
    if (!_descriptionFocus.hasFocus &&
        oldWidget.position.beschreibung != widget.position.beschreibung) {
      _beschreibungController.text = widget.position.beschreibung;
    }
  }

  @override
  void dispose() {
    _teilnehmendeController.dispose();
    _beschreibungController.dispose();
    _participantsFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: TextFormField(
              key: ValueKey(
                  'pos_anz_${widget.categoryPath.join('_')}_${widget.index}'),
              initialValue: widget.position.anzahl.toString(),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: widget.accentColor,
              ),
              decoration: const InputDecoration(
                labelText: 'Anz.',
                labelStyle: TextStyle(fontSize: 10),
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              ),
              onChanged: (value) {
                final parsed = int.tryParse(value);
                if (parsed != null) {
                  widget.onChanged(widget.categoryPath, widget.index,
                      widget.position.copyWith(anzahl: parsed));
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: _teilnehmendeController,
              focusNode: _participantsFocus,
              decoration: const InputDecoration(
                labelText: 'Teilnehmende',
                labelStyle: TextStyle(fontSize: 10),
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              onFieldSubmitted: (value) {
                widget.onChanged(widget.categoryPath, widget.index,
                    widget.position.copyWith(teilnehmende: value));
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: _beschreibungController,
              focusNode: _descriptionFocus,
              decoration: const InputDecoration(
                labelText: 'Beschreibung',
                labelStyle: TextStyle(fontSize: 10),
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              onFieldSubmitted: (value) {
                widget.onChanged(widget.categoryPath, widget.index,
                    widget.position.copyWith(beschreibung: value));
              },
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline,
                color: Colors.red, size: 20),
            tooltip: 'Position entfernen',
            onPressed: () =>
                widget.onRemoved(widget.categoryPath, widget.index),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
