import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

enum AdminFieldKind { text, multiline, number, toggle, image, gallery }

class AdminField {
  const AdminField(
    this.column,
    this.label, {
    this.kind = AdminFieldKind.text,
    this.hint,
  });

  final String column;
  final String label;
  final AdminFieldKind kind;
  final String? hint;
}

class AdminInput extends StatelessWidget {
  const AdminInput({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    const OutlineInputBorder base = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: AppColors.line),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label.toUpperCase(), style: AppText.skillLabel),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: obscureText ? 1 : maxLines,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: AppText.lede.copyWith(color: AppColors.ink),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppText.lede.copyWith(
                color: AppColors.inkSoft.withValues(alpha: 0.55),
              ),
              filled: true,
              fillColor: AppColors.card,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              border: base,
              enabledBorder: base,
              focusedBorder: base.copyWith(
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminToggle extends StatelessWidget {
  const AdminToggle({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: <Widget>[
          Switch(
            value: value,
            activeTrackColor: AppColors.primary,
            onChanged: onChanged,
          ),
          const SizedBox(width: 10),
          Text(label.toUpperCase(), style: AppText.skillLabel),
        ],
      ),
    );
  }
}

class AdminActionButton extends StatelessWidget {
  const AdminActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.destructive = false,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool destructive;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final Color accent =
        destructive ? AppColors.primaryDeep : AppColors.primary;

    if (outlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: accent,
          side: BorderSide(color: accent, width: 1.4),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          textStyle: AppText.pill.copyWith(fontSize: 12, letterSpacing: 0),
        ),
        child: _content(),
      );
    }

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        textStyle: AppText.pill.copyWith(fontSize: 12, letterSpacing: 0),
      ),
      child: _content(),
    );
  }

  Widget _content() {
    if (icon == null) return Text(label);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 16),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}

class AdminCard extends StatelessWidget {
  const AdminCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

String adminErrorText(Object error) {
  String raw = error.toString().replaceAll('\n', ' ').trim();
  if (raw.startsWith('PostgrestException(')) {
    raw = raw.substring('PostgrestException('.length);
    if (raw.endsWith(')')) raw = raw.substring(0, raw.length - 1);
  }
  if (raw.length > 240) raw = '${raw.substring(0, 240)}…';
  return raw;
}

void showAdminMessage(BuildContext context, String message,
    {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: error ? AppColors.primaryDeep : AppColors.ink,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: error ? 10 : 3),
        showCloseIcon: error,
        closeIconColor: AppColors.cream,
        content: Text(message, style: AppText.footerRow),
      ),
    );
}
