import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/sensor_reading.dart';

enum ChartType { temperature, humidity, light, noise, tvoc }

class SensorChart extends StatelessWidget {
  final List<SensorReading> readings;
  final ChartType type;

  const SensorChart({
    super.key,
    required this.readings,
    required this.type,
  });

  String get title {
    switch (type) {
      case ChartType.temperature:
        return 'Temperature (°C)';
      case ChartType.humidity:
        return 'Humidity (%)';
      case ChartType.light:
        return 'Light (lux)';
      case ChartType.noise:
        return 'Noise (dB)';
      case ChartType.tvoc:
        return 'TVOC (ppm)';
    }
  }

  Color get color {
    switch (type) {
      case ChartType.temperature:
        return Colors.red;
      case ChartType.humidity:
        return Colors.blue;
      case ChartType.light:
        return Colors.amber;
      case ChartType.noise:
        return Colors.purple;
      case ChartType.tvoc:
        return Colors.green;
    }
  }

  double getValue(SensorReading reading) {
    switch (type) {
      case ChartType.temperature:
        return reading.temperature;
      case ChartType.humidity:
        return reading.humidity;
      case ChartType.light:
        return reading.light;
      case ChartType.noise:
        return reading.noise;
      case ChartType.tvoc:
        return reading.tvoc;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (readings.isEmpty) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              const Text('No data available'),
            ],
          ),
        ),
      );
    }

    // Sort readings by timestamp
    final sortedReadings = List<SensorReading>.from(readings)
      ..sort((a, b) => a.readAt.compareTo(b.readAt));

    // Create spots for the chart
    final spots = <FlSpot>[];
    for (int i = 0; i < sortedReadings.length; i++) {
      spots.add(FlSpot(i.toDouble(), getValue(sortedReadings[i])));
    }

    // Find min and max values for Y axis
    final values = spots.map((spot) => spot.y).toList();
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);
    final yRange = (maxY - minY) > 0 ? maxY - minY : 1;
    final yPadding = yRange * 0.1; // 10% padding

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: yRange / 4,
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(0),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= sortedReadings.length) {
                            return const SizedBox.shrink();
                          }
                          // Show only a few labels to avoid crowding
                          if (value.toInt() % (sortedReadings.length ~/ 5 + 1) == 0) {
                            final reading = sortedReadings[value.toInt()];
                            final date = DateTime.fromMillisecondsSinceEpoch(reading.readAt * 1000);
                            return Text(
                              '${date.day}/${date.month}',
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: minY - yPadding,
                  maxY: maxY + yPadding,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: spots.length <= 20,
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: color.withOpacity(0.1),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final reading = sortedReadings[spot.x.toInt()];
                          final date = DateTime.fromMillisecondsSinceEpoch(reading.readAt * 1000);
                          return LineTooltipItem(
                            '${spot.y.toStringAsFixed(1)}\n${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                            TextStyle(color: Colors.white, fontSize: 12),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
