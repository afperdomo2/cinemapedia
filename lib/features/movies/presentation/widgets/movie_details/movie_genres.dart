import 'package:cinemapedia/features/movies/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MovieGenres extends StatelessWidget {
  const MovieGenres({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Wrap(
        children: [
          ...movie.genreIds.map(
            (gender) => Container(
              margin: const EdgeInsets.only(right: 5),
              child: Chip(
                label: Text(gender),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
