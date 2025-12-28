import 'package:flutter/material.dart';

String typeIcon(String type) {
  switch (type) {
    case 'health':
      return '🏥';
    case 'safety':
      return '⚠️';
    case 'technical':
      return '🔧';
    default:
      return '📢';
  }
}

Color statusColor(String status) {
  switch (status) {
    case 'open':
      return Colors.red;
    case 'under_review':
      return Colors.orange;
    case 'resolved':
      return Colors.green;
    default:
      return Colors.grey;
  }
}

String timeAgo(DateTime date) {
  final d = DateTime.now().difference(date);
  if (d.inMinutes < 60) return '${d.inMinutes}m ago';
  if (d.inHours < 24) return '${d.inHours}h ago';
  return '${d.inDays}d ago';
}
