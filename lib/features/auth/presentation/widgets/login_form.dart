import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../providers/auth_provider.dart';

/// Login form widget
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.hideKeyboard();

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      context.showSnackBar(
        authProvider.error ?? 'Login failed',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email field
              CustomTextField(
                label: 'Email',
                hint: 'Enter your email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.email_outlined),
                validator: Validators.validateEmail,
                enabled: !authProvider.isLoading,
              ),
              const SizedBox(height: 16),
              // Password field
              PasswordTextField(
                label: 'Password',
                controller: _passwordController,
                validator: Validators.validatePassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _handleLogin(),
              ),
              const SizedBox(height: 24),
              // Login button
              CustomButton(
                label: 'Sign In',
                onPressed: _handleLogin,
                isLoading: authProvider.isLoading,
              ),
            ],
          ),
        );
      },
    );
  }
}
