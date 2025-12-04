import 'package:flutter/material.dart';
import '../../../devices/domain/entities/device.dart';

class DeviceSelectorDropdown extends StatelessWidget {
  final List<Device> devices;
  final Device? selectedDevice;
  final Function(Device?) onChanged;

  const DeviceSelectorDropdown({
    super.key,
    required this.devices,
    required this.selectedDevice,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return const Card(
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No devices available. Please add a device first.'),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Device',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Device>(
              initialValue: selectedDevice,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              hint: const Text('Choose a device'),
              isExpanded: true,
              items: devices.map((device) {
                return DropdownMenuItem<Device>(
                  value: device,
                  child: Row(
                    children: [
                      Icon(
                        device.isActive ? Icons.check_circle : Icons.circle_outlined,
                        color: device.isActive ? Colors.green : Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          device.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
