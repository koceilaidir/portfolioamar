import 'package:flutter/material.dart';

/// Fait le lien entre une clé texte (fournie par le contenu, donc plus tard
/// par le back) et une icône Material.
abstract final class AppIcons {
  static const Map<String, IconData> _icons = <String, IconData>{
    'user': Icons.person_outline_rounded,
    'code': Icons.code_rounded,
    'responsive': Icons.devices_rounded,
    'performance': Icons.bolt_rounded,
    'design': Icons.brush_outlined,
    'star': Icons.star_rounded,
    'mail': Icons.mail_outline_rounded,
    'link': Icons.public_rounded,
    'available': Icons.event_available_outlined,
    'arrow': Icons.arrow_forward_rounded,
  };

  static IconData resolve(String key) =>
      _icons[key] ?? Icons.auto_awesome_outlined;
}
