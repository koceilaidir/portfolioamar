import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_typography.dart';
import 'data/models/portfolio_content.dart';
import 'data/repositories/admin_repository.dart';
import 'data/repositories/portfolio_repository.dart';
import 'presentation/home/home_page.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => <PointerDeviceKind>{
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({
    super.key,
    required this.repository,
    this.adminRepository,
  });

  final PortfolioRepository repository;
  final AdminRepository? adminRepository;

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  late Future<PortfolioContent> _contentFuture;

  @override
  void initState() {
    super.initState();
    _contentFuture = widget.repository.loadContent();
  }

  void _reload() {
    setState(() {
      _contentFuture = widget.repository.loadContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amar Hammour Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      scrollBehavior: const AppScrollBehavior(),
      home: FutureBuilder<PortfolioContent>(
        future: _contentFuture,
        builder: (BuildContext context,
            AsyncSnapshot<PortfolioContent> snapshot) {
          if (snapshot.hasError) {
            return _ErrorScreen(onRetry: _reload);
          }
          if (!snapshot.hasData) {
            return const _LoadingScreen();
          }
          return HomePage(
            content: snapshot.data!,
            repository: widget.repository,
            adminRepository: widget.adminRepository,
            onContentChanged: _reload,
          );
        },
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.terracotta,
          ),
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Contenu indisponible',
                style: AppText.sectionKicker(24),
              ),
              const SizedBox(height: 10),
              Text(
                'Impossible de charger le contenu du portfolio pour le moment.',
                textAlign: TextAlign.center,
                style: AppText.sectionDesc,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.terracottaDeep,
                ),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
