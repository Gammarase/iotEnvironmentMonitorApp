import 'package:flutter/material.dart';
import '../../../../core/utils/extensions.dart';
import '../widgets/register_form.dart';

/// Register screen
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/login');
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                'Create Account',
                textAlign: TextAlign.center,
                style: context.textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Sign up to get started',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 32),
              // Register form
              const RegisterForm(),
              const SizedBox(height: 16),
              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: context.textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    child: const Text('Sign In'),
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
