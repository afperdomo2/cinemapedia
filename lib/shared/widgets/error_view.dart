import 'package:flutter/material.dart';

/// Estado de error con botón de reintento, para pantallas y secciones.
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    this.compact = false,
  });

  final String message;
  final VoidCallback onRetry;

  /// `true` para ocupar el alto de una sección en vez de la pantalla entera.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.cloud_off_outlined,
          size: compact ? 32 : 56,
          color: colors.outline,
        ),
        SizedBox(height: compact ? 8 : 16),
        Text(
          message,
          style: compact ? textStyles.bodyMedium : textStyles.titleMedium,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: compact ? 8 : 16),
        FilledButton.tonalIcon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Reintentar'),
        ),
      ],
    );

    if (compact) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Center(child: content),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: content,
      ),
    );
  }
}
