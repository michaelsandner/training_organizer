import 'package:flutter/material.dart';
import 'package:training_organizer/domain/exercise_plan/exercise.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_image_detail_page.dart';
import 'package:training_organizer/features/exercise_plan/ui/exercise_image_placeholder.dart';
import 'package:url_launcher/url_launcher.dart';

class ExerciseLinkImageRow extends StatelessWidget {
  final Exercise exercise;

  const ExerciseLinkImageRow({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => _openImageDetailPage(context),
          child: Hero(
            tag: 'exercise-image-${exercise.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: exercise.imageName != null
                  ? Image.asset(
                      'assets/images/${exercise.imageName}',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return ExerciseImagePlaceholder(
                          color: exercise.type.color,
                        );
                      },
                    )
                  : ExerciseImagePlaceholder(
                      color: exercise.type.color,
                    ),
            ),
          ),
        ),
        if (exercise.link != null)
          IconButton(
            onPressed: () => _openLink(context),
            icon: const Icon(Icons.link),
            tooltip: 'Link',
          ),
      ],
    );
  }

  void _openImageDetailPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ExerciseImageDetailPage(exercise: exercise),
      ),
    );
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

      final launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Link konnte nicht geöffnet werden')),
        );
      }
    } on Exception {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ungültiger Link')),
        );
      }
    }
  }
}
