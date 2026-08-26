import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/admin_repository.dart';
import 'data/repositories/portfolio_repository.dart';
import 'data/repositories/static_portfolio_repository.dart';
import 'data/repositories/supabase_portfolio_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(AppTheme.overlayStyle);

  PortfolioRepository repository = const StaticPortfolioRepository();
  AdminRepository? adminRepository;

  if (AppConfig.hasSupabase) {
    try {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        // ignore: deprecated_member_use
        anonKey: AppConfig.supabaseAnonKey,
      );
      final SupabaseClient client = Supabase.instance.client;
      repository = SupabasePortfolioRepository(client);
      adminRepository = AdminRepository(client);
    } catch (error) {
      debugPrint('Supabase indisponible, contenu statique utilisé : $error');
    }
  }

  runApp(
    PortfolioApp(
      repository: repository,
      adminRepository: adminRepository,
    ),
  );
}
