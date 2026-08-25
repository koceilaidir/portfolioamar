import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/repositories/admin_repository.dart';
import 'admin_fields.dart';

class AdminGalleryField extends StatefulWidget {
  const AdminGalleryField({
    super.key,
    required this.repository,
    required this.projectId,
  });

  final AdminRepository repository;
  final Object projectId;

  @override
  State<AdminGalleryField> createState() => _AdminGalleryFieldState();
}

class _AdminGalleryFieldState extends State<AdminGalleryField> {
  List<Map<String, dynamic>> _rows = <Map<String, dynamic>>[];
  bool _loading = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final List<Map<String, dynamic>> rows =
          await widget.repository.loadProjectImages(widget.projectId);
      if (!mounted) return;
      setState(() {
        _rows = rows;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      showAdminMessage(
        context,
        'Photos illisibles : ${adminErrorText(error)}',
        error: true,
      );
    }
  }

  String _safeName(String raw) {
    final String lower = raw.toLowerCase();
    final int dot = lower.lastIndexOf('.');
    String extension = dot == -1 ? 'jpg' : lower.substring(dot + 1);
    extension = extension.replaceAll(RegExp('[^a-z0-9]'), '');
    if (extension.isEmpty) extension = 'jpg';

    String base = dot == -1 ? lower : lower.substring(0, dot);
    base = base
        .replaceAll(RegExp('[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    if (base.isEmpty) base = 'photo';
    if (base.length > 40) base = base.substring(0, 40);

    return '$base-${DateTime.now().microsecondsSinceEpoch}.$extension';
  }

  Future<void> _add() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
      allowMultiple: true,
    );
    if (result == null || result.files.isEmpty) return;
    if (!mounted) return;

    setState(() => _busy = true);
    int position = _rows.length;
    int added = 0;
    final List<String> skipped = <String>[];

    for (final PlatformFile file in result.files) {
      final Uint8List? bytes = file.bytes;
      if (bytes == null || bytes.lengthInBytes > 5 * 1024 * 1024) {
        skipped.add(file.name);
        continue;
      }
      try {
        final String path = await widget.repository.uploadProjectImage(
          fileName: _safeName(file.name),
          bytes: bytes,
        );
        position += 1;
        await widget.repository.addProjectImage(
          projectId: widget.projectId,
          imagePath: path,
          position: position,
        );
        added += 1;
      } catch (_) {
        skipped.add(file.name);
      }
    }

    await _load();
    if (!mounted) return;
    setState(() => _busy = false);

    if (skipped.isEmpty) {
      showAdminMessage(
        context,
        added > 1 ? '$added photos ajoutées.' : 'Photo ajoutée.',
      );
    } else {
      showAdminMessage(
        context,
        'Ignorées (illisibles ou plus de 5 Mo) : ${skipped.join(', ')}',
        error: true,
      );
    }
  }

  Future<void> _delete(Map<String, dynamic> row) async {
    setState(() => _busy = true);
    try {
      await widget.repository.deleteRow('project_images', row['id'] as Object);
      await widget.repository
          .removeStoredImage((row['image_path'] ?? '') as String);
      await _load();
    } catch (error) {
      if (!mounted) return;
      showAdminMessage(
        context,
        'Suppression impossible : ${adminErrorText(error)}',
        error: true,
      );
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _move(int from, int to) async {
    if (to < 0 || to >= _rows.length) return;
    final List<Map<String, dynamic>> next =
        List<Map<String, dynamic>>.from(_rows);
    final Map<String, dynamic> moved = next.removeAt(from);
    next.insert(to, moved);
    setState(() {
      _rows = next;
      _busy = true;
    });
    try {
      await widget.repository.reorderProjectImages(
        next.map((Map<String, dynamic> row) => row['id'] as Object).toList(),
      );
      await _load();
    } catch (error) {
      if (!mounted) return;
      showAdminMessage(
        context,
        'Réorganisation impossible : ${adminErrorText(error)}',
        error: true,
      );
      await _load();
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _saveCaption(Map<String, dynamic> row, String caption) async {
    try {
      await widget.repository.updateRow(
        'project_images',
        row['id'] as Object,
        <String, dynamic>{'caption': caption.trim()},
      );
      if (!mounted) return;
      showAdminMessage(context, 'Légende enregistrée.');
    } catch (error) {
      if (!mounted) return;
      showAdminMessage(
        context,
        'Échec : ${adminErrorText(error)}',
        error: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('PHOTOS DE LA PAGE PROJET', style: AppText.skillLabel),
          const SizedBox(height: 6),
          Text(
            'La première photo sert de couverture. Les suivantes alternent '
            'automatiquement deux par ligne puis pleine largeur.',
            style: AppText.testimonialRole,
          ),
          const SizedBox(height: 12),
          if (_loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            )
          else if (_rows.isEmpty)
            Text('Aucune photo pour ce projet.', style: AppText.testimonialRole)
          else
            for (int i = 0; i < _rows.length; i++)
              _PhotoRow(
                key: ValueKey<Object?>(_rows[i]['id']),
                row: _rows[i],
                index: i,
                total: _rows.length,
                url: widget.repository
                    .publicImageUrl((_rows[i]['image_path'] ?? '') as String),
                busy: _busy,
                onUp: () => _move(i, i - 1),
                onDown: () => _move(i, i + 1),
                onDelete: () => _delete(_rows[i]),
                onSaveCaption: (String value) =>
                    _saveCaption(_rows[i], value),
              ),
          const SizedBox(height: 12),
          AdminActionButton(
            label: _busy ? 'Envoi…' : 'Ajouter des photos',
            icon: Icons.add_photo_alternate_outlined,
            onPressed: _busy || _loading ? null : _add,
          ),
        ],
      ),
    );
  }
}

class _PhotoRow extends StatefulWidget {
  const _PhotoRow({
    super.key,
    required this.row,
    required this.index,
    required this.total,
    required this.url,
    required this.busy,
    required this.onUp,
    required this.onDown,
    required this.onDelete,
    required this.onSaveCaption,
  });

  final Map<String, dynamic> row;
  final int index;
  final int total;
  final String url;
  final bool busy;
  final VoidCallback onUp;
  final VoidCallback onDown;
  final VoidCallback onDelete;
  final ValueChanged<String> onSaveCaption;

  @override
  State<_PhotoRow> createState() => _PhotoRowState();
}

class _PhotoRowState extends State<_PhotoRow> {
  late final TextEditingController _caption = TextEditingController(
    text: (widget.row['caption'] ?? '').toString(),
  );

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: AppColors.line),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.cream,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 68,
            height: 52,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.creamAlt,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Image.network(
              widget.url,
              fit: BoxFit.cover,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stack) =>
                      const Icon(
                Icons.broken_image_outlined,
                size: 18,
                color: AppColors.inkSoft,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.index == 0
                      ? 'COUVERTURE'
                      : 'PHOTO ${widget.index + 1}',
                  style: AppText.kicker.copyWith(
                    color: widget.index == 0
                        ? AppColors.primaryDeep
                        : AppColors.inkSoft,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _caption,
                  style: AppText.testimonialRole
                      .copyWith(color: AppColors.ink),
                  onSubmitted: widget.onSaveCaption,
                  onTapOutside: (PointerDownEvent event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  decoration: InputDecoration(
                    hintText: 'Légende (optionnelle)',
                    hintStyle: AppText.testimonialRole.copyWith(
                      color: AppColors.inkSoft.withValues(alpha: 0.55),
                    ),
                    filled: true,
                    fillColor: AppColors.card,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 9),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 1.5),
                    ),
                    suffixIcon: IconButton(
                      tooltip: 'Enregistrer la légende',
                      icon: const Icon(Icons.check_rounded, size: 17),
                      color: AppColors.primaryDeep,
                      onPressed: widget.busy
                          ? null
                          : () => widget.onSaveCaption(_caption.text),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _SquareButton(
                icon: Icons.keyboard_arrow_up_rounded,
                tooltip: 'Monter',
                onPressed:
                    widget.busy || widget.index == 0 ? null : widget.onUp,
              ),
              const SizedBox(height: 6),
              _SquareButton(
                icon: Icons.keyboard_arrow_down_rounded,
                tooltip: 'Descendre',
                onPressed: widget.busy || widget.index == widget.total - 1
                    ? null
                    : widget.onDown,
              ),
            ],
          ),
          const SizedBox(width: 6),
          _SquareButton(
            icon: Icons.close_rounded,
            tooltip: 'Supprimer',
            destructive: true,
            onPressed: widget.busy ? null : widget.onDelete,
          ),
        ],
      ),
    );
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.destructive = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final Color accent =
        destructive ? AppColors.primaryDeep : AppColors.inkSoft;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          borderRadius: BorderRadius.circular(9),
          onTap: onPressed,
          child: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: destructive
                    ? AppColors.primaryDeep.withValues(alpha: 0.4)
                    : AppColors.line,
              ),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              size: 17,
              color: onPressed == null
                  ? accent.withValues(alpha: 0.35)
                  : accent,
            ),
          ),
        ),
      ),
    );
  }
}
