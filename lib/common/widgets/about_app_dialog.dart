import 'package:flutter/material.dart';

/// Diálogo "Acerca de": nombre de la app, versión y atribución de TMDB.
///
/// La versión viene de `pubspec.yaml` (formato `x.y.z+número de build`) y se
/// lee en runtime con `package_info_plus`; ver README §8 (Versionamiento).
class AboutAppDialog extends StatelessWidget {
  const AboutAppDialog({
    super.key,
    required this.version,
    this.buildNumber = '',
  });

  /// Versión semver visible (`0.2.0`).
  final String version;

  /// Número de build (`3`); vacío si el build no lo define.
  final String buildNumber;

  @override
  Widget build(BuildContext context) {
    final versionLabel =
        buildNumber.isEmpty ? version : '$version (build $buildNumber)';

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.movie_outlined),
          SizedBox(width: 8),
          Text('Cinemapedia'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Versión $versionLabel'),
          const SizedBox(height: 8),
          const Text('Datos de películas cortesía de The Movie Database '
              '(TMDB).'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
