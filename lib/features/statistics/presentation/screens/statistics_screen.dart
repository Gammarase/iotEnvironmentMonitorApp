import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as custom;
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../devices/presentation/providers/devices_provider.dart';
import '../providers/statistics_provider.dart';
import '../widgets/current_readings_card.dart';
import '../widgets/date_range_selector.dart';
import '../widgets/device_selector_dropdown.dart';
import '../widgets/sensor_chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load devices if not already loaded
      final devicesProvider = context.read<DevicesProvider>();
      if (devicesProvider.devices.isEmpty && !devicesProvider.isLoading) {
        devicesProvider.loadDevices();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        elevation: 0,
      ),
      body: Consumer2<StatisticsProvider, DevicesProvider>(
        builder: (context, statisticsProvider, devicesProvider, child) {
          // Show loading while devices are being fetched
          if (devicesProvider.isLoading && devicesProvider.devices.isEmpty) {
            return const Center(child: LoadingIndicator());
          }

          // Show error if devices failed to load
          if (devicesProvider.error != null && devicesProvider.devices.isEmpty) {
            return custom.CustomErrorWidget(
              message: devicesProvider.error!,
              onRetry: () => devicesProvider.loadDevices(),
            );
          }

          // Show empty state if no devices
          if (devicesProvider.devices.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.device_unknown,
              message: 'No devices available.\nPlease add a device first.',
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await statisticsProvider.loadData();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Device selector
                  DeviceSelectorDropdown(
                    devices: devicesProvider.devices,
                    selectedDevice: statisticsProvider.selectedDevice,
                    onChanged: (device) {
                      if (device != null) {
                        statisticsProvider.setDevice(device);
                      }
                    },
                  ),

                  // Show content only if device is selected
                  if (statisticsProvider.selectedDevice != null) ...[
                    // Date range selector
                    DateRangeSelector(
                      period: statisticsProvider.period,
                      dateRange: statisticsProvider.dateRange,
                      onPrevious: () => statisticsProvider.goToPreviousPeriod(),
                      onNext: () => statisticsProvider.goToNextPeriod(),
                      onPeriodChanged: (period) => statisticsProvider.setPeriod(period),
                    ),

                    // Error message
                    if (statisticsProvider.error != null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Card(
                          color: Colors.red.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: Colors.red),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    statisticsProvider.error!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // Current readings
                    if (statisticsProvider.isLoading)
                      const Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(child: LoadingIndicator()),
                      )
                    else
                      CurrentReadingsCard(
                        reading: statisticsProvider.currentReading,
                      ),

                    // Charts section
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Historical Data',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),

                    if (statisticsProvider.isLoadingHistory)
                      const Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(child: LoadingIndicator()),
                      )
                    else if (statisticsProvider.historyReadings.length < 2)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: EmptyStateWidget(
                          icon: Icons.show_chart,
                          message: 'No historical data available for this period',
                        ),
                      )
                    else ...[
                      SensorChart(
                        readings: statisticsProvider.historyReadings,
                        type: ChartType.temperature,
                      ),
                      SensorChart(
                        readings: statisticsProvider.historyReadings,
                        type: ChartType.humidity,
                      ),
                      SensorChart(
                        readings: statisticsProvider.historyReadings,
                        type: ChartType.light,
                      ),
                      SensorChart(
                        readings: statisticsProvider.historyReadings,
                        type: ChartType.noise,
                      ),
                      SensorChart(
                        readings: statisticsProvider.historyReadings,
                        type: ChartType.tvoc,
                      ),
                    ],

                    const SizedBox(height: 16),
                  ] else
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: EmptyStateWidget(
                        icon: Icons.bar_chart,
                        message: 'Please select a device to view statistics',
                      ),
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
