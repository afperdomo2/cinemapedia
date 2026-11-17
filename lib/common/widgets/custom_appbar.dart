import 'package:cinemapedia/shared/widgets/movie_search_icon_button.dart';
import 'package:flutter/material.dart';

/// Barra superior de la aplicación: marca + acceso al buscador.
class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final titleStyle = theme.textTheme.titleMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(Icons.movie_outlined, color: colors.primary),
          const SizedBox(width: 8),
          Text('Cinemapedia', style: titleStyle),
          const Spacer(),
          const MovieSearchIconButton(),
        ],
      ),
    );
  }
}
