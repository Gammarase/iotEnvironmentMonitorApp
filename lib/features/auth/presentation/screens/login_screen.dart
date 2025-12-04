import 'package:flutter/material.dart';
import '../../../../core/utils/extensions.dart';
import '../widgets/login_form.dart';

/// Login screen
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Logo/Icon
              Icon(
                Icons.eco,
                size: 80,
                color: context.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: context.textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 40),
              // Login form
              const LoginForm(),
              const SizedBox(height: 16),
              // Register link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: context.textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/register');
                    },
                    child: const Text('Sign Up'),
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
