import 'package:flutter/material.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:url_launcher/url_launcher.dart';

class ExerciseLinkImageRow extends StatelessWidget {
  final Exercise exercise;
  final Axis direction;
  final bool iconOnly;

  const ExerciseLinkImageRow({
    super.key,
    required this.exercise,
    this.direction = Axis.horizontal,
    this.iconOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final children = [
      if (exercise.link != null)
        iconOnly
            ? IconButton(
                onPressed: () => _openLink(context),
                icon: const Icon(Icons.link),
                tooltip: 'Link',
              )
            : TextButton.icon(
                onPressed: () => _openLink(context),
                icon: const Icon(Icons.link),
                label: const Text('Link'),
              ),
      if (exercise.imageName != null)
        iconOnly
            ? IconButton(
                onPressed: () => _showImageDialog(context),
                icon: const Icon(Icons.image),
                tooltip: 'Bild',
              )
            : TextButton.icon(
                onPressed: () => _showImageDialog(context),
                icon: const Icon(Icons.image),
                label: const Text('Bild'),
              ),
    ];

    if (direction == Axis.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    }

    return Row(children: children);
  }

  Future<void> _openLink(BuildContext context) async {
    final link = exercise.link;
    if (link == null) return;

    try {
      final uri = Uri.parse(
        link.startsWith('http://') || link.startsWith('https://')
            ? link
            : 'https://$link',
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Link konnte nicht geöffnet werden')),
        );
      }
    } on FormatException {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ungültiger Link')),
        );
      }
    }
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
                exercise.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Image.asset(
                'assets/images/${exercise.imageName}',
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
}
