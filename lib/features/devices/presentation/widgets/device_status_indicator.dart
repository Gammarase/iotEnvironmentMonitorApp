import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Device status indicator widget
class DeviceStatusIndicator extends StatelessWidget {
  final bool isActive;

  const DeviceStatusIndicator({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.deviceActive.withOpacity(0.1)
            : AppColors.deviceInactive.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? AppColors.deviceActive : AppColors.deviceInactive,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? 'Active' : 'Inactive',
            style: TextStyle(
              color: isActive ? AppColors.deviceActive : AppColors.deviceInactive,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
