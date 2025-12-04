import 'package:flutter/material.dart';
import '../../domain/entities/sensor_reading.dart';

class CurrentReadingsCard extends StatelessWidget {
  final SensorReading? reading;

  const CurrentReadingsCard({
    super.key,
    required this.reading,
  });

  @override
  Widget build(BuildContext context) {
    if (reading == null) {
      return const Card(
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text('No current reading available'),
          ),
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
              'Current Readings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                _buildReadingItem(
                  context,
                  icon: Icons.thermostat,
                  label: 'Temperature',
                  value: '${reading!.temperature.toStringAsFixed(1)}°C',
                  color: Colors.red,
                ),
                _buildReadingItem(
                  context,
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '${reading!.humidity.toStringAsFixed(1)}%',
                  color: Colors.blue,
                ),
                _buildReadingItem(
                  context,
                  icon: Icons.lightbulb,
                  label: 'Light',
                  value: '${reading!.light.toStringAsFixed(0)} lux',
                  color: Colors.amber,
                ),
                _buildReadingItem(
                  context,
                  icon: Icons.volume_up,
                  label: 'Noise',
                  value: '${reading!.noise.toStringAsFixed(1)} dB',
                  color: Colors.purple,
                ),
                _buildReadingItem(
                  context,
                  icon: Icons.air,
                  label: 'TVOC',
                  value: '${reading!.tvoc.toStringAsFixed(0)} ppm',
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
