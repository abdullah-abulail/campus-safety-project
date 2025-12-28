import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../utils/helpers.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppState.currentUser!;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                user.name[0].toUpperCase(),
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(user.email),
            const SizedBox(height: 20),
            const Divider(),
            const Text('Followed Notifications'),
            const SizedBox(height: 8),
            ...AppState.notifications
                .where((n) => AppState.followedNotifications.contains(n.id))
                .map(
                  (n) => ListTile(
                    title: Text(n.title),
                    leading: Text(typeIcon(n.type)),
                  ),
                ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                AppState.currentUser = null;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
