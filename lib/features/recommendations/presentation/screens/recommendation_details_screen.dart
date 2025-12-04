import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../providers/recommendations_provider.dart';
import '../widgets/priority_badge.dart';
import '../widgets/type_icon.dart';

class RecommendationDetailsScreen extends StatefulWidget {
  final int recommendationId;

  const RecommendationDetailsScreen({
    super.key,
    required this.recommendationId,
  });

  @override
  State<RecommendationDetailsScreen> createState() => _RecommendationDetailsScreenState();
}

class _RecommendationDetailsScreenState extends State<RecommendationDetailsScreen> {
  bool _isProcessing = false;

  Future<void> _acknowledgeRecommendation() async {
    setState(() => _isProcessing = true);

    final provider = context.read<RecommendationsProvider>();
    final success = await provider.acknowledgeRecommendation(widget.recommendationId);

    setState(() => _isProcessing = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recommendation acknowledged')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error ?? 'Failed to acknowledge')),
      );
    }
  }

  Future<void> _dismissRecommendation() async {
    setState(() => _isProcessing = true);

    final provider = context.read<RecommendationsProvider>();
    final success = await provider.dismissRecommendation(widget.recommendationId);

    setState(() => _isProcessing = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recommendation dismissed')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error ?? 'Failed to dismiss')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendation Details'),
        elevation: 0,
      ),
      body: Consumer<RecommendationsProvider>(
        builder: (context, provider, child) {
          final recommendation = provider.recommendations.firstWhere(
            (r) => r.id == widget.recommendationId,
            orElse: () => provider.recommendations.first,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type icon and title
                Row(
                  children: [
                    TypeIcon(type: recommendation.type, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        recommendation.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Priority and Status
                Row(
                  children: [
                    PriorityBadge(priority: recommendation.priority),
                    const SizedBox(width: 12),
                    _buildStatusChip(recommendation.status),
                  ],
                ),
                const SizedBox(height: 24),

                // Message
                _buildSection(
                  context,
                  title: 'Message',
                  content: recommendation.message,
                ),
                const SizedBox(height: 16),

                // Type
                _buildSection(
                  context,
                  title: 'Type',
                  content: recommendation.type,
                ),
                const SizedBox(height: 16),

                // Device ID
                _buildSection(
                  context,
                  title: 'Device ID',
                  content: recommendation.deviceId.toString(),
                ),
                const SizedBox(height: 16),

                // Metadata
                if (recommendation.metadata != null && recommendation.metadata is Map)
                  _buildSection(
                    context,
                    title: 'Additional Information',
                    content: (recommendation.metadata as Map).entries
                        .map((e) => '${e.key}: ${e.value}')
                        .join('\n'),
                  ),
                const SizedBox(height: 16),

                // Timestamps
                if (recommendation.acknowledgedAt != null)
                  _buildSection(
                    context,
                    title: 'Acknowledged At',
                    content: _formatTimestamp(recommendation.acknowledgedAt!),
                  ),
                if (recommendation.dismissedAt != null)
                  _buildSection(
                    context,
                    title: 'Dismissed At',
                    content: _formatTimestamp(recommendation.dismissedAt!),
                  ),
                const SizedBox(height: 32),

                // Actions
                if (recommendation.status.toLowerCase() == 'pending') ...[
                  if (_isProcessing)
                    const Center(child: LoadingIndicator())
                  else ...[
                    ElevatedButton.icon(
                      onPressed: _acknowledgeRecommendation,
                      icon: const Icon(Icons.check),
                      label: const Text('Acknowledge'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _dismissRecommendation,
                      icon: const Icon(Icons.close),
                      label: const Text('Dismiss'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildSection(BuildContext context, {required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'acknowledged':
        color = Colors.green;
        break;
      case 'dismissed':
        color = Colors.grey;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
