import 'package:flutter/material.dart';
import 'core/navigation/app_router.dart';
import 'core/navigation/navigation_service.dart';
import 'core/navigation/route_names.dart';
import 'core/theme/app_theme.dart';

/// Root application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Environment Monitor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      navigatorKey: NavigationService.navigatorKey,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: RouteNames.splash,
    );
  }
}
