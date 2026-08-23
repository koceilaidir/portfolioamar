import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/portfolio_repository.dart';
import 'data/repositories/static_portfolio_repository.dart';
import 'data/repositories/supabase_portfolio_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(AppTheme.overlayStyle);

  // Sans clés Supabase, le site fonctionne avec le contenu embarqué.
  PortfolioRepository repository = const StaticPortfolioRepository();

  if (AppConfig.hasSupabase) {
    try {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey,
      );
      repository = SupabasePortfolioRepository(Supabase.instance.client);
    } catch (error) {
      debugPrint('Supabase indisponible, contenu statique utilisé : $error');
    }
  }

  runApp(PortfolioApp(repository: repository));
}
