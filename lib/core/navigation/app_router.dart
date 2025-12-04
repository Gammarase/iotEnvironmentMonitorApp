import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/devices/presentation/screens/device_details_screen.dart';
import '../../features/devices/presentation/screens/add_device_screen.dart';
import '../../features/devices/presentation/screens/edit_device_screen.dart';
import '../../features/recommendations/presentation/screens/recommendation_details_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import 'route_names.dart';

/// Central app router
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      // Device routes
      case RouteNames.deviceDetails:
        final deviceId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => DeviceDetailsScreen(deviceId: deviceId),
        );

      case RouteNames.addDevice:
        return MaterialPageRoute(builder: (_) => const AddDeviceScreen());

      case RouteNames.editDevice:
        final deviceId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => EditDeviceScreen(deviceId: deviceId),
        );

      // Recommendation routes
      case RouteNames.recommendationDetails:
        final recommendationId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => RecommendationDetailsScreen(recommendationId: recommendationId),
        );

      // Profile routes
      case RouteNames.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case RouteNames.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
