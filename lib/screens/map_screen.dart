import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../data/app_state.dart';
import 'notification_detail_screen.dart';
import 'package:mobile_project/screens/create_notification_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Add initial location of the map
  LatLng _currentLocation = LatLng(39.9334, 41.2677);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: FlutterMap(
        options: MapOptions(
          onTap: (tapPosition, point) {
            // Update the current location when tapped
            setState(() {
              _currentLocation = point;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', // here is the link to access the map from openstreetmap
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.mobile_project',
          ),

          //this shows the markers on the map
          MarkerLayer(
            markers: AppState.notifications.map((n) {
              return Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(n.location.lat, n.location.lng),
                child: GestureDetector(
                  onTap: () {
                    // when we press on the notification it send us to the notification screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            NotificationDetailScreen(notification: n),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          n.title, // Displaying notification title
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Icon(
                        Icons.location_on,
                        color: Color.fromARGB(255, 57, 0, 127),
                        size: 36,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Once the button is pressed, it sends us to the create notification screen
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateNotificationScreen(
                location:
                    _currentLocation, // Pass the selected location to the Create_notification_screen
              ),
            ),
          );
          setState(() {}); // Refresh the map with the new notification
        },
        backgroundColor: const Color.fromARGB(255, 57, 0, 127),
        child: const Icon(Icons.add),
      ),
    );
  }
}
