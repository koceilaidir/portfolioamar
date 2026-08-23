import 'package:flutter/material.dart';

import '../models/portfolio_content.dart';
import 'portfolio_repository.dart';

class StaticPortfolioRepository implements PortfolioRepository {
  const StaticPortfolioRepository();

  @override
  Future<PortfolioContent> loadContent() async => content;

  @override
  bool get acceptsReviews => false;

  @override
  Future<void> submitReview({
    required String author,
    required String authorRole,
    required String quote,
    String? email,
  }) async {
    throw UnsupportedError(
      'Le dépôt d\'avis nécessite Supabase (voir supabase/schema.sql).',
    );
  }

  static const PortfolioContent content = PortfolioContent(
    profile: ProfileInfo(
      role: 'Web Designer',
      heroTitle: 'Portfolio',
      greeting: "Hello, I'm",
      firstName: 'Amar',
      lastName: 'Hammour',
      subrole: 'Web Designer & Digital Creative',
      lede:
          "Je conçois des visuels clairs, modernes et centrés sur l'utilisateur "
          "qui aident les marques à se démarquer.",
      signature: 'Amar Hammour',
    ),
    projectsSection: SectionCopy(
      title: 'Selected',
      accent: 'Projects',
      description:
          'Une sélection de travaux récents mêlant design, développement et '
          'résolution de problèmes.',
      linkLabel: 'Voir tous les projets',
    ),
    projects: <Project>[
      Project(
        id: 'studio-form',
        title: 'Studio Form',
        subtitle: 'Architecture Studio',
        thumbnailLabel: 'STUDIO\nFORM',
        gradient: <Color>[Color(0xFF2B2B28), Color(0xFF4A453D)],
      ),
      Project(
        id: 'avenue-co',
        title: 'Avenue & Co.',
        subtitle: 'Luxury Fashion Brand',
        thumbnailLabel: 'AVENUE & CO.',
        gradient: <Color>[Color(0xFFCBB79C), Color(0xFF7D6A52)],
      ),
      Project(
        id: 'the-journal',
        title: 'The Journal',
        subtitle: 'Editorial Platform',
        thumbnailLabel: 'THE JOURNAL',
        gradient: <Color>[Color(0xFFEFE9DE), Color(0xFFC9C1B2)],
        thumbnailTextColor: Color(0xFF2B2B28),
      ),
      Project(
        id: 'fuel-performance',
        title: 'Fuel Performance',
        subtitle: 'Sports Nutrition Brand',
        thumbnailLabel: 'FUEL PERFORMANCE',
        gradient: <Color>[Color(0xFF1C1C1A), Color(0xFF3A352E)],
      ),
    ],
    skillsSection: SectionCopy(title: 'Skills &', accent: 'Expertise'),
    skills: <Skill>[
      Skill(label: 'UI / UX Design', level: 95),
      Skill(label: 'Web Development', level: 90),
      Skill(label: 'Branding', level: 85),
      Skill(label: 'Responsive Design', level: 90),
      Skill(label: 'Interaction Design', level: 80),
    ],
    quote:
        'Je conçois et développe des expériences digitales qui ne sont pas '
        'seulement belles, mais aussi fonctionnelles, intuitives et marquantes.',
    features: <Feature>[
      Feature(
        iconKey: 'user',
        title: 'User-Centered Design',
        description: "Des expériences fluides et pensées pour l'utilisateur.",
      ),
      Feature(
        iconKey: 'code',
        title: 'Clean & Modern Code',
        description: 'Développement performant et évolutif.',
      ),
      Feature(
        iconKey: 'responsive',
        title: 'Fully Responsive',
        description: 'Un rendu parfait sur tous les écrans.',
      ),
      Feature(
        iconKey: 'performance',
        title: 'Performance Driven',
        description: 'Vitesse, SEO et bonnes pratiques intégrées.',
      ),
    ],
    testimonialsSection: SectionCopy(
      title: 'What Clients',
      accent: 'Say',
      description:
          "Retours sincères de clients avec qui j'ai eu le plaisir de travailler.",
    ),
    testimonials: <Testimonial>[
      Testimonial(
        quote:
            'Amar est un designer incroyable. Il a parfaitement compris notre '
            'vision et livré un site qui a dépassé nos attentes.',
        author: 'Jessica Lee',
        authorRole: 'Founder, Avenue & Co.',
      ),
      Testimonial(
        quote:
            'Professionnel, créatif et minutieux. Tout le processus a été '
            'fluide du début à la fin.',
        author: 'David Carter',
        authorRole: 'CEO, Studio Form',
      ),
    ],
    contact: ContactInfo(
      email: 'hello@amarhammour.design',
      website: 'www.amarhammour.design',
      availability: 'Disponible en freelance',
      headline: "Let's create",
      headlineAccent: 'something great',
      pitch:
          "Un projet en tête ? Construisons ensemble quelque chose qui a de "
          "l'impact.",
    ),
  );
}
