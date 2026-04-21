import 'package:flutter/material.dart';
import 'package:training_organizer/blocklist/ui/blocklist_page.dart';
import 'package:training_organizer/ui/features/email/send_email_page.dart';
import 'package:training_organizer/ui/features/performance_data/performance_data_page.dart';
import 'package:training_organizer/ui/features/rescue_qualification/rescue_qualification_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Text(
              'Menü',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.document_scanner),
            title: const Text('Blocklisten'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BlocklistPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Email'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SendEmailPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.pool),
            title: const Text('Rettungsschwimmausbildung'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RescueQualificationPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Leistungsdaten'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PerformanceDataPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
