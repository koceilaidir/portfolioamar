import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/repositories/admin_repository.dart';
import 'admin_fields.dart';

class AdminImageField extends StatefulWidget {
  const AdminImageField({
    super.key,
    required this.controller,
    required this.repository,
    required this.label,
    this.hint,
  });

  final TextEditingController controller;
  final AdminRepository repository;
  final String label;
  final String? hint;

  @override
  State<AdminImageField> createState() => _AdminImageFieldState();
}

class _AdminImageFieldState extends State<AdminImageField> {
  bool _busy = false;

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
    if (base.isEmpty) base = 'image';
    if (base.length > 40) base = base.substring(0, 40);

    return '$base-${DateTime.now().millisecondsSinceEpoch}.$extension';
  }

  Future<void> _pick() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;

    final PlatformFile file = result.files.first;
    final Uint8List? bytes = file.bytes;
    if (bytes == null) {
      if (!mounted) return;
      showAdminMessage(context, 'Fichier illisible.', error: true);
      return;
    }
    if (bytes.lengthInBytes > 5 * 1024 * 1024) {
      if (!mounted) return;
      showAdminMessage(
        context,
        'Image trop lourde (max 5 Mo). Compresse-la avant de l\'envoyer.',
        error: true,
      );
      return;
    }

    if (!mounted) return;
    setState(() => _busy = true);
    try {
      final String path = await widget.repository.uploadProjectImage(
        fileName: _safeName(file.name),
        bytes: bytes,
      );
      if (!mounted) return;
      widget.controller.text = path;
      showAdminMessage(context, "Image envoyée. Pense à enregistrer.");
    } catch (error) {
      if (!mounted) return;
      showAdminMessage(
        context,
        'Envoi impossible : ${adminErrorText(error)}',
        error: true,
      );
    }
    if (mounted) setState(() => _busy = false);
  }

  void _clear() {
    widget.controller.text = '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.label.toUpperCase(), style: AppText.skillLabel),
          const SizedBox(height: 8),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: widget.controller,
            builder: (BuildContext context, TextEditingValue value, Widget? _) {
              final String path = value.text.trim();
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _Preview(
                    url: path.isEmpty
                        ? null
                        : widget.repository.publicImageUrl(path),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: <Widget>[
                            AdminActionButton(
                              label: _busy
                                  ? 'Envoi…'
                                  : (path.isEmpty
                                      ? 'Choisir une image'
                                      : 'Remplacer'),
                              icon: Icons.image_outlined,
                              onPressed: _busy ? null : _pick,
                            ),
                            if (path.isNotEmpty)
                              AdminActionButton(
                                label: 'Retirer',
                                icon: Icons.close_rounded,
                                outlined: true,
                                destructive: true,
                                onPressed: _busy ? null : _clear,
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          path.isEmpty
                              ? 'Sans image, la vignette garde son dégradé.'
                              : path,
                          style: AppText.testimonialRole,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: widget.controller,
            style: AppText.testimonialRole.copyWith(color: AppColors.inkSoft),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppText.testimonialRole.copyWith(
                color: AppColors.inkSoft.withValues(alpha: 0.55),
              ),
              filled: true,
              fillColor: AppColors.card,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: AppColors.line),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: AppColors.line),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: AppColors.terracotta, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 96,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.creamAlt,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: url == null
          ? const Icon(
              Icons.image_outlined,
              color: AppColors.inkSoft,
              size: 22,
            )
          : Image.network(
              url!,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object error,
                      StackTrace? stack) =>
                  const Icon(
                Icons.broken_image_outlined,
                color: AppColors.inkSoft,
                size: 22,
              ),
            ),
    );
  }
}
