import '../models/portfolio_content.dart';

/// Contrat de récupération du contenu du portfolio.
///
/// L'UI ne connaît que cette interface : quand le back sera branché, il
/// suffira de fournir une implémentation `ApiPortfolioRepository` qui appelle
/// l'API et passe le JSON à [PortfolioContent.fromJson].
abstract interface class PortfolioRepository {
  Future<PortfolioContent> loadContent();
}
