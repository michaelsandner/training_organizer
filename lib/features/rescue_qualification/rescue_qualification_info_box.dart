import 'package:flutter/material.dart';

class RescueQualificationInfoBox extends StatelessWidget {
  const RescueQualificationInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Container(
        decoration: BoxDecoration(
          color: primary.withValues(alpha: 0.08),
          border: Border(
            left: BorderSide(color: primary, width: 4),
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, color: primary, size: 20),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Hier kannst du die Teilnehmerliste für die Rettungsschwimmausbildung erstellen.\n'
                'Die erstellte Liste kannst du im BRK-Dokumentengenerator verwenden, damit die Teilnehmenden nicht einzeln eingetragen werden müssen.\n'
                'Kopiere dafür den Inhalt der exportierten CSV-Datei in das entsprechende Feld des Dokumentengenerators.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
