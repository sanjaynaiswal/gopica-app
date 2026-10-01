
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: const [
          ListTile(leading: Icon(Icons.palette), title: Text('Appearance')),
          ListTile(leading: Icon(Icons.notifications), title: Text('Notifications')),
          ListTile(leading: Icon(Icons.info), title: Text('About Gopica')),
        ],
      ),
    );
  }
}
