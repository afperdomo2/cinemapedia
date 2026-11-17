import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_details.dart';
import 'package:cinemapedia/domain/entities/movie_page.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/domain/repositories/movie_repository.dart';

/// Construye una [Movie] de prueba sobreescribiendo solo los campos necesarios.
Movie makeMovie({
  int id = 1,
  String title = 'Película',
  String posterPath = '/poster.jpg',
  String backdropPath = '/backdrop.jpg',
  double voteAverage = 7.5,
  int voteCount = 100,
  DateTime? releaseDate,
  String overview = 'Una película de prueba.',
}) {
  return Movie(
    adult: false,
    backdropPath: backdropPath,
    genreIds: const ['28'],
    id: id,
    originalLanguage: 'en',
    originalTitle: title,
    overview: overview,
    popularity: 10,
    posterPath: posterPath,
    releaseDate: releaseDate ?? DateTime(2026, 1, 15),
    title: title,
    video: false,
    voteAverage: voteAverage,
    voteCount: voteCount,
  );
}

MovieDetails makeMovieDetails(int id) {
  return MovieDetails(
    movie: makeMovie(id: id, title: 'Película $id'),
    actors: [
      Actor(
          id: 1,
          name: 'Actor',
          profilePath: '/actor.jpg',
          character: 'Personaje'),
    ],
    videos: [
      Video(
          id: 'v1',
          name: 'Trailer',
          youtubeKey: 'abc123',
          publishedAt: DateTime(2026, 1, 1)),
    ],
    similarMovies: [makeMovie(id: id + 100, title: 'Similar $id')],
  );
}

/// Repositorio falso con comportamiento configurable por test.
class FakeMovieRepository implements MovieRepository {
  /// Constructor de la página que devuelve cada listado.
  ///
  /// Devuelve 3 películas con ids distintos por página (como TMDB, que trae
  /// resultados distintos y sin repetir ids dentro del mismo listado).
  MoviePage Function(int page) pageBuilder = (page) {
    return MoviePage(
      movies: [
        for (var i = 0; i < 3; i++)
          makeMovie(id: page * 100 + i, title: 'Película página $page'),
      ],
      page: page,
      totalPages: 3,
    );
  };

  /// Si se setea, las páginas (y/o los detalles) fallan con este error.
  Object? pageError;
  Object? detailsError;
  MovieDetails Function(int movieId) detailsBuilder = makeMovieDetails;

  /// Registro de llamadas para las aserciones.
  final List<String> calls = [];

  Future<MoviePage> _page(String source, int page) async {
    calls.add('$source:$page');
    final error = pageError;
    if (error != null) throw error;
    return pageBuilder(page);
  }

  @override
  Future<MoviePage> getNowPlaying({int page = 1}) => _page('nowPlaying', page);

  @override
  Future<MoviePage> getPopular({int page = 1}) => _page('popular', page);

  @override
  Future<MoviePage> getTopRated({int page = 1}) => _page('topRated', page);

  @override
  Future<MoviePage> getUpcoming({int page = 1}) => _page('upcoming', page);

  @override
  Future<MoviePage> searchMovies(String query, {int page = 1}) =>
      _page('search:$query', page);

  @override
  Future<MovieDetails> getMovieDetails(int movieId) async {
    calls.add('details:$movieId');
    final error = detailsError;
    if (error != null) throw error;
    return detailsBuilder(movieId);
  }
}

/// Almacenamiento local falso en memoria.
class FakeLocalStorageDataSource implements LocalStorageDataSource {
  final Map<int, Movie> favorites = {};
  final List<String> calls = [];

  @override
  Future<bool> isFavoriteMovie(int movieId) async {
    calls.add('isFavorite:$movieId');
    return favorites.containsKey(movieId);
  }

  @override
  Future<bool> toggleFavoriteMovie(Movie movie) async {
    calls.add('toggle:${movie.id}');
    if (favorites.containsKey(movie.id)) {
      favorites.remove(movie.id);
      return false;
    }
    favorites[movie.id] = movie;
    return true;
  }

  @override
  Future<MoviePage> getFavoriteMovies({int page = 1, int limit = 20}) async {
    calls.add('getFavoriteMovies:$page');
    // Más recientes primero, como el datasource real.
    final all = favorites.values.toList().reversed.toList();
    final start = (page - 1) * limit;
    final movies =
        start >= all.length ? <Movie>[] : all.skip(start).take(limit).toList();
    return MoviePage(
      movies: movies,
      page: page,
      totalPages: (all.length / limit).ceil(),
    );
  }
}
