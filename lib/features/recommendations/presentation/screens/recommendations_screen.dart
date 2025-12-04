import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as custom;
import '../../../../shared/widgets/loading_indicator.dart';
import '../providers/recommendations_provider.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/recommendation_filter_chips.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecommendationsProvider>().loadRecommendations();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      final provider = context.read<RecommendationsProvider>();
      if (!provider.isLoadingMore && provider.hasMorePages) {
        provider.loadMoreRecommendations();
      }
    }
  }

  Future<void> _onRefresh() async {
    await context.read<RecommendationsProvider>().loadRecommendations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
        elevation: 0,
      ),
      body: Consumer<RecommendationsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: LoadingIndicator());
          }

          if (provider.error != null) {
            return custom.CustomErrorWidget(
              message: provider.error!,
              onRetry: () => provider.loadRecommendations(),
            );
          }

          return Column(
            children: [
              RecommendationFilterChips(
                currentFilter: provider.filter,
                onFilterChanged: (filter) => provider.setFilter(filter),
              ),
              Expanded(
                child: provider.recommendations.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.lightbulb_outline,
                        message: provider.filter == RecommendationsFilter.pending
                            ? 'No pending recommendations'
                            : 'No recommendations found',
                      )
                    : RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: provider.recommendations.length + (provider.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == provider.recommendations.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(child: LoadingIndicator()),
                              );
                            }

                            final recommendation = provider.recommendations[index];
                            return RecommendationCard(
                              recommendation: recommendation,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.recommendationDetails,
                                  arguments: recommendation.id,
                                );
                              },
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
