import 'package:mobile_project/models/user.dart';
import 'package:mobile_project/models/notification_model.dart';

class AppState {
  static User? currentUser; //Stores the logged in user

  //Stores all reported incidents and there is a default wrtten notification
  static List<NotificationModel> notifications = [
    NotificationModel(
      id: 1,
      type: 'health',
      title: 'First Aid Needed',
      description: 'Student fainted near library entrance',
      status: 'open',
      location: Location(lat: 39.9334, lng: 41.2677, name: 'Library Entrance'),
      createdBy: 'user1@atauni.edu.tr',
      createdAt: DateTime.now(),
    ),
  ];

  static List<int> followedNotifications =
      []; //here we store the followed notifications
}

//this file to share data between the screens
