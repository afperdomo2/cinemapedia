import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MovieSlide extends StatelessWidget {
  final Movie movie;

  const MovieSlide(this.movie, {super.key});

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 10)),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: DecoratedBox(
        decoration: boxDecoration, // Añade una sombra alrededor del contenedor.
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              /// Background image
              FadeInImage(
                fit: BoxFit.cover,
                placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
                image: NetworkImage(movie.backdropPath),
              ),

              /// Gradient overlay for better text visibility
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.8, 0.95],
                      colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                    ),
                  ),
                ),
              ),

              /// Movie title
              Positioned(
                bottom: 8,
                left: 12,
                child: Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: const TextStyle(color: Colors.white, fontSize: 11.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
