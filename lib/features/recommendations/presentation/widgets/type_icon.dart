import 'package:flutter/material.dart';

class TypeIcon extends StatelessWidget {
  final String type;
  final double size;

  const TypeIcon({
    super.key,
    required this.type,
    this.size = 24,
  });

  IconData _getIcon() {
    switch (type.toLowerCase()) {
      case 'ventilate':
        return Icons.air;
      case 'lighting':
        return Icons.lightbulb_outline;
      case 'noise':
        return Icons.volume_up;
      case 'break':
        return Icons.coffee;
      case 'temperature':
        return Icons.thermostat;
      case 'humidity':
        return Icons.water_drop;
      default:
        return Icons.info_outline;
    }
  }

  Color _getColor() {
    switch (type.toLowerCase()) {
      case 'ventilate':
        return Colors.cyan;
      case 'lighting':
        return Colors.amber;
      case 'noise':
        return Colors.purple;
      case 'break':
        return Colors.brown;
      case 'temperature':
        return Colors.red;
      case 'humidity':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _getColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        _getIcon(),
        color: _getColor(),
        size: size,
      ),
    );
  }
}
