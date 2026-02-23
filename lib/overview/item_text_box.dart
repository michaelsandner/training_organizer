import 'package:flutter/material.dart';

class ItemTextBox extends StatelessWidget {
  final String text;
  final double? width;
  final bool isMember;
  const ItemTextBox({
    required this.text,
    this.width,
    required this.isMember,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      width: width,
      child: Text(
        text,
        style: TextStyle(
            color: isMember ? Colors.black : Colors.red,
            fontStyle: !isMember ? FontStyle.italic : FontStyle.normal),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
