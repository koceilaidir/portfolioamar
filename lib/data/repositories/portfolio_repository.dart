import '../models/portfolio_content.dart';

/// Contrat de récupération du contenu du portfolio.
///
/// L'UI ne connaît que cette interface : `StaticPortfolioRepository` sert le
/// contenu embarqué, `SupabasePortfolioRepository` sert celui de la base.
abstract interface class PortfolioRepository {
  Future<PortfolioContent> loadContent();

  /// `true` si le site peut recevoir des avis de visiteurs.
  bool get acceptsReviews;

  /// Dépose un avis. Il n'est publié qu'après validation dans Supabase.
  Future<void> submitReview({
    required String author,
    required String authorRole,
    required String quote,
    String? email,
  });
}
