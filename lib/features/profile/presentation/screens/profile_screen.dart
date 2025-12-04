import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/error_widget.dart' as custom;
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadProfile();
    });
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.logout();
      if (mounted) {
        Navigator.pushReplacementNamed(context, RouteNames.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                RouteNames.editProfile,
              );
              if (result == true && mounted) {
                context.read<ProfileProvider>().loadProfile();
              }
            },
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.user == null) {
            return const Center(child: LoadingIndicator());
          }

          if (provider.error != null && provider.user == null) {
            return custom.CustomErrorWidget(
              message: provider.error!,
              onRetry: () => provider.loadProfile(),
            );
          }

          if (provider.user == null) {
            return const Center(child: Text('No profile data available'));
          }

          final user = provider.user!;

          return RefreshIndicator(
            onRefresh: () => provider.loadProfile(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile header
                  ProfileHeader(
                    name: user.name,
                    email: user.email,
                  ),

                  const SizedBox(height: 24),

                  // Profile information
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Account Information',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            ProfileInfoItem(
                              icon: Icons.person,
                              label: 'Name',
                              value: user.name,
                            ),
                            const Divider(),
                            ProfileInfoItem(
                              icon: Icons.email,
                              label: 'Email',
                              value: user.email,
                              iconColor: Colors.blue,
                            ),
                            const Divider(),
                            ProfileInfoItem(
                              icon: Icons.language,
                              label: 'Language',
                              value: user.language == 'en' ? 'English' : 'Ukrainian',
                              iconColor: Colors.green,
                            ),
                            if (user.timezone != null) ...[
                              const Divider(),
                              ProfileInfoItem(
                                icon: Icons.access_time,
                                label: 'Timezone',
                                value: user.timezone!,
                                iconColor: Colors.orange,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Logout button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: OutlinedButton.icon(
                      onPressed: _handleLogout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
