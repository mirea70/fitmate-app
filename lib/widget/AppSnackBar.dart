import 'package:flutter/material.dart';

enum SnackBarType { success, error, info }

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();

    final config = _getConfig(type);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: config.iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(config.icon, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: config.bgColor,
        elevation: 4,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        duration: Duration(seconds: type == SnackBarType.success ? 3 : 4),
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  static _SnackBarConfig _getConfig(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return _SnackBarConfig(
          bgColor: Colors.white,
          iconBgColor: Colors.orangeAccent,
          icon: Icons.check,
        );
      case SnackBarType.error:
        return _SnackBarConfig(
          bgColor: Colors.white,
          iconBgColor: Colors.redAccent,
          icon: Icons.close,
        );
      case SnackBarType.info:
        return _SnackBarConfig(
          bgColor: Colors.white,
          iconBgColor: Colors.grey,
          icon: Icons.info_outline,
        );
    }
  }
}

class _SnackBarConfig {
  final Color bgColor;
  final Color iconBgColor;
  final IconData icon;

  _SnackBarConfig({
    required this.bgColor,
    required this.iconBgColor,
    required this.icon,
  });
}
