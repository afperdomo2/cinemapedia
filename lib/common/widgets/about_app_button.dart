import 'dart:async';

import 'package:cinemapedia/common/widgets/about_app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Botón de la barra superior que abre el diálogo "Acerca de" con la versión
/// de la app (leída en runtime con `package_info_plus`).
class AboutAppButton extends StatelessWidget {
  const AboutAppButton({super.key});

  Future<void> _showAbout(BuildContext context) async {
    final info = await PackageInfo.fromPlatform();
    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      builder: (_) => AboutAppDialog(
        version: info.version,
        buildNumber: info.buildNumber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info_outline),
      tooltip: 'Acerca de',
      onPressed: () => unawaited(_showAbout(context)),
    );
  }
}
