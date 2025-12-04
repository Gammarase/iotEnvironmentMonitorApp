import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/device.dart';

/// Device card widget for list
class DeviceCard extends StatelessWidget {
  final Device device;
  final VoidCallback onTap;

  const DeviceCard({
    super.key,
    required this.device,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: device.isActive
              ? AppColors.deviceActive
              : AppColors.deviceInactive,
          child: Icon(
            device.isActive ? Icons.devices : Icons.devices_other,
            color: Colors.white,
          ),
        ),
        title: Text(
          device.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('ID: ${device.deviceId}'),
            if (device.lastSeenAt != null) ...[
              const SizedBox(height: 2),
              Text(
                'Last seen: ${Formatters.formatRelativeTime(device.lastSeenAt!)}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }
}
