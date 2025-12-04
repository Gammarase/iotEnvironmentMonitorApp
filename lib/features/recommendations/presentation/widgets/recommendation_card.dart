import 'package:flutter/material.dart';
import '../../domain/entities/recommendation.dart';
import 'priority_badge.dart';
import 'type_icon.dart';

class RecommendationCard extends StatelessWidget {
  final Recommendation recommendation;
  final VoidCallback onTap;

  const RecommendationCard({
    super.key,
    required this.recommendation,
    required this.onTap,
  });

  String _getStatusText() {
    switch (recommendation.status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'acknowledged':
        return 'Acknowledged';
      case 'dismissed':
        return 'Dismissed';
      default:
        return recommendation.status;
    }
  }

  Color _getStatusColor() {
    switch (recommendation.status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'acknowledged':
        return Colors.green;
      case 'dismissed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TypeIcon(type: recommendation.type),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendation.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          recommendation.message,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PriorityBadge(priority: recommendation.priority),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(),
                      style: TextStyle(
                        color: _getStatusColor(),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
