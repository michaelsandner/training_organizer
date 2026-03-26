import 'package:flutter/material.dart';
import 'package:training_organizer/features/exercise_plan/domain/exercise.dart';

class ExerciseCarouselItem extends StatefulWidget {
  final Exercise exercise;
  final int distance;
  final Color color;
  final ValueChanged<int> onDistanceChanged;

  const ExerciseCarouselItem({
    super.key,
    required this.exercise,
    required this.distance,
    required this.color,
    required this.onDistanceChanged,
  });

  @override
  State<ExerciseCarouselItem> createState() => _ExerciseCarouselItemState();
}

class _ExerciseCarouselItemState extends State<ExerciseCarouselItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color.withAlpha(30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: widget.color, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            if (_isExpanded) ...[
              const SizedBox(height: 8),
              _buildDescription(),
              if (widget.exercise.imageName != null) _buildImageLink(context),
            ],
            const SizedBox(height: 8),
            _buildDistanceInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Row(
        children: [
          Icon(
            _isExpanded ? Icons.expand_less : Icons.expand_more,
            color: widget.color,
          ),
          const SizedBox(width: 8),
          Text(
            '#${widget.exercise.id}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: widget.color,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.exercise.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: Text(widget.exercise.description),
    );
  }

  Widget _buildImageLink(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, top: 4),
      child: TextButton.icon(
        onPressed: () => _showImageDialog(context),
        icon: const Icon(Icons.image),
        label: const Text('Bild anzeigen'),
      ),
    );
  }

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.exercise.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Image.asset(
                'assets/images/${widget.exercise.imageName}',
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Bild nicht gefunden');
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Schließen'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDistanceInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: TextFormField(
              initialValue: widget.distance.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                final distance = int.tryParse(value);
                if (distance != null) {
                  widget.onDistanceChanged(distance);
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Text(widget.exercise.unit),
        ],
      ),
    );
  }
}
