import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/repositories/admin_repository.dart';
import 'admin_fields.dart';
import 'admin_gallery_field.dart';
import 'admin_image_field.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key, required this.repository});

  final AdminRepository repository;

  static const List<AdminField> fields = <AdminField>[
    AdminField(
      'hero_sentence',
      'Phrase du hero (optionnelle, vide = rien)',
      kind: AdminFieldKind.multiline,
      hint: '*mot* = mis en avant en gras',
    ),
    AdminField('subrole', 'Métier (sous la signature du hero)'),
    AdminField('signature', 'Signature manuscrite'),
    AdminField('first_name', 'Prénom'),
    AdminField('last_name', 'Nom'),
    AdminField('projects_title', 'Projets : titre'),
    AdminField('projects_accent', 'Projets : mot en rouge'),
    AdminField('projects_description', 'Projets : description',
        kind: AdminFieldKind.multiline),
    AdminField('projects_link_label', 'Projets : libellé du lien'),
    AdminField('skills_title', 'Compétences : titre'),
    AdminField('skills_accent', 'Compétences : mot en rouge'),
    AdminField('skills_description', 'Compétences : sous-titre',
        kind: AdminFieldKind.multiline),
    AdminField('quote', 'Citation', kind: AdminFieldKind.multiline),
    AdminField('testimonials_title', 'Avis : titre'),
    AdminField('testimonials_accent', 'Avis : mot en rouge'),
    AdminField('testimonials_description', 'Avis : description',
        kind: AdminFieldKind.multiline),
    AdminField('contact_headline', 'Pied de page : titre'),
    AdminField('contact_headline_accent', 'Pied de page : mot en rouge'),
    AdminField('contact_pitch', 'Pied de page : texte',
        kind: AdminFieldKind.multiline),
    AdminField('contact_email', 'Email de contact'),
    AdminField('contact_website', 'Site web'),
    AdminField('contact_availability', 'Disponibilité'),
  ];

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  final Map<String, TextEditingController> _controllers =
      <String, TextEditingController>{};
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final TextEditingController c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final Map<String, dynamic> row = await widget.repository.loadSettings();
      final Map<String, TextEditingController> next =
          <String, TextEditingController>{
        for (final AdminField field in SettingsTab.fields)
          field.column:
              TextEditingController(text: (row[field.column] ?? '').toString()),
      };
      if (!mounted) {
        for (final TextEditingController c in next.values) {
          c.dispose();
        }
        return;
      }
      _controllers.addAll(next);
      setState(() => _loading = false);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = error.toString();
      });
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final Map<String, dynamic> values = <String, dynamic>{
      for (final AdminField field in SettingsTab.fields)
        field.column: _controllers[field.column]!.text.trim(),
    };
    try {
      await widget.repository.saveSettings(values);
      if (!mounted) return;
      showAdminMessage(context, 'Textes enregistrés.');
    } catch (error) {
      if (!mounted) return;
      showAdminMessage(context, "Échec : ${adminErrorText(error)}", error: true);
    }
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (_error != null) {
      return Center(child: Text(_error!, style: AppText.sectionDesc));
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 40),
      children: <Widget>[
        AdminCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (final AdminField field in SettingsTab.fields)
                AdminInput(
                  controller: _controllers[field.column]!,
                  label: field.label,
                  hint: field.hint,
                  maxLines:
                      field.kind == AdminFieldKind.multiline ? 4 : 1,
                ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: AdminActionButton(
                  label: _saving ? 'Enregistrement…' : 'Enregistrer',
                  icon: Icons.check_rounded,
                  onPressed: _saving ? null : _save,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AboutTab extends StatefulWidget {
  const AboutTab({super.key, required this.repository});

  final AdminRepository repository;

  static const List<AdminField> fields = <AdminField>[
    AdminField('about_kicker', 'Petit titre au-dessus', hint: 'À PROPOS'),
    AdminField(
      'about_title',
      'Grand titre',
      kind: AdminFieldKind.multiline,
      hint: '*mot* = mot en rouge. Entrée = retour à la ligne.',
    ),
    AdminField(
      'about_quote',
      'Phrase mise en avant (encadré)',
      kind: AdminFieldKind.multiline,
      hint: 'Laisser vide pour retirer l’encadré',
    ),
    AdminField(
      'about_body',
      'Texte de présentation',
      kind: AdminFieldKind.multiline,
      hint: 'Une ligne vide entre deux paragraphes. *mot* = mot en gras.',
    ),
    AdminField(
      'about_tags',
      'Étiquettes',
      kind: AdminFieldKind.multiline,
      hint: 'Séparées par des virgules. Laisser vide pour les retirer.',
    ),
  ];

  static const List<AdminField> stepFields = <AdminField>[
    AdminField('title', 'Titre de l’étape'),
    AdminField('description', 'Description',
        kind: AdminFieldKind.multiline),
    AdminField('position', 'Ordre', kind: AdminFieldKind.number),
  ];

  @override
  State<AboutTab> createState() => _AboutTabState();
}

class _AboutTabState extends State<AboutTab> {
  final Map<String, TextEditingController> _controllers =
      <String, TextEditingController>{};
  List<Map<String, dynamic>> _steps = <Map<String, dynamic>>[];
  bool _loading = true;
  bool _saving = false;
  bool _visible = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final TextEditingController c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final Map<String, dynamic> row = await widget.repository.loadSettings();
      final List<Map<String, dynamic>> steps =
          await widget.repository.loadRows('about_steps');
      final Map<String, TextEditingController> next =
          <String, TextEditingController>{
        for (final AdminField field in AboutTab.fields)
          field.column:
              TextEditingController(text: (row[field.column] ?? '').toString()),
      };
      if (!mounted) {
        for (final TextEditingController c in next.values) {
          c.dispose();
        }
        return;
      }
      _controllers.addAll(next);
      setState(() {
        _steps = steps;
        _visible = row['about_visible'] != false;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = error.toString();
      });
    }
  }

  Future<void> _reloadSteps() async {
    try {
      final List<Map<String, dynamic>> steps =
          await widget.repository.loadRows('about_steps');
      if (!mounted) return;
      setState(() => _steps = steps);
    } catch (error) {
      if (!mounted) return;
      showAdminMessage(context, "Rechargement impossible : ${adminErrorText(error)}",
          error: true);
    }
  }

  Future<void> _setVisible(bool value) async {
    final bool previous = _visible;
    setState(() => _visible = value);
    try {
      await widget.repository.saveSettings(<String, dynamic>{
        'about_visible': value,
      });
      if (!mounted) return;
      showAdminMessage(
        context,
        value
            ? 'La section À propos est affichée sur le site.'
            : 'La section À propos est masquée du site.',
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _visible = previous);
      showAdminMessage(context, "Action impossible : ${adminErrorText(error)}",
          error: true);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final Map<String, dynamic> values = <String, dynamic>{
      for (final AdminField field in AboutTab.fields)
        field.column: _controllers[field.column]!.text.trim(),
    };
    try {
      await widget.repository.saveSettings(values);
      if (!mounted) return;
      showAdminMessage(context, 'Textes enregistrés.');
    } catch (error) {
      if (!mounted) return;
      showAdminMessage(context, "Échec : ${adminErrorText(error)}", error: true);
    }
    if (mounted) setState(() => _saving = false);
  }

  Future<void> _addStep() async {
    try {
      final int position = await widget.repository.nextPosition('about_steps');
      await widget.repository.insertRow('about_steps', <String, dynamic>{
        'title': 'Nouvelle étape',
        'description': '',
        'position': position,
      });
      await _reloadSteps();
      if (!mounted) return;
      showAdminMessage(context, 'Étape ajoutée.');
    } catch (error) {
      if (!mounted) return;
      showAdminMessage(context, "Ajout impossible : ${adminErrorText(error)}",
          error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (_error != null) {
      return Center(child: Text(_error!, style: AppText.sectionDesc));
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 40),
      children: <Widget>[
        AdminCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AdminToggle(
                label: 'Afficher la section À propos sur le site',
                value: _visible,
                onChanged: _setVisible,
              ),
              Text(
                _visible
                    ? 'La section apparaît sous le hero, avec son lien dans le menu.'
                    : 'La section et son lien dans le menu sont masqués. Les textes restent enregistrés ici.',
                style: AppText.sectionDesc,
              ),
            ],
          ),
        ),
        AdminCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (final AdminField field in AboutTab.fields)
                AdminInput(
                  controller: _controllers[field.column]!,
                  label: field.label,
                  hint: field.hint,
                  maxLines: field.kind == AdminFieldKind.multiline ? 4 : 1,
                ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: AdminActionButton(
                  label: _saving ? 'Enregistrement…' : 'Enregistrer',
                  icon: Icons.check_rounded,
                  onPressed: _saving ? null : _save,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 6, 2, 12),
          child: Text('LES ÉTAPES DE LA MÉTHODE', style: AppText.skillLabel),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: AdminActionButton(
            label: 'Ajouter une étape',
            icon: Icons.add_rounded,
            onPressed: _addStep,
          ),
        ),
        if (_steps.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'Aucune étape. La colonne de droite ne sera pas affichée.',
              textAlign: TextAlign.center,
              style: AppText.sectionDesc,
            ),
          ),
        for (final Map<String, dynamic> row in _steps)
          RowEditor(
            key: ValueKey<Object?>(row['id']),
            repository: widget.repository,
            row: row,
            fields: AboutTab.stepFields,
            title: (row['title'] ?? 'Sans titre').toString(),
            onSave: (Map<String, dynamic> values) => widget.repository
                .updateRow('about_steps', row['id'] as Object, values),
            onDelete: () async {
              await widget.repository
                  .deleteRow('about_steps', row['id'] as Object);
              await _reloadSteps();
            },
          ),
      ],
    );
  }
}

class TableTab extends StatefulWidget {
  const TableTab({
    super.key,
    required this.repository,
    required this.table,
    required this.fields,
    required this.titleColumn,
    required this.newRowDefaults,
    required this.addLabel,
  });

  final AdminRepository repository;
  final String table;
  final List<AdminField> fields;
  final String titleColumn;
  final Map<String, dynamic> newRowDefaults;
  final String addLabel;

  @override
  State<TableTab> createState() => _TableTabState();
}

class _TableTabState extends State<TableTab> {
  List<Map<String, dynamic>> _rows = <Map<String, dynamic>>[];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final List<Map<String, dynamic>> rows =
          await widget.repository.loadRows(widget.table);
      if (!mounted) return;
      setState(() {
        _rows = rows;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = error.toString();
      });
    }
  }

  Future<void> _add() async {
    try {
      final int position = await widget.repository.nextPosition(widget.table);
      final Map<String, dynamic> values =
          Map<String, dynamic>.from(widget.newRowDefaults)
            ..['position'] = position;
      await widget.repository.insertRow(widget.table, values);
      await _load();
      if (!mounted) return;
      showAdminMessage(context, 'Élément ajouté.');
    } catch (error) {
      if (!mounted) return;
      showAdminMessage(context, "Ajout impossible : ${adminErrorText(error)}",
          error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (_error != null) {
      return Center(child: Text(_error!, style: AppText.sectionDesc));
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 40),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: AdminActionButton(
            label: widget.addLabel,
            icon: Icons.add_rounded,
            onPressed: _add,
          ),
        ),
        for (final Map<String, dynamic> row in _rows)
          RowEditor(
            key: ValueKey<Object?>(row['id']),
            repository: widget.repository,
            row: row,
            fields: widget.fields,
            title: (row[widget.titleColumn] ?? 'Sans titre').toString(),
            onSave: (Map<String, dynamic> values) =>
                widget.repository.updateRow(widget.table, row['id'] as Object, values),
            onDelete: () async {
              await widget.repository.deleteRow(widget.table, row['id'] as Object);
              await _load();
            },
          ),
      ],
    );
  }
}

class RowEditor extends StatefulWidget {
  const RowEditor({
    super.key,
    required this.repository,
    required this.row,
    required this.fields,
    required this.title,
    required this.onSave,
    required this.onDelete,
  });

  final AdminRepository repository;
  final Map<String, dynamic> row;
  final List<AdminField> fields;
  final String title;
  final Future<void> Function(Map<String, dynamic> values) onSave;
  final Future<void> Function() onDelete;

  @override
  State<RowEditor> createState() => _RowEditorState();
}

class _RowEditorState extends State<RowEditor> {
  final Map<String, TextEditingController> _controllers =
      <String, TextEditingController>{};
  final Map<String, bool> _toggles = <String, bool>{};
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    for (final AdminField field in widget.fields) {
      final Object? value = widget.row[field.column];
      if (field.kind == AdminFieldKind.gallery) {
        continue;
      } else if (field.kind == AdminFieldKind.toggle) {
        _toggles[field.column] = value == true;
      } else {
        _controllers[field.column] =
            TextEditingController(text: (value ?? '').toString());
      }
    }
  }

  @override
  void dispose() {
    for (final TextEditingController c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    final Map<String, dynamic> values = <String, dynamic>{};
    for (final AdminField field in widget.fields) {
      if (field.kind == AdminFieldKind.gallery) {
        continue;
      } else if (field.kind == AdminFieldKind.toggle) {
        values[field.column] = _toggles[field.column] ?? false;
      } else if (field.kind == AdminFieldKind.number) {
        values[field.column] =
            int.tryParse(_controllers[field.column]!.text.trim()) ?? 0;
      } else {
        values[field.column] = _controllers[field.column]!.text.trim();
      }
    }
    try {
      await widget.onSave(values);
      if (!mounted) return;
      showAdminMessage(context, 'Modifications enregistrées.');
    } catch (error) {
      if (!mounted) return;
      showAdminMessage(context, "Échec : ${adminErrorText(error)}", error: true);
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _confirmDelete() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppColors.cream,
        title: Text('Supprimer ?', style: AppText.sectionKicker(22)),
        content: Text(
          'Cette suppression est définitive.',
          style: AppText.sectionDesc,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await widget.onDelete();
    } catch (error) {
      if (!mounted) return;
      showAdminMessage(context, "Suppression impossible : ${adminErrorText(error)}",
          error: true);
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(top: 8),
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.inkSoft,
          title: Text(widget.title, style: AppText.projectTitle),
          children: <Widget>[
            for (final AdminField field in widget.fields)
              if (field.kind == AdminFieldKind.gallery)
                AdminGalleryField(
                  repository: widget.repository,
                  projectId: widget.row['id'] as Object,
                )
              else if (field.kind == AdminFieldKind.toggle)
                AdminToggle(
                  label: field.label,
                  value: _toggles[field.column] ?? false,
                  onChanged: (bool value) =>
                      setState(() => _toggles[field.column] = value),
                )
              else if (field.kind == AdminFieldKind.image)
                AdminImageField(
                  controller: _controllers[field.column]!,
                  repository: widget.repository,
                  label: field.label,
                  hint: field.hint,
                )
              else
                AdminInput(
                  controller: _controllers[field.column]!,
                  label: field.label,
                  hint: field.hint,
                  maxLines: field.kind == AdminFieldKind.multiline ? 3 : 1,
                  keyboardType: field.kind == AdminFieldKind.number
                      ? TextInputType.number
                      : null,
                ),
            Row(
              children: <Widget>[
                AdminActionButton(
                  label: 'Enregistrer',
                  icon: Icons.check_rounded,
                  onPressed: _busy ? null : _save,
                ),
                const SizedBox(width: 12),
                AdminActionButton(
                  label: 'Supprimer',
                  icon: Icons.delete_outline_rounded,
                  destructive: true,
                  outlined: true,
                  onPressed: _busy ? null : _confirmDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewsTab extends StatefulWidget {
  const ReviewsTab({super.key, required this.repository});

  final AdminRepository repository;

  @override
  State<ReviewsTab> createState() => _ReviewsTabState();
}

class _ReviewsTabState extends State<ReviewsTab> {
  List<Map<String, dynamic>> _rows = <Map<String, dynamic>>[];
  bool _loading = true;
  bool _visible = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final List<Map<String, dynamic>> rows =
          await widget.repository.loadTestimonials();
      final Map<String, dynamic> settings =
          await widget.repository.loadSettings();
      if (!mounted) return;
      setState(() {
        _rows = rows;
        _visible = settings['testimonials_visible'] != false;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = error.toString();
      });
    }
  }

  Future<void> _setVisible(bool value) async {
    final bool previous = _visible;
    setState(() => _visible = value);
    try {
      await widget.repository.saveSettings(<String, dynamic>{
        'testimonials_visible': value,
      });
      if (!mounted) return;
      showAdminMessage(
        context,
        value
            ? 'La section Avis est affichée sur le site.'
            : 'La section Avis est masquée du site.',
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _visible = previous);
      showAdminMessage(context, "Action impossible : ${adminErrorText(error)}",
          error: true);
    }
  }

  Future<void> _setStatus(Map<String, dynamic> row, String status) async {
    try {
      await widget.repository.updateRow(
        'testimonials',
        row['id'] as Object,
        <String, dynamic>{'status': status},
      );
      await _load();
      if (!mounted) return;
      showAdminMessage(
        context,
        status == 'approved' ? 'Avis publié.' : 'Avis masqué.',
      );
    } catch (error) {
      if (!mounted) return;
      showAdminMessage(context, "Action impossible : ${adminErrorText(error)}",
          error: true);
    }
  }

  Future<void> _delete(Map<String, dynamic> row) async {
    try {
      await widget.repository.deleteRow('testimonials', row['id'] as Object);
      await _load();
    } catch (error) {
      if (!mounted) return;
      showAdminMessage(context, "Suppression impossible : ${adminErrorText(error)}",
          error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (_error != null) {
      return Center(child: Text(_error!, style: AppText.sectionDesc));
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 40),
      children: <Widget>[
        AdminCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AdminToggle(
                label: 'Afficher la section Avis sur le site',
                value: _visible,
                onChanged: _setVisible,
              ),
              Text(
                _visible
                    ? "La section apparaît sur le site avec les avis publiés et le bouton « Laisser un avis »."
                    : "La section est entièrement masquée : ni les avis, ni le bouton, ni le lien dans le menu. Les avis restent enregistrés ici.",
                style: AppText.sectionDesc,
              ),
            ],
          ),
        ),
        if (_rows.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Text(
              'Aucun avis pour le moment.',
              textAlign: TextAlign.center,
              style: AppText.sectionDesc,
            ),
          ),
        for (final Map<String, dynamic> row in _rows)
          AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _StatusChip(status: (row['status'] ?? '').toString()),
                const SizedBox(height: 12),
                Text((row['quote'] ?? '').toString(),
                    style: AppText.testimonial),
                const SizedBox(height: 12),
                Text((row['author'] ?? '').toString(),
                    style: AppText.testimonialName),
                Text((row['author_role'] ?? '').toString(),
                    style: AppText.testimonialRole),
                if ((row['email'] ?? '').toString().isNotEmpty)
                  Text((row['email'] ?? '').toString(),
                      style: AppText.testimonialRole),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    if (row['status'] != 'approved')
                      AdminActionButton(
                        label: 'Publier',
                        icon: Icons.check_rounded,
                        onPressed: () => _setStatus(row, 'approved'),
                      ),
                    if (row['status'] == 'approved')
                      AdminActionButton(
                        label: 'Masquer',
                        icon: Icons.visibility_off_outlined,
                        outlined: true,
                        onPressed: () => _setStatus(row, 'pending'),
                      ),
                    AdminActionButton(
                      label: 'Supprimer',
                      icon: Icons.delete_outline_rounded,
                      destructive: true,
                      outlined: true,
                      onPressed: () => _delete(row),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    String label = 'En attente';
    Color color = AppColors.primaryDeep;
    if (status == 'approved') {
      label = 'En ligne';
      color = AppColors.primary;
    } else if (status == 'rejected') {
      label = 'Rejeté';
      color = AppColors.inkSoft;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppText.kicker.copyWith(color: color),
      ),
    );
  }
}
