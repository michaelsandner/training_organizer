import 'package:flutter/material.dart';
import 'package:training_organizer/email/ui/send_email_page.dart';
import 'package:training_organizer/rescue_qualification/ui/rescue_qualification_page.dart';

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
        ],
      ),
    );
  }
}
