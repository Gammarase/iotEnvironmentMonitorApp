import 'package:flutter/foundation.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/usecases/acknowledge_recommendation_usecase.dart';
import '../../domain/usecases/dismiss_recommendation_usecase.dart';
import '../../domain/usecases/get_pending_recommendations_usecase.dart';
import '../../domain/usecases/get_recommendation_details_usecase.dart';
import '../../domain/usecases/get_recommendations_usecase.dart';

enum RecommendationsFilter { all, pending }

class RecommendationsProvider extends ChangeNotifier {
  final GetRecommendationsUseCase getRecommendationsUseCase;
  final GetPendingRecommendationsUseCase getPendingRecommendationsUseCase;
  final GetRecommendationDetailsUseCase getRecommendationDetailsUseCase;
  final AcknowledgeRecommendationUseCase acknowledgeRecommendationUseCase;
  final DismissRecommendationUseCase dismissRecommendationUseCase;

  RecommendationsProvider({
    required this.getRecommendationsUseCase,
    required this.getPendingRecommendationsUseCase,
    required this.getRecommendationDetailsUseCase,
    required this.acknowledgeRecommendationUseCase,
    required this.dismissRecommendationUseCase,
  });

  // State
  List<Recommendation> _recommendations = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMorePages = true;
  RecommendationsFilter _filter = RecommendationsFilter.pending;

  // Getters
  List<Recommendation> get recommendations => _recommendations;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get hasMorePages => _hasMorePages;
  RecommendationsFilter get filter => _filter;

  // Load first page
  Future<void> loadRecommendations() async {
    _isLoading = true;
    _error = null;
    _currentPage = 1;
    _hasMorePages = true;
    notifyListeners();

    final result = _filter == RecommendationsFilter.pending
        ? await getPendingRecommendationsUseCase(page: 1)
        : await getRecommendationsUseCase(page: 1);

    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (paginatedResponse) {
        _recommendations = paginatedResponse.data;
        _currentPage = paginatedResponse.meta.currentPage;
        _hasMorePages = paginatedResponse.meta.currentPage < paginatedResponse.meta.lastPage;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Load more (pagination)
  Future<void> loadMoreRecommendations() async {
    if (_isLoadingMore || !_hasMorePages) return;

    _isLoadingMore = true;
    notifyListeners();

    final nextPage = _currentPage + 1;
    final result = _filter == RecommendationsFilter.pending
        ? await getPendingRecommendationsUseCase(page: nextPage)
        : await getRecommendationsUseCase(page: nextPage);

    result.fold(
      (failure) {
        _error = failure.message;
        _isLoadingMore = false;
        notifyListeners();
      },
      (paginatedResponse) {
        _recommendations.addAll(paginatedResponse.data);
        _currentPage = paginatedResponse.meta.currentPage;
        _hasMorePages = paginatedResponse.meta.currentPage < paginatedResponse.meta.lastPage;
        _isLoadingMore = false;
        notifyListeners();
      },
    );
  }

  // Change filter
  void setFilter(RecommendationsFilter newFilter) {
    if (_filter != newFilter) {
      _filter = newFilter;
      loadRecommendations();
    }
  }

  // Acknowledge recommendation
  Future<bool> acknowledgeRecommendation(int id) async {
    final result = await acknowledgeRecommendationUseCase(id);

    return result.fold(
      (failure) {
        _error = failure.message;
        notifyListeners();
        return false;
      },
      (updatedRecommendation) {
        // Update in list
        final index = _recommendations.indexWhere((r) => r.id == id);
        if (index != -1) {
          _recommendations[index] = updatedRecommendation;
          notifyListeners();
        }
        return true;
      },
    );
  }

  // Dismiss recommendation
  Future<bool> dismissRecommendation(int id) async {
    final result = await dismissRecommendationUseCase(id);

    return result.fold(
      (failure) {
        _error = failure.message;
        notifyListeners();
        return false;
      },
      (updatedRecommendation) {
        // Update in list or remove if on pending filter
        final index = _recommendations.indexWhere((r) => r.id == id);
        if (index != -1) {
          if (_filter == RecommendationsFilter.pending) {
            _recommendations.removeAt(index);
          } else {
            _recommendations[index] = updatedRecommendation;
          }
          notifyListeners();
        }
        return true;
      },
    );
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
