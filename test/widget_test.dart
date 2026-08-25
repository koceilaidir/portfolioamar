import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/data/repositories/static_portfolio_repository.dart';
import 'package:portfolio/presentation/widgets/hero_sentence.dart';
import 'package:portfolio/presentation/widgets/project_card.dart';
import 'package:portfolio/presentation/widgets/testimonial_card.dart';

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump(const Duration(milliseconds: 800));
}

void main() {
  testWidgets('Le hero affiche la phrase et la signature',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const PortfolioApp(repository: StaticPortfolioRepository()),
    );
    await _settle(tester);

    expect(find.byType(HeroSentence), findsOneWidget);
    expect(
      find.text(StaticPortfolioRepository.content.profile.signature),
      findsWidgets,
    );
  });

  testWidgets('Tous les projets et témoignages sont rendus',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const PortfolioApp(repository: StaticPortfolioRepository()),
    );
    await _settle(tester);

    expect(
      find.byType(ProjectCard),
      findsNWidgets(StaticPortfolioRepository.content.projects.length),
    );
    expect(
      find.byType(TestimonialCard),
      findsNWidgets(StaticPortfolioRepository.content.testimonials.length),
    );
  });
}
