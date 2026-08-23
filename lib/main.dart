import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/static_portfolio_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(AppTheme.overlayStyle);

  // Le jour où le back existe, il suffit de remplacer cette ligne par
  // `ApiPortfolioRepository(baseUrl: ...)`.
  runApp(const PortfolioApp(repository: StaticPortfolioRepository()));
}
