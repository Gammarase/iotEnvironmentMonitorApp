import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../providers/device_details_provider.dart';
import '../providers/devices_provider.dart';
import '../widgets/device_status_indicator.dart';

/// Device details screen
class DeviceDetailsScreen extends StatefulWidget {
  final int deviceId;

  const DeviceDetailsScreen({
    super.key,
    required this.deviceId,
  });

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeviceDetailsProvider>().loadDeviceDetails(widget.deviceId);
    });
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Device'),
        content: const Text('Are you sure you want to delete this device?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final success = await context.read<DevicesProvider>().deleteDevice(widget.deviceId);

    if (!mounted) return;

    if (success) {
      context.showSnackBar('Device deleted successfully');
      Navigator.pop(context);
    } else {
      final error = context.read<DevicesProvider>().error;
      context.showSnackBar(error ?? 'Failed to delete device', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Device Details',
        actions: [
          Consumer<DeviceDetailsProvider>(
            builder: (context, provider, child) {
              if (provider.device == null) return const SizedBox();
              return PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: AppColors.error),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.pushNamed(
                      context,
                      RouteNames.editDevice,
                      arguments: provider.device!.id,
                    );
                  } else if (value == 'delete') {
                    _handleDelete();
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<DeviceDetailsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingIndicator();
          }

          if (provider.error != null) {
            return CustomErrorWidget(
              message: provider.error!,
              onRetry: () => provider.loadDeviceDetails(widget.deviceId),
            );
          }

          final device = provider.device;
          if (device == null) {
            return const Center(child: Text('Device not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              device.name,
                              style: context.textTheme.headlineSmall,
                            ),
                            DeviceStatusIndicator(isActive: device.isActive),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(Icons.qr_code, 'Device ID', device.deviceId),
                        const SizedBox(height: 12),
                        if (device.lastSeenAt != null)
                          _buildInfoRow(
                            Icons.access_time,
                            'Last Seen',
                            Formatters.formatDateTime(device.lastSeenAt!),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (device.description != null && device.description!.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: context.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(device.description!),
                        ],
                      ),
                    ),
                  ),
                if (device.latitude != null && device.longitude != null) ...[
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location',
                            style: context.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(Icons.location_on, 'Latitude', device.latitude!),
                          const SizedBox(height: 8),
                          _buildInfoRow(Icons.location_on, 'Longitude', device.longitude!),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }
}
