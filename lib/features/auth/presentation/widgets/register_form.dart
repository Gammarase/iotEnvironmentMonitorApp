import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../providers/auth_provider.dart';

/// Register form widget
class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedLanguage = 'en';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.hideKeyboard();

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      language: _selectedLanguage,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      context.showSnackBar(
        authProvider.error ?? 'Registration failed',
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
              // Name field
              CustomTextField(
                label: 'Full Name',
                hint: 'Enter your full name',
                controller: _nameController,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.person_outline),
                validator: Validators.validateName,
                enabled: !authProvider.isLoading,
              ),
              const SizedBox(height: 16),
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
                onSubmitted: (_) => _handleRegister(),
              ),
              const SizedBox(height: 16),
              // Language selector
              DropdownButtonFormField<String>(
                initialValue: _selectedLanguage,
                decoration: const InputDecoration(
                  labelText: 'Language',
                  prefixIcon: Icon(Icons.language),
                ),
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'uk', child: Text('Ukrainian')),
                ],
                onChanged: authProvider.isLoading
                    ? null
                    : (value) {
                        setState(() {
                          _selectedLanguage = value;
                        });
                      },
              ),
              const SizedBox(height: 24),
              // Register button
              CustomButton(
                label: 'Sign Up',
                onPressed: _handleRegister,
                isLoading: authProvider.isLoading,
              ),
            ],
          ),
        );
      },
    );
  }
}
