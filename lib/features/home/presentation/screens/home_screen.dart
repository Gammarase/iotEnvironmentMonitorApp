import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../devices/presentation/screens/devices_screen.dart';
import '../../../recommendations/presentation/screens/recommendations_screen.dart';
import '../../../statistics/presentation/screens/statistics_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../providers/navigation_provider.dart';

/// Home screen with bottom navigation
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          body: IndexedStack(
            index: navigationProvider.currentIndex,
            children: [
              // Tab 1: Profile
              const ProfileScreen(),

              // Tab 2: Devices
              const DevicesScreen(),

              // Tab 3: Recommendations
              const RecommendationsScreen(),

              // Tab 4: Statistics
              const StatisticsScreen(),
            ],
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: navigationProvider.currentIndex,
            onTap: (index) => navigationProvider.setIndex(index),
          ),
        );
      },
    );
  }

  /// Placeholder for tabs (will be replaced with actual screens)
  Widget _buildPlaceholder(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            '$title Screen',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Coming soon...'),
        ],
      ),
    );
  }
}
