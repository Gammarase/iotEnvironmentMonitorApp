import 'package:flutter/material.dart';
import '../providers/recommendations_provider.dart';

class RecommendationFilterChips extends StatelessWidget {
  final RecommendationsFilter currentFilter;
  final Function(RecommendationsFilter) onFilterChanged;

  const RecommendationFilterChips({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildChip(
            context,
            label: 'Pending',
            filter: RecommendationsFilter.pending,
          ),
          const SizedBox(width: 8),
          _buildChip(
            context,
            label: 'All',
            filter: RecommendationsFilter.all,
          ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, {required String label, required RecommendationsFilter filter}) {
    final isSelected = currentFilter == filter;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onFilterChanged(filter),
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }
}
