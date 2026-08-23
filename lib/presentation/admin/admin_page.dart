import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/repositories/admin_repository.dart';
import 'admin_fields.dart';
import 'admin_tabs.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key, required this.repository});

  final AdminRepository repository;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool _checking = true;
  bool _authorized = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    bool authorized = false;
    if (widget.repository.isSignedIn) {
      try {
        authorized = await widget.repository.isAdmin();
      } catch (_) {
        authorized = false;
      }
    }
    if (!mounted) return;
    setState(() {
      _checking = false;
      _authorized = authorized;
    });
  }

  Future<void> _signOut() async {
    await widget.repository.signOut();
    if (!mounted) return;
    setState(() => _authorized = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.terracotta),
        ),
      );
    }

    if (!_authorized) {
      return _LoginScreen(
        repository: widget.repository,
        onSuccess: () => setState(() => _authorized = true),
      );
    }

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: AppColors.cream,
        appBar: AppBar(
          backgroundColor: AppColors.cream,
          surfaceTintColor: Colors.transparent,
          foregroundColor: AppColors.ink,
          elevation: 0,
          title: Text('Administration', style: AppText.sectionKicker(20)),
          actions: <Widget>[
            IconButton(
              tooltip: 'Se déconnecter',
              onPressed: _signOut,
              icon: const Icon(Icons.logout_rounded, size: 20),
            ),
            const SizedBox(width: 8),
          ],
          bottom: TabBar(
            isScrollable: true,
            labelColor: AppColors.terracottaDeep,
            unselectedLabelColor: AppColors.inkSoft,
            indicatorColor: AppColors.terracotta,
            dividerColor: AppColors.line,
            labelStyle: AppText.navLink.copyWith(fontSize: 12),
            unselectedLabelStyle: AppText.navLink.copyWith(fontSize: 12),
            tabs: const <Widget>[
              Tab(text: 'TEXTES'),
              Tab(text: 'PROJETS'),
              Tab(text: 'COMPÉTENCES'),
              Tab(text: 'ATOUTS'),
              Tab(text: 'AVIS'),
            ],
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TabBarView(
                children: <Widget>[
                  SettingsTab(repository: widget.repository),
                  TableTab(
                    repository: widget.repository,
                    table: 'projects',
                    titleColumn: 'title',
                    addLabel: 'Ajouter un projet',
                    newRowDefaults: const <String, dynamic>{
                      'title': 'Nouveau projet',
                      'subtitle': '',
                      'thumbnail_label': 'NOUVEAU',
                      'published': false,
                    },
                    fields: const <AdminField>[
                      AdminField('title', 'Titre'),
                      AdminField('subtitle', 'Sous-titre'),
                      AdminField(
                        'thumbnail_label',
                        'Texte sur la vignette',
                        kind: AdminFieldKind.multiline,
                        hint: 'Appuie sur Entrée pour un retour à la ligne',
                      ),
                      AdminField('gradient_start', 'Dégradé : couleur 1',
                          hint: '#2B2B28'),
                      AdminField('gradient_end', 'Dégradé : couleur 2',
                          hint: '#4A453D'),
                      AdminField('thumbnail_text_color', 'Couleur du texte',
                          hint: '#FFFFFF'),
                      AdminField(
                        'image_path',
                        'Image',
                        hint: 'Nom du fichier dans le bucket, ou URL complète',
                      ),
                      AdminField('url', 'Lien du projet'),
                      AdminField('position', 'Ordre',
                          kind: AdminFieldKind.number),
                      AdminField('published', 'Visible sur le site',
                          kind: AdminFieldKind.toggle),
                    ],
                  ),
                  TableTab(
                    repository: widget.repository,
                    table: 'skills',
                    titleColumn: 'label',
                    addLabel: 'Ajouter une compétence',
                    newRowDefaults: const <String, dynamic>{
                      'label': 'Nouvelle compétence',
                      'level': 80,
                    },
                    fields: const <AdminField>[
                      AdminField('label', 'Intitulé'),
                      AdminField('level', 'Niveau (0 à 100)',
                          kind: AdminFieldKind.number),
                      AdminField('position', 'Ordre',
                          kind: AdminFieldKind.number),
                    ],
                  ),
                  TableTab(
                    repository: widget.repository,
                    table: 'features',
                    titleColumn: 'title',
                    addLabel: 'Ajouter un atout',
                    newRowDefaults: const <String, dynamic>{
                      'title': 'Nouvel atout',
                      'description': '',
                      'icon_key': 'star',
                    },
                    fields: const <AdminField>[
                      AdminField('title', 'Titre'),
                      AdminField('description', 'Description',
                          kind: AdminFieldKind.multiline),
                      AdminField(
                        'icon_key',
                        'Icône',
                        hint: 'user, code, responsive, performance, design, star',
                      ),
                      AdminField('position', 'Ordre',
                          kind: AdminFieldKind.number),
                    ],
                  ),
                  ReviewsTab(repository: widget.repository),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginScreen extends StatefulWidget {
  const _LoginScreen({required this.repository, required this.onSuccess});

  final AdminRepository repository;
  final VoidCallback onSuccess;

  @override
  State<_LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _fail(String message) {
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = message;
    });
  }

  String _readable(Object error) {
    final String raw = error.toString();
    if (raw.contains('Invalid login credentials')) {
      return 'Email ou mot de passe incorrect.';
    }
    if (raw.contains('Email not confirmed')) {
      return "Email non confirmé. Dans Supabase : Authentication > Users > "
          "ouvrir le compte > Confirm email.";
    }
    if (raw.contains('Failed host lookup') || raw.contains('ClientException')) {
      return 'Serveur injoignable. Vérifie la connexion et les clés Supabase.';
    }
    return raw;
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      await widget.repository.signIn(
        email: _email.text,
        password: _password.text,
      );
    } catch (error) {
      _fail('Connexion refusée. ${_readable(error)}');
      return;
    }

    bool admin = false;
    try {
      admin = await widget.repository.isAdmin();
    } catch (error) {
      await widget.repository.signOut();
      _fail(
        'Compte reconnu, mais impossible de vérifier les droits. '
        'Le fichier supabase/admin.sql a-t-il bien été exécuté ? '
        '${_readable(error)}',
      );
      return;
    }

    if (!admin) {
      await widget.repository.signOut();
      _fail(
        'Compte reconnu, mais absent de la table admins. '
        "Exécute la requête insert into public.admins avec l'email "
        '${_email.text.trim()}',
      );
      return;
    }

    if (!mounted) return;
    widget.onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.ink,
        elevation: 0,
        title: Text('Administration', style: AppText.sectionKicker(20)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: AdminCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Connexion', style: AppText.sectionKicker(24)),
                  const SizedBox(height: 6),
                  Text(
                    'Réservé au propriétaire du site.',
                    style: AppText.sectionDesc,
                  ),
                  const SizedBox(height: 18),
                  AdminInput(
                    controller: _email,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  AdminInput(
                    controller: _password,
                    label: 'Mot de passe',
                    obscureText: true,
                  ),
                  if (_error != null) ...<Widget>[
                    Text(
                      _error!,
                      style: AppText.sectionDesc
                          .copyWith(color: AppColors.terracottaDeep),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Align(
                    alignment: Alignment.centerRight,
                    child: AdminActionButton(
                      label: _busy ? 'Connexion…' : 'Se connecter',
                      onPressed: _busy ? null : _submit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
