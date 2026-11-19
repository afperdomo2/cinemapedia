import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/domain/entities/genre_filter.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_details.dart';
import 'package:cinemapedia/domain/entities/movie_page.dart';
import 'package:cinemapedia/domain/entities/person.dart';
import 'package:cinemapedia/domain/entities/person_filmography.dart';
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
  double popularity = 10,
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
    popularity: popularity,
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

/// Construye una [Person] de prueba sobreescribiendo solo los campos necesarios.
Person makePerson(int id, {String name = 'Persona'}) {
  return Person(
    id: id,
    name: name,
    biography: 'Una biografía de prueba.',
    profilePath: '/persona.jpg',
    birthday: '1980-05-20',
    placeOfBirth: 'Buenos Aires, Argentina',
    knownForDepartment: 'Acting',
  );
}

/// Construye una [PersonFilmography] de prueba con reparto y equipo.
PersonFilmography makePersonFilmography() {
  return PersonFilmography(
    cast: [
      PersonCredit(
        movie: makeMovie(id: 1, title: 'Película 1', popularity: 10),
        character: 'Personaje 1',
        department: 'Acting',
      ),
      PersonCredit(
        movie: makeMovie(id: 2, title: 'Película 2', popularity: 20),
        character: 'Personaje 2',
        department: 'Acting',
      ),
    ],
    crew: [
      PersonCredit(
        movie: makeMovie(id: 3, title: 'Película 3', popularity: 30),
        job: 'Director',
        department: 'Directing',
      ),
      PersonCredit(
        movie: makeMovie(id: 4, title: 'Película 4', popularity: 5),
        job: 'Guionista',
        department: 'Writing',
      ),
    ],
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
  Object? genresError;
  MovieDetails Function(int movieId) detailsBuilder = makeMovieDetails;

  /// Géneros que devuelve [getGenres].
  List<Genre> genres = const [
    Genre(id: 28, name: 'Acción'),
    Genre(id: 35, name: 'Comedia'),
  ];

  /// Persona que devuelve [getPerson].
  Person Function(int personId) personBuilder = makePerson;
  Object? personError;

  /// Filmografía que devuelve [getPersonMovieCredits].
  PersonFilmography Function(int personId) creditsBuilder =
      (personId) => makePersonFilmography();

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
  Future<List<Genre>> getGenres() async {
    calls.add('genres');
    final error = genresError;
    if (error != null) throw error;
    return genres;
  }

  @override
  Future<MoviePage> discoverMovies(GenreFilter filter, {int page = 1}) => _page(
        'discover:${filter.genreId}:${filter.sortBy.name}:${filter.releaseYear}',
        page,
      );

  @override
  Future<Person> getPerson(int personId) async {
    calls.add('person:$personId');
    final error = personError;
    if (error != null) throw error;
    return personBuilder(personId);
  }

  @override
  Future<PersonFilmography> getPersonMovieCredits(int personId) async {
    calls.add('personCredits:$personId');
    final error = personError;
    if (error != null) throw error;
    return creditsBuilder(personId);
  }

  /// Error configurable y contador de sorteos para [getRandomMovie].
  Object? randomError;
  int randomDraws = 0;

  @override
  Future<Movie> getRandomMovie({int? genreId, double? minVoteAverage}) async {
    calls.add('random:$genreId:$minVoteAverage');
    final error = randomError;
    if (error != null) throw error;
    randomDraws += 1;
    return makeMovie(id: 900 + randomDraws, title: 'Sugerencia $randomDraws');
  }

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
  final Map<int, Movie> watchlist = {};
  final List<String> calls = [];

  @override
  Future<bool> isFavoriteMovie(int movieId) async {
    calls.add('isFavorite:$movieId');
    return favorites.containsKey(movieId);
  }

  @override
  Future<bool> isInWatchlistMovie(int movieId) async {
    calls.add('isInWatchlist:$movieId');
    return watchlist.containsKey(movieId);
  }

  @override
  Future<bool> toggleFavoriteMovie(Movie movie) async {
    calls.add('toggleFavorite:${movie.id}');
    if (favorites.containsKey(movie.id)) {
      favorites.remove(movie.id);
      return false;
    }
    favorites[movie.id] = movie;
    return true;
  }

  @override
  Future<bool> toggleWatchlistMovie(Movie movie) async {
    calls.add('toggleWatchlist:${movie.id}');
    if (watchlist.containsKey(movie.id)) {
      watchlist.remove(movie.id);
      return false;
    }
    watchlist[movie.id] = movie;
    return true;
  }

  @override
  Future<MoviePage> getFavoriteMovies({int page = 1, int limit = 20}) {
    calls.add('getFavoriteMovies:$page');
    return _pageOf(favorites, page, limit);
  }

  @override
  Future<MoviePage> getWatchlistMovies({int page = 1, int limit = 20}) {
    calls.add('getWatchlistMovies:$page');
    return _pageOf(watchlist, page, limit);
  }

  Future<MoviePage> _pageOf(
    Map<int, Movie> source,
    int page,
    int limit,
  ) async {
    // Más recientes primero, como el datasource real.
    final all = source.values.toList().reversed.toList();
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
