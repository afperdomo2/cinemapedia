import 'package:flutter/material.dart';

/// Aviso discreto de que el contenido proviene del caché local porque no
/// había conexión con TMDB.
class CachedContentBanner extends StatelessWidget {
  const CachedContentBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 18,
            color: colors.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Sin conexión: mostrando contenido guardado',
              style: textStyles.bodySmall
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
