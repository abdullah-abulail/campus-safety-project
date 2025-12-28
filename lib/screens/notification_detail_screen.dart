import 'package:flutter/material.dart';

import '../models/notification_model.dart';
import '../data/app_state.dart';
import '../utils/helpers.dart';

class NotificationDetailScreen extends StatefulWidget {
  final NotificationModel notification;

  const NotificationDetailScreen({super.key, required this.notification});

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final isFollowing = AppState.followedNotifications.contains(
      widget.notification.id,
    );
    final isAdmin = AppState.currentUser?.role == 'admin';

    return Scaffold(
      appBar: AppBar(title: const Text('Notification Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.notification.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.notification.description),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  label: Text(widget.notification.status),
                  backgroundColor: statusColor(widget.notification.status),
                ),
                const SizedBox(width: 12),
                Text(timeAgo(widget.notification.createdAt)),
              ],
            ),
            const Spacer(),
            if (!isAdmin)
              ElevatedButton.icon(
                icon: Icon(
                  isFollowing ? Icons.favorite : Icons.favorite_border,
                ),
                label: Text(isFollowing ? 'Unfollow' : 'Follow'),
                onPressed: () {
                  setState(() {
                    isFollowing
                        ? AppState.followedNotifications.remove(
                            widget.notification.id,
                          )
                        : AppState.followedNotifications.add(
                            widget.notification.id,
                          );
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
