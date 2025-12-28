import 'package:flutter/material.dart';

import '../data/app_state.dart';
// ignore: unused_import
import '../utils/helpers.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: AppState.notifications.map((n) {
          return Card(
            child: ListTile(
              title: Text(n.title),
              subtitle: Text(n.status),
              trailing: DropdownButton<String>(
                value: n.status,
                items: const [
                  DropdownMenuItem(value: 'open', child: Text('Open')),
                  DropdownMenuItem(
                    value: 'under_review',
                    child: Text('Under Review'),
                  ),
                  DropdownMenuItem(value: 'resolved', child: Text('Resolved')),
                ],
                onChanged: (v) {
                  n.status = v!;
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
