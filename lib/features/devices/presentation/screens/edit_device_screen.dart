import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../providers/device_details_provider.dart';
import '../providers/devices_provider.dart';
import '../widgets/device_form.dart';

/// Edit device screen
class EditDeviceScreen extends StatefulWidget {
  final int deviceId;

  const EditDeviceScreen({
    super.key,
    required this.deviceId,
  });

  @override
  State<EditDeviceScreen> createState() => _EditDeviceScreenState();
}

class _EditDeviceScreenState extends State<EditDeviceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeviceDetailsProvider>().loadDeviceDetails(widget.deviceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Device'),
      body: Consumer<DeviceDetailsProvider>(
        builder: (context, detailsProvider, child) {
          if (detailsProvider.isLoading) {
            return const LoadingIndicator();
          }

          final device = detailsProvider.device;
          if (device == null) {
            return const Center(child: Text('Device not found'));
          }

          return Consumer<DevicesProvider>(
            builder: (context, devicesProvider, child) {
              return DeviceForm(
                isEdit: true,
                initialName: device.name,
                initialLatitude: device.latitude,
                initialLongitude: device.longitude,
                initialDescription: device.description,
                initialIsActive: device.isActive,
                onSubmit: ({
                  required name,
                  deviceId,
                  latitude,
                  longitude,
                  description,
                  isActive,
                }) async {
                  final success = await devicesProvider.updateDevice(
                    id: device.id,
                    name: name,
                    isActive: isActive!,
                    latitude: latitude,
                    longitude: longitude,
                    description: description,
                  );

                  if (!context.mounted) return;

                  if (success) {
                    context.showSnackBar('Device updated successfully');
                    Navigator.pop(context);
                  } else {
                    context.showSnackBar(
                      devicesProvider.error ?? 'Failed to update device',
                      isError: true,
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
