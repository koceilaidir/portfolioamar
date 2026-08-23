import 'package:flutter/material.dart';

/// Convertit une couleur "#RRGGBB" (ou "#AARRGGBB") en [Color].
Color colorFromHex(String value) {
  String hex = value.replaceAll('#', '').trim();
  if (hex.length == 6) hex = 'FF$hex';
  return Color(int.parse(hex, radix: 16));
}

/// Identité et pitch affichés dans le hero.
@immutable
class ProfileInfo {
  const ProfileInfo({
    required this.role,
    required this.heroTitle,
    required this.greeting,
    required this.firstName,
    required this.lastName,
    required this.subrole,
    required this.lede,
    required this.signature,
  });

  final String role;
  final String heroTitle;
  final String greeting;
  final String firstName;
  final String lastName;
  final String subrole;
  final String lede;
  final String signature;

  String get fullName => '$firstName $lastName';

  factory ProfileInfo.fromJson(Map<String, dynamic> json) => ProfileInfo(
        role: json['role'] as String,
        heroTitle: json['heroTitle'] as String,
        greeting: json['greeting'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        subrole: json['subrole'] as String,
        lede: json['lede'] as String,
        signature: json['signature'] as String,
      );
}

/// Un projet de la section "Selected Projects".
@immutable
class Project {
  const Project({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.thumbnailLabel,
    required this.gradient,
    this.thumbnailTextColor = Colors.white,
    this.url,
  });

  final String id;
  final String title;
  final String subtitle;

  /// Texte affiché en grand dans la vignette (retours à la ligne avec "\n").
  final String thumbnailLabel;

  /// Dégradé de la vignette (2 couleurs, orientation 135°).
  final List<Color> gradient;
  final Color thumbnailTextColor;
  final String? url;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'] as String,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String,
        thumbnailLabel: json['thumbnailLabel'] as String,
        gradient: (json['gradient'] as List<dynamic>)
            .map((dynamic e) => colorFromHex(e as String))
            .toList(),
        thumbnailTextColor: json['thumbnailTextColor'] == null
            ? Colors.white
            : colorFromHex(json['thumbnailTextColor'] as String),
        url: json['url'] as String?,
      );
}

/// Une ligne de compétence avec sa barre de progression.
@immutable
class Skill {
  const Skill({required this.label, required this.level});

  final String label;

  /// Niveau entre 0 et 100.
  final int level;

  double get fraction => (level / 100).clamp(0.0, 1.0);

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
        label: json['label'] as String,
        level: (json['level'] as num).round(),
      );
}

/// Un argument différenciant (icône + titre + description).
@immutable
class Feature {
  const Feature({
    required this.iconKey,
    required this.title,
    required this.description,
  });

  /// Clé résolue en icône par `AppIcons.resolve`.
  final String iconKey;
  final String title;
  final String description;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        iconKey: json['iconKey'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
      );
}

/// Un témoignage client.
@immutable
class Testimonial {
  const Testimonial({
    required this.quote,
    required this.author,
    required this.authorRole,
  });

  final String quote;
  final String author;
  final String authorRole;

  factory Testimonial.fromJson(Map<String, dynamic> json) => Testimonial(
        quote: json['quote'] as String,
        author: json['author'] as String,
        authorRole: json['authorRole'] as String,
      );
}

/// Coordonnées affichées dans le pied de page.
@immutable
class ContactInfo {
  const ContactInfo({
    required this.email,
    required this.website,
    required this.availability,
    required this.headline,
    required this.headlineAccent,
    required this.pitch,
  });

  final String email;
  final String website;
  final String availability;
  final String headline;
  final String headlineAccent;
  final String pitch;

  factory ContactInfo.fromJson(Map<String, dynamic> json) => ContactInfo(
        email: json['email'] as String,
        website: json['website'] as String,
        availability: json['availability'] as String,
        headline: json['headline'] as String,
        headlineAccent: json['headlineAccent'] as String,
        pitch: json['pitch'] as String,
      );
}

/// Titre + description d'une section.
@immutable
class SectionCopy {
  const SectionCopy({
    required this.title,
    required this.accent,
    this.description,
    this.linkLabel,
  });

  final String title;
  final String accent;
  final String? description;
  final String? linkLabel;

  factory SectionCopy.fromJson(Map<String, dynamic> json) => SectionCopy(
        title: json['title'] as String,
        accent: json['accent'] as String,
        description: json['description'] as String?,
        linkLabel: json['linkLabel'] as String?,
      );
}

/// L'ensemble du contenu du site. C'est le seul objet que l'UI consomme :
/// le back n'aura qu'à fournir un [PortfolioContent].
@immutable
class PortfolioContent {
  const PortfolioContent({
    required this.profile,
    required this.projectsSection,
    required this.projects,
    required this.skillsSection,
    required this.skills,
    required this.quote,
    required this.features,
    required this.testimonialsSection,
    required this.testimonials,
    required this.contact,
  });

  final ProfileInfo profile;
  final SectionCopy projectsSection;
  final List<Project> projects;
  final SectionCopy skillsSection;
  final List<Skill> skills;
  final String quote;
  final List<Feature> features;
  final SectionCopy testimonialsSection;
  final List<Testimonial> testimonials;
  final ContactInfo contact;

  factory PortfolioContent.fromJson(Map<String, dynamic> json) =>
      PortfolioContent(
        profile: ProfileInfo.fromJson(json['profile'] as Map<String, dynamic>),
        projectsSection:
            SectionCopy.fromJson(json['projectsSection'] as Map<String, dynamic>),
        projects: (json['projects'] as List<dynamic>)
            .map((dynamic e) => Project.fromJson(e as Map<String, dynamic>))
            .toList(),
        skillsSection:
            SectionCopy.fromJson(json['skillsSection'] as Map<String, dynamic>),
        skills: (json['skills'] as List<dynamic>)
            .map((dynamic e) => Skill.fromJson(e as Map<String, dynamic>))
            .toList(),
        quote: json['quote'] as String,
        features: (json['features'] as List<dynamic>)
            .map((dynamic e) => Feature.fromJson(e as Map<String, dynamic>))
            .toList(),
        testimonialsSection: SectionCopy.fromJson(
            json['testimonialsSection'] as Map<String, dynamic>),
        testimonials: (json['testimonials'] as List<dynamic>)
            .map((dynamic e) => Testimonial.fromJson(e as Map<String, dynamic>))
            .toList(),
        contact: ContactInfo.fromJson(json['contact'] as Map<String, dynamic>),
      );
}
