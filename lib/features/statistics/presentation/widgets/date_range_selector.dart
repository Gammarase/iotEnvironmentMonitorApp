import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/statistics_provider.dart';

class DateRangeSelector extends StatelessWidget {
  final StatisticsPeriod period;
  final DateTimeRange dateRange;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final Function(StatisticsPeriod) onPeriodChanged;

  const DateRangeSelector({
    super.key,
    required this.period,
    required this.dateRange,
    required this.onPrevious,
    required this.onNext,
    required this.onPeriodChanged,
  });

  String _formatDateRange() {
    final startFormat = DateFormat('MMM d');
    final endFormat = DateFormat('MMM d, yyyy');

    if (period == StatisticsPeriod.week) {
      return '${startFormat.format(dateRange.start)} - ${endFormat.format(dateRange.end)}';
    } else {
      return DateFormat('MMMM yyyy').format(dateRange.start);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time Period',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildPeriodChip(
                  context,
                  label: 'Week',
                  isSelected: period == StatisticsPeriod.week,
                  onTap: () => onPeriodChanged(StatisticsPeriod.week),
                ),
                const SizedBox(width: 8),
                _buildPeriodChip(
                  context,
                  label: 'Month',
                  isSelected: period == StatisticsPeriod.month,
                  onTap: () => onPeriodChanged(StatisticsPeriod.month),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: onPrevious,
                  icon: const Icon(Icons.chevron_left),
                  tooltip: 'Previous',
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      _formatDateRange(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onNext,
                  icon: const Icon(Icons.chevron_right),
                  tooltip: 'Next',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
