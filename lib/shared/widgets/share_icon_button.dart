import 'package:cinemapedia/config/helpers/share_links.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/person.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

/// Botón para compartir el enlace de TMDB de una película.
class ShareMovieIconButton extends StatelessWidget {
  const ShareMovieIconButton(this.movie, {super.key});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Compartir',
      icon: const Icon(Icons.share_outlined),
      onPressed: () => SharePlus.instance.share(
        ShareParams(text: ShareLinks.movieText(movie)),
      ),
    );
  }
}

/// Botón para compartir el enlace de TMDB de una persona.
class SharePersonIconButton extends StatelessWidget {
  const SharePersonIconButton(this.person, {super.key});

  final Person person;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Compartir',
      icon: const Icon(Icons.share_outlined),
      onPressed: () => SharePlus.instance.share(
        ShareParams(text: ShareLinks.personText(person)),
      ),
    );
  }
}
