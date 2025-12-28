class Location {
  final double lat;
  final double lng;
  final String name;

  Location({required this.lat, required this.lng, required this.name});
}

class NotificationModel {
  final int id;
  final String type;
  final String title;
  final String description;
  String status;
  final Location location;
  final String createdBy;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.status,
    required this.location,
    required this.createdBy,
    required this.createdAt,
  });
}
