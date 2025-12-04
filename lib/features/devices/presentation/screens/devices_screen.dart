import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../providers/devices_provider.dart';
import '../widgets/device_card.dart';

/// Devices list screen
class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DevicesProvider>().loadDevices();
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<DevicesProvider>().loadMoreDevices();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<DevicesProvider>().loadDevices(),
          ),
        ],
      ),
      body: Consumer<DevicesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.devices.isEmpty) {
            return const LoadingIndicator();
          }

          if (provider.error != null && provider.devices.isEmpty) {
            return CustomErrorWidget(
              message: provider.error!,
              onRetry: () => provider.loadDevices(),
            );
          }

          if (provider.devices.isEmpty) {
            return EmptyStateWidget(
              message: 'No devices found',
              icon: Icons.devices_outlined,
              actionLabel: 'Add Device',
              onAction: () => Navigator.pushNamed(context, RouteNames.addDevice),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadDevices(),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: provider.devices.length + (provider.hasMorePages ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == provider.devices.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: LoadingIndicator(size: 24),
                  );
                }

                final device = provider.devices[index];
                return DeviceCard(
                  device: device,
                  onTap: () => Navigator.pushNamed(
                    context,
                    RouteNames.deviceDetails,
                    arguments: device.id,
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, RouteNames.addDevice),
        child: const Icon(Icons.add),
      ),
    );
  }
}
