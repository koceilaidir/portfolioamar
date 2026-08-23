/// Configuration injectée à la compilation.
///
/// En développement :
/// ```bash
/// flutter run -d chrome --dart-define-from-file=env.json
/// ```
/// avec un fichier `env.json` (non versionné) :
/// ```json
/// {
///   "SUPABASE_URL": "https://xxxx.supabase.co",
///   "SUPABASE_ANON_KEY": "eyJhbGciOi..."
/// }
/// ```
/// Si rien n'est fourni, le site retombe sur le contenu statique embarqué.
abstract final class AppConfig {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Nom du bucket Supabase Storage contenant les visuels des projets.
  static const String projectImagesBucket = 'project-images';

  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
