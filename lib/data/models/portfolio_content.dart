import 'package:flutter/material.dart';

Color colorFromHex(String value) {
  String hex = value.replaceAll('#', '').trim();
  if (hex.length == 6) hex = 'FF$hex';
  return Color(int.parse(hex, radix: 16));
}

@immutable
class ProfileInfo {
  const ProfileInfo({
    required this.role,
    required this.heroSentence,
    required this.firstName,
    required this.lastName,
    required this.subrole,
    required this.signature,
  });

  final String role;

  final String heroSentence;
  final String firstName;
  final String lastName;
  final String subrole;
  final String signature;

  String get fullName => '$firstName $lastName';

  factory ProfileInfo.fromJson(Map<String, dynamic> json) => ProfileInfo(
        role: json['role'] as String,
        heroSentence: json['heroSentence'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        subrole: json['subrole'] as String,
        signature: json['signature'] as String,
      );
}

@immutable
class Project {
  const Project({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.thumbnailLabel,
    required this.gradient,
    this.thumbnailTextColor = Colors.white,
    this.imageUrl,
    this.url,
  });

  final String id;
  final String title;
  final String subtitle;

  final String thumbnailLabel;

  final List<Color> gradient;
  final Color thumbnailTextColor;

  final String? imageUrl;
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
        imageUrl: json['imageUrl'] as String?,
        url: json['url'] as String?,
      );

  factory Project.fromRow(Map<String, dynamic> row, {String? imageUrl}) =>
      Project(
        id: row['id'].toString(),
        title: (row['title'] ?? '') as String,
        subtitle: (row['subtitle'] ?? '') as String,
        thumbnailLabel: (row['thumbnail_label'] ?? '') as String,
        gradient: <Color>[
          colorFromHex((row['gradient_start'] ?? '#2B2B28') as String),
          colorFromHex((row['gradient_end'] ?? '#4A453D') as String),
        ],
        thumbnailTextColor:
            colorFromHex((row['thumbnail_text_color'] ?? '#FFFFFF') as String),
        imageUrl: imageUrl,
        url: row['url'] as String?,
      );
}

@immutable
class Skill {
  const Skill({required this.label, required this.level});

  final String label;

  final int level;

  double get fraction => (level / 100).clamp(0.0, 1.0);

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
        label: json['label'] as String,
        level: (json['level'] as num).round(),
      );

  factory Skill.fromRow(Map<String, dynamic> row) => Skill(
        label: (row['label'] ?? '') as String,
        level: ((row['level'] ?? 0) as num).round(),
      );
}

@immutable
class Feature {
  const Feature({
    required this.iconKey,
    required this.title,
    required this.description,
  });

  final String iconKey;
  final String title;
  final String description;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        iconKey: json['iconKey'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
      );

  factory Feature.fromRow(Map<String, dynamic> row) => Feature(
        iconKey: (row['icon_key'] ?? 'star') as String,
        title: (row['title'] ?? '') as String,
        description: (row['description'] ?? '') as String,
      );
}

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

  factory Testimonial.fromRow(Map<String, dynamic> row) => Testimonial(
        quote: (row['quote'] ?? '') as String,
        author: (row['author'] ?? '') as String,
        authorRole: (row['author_role'] ?? '') as String,
      );
}

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
    this.testimonialsVisible = true,
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

  final bool testimonialsVisible;

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
        testimonialsVisible: json['testimonialsVisible'] as bool? ?? true,
      );
}
