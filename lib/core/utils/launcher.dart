import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

abstract final class AppLauncher {
  static Future<void> open(BuildContext context, Uri uri) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    bool launched = false;
    try {
      launched = await launchUrl(uri);
    } catch (_) {
      launched = false;
    }
    if (launched) return;

    await Clipboard.setData(
      ClipboardData(text: uri.scheme == 'mailto' ? uri.path : uri.toString()),
    );
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: AppColors.ink,
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Lien copié dans le presse-papiers',
          style: AppText.footerRow,
        ),
      ),
    );
  }

  static Future<void> email(BuildContext context, String address) {
    return open(context, Uri(scheme: 'mailto', path: address));
  }

  static Future<void> website(BuildContext context, String url) {
    final String normalized =
        url.startsWith('http') ? url : 'https://${url.replaceAll(RegExp(r'^/+'), '')}';
    return open(context, Uri.parse(normalized));
  }
}
