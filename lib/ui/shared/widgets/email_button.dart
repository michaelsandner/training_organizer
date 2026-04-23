import 'package:flutter/material.dart';

class EmailButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EmailButton({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      onPressed: onPressed,
      icon: const Icon(Icons.mail),
      color: Colors.blue,
    );
  }
}
