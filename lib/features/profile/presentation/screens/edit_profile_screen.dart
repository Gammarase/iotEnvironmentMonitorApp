import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _timezoneController = TextEditingController();
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProfileProvider>();
      if (provider.user != null) {
        _nameController.text = provider.user!.name;
        _timezoneController.text = provider.user!.timezone ?? '';
        _selectedLanguage = provider.user!.language;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timezoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ProfileProvider>();
    final success = await provider.updateProfile(
      name: _nameController.text.trim(),
      timezone: _timezoneController.text.trim().isEmpty ? null : _timezoneController.text.trim(),
      language: _selectedLanguage,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error ?? 'Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        elevation: 0,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Name field
                  CustomTextField(
                    controller: _nameController,
                    label: 'Name',
                    prefixIcon: const Icon(Icons.person),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Language selector
                  DropdownButtonFormField<String>(
                    initialValue: _selectedLanguage,
                    decoration: const InputDecoration(
                      labelText: 'Language',
                      prefixIcon: Icon(Icons.language),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'en',
                        child: Text('English'),
                      ),
                      DropdownMenuItem(
                        value: 'uk',
                        child: Text('Ukrainian'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedLanguage = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Timezone field
                  CustomTextField(
                    controller: _timezoneController,
                    label: 'Timezone (optional)',
                    prefixIcon: const Icon(Icons.access_time),
                    hint: 'e.g., Europe/Kiev, America/New_York',
                  ),
                  const SizedBox(height: 24),

                  // Save button
                  CustomButton(
                    label: provider.isLoading ? 'Saving...' : 'Save Changes',
                    onPressed: provider.isLoading ? null : _saveProfile,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
