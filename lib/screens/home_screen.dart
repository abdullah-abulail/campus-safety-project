import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../models/notification_model.dart';
import 'map_screen.dart';
import 'profile_screen.dart';
import 'admin_screen.dart';
//import 'create_notification_screen.dart';
import 'notification_detail_screen.dart';
//import 'package:latlong2/latlong.dart';
import 'package:mobile_project/utils/helpers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _searchText = '';
  String _filter = 'all';

  List<NotificationModel> get _filteredNotifications {
    return AppState.notifications.where((n) {
      final matchesSearch =
          n.title.toLowerCase().contains(_searchText.toLowerCase()) ||
          n.description.toLowerCase().contains(_searchText.toLowerCase());

      if (!matchesSearch) return false;

      if (_filter == 'all') return true;
      if (_filter == 'open') return n.status == 'open';
      if (_filter == 'following') {
        return AppState.followedNotifications.contains(n.id);
      }

      return n.type == _filter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = AppState.currentUser?.role == 'admin';

    final pages = [
      _buildHomeTab(),
      const MapScreen(),
      if (isAdmin) const AdminScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Home',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          if (isAdmin)
            const BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings),
              label: 'Admin',
            ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ---------------- HOME TAB ----------------

  Widget _buildHomeTab() {
    return Column(
      children: [
        _buildHeader(),
        _buildFilters(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredNotifications.length,
            itemBuilder: (context, index) {
              final notification = _filteredNotifications[index];
              return _buildNotificationCard(notification);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color.fromARGB(255, 31, 31, 31),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Campus Safety',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: (value) => setState(() => _searchText = value),
              decoration: InputDecoration(
                hintText: 'Search notifications...',
                filled: true,
                fillColor: const Color.fromARGB(255, 42, 42, 42),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _filterChip('All', 'all'),
          _filterChip('Open', 'open'),
          _filterChip('Following', 'following'),
          _filterChip('🏥 Health', 'health'),
          _filterChip('⚠️ Safety', 'safety'),
          _filterChip('🔧 Technical', 'technical'),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final isSelected = _filter == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _filter = value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromARGB(255, 57, 0, 127)
                : const Color.fromARGB(255, 42, 42, 42),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : const Color.fromARGB(255, 224, 224, 224),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel n) {
    final isFollowing = AppState.followedNotifications.contains(n.id);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NotificationDetailScreen(notification: n),
            ),
          );
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(typeIcon(n.type), style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      n.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isFollowing)
                    const Icon(Icons.favorite, color: Colors.red),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                n.description,
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor(n.status),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      n.status.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    timeAgo(n.createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
