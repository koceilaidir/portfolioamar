import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/hover_region.dart';
import '../../data/repositories/admin_repository.dart';
import '../admin/admin_page.dart';

class AdminEntryButton extends StatelessWidget {
  const AdminEntryButton({
    super.key,
    required this.repository,
    this.onClosed,
  });

  final AdminRepository repository;
  final VoidCallback? onClosed;

  Future<void> _open(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => AdminPage(repository: repository),
      ),
    );
    onClosed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: () => _open(context),
      builder: (BuildContext context, bool hovered) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: hovered ? AppColors.ink : AppColors.surface,
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.lock_outline_rounded,
                size: 14,
                color: hovered ? AppColors.cream : AppColors.inkSoft,
              ),
              const SizedBox(width: 8),
              Text(
                'ADMIN',
                style: AppText.kicker.copyWith(
                  color: hovered ? AppColors.cream : AppColors.inkSoft,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
