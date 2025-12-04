import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../providers/devices_provider.dart';
import '../widgets/device_form.dart';

/// Add device screen
class AddDeviceScreen extends StatelessWidget {
  const AddDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Add Device'),
      body: Consumer<DevicesProvider>(
        builder: (context, provider, child) {
          return DeviceForm(
            onSubmit: ({
              required name,
              deviceId,
              latitude,
              longitude,
              description,
              isActive,
            }) async {
              final success = await provider.createDevice(
                deviceId: deviceId!,
                name: name,
                latitude: latitude,
                longitude: longitude,
                description: description,
              );

              if (!context.mounted) return;

              if (success) {
                context.showSnackBar('Device created successfully');
                Navigator.pop(context);
              } else {
                context.showSnackBar(
                  provider.error ?? 'Failed to create device',
                  isError: true,
                );
              }
            },
          );
        },
      ),
    );
  }
}
