import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoviePosterLink extends StatelessWidget {
  const MoviePosterLink(this.movie, {super.key});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final random = Random();

    const imageHeight = 200.0;

    return FadeInUp(
      from: random.nextInt(100) + 80,
      delay: Duration(milliseconds: random.nextInt(450) + 0),
      child: GestureDetector(
        onTap: () => context.push('/movie/${movie.id}'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: FadeInImage(
            fit: BoxFit.cover,
            height: imageHeight,
            placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
            image: NetworkImage(movie.posterPath),
          ),
        ),
      ),
    );
  }
}
