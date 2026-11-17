import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/video.dart';

/// Todo lo que la pantalla de detalles necesita, resuelto en una sola
/// petición a TMDB (`append_to_response=credits,videos,similar`).
class MovieDetails {
  const MovieDetails({
    required this.movie,
    required this.actors,
    required this.videos,
    required this.similarMovies,
  });

  final Movie movie;
  final List<Actor> actors;
  final List<Video> videos;
  final List<Movie> similarMovies;
}
