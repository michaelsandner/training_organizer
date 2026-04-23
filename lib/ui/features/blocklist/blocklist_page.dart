import 'package:flutter/material.dart';
import 'package:training_organizer/ui/features/blocklist/pdf_view.dart';

class BlocklistPage extends StatelessWidget {
  const BlocklistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocklisten'),
      ),
      body: const PdfView(),
    );
  }
}
