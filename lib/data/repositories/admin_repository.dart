import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/app_config.dart';

class AdminRepository {
  const AdminRepository(this.client);

  final SupabaseClient client;

  bool get isSignedIn => client.auth.currentUser != null;

  String? get currentEmail => client.auth.currentUser?.email;

  Future<void> signIn({required String email, required String password}) async {
    await client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signOut() => client.auth.signOut();

  Future<bool> isAdmin() async {
    final List<dynamic> rows =
        await client.from('admins').select('user_id').limit(1);
    return rows.isNotEmpty;
  }

  Future<Map<String, dynamic>> loadSettings() async {
    final Map<String, dynamic>? row =
        await client.from('site_settings').select().eq('id', 1).maybeSingle();
    return row ?? <String, dynamic>{};
  }

  Future<void> saveSettings(Map<String, dynamic> values) async {
    await client.from('site_settings').update(values).eq('id', 1);
  }

  Future<List<Map<String, dynamic>>> loadRows(String table) async {
    final List<dynamic> rows =
        await client.from(table).select().order('position', ascending: true);
    return rows.cast<Map<String, dynamic>>().toList();
  }

  Future<List<Map<String, dynamic>>> loadTestimonials() async {
    final List<dynamic> rows = await client
        .from('testimonials')
        .select()
        .order('created_at', ascending: false);
    return rows.cast<Map<String, dynamic>>().toList();
  }

  Future<List<Map<String, dynamic>>> loadProjectImages(Object projectId) async {
    final List<dynamic> rows = await client
        .from('project_images')
        .select()
        .eq('project_id', projectId)
        .order('position', ascending: true)
        .order('created_at', ascending: true);
    return rows.cast<Map<String, dynamic>>().toList();
  }

  Future<void> addProjectImage({
    required Object projectId,
    required String imagePath,
    required int position,
  }) async {
    await client.from('project_images').insert(<String, dynamic>{
      'project_id': projectId,
      'image_path': imagePath,
      'position': position,
    });
  }

  Future<void> reorderProjectImages(List<Object> orderedIds) async {
    for (int i = 0; i < orderedIds.length; i++) {
      await client
          .from('project_images')
          .update(<String, dynamic>{'position': i + 1}).eq('id', orderedIds[i]);
    }
  }

  Future<Map<String, dynamic>> insertRow(
    String table,
    Map<String, dynamic> values,
  ) async {
    final Map<String, dynamic> row =
        await client.from(table).insert(values).select().single();
    return row;
  }

  Future<void> updateRow(
    String table,
    Object id,
    Map<String, dynamic> values,
  ) async {
    await client.from(table).update(values).eq('id', id);
  }

  Future<void> deleteRow(String table, Object id) async {
    await client.from(table).delete().eq('id', id);
  }

  Future<String> uploadProjectImage({
    required String fileName,
    required Uint8List bytes,
  }) async {
    await client.storage.from(AppConfig.projectImagesBucket).uploadBinary(
          fileName,
          bytes,
          fileOptions: const FileOptions(upsert: true, cacheControl: '3600'),
        );
    return fileName;
  }

  Future<void> removeStoredImage(String path) async {
    final String name = path.trim();
    if (name.isEmpty || name.startsWith('http')) return;
    try {
      await client.storage
          .from(AppConfig.projectImagesBucket)
          .remove(<String>[name]);
    } catch (_) {
      return;
    }
  }

  String publicImageUrl(String path) {
    if (path.startsWith('http')) return path;
    return client.storage
        .from(AppConfig.projectImagesBucket)
        .getPublicUrl(path);
  }

  Future<int> nextPosition(String table) async {
    final List<dynamic> rows =
        await client.from(table).select('position').order(
              'position',
              ascending: true,
            );
    if (rows.isEmpty) return 1;
    final Map<String, dynamic> last = rows.last as Map<String, dynamic>;
    return ((last['position'] as num?)?.toInt() ?? 0) + 1;
  }
}
