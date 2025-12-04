import 'package:equatable/equatable.dart';

class SensorReading extends Equatable {
  final int id;
  final int deviceId;
  final int readAt;
  final double temperature;
  final double humidity;
  final double light;
  final double noise;
  final double tvoc;

  const SensorReading({
    required this.id,
    required this.deviceId,
    required this.readAt,
    required this.temperature,
    required this.humidity,
    required this.light,
    required this.noise,
    required this.tvoc,
  });

  @override
  List<Object?> get props => [
        id,
        deviceId,
        readAt,
        temperature,
        humidity,
        light,
        noise,
        tvoc,
      ];
}
