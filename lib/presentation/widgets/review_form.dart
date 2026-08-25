import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'pill_button.dart';

typedef ReviewSubmitter = Future<void> Function({
  required String author,
  required String authorRole,
  required String quote,
  String? email,
});

class ReviewFormDialog extends StatefulWidget {
  const ReviewFormDialog({super.key, required this.onSubmit});

  final ReviewSubmitter onSubmit;

  static Future<bool?> show(BuildContext context, ReviewSubmitter onSubmit) {
    return showDialog<bool>(
      context: context,
      barrierColor: const Color(0x8820201C),
      builder: (BuildContext context) => ReviewFormDialog(onSubmit: onSubmit),
    );
  }

  @override
  State<ReviewFormDialog> createState() => _ReviewFormDialogState();
}

class _ReviewFormDialogState extends State<ReviewFormDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _author = TextEditingController();
  final TextEditingController _role = TextEditingController();
  final TextEditingController _quote = TextEditingController();
  final TextEditingController _email = TextEditingController();

  bool _sending = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _author.dispose();
    _role.dispose();
    _quote.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_sending) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _sending = true;
      _error = null;
    });

    try {
      await widget.onSubmit(
        author: _author.text,
        authorRole: _role.text,
        quote: _quote.text,
        email: _email.text,
      );
      if (!mounted) return;
      setState(() {
        _sending = false;
        _sent = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _sending = false;
        _error = "L'envoi a échoué. Réessaie dans un instant.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.background,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.line),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
          child: SingleChildScrollView(
            child: _sent ? _buildSuccess(context) : _buildForm(context),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 22),
        ),
        const SizedBox(height: 16),
        Text('Merci !', style: AppText.sectionKicker(26)),
        const SizedBox(height: 8),
        Text(
          "Ton avis a bien été envoyé. Il sera publié sur le site après validation.",
          style: AppText.sectionDesc,
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: PillButton(
            label: 'Fermer',
            onTap: () => Navigator.of(context).pop(true),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Laisser un', style: AppText.sectionKicker(26)),
                    Text(
                      'avis',
                      style: AppText.sectionKicker(26)
                          .copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(false),
                icon: const Icon(Icons.close_rounded),
                color: AppColors.inkSoft,
                tooltip: 'Fermer',
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Ton retour sera relu avant publication.',
            style: AppText.sectionDesc,
          ),
          const SizedBox(height: 18),
          _Field(
            controller: _author,
            label: 'Nom',
            hint: 'Jessica Lee',
            textInputAction: TextInputAction.next,
            validator: (String? value) {
              final String text = (value ?? '').trim();
              if (text.length < 2) return 'Indique ton nom.';
              if (text.length > 80) return 'Nom trop long.';
              return null;
            },
          ),
          const SizedBox(height: 14),
          _Field(
            controller: _role,
            label: 'Rôle / entreprise (optionnel)',
            hint: 'Founder, Avenue & Co.',
            textInputAction: TextInputAction.next,
            validator: (String? value) {
              if ((value ?? '').trim().length > 120) return 'Texte trop long.';
              return null;
            },
          ),
          const SizedBox(height: 14),
          _Field(
            controller: _email,
            label: 'Email (optionnel, non publié)',
            hint: 'jessica@exemple.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (String? value) {
              final String text = (value ?? '').trim();
              if (text.isEmpty) return null;
              if (!text.contains('@') || text.length > 160) {
                return 'Email invalide.';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          _Field(
            controller: _quote,
            label: 'Ton avis',
            hint: 'Raconte comment s\'est passée la collaboration…',
            maxLines: 5,
            validator: (String? value) {
              final String text = (value ?? '').trim();
              if (text.length < 10) return 'Au moins 10 caractères.';
              if (text.length > 600) return 'Maximum 600 caractères.';
              return null;
            },
          ),
          if (_error != null) ...<Widget>[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: AppText.sectionDesc.copyWith(color: AppColors.primaryDeep),
            ),
          ],
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: _sending
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : PillButton(label: 'Envoyer mon avis', onTap: _submit),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.validator,
    this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    const OutlineInputBorder base = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: AppColors.line),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label.toUpperCase(), style: AppText.skillLabel),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: AppText.lede.copyWith(color: AppColors.ink),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppText.lede.copyWith(
              color: AppColors.inkSoft.withValues(alpha: 0.6),
            ),
            filled: true,
            fillColor: AppColors.surface,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: base,
            enabledBorder: base,
            focusedBorder: base.copyWith(
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: base.copyWith(
              borderSide: const BorderSide(color: AppColors.primaryDeep),
            ),
            focusedErrorBorder: base.copyWith(
              borderSide:
                  const BorderSide(color: AppColors.primaryDeep, width: 1.5),
            ),
            errorStyle: AppText.testimonialRole
                .copyWith(color: AppColors.primaryDeep),
          ),
        ),
      ],
    );
  }
}
