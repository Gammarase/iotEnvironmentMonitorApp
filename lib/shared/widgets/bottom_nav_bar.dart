import 'package:flutter/material.dart';

/// Custom bottom navigation bar
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.devices_outlined),
          activeIcon: Icon(Icons.devices),
          label: 'Devices',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.lightbulb_outline),
          activeIcon: Icon(Icons.lightbulb),
          label: 'Recommendations',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_outlined),
          activeIcon: Icon(Icons.bar_chart),
          label: 'Statistics',
        ),
      ],
    );
  }
}
