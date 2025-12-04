import 'package:flutter/material.dart';

/// Navigation service for programmatic navigation
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;

  static Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  static void goBack() {
    return navigatorKey.currentState!.pop();
  }

  static Future<dynamic> navigateAndRemoveUntil(String routeName) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
    );
  }

  static Future<dynamic> navigateAndReplace(String routeName,
      {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }
}
