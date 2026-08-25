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
class ProjectPhoto {
  const ProjectPhoto({required this.url, this.caption = ''});

  final String url;
  final String caption;

  factory ProjectPhoto.fromJson(Map<String, dynamic> json) => ProjectPhoto(
        url: json['url'] as String,
        caption: json['caption'] as String? ?? '',
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
    this.description = '',
    this.client = '',
    this.year = '',
    this.role = '',
    this.photos = const <ProjectPhoto>[],
  });

  final String id;
  final String title;
  final String subtitle;

  final String thumbnailLabel;

  final List<Color> gradient;
  final Color thumbnailTextColor;

  final String? imageUrl;
  final String? url;

  final String description;
  final String client;
  final String year;
  final String role;
  final List<ProjectPhoto> photos;

  bool get hasDetail =>
      description.trim().isNotEmpty ||
      client.trim().isNotEmpty ||
      year.trim().isNotEmpty ||
      role.trim().isNotEmpty ||
      photos.isNotEmpty;

  List<ProjectPhoto> get gallery {
    if (photos.isNotEmpty) return photos;
    final String? cover = imageUrl;
    if (cover == null || cover.trim().isEmpty) return const <ProjectPhoto>[];
    return <ProjectPhoto>[ProjectPhoto(url: cover)];
  }

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
        description: json['description'] as String? ?? '',
        client: json['client'] as String? ?? '',
        year: json['year'] as String? ?? '',
        role: json['role'] as String? ?? '',
        photos: (json['photos'] as List<dynamic>? ?? <dynamic>[])
            .map((dynamic e) =>
                ProjectPhoto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  factory Project.fromRow(
    Map<String, dynamic> row, {
    String? imageUrl,
    List<ProjectPhoto> photos = const <ProjectPhoto>[],
  }) =>
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
        description: ((row['description'] ?? '') as String).trim(),
        client: ((row['client'] ?? '') as String).trim(),
        year: ((row['project_year'] ?? '') as String).trim(),
        role: ((row['project_role'] ?? '') as String).trim(),
        photos: photos,
      );
}

@immutable
class Skill {
  const Skill({
    required this.label,
    required this.level,
    this.shortLabel = '',
  });

  final String label;

  final int level;

  final String shortLabel;

  double get fraction => (level / 100).clamp(0.0, 1.0);

  String get badge {
    final String custom = shortLabel.trim();
    if (custom.isNotEmpty) return custom;
    final List<String> words = label
        .trim()
        .split(RegExp(r'[\s/&+.-]+'))
        .where((String word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) {
      final String word = words.first;
      if (word.length == 1) return word.toUpperCase();
      return word.substring(0, 1).toUpperCase() +
          word.substring(1, 2).toLowerCase();
    }
    return words
        .take(2)
        .map((String word) => word.substring(0, 1).toUpperCase())
        .join();
  }

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
        label: json['label'] as String,
        level: (json['level'] as num).round(),
        shortLabel: json['shortLabel'] as String? ?? '',
      );

  factory Skill.fromRow(Map<String, dynamic> row) => Skill(
        label: (row['label'] ?? '') as String,
        level: ((row['level'] ?? 0) as num).round(),
        shortLabel: (row['short_label'] ?? '') as String,
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
class AboutStep {
  const AboutStep({required this.title, required this.description});

  final String title;
  final String description;

  factory AboutStep.fromJson(Map<String, dynamic> json) => AboutStep(
        title: json['title'] as String,
        description: json['description'] as String,
      );

  factory AboutStep.fromRow(Map<String, dynamic> row) => AboutStep(
        title: (row['title'] ?? '') as String,
        description: (row['description'] ?? '') as String,
      );
}

@immutable
class AboutInfo {
  const AboutInfo({
    required this.visible,
    required this.kicker,
    required this.title,
    required this.quote,
    required this.body,
    required this.tags,
    required this.steps,
  });

  final bool visible;
  final String kicker;
  final String title;
  final String quote;
  final String body;
  final List<String> tags;
  final List<AboutStep> steps;

  static const AboutInfo empty = AboutInfo(
    visible: false,
    kicker: '',
    title: '',
    quote: '',
    body: '',
    tags: <String>[],
    steps: <AboutStep>[],
  );

  static List<String> splitTags(String raw) => raw
      .split(RegExp(r'[,\n]'))
      .map((String value) => value.trim())
      .where((String value) => value.isNotEmpty)
      .toList(growable: false);

  List<String> get paragraphs => body
      .split(RegExp(r'\n\s*\n'))
      .map((String value) => value.trim())
      .where((String value) => value.isNotEmpty)
      .toList(growable: false);

  bool get hasContent =>
      title.trim().isNotEmpty ||
      quote.trim().isNotEmpty ||
      paragraphs.isNotEmpty ||
      steps.isNotEmpty;

  bool get isShown => visible && hasContent;

  factory AboutInfo.fromJson(Map<String, dynamic> json) => AboutInfo(
        visible: json['visible'] as bool? ?? true,
        kicker: json['kicker'] as String? ?? '',
        title: json['title'] as String? ?? '',
        quote: json['quote'] as String? ?? '',
        body: json['body'] as String? ?? '',
        tags: (json['tags'] as List<dynamic>? ?? <dynamic>[])
            .map((dynamic e) => e as String)
            .toList(),
        steps: (json['steps'] as List<dynamic>? ?? <dynamic>[])
            .map((dynamic e) => AboutStep.fromJson(e as Map<String, dynamic>))
            .toList(),
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
    this.about = AboutInfo.empty,
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
  final AboutInfo about;
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
        about: json['about'] == null
            ? AboutInfo.empty
            : AboutInfo.fromJson(json['about'] as Map<String, dynamic>),
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
