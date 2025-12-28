import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../models/notification_model.dart';
import 'package:latlong2/latlong.dart';

class CreateNotificationScreen extends StatefulWidget {
  final LatLng
  location; // Receiving the location where the user tapped on the map

  const CreateNotificationScreen({super.key, required this.location});

  @override
  State<CreateNotificationScreen> createState() =>
      _CreateNotificationScreenState();
}

class _CreateNotificationScreenState extends State<CreateNotificationScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  String _type = 'health';

  void _save() {
    AppState.notifications.insert(
      //here wherre we create the notification and add it to the app_state
      0,
      NotificationModel(
        id: AppState.notifications.length + 1,
        type: _type,
        title: _title.text,
        description: _description.text,
        status: 'open',
        location: Location(
          lat: widget.location.latitude, // Get latitude from tapped location
          lng: widget.location.longitude, // Get longitude from tapped location
          name: 'Selected Location', // Name for the location
        ),
        createdBy: AppState.currentUser!.email,
        createdAt: DateTime.now(),
      ),
    );
    Navigator.pop(
      context,
    ); //after adding the notification we return to the last scree we were in
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Notification')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField(
              items: const [
                DropdownMenuItem(value: 'health', child: Text('Health')),
                DropdownMenuItem(value: 'safety', child: Text('Safety')),
                DropdownMenuItem(value: 'technical', child: Text('Technical')),
              ],
              onChanged: (v) => setState(() => _type = v!),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _description,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text('Create')),
          ],
        ),
      ),
    );
  }
}
