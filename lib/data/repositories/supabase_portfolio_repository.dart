import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/app_config.dart';
import '../models/portfolio_content.dart';
import 'portfolio_repository.dart';
import 'static_portfolio_repository.dart';

class SupabasePortfolioRepository implements PortfolioRepository {
  const SupabasePortfolioRepository(this._client);

  final SupabaseClient _client;

  static const PortfolioContent _fallback = StaticPortfolioRepository.content;

  @override
  bool get acceptsReviews => true;

  @override
  Future<PortfolioContent> loadContent() async {
    final List<dynamic> results = await Future.wait<dynamic>(<Future<dynamic>>[
      _client.from('site_settings').select().eq('id', 1).maybeSingle(),
      _client
          .from('projects')
          .select()
          .eq('published', true)
          .order('position', ascending: true),
      _client.from('skills').select().order('position', ascending: true),
      _client.from('features').select().order('position', ascending: true),
      _client
          .from('testimonials')
          .select()
          .eq('status', 'approved')
          .order('position', ascending: true)
          .order('created_at', ascending: true),
    ]);

    final Map<String, dynamic> settings =
        (results[0] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final List<Map<String, dynamic>> projectRows = _rows(results[1]);
    final List<Map<String, dynamic>> skillRows = _rows(results[2]);
    final List<Map<String, dynamic>> featureRows = _rows(results[3]);
    final List<Map<String, dynamic>> testimonialRows = _rows(results[4]);

    final List<Project> projects = projectRows
        .map((Map<String, dynamic> row) =>
            Project.fromRow(row, imageUrl: _imageUrl(row['image_path'])))
        .toList();

    return PortfolioContent(
      profile: ProfileInfo(
        role: _text(settings, 'role', _fallback.profile.role),
        heroSentence: _text(
            settings, 'hero_sentence', _fallback.profile.heroSentence),
        firstName: _text(settings, 'first_name', _fallback.profile.firstName),
        lastName: _text(settings, 'last_name', _fallback.profile.lastName),
        subrole: _text(settings, 'subrole', _fallback.profile.subrole),
        signature: _text(settings, 'signature', _fallback.profile.signature),
      ),
      projectsSection: SectionCopy(
        title: _text(settings, 'projects_title', _fallback.projectsSection.title),
        accent:
            _text(settings, 'projects_accent', _fallback.projectsSection.accent),
        description: settings['projects_description'] as String? ??
            _fallback.projectsSection.description,
        linkLabel: settings['projects_link_label'] as String? ??
            _fallback.projectsSection.linkLabel,
      ),
      projects: projects.isEmpty ? _fallback.projects : projects,
      skillsSection: SectionCopy(
        title: _text(settings, 'skills_title', _fallback.skillsSection.title),
        accent: _text(settings, 'skills_accent', _fallback.skillsSection.accent),
      ),
      skills: skillRows.isEmpty
          ? _fallback.skills
          : skillRows.map(Skill.fromRow).toList(),
      quote: _text(settings, 'quote', _fallback.quote),
      features: featureRows.isEmpty
          ? _fallback.features
          : featureRows.map(Feature.fromRow).toList(),
      testimonialsSection: SectionCopy(
        title: _text(
            settings, 'testimonials_title', _fallback.testimonialsSection.title),
        accent: _text(settings, 'testimonials_accent',
            _fallback.testimonialsSection.accent),
        description: settings['testimonials_description'] as String? ??
            _fallback.testimonialsSection.description,
      ),
      testimonials: testimonialRows.map(Testimonial.fromRow).toList(),
      contact: ContactInfo(
        email: _text(settings, 'contact_email', _fallback.contact.email),
        website: _text(settings, 'contact_website', _fallback.contact.website),
        availability: _text(
            settings, 'contact_availability', _fallback.contact.availability),
        headline:
            _text(settings, 'contact_headline', _fallback.contact.headline),
        headlineAccent: _text(settings, 'contact_headline_accent',
            _fallback.contact.headlineAccent),
        pitch: _text(settings, 'contact_pitch', _fallback.contact.pitch),
      ),
    );
  }

  @override
  Future<void> submitReview({
    required String author,
    required String authorRole,
    required String quote,
    String? email,
  }) async {
    await _client.from('testimonials').insert(<String, dynamic>{
      'author': author.trim(),
      'author_role': authorRole.trim(),
      'quote': quote.trim(),
      if (email != null && email.trim().isNotEmpty) 'email': email.trim(),
      'status': 'pending',
    });
  }

  List<Map<String, dynamic>> _rows(dynamic value) {
    if (value is! List) return <Map<String, dynamic>>[];
    return value
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);
  }

  String _text(Map<String, dynamic> row, String key, String fallback) {
    final Object? value = row[key];
    if (value is String && value.trim().isNotEmpty) return value;
    return fallback;
  }

  String? _imageUrl(Object? imagePath) {
    if (imagePath is! String || imagePath.trim().isEmpty) return null;
    final String path = imagePath.trim();
    if (path.startsWith('http')) return path;
    return _client.storage
        .from(AppConfig.projectImagesBucket)
        .getPublicUrl(path);
  }
}
