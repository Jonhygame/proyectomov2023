import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Settings'),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/principal');
                },
                child: const Text('Principal'))
          ],
        ),
      ),
    );
  }
}
