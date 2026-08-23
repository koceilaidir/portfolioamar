import '../models/portfolio_content.dart';

abstract interface class PortfolioRepository {
  Future<PortfolioContent> loadContent();

  bool get acceptsReviews;

  Future<void> submitReview({
    required String author,
    required String authorRole,
    required String quote,
    String? email,
  });
}
