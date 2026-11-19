import 'package:cinemapedia/data/datasources/movie_cache_store.dart';
import 'package:cinemapedia/data/models/local/movie_cache_codec.dart';
import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/domain/entities/genre_filter.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_details.dart';
import 'package:cinemapedia/domain/entities/movie_page.dart';
import 'package:cinemapedia/domain/entities/person.dart';
import 'package:cinemapedia/domain/entities/person_filmography.dart';
import 'package:cinemapedia/domain/exceptions/fetch_exception.dart';
import 'package:cinemapedia/domain/repositories/movie_repository.dart';

/// Repositorio decorado: responde desde TMDB y cachea el resultado para
/// poder mostrar contenido cuando no hay conexión.
///
/// Estrategia *network-first*: la red manda (los datos están frescos y el
/// pull-to-refresh siempre pega a TMDB); si la petición falla, se sirve la
/// última respuesta cacheada. El caché nunca reemplaza a la red.
class CachedMovieRepository implements MovieRepository {
  CachedMovieRepository(this._inner, this._cache);

  final MovieRepository _inner;
  final MovieCacheStore _cache;

  @override
  Future<MoviePage> getNowPlaying({int page = 1}) {
    return _moviePage(
        'now_playing', page, () => _inner.getNowPlaying(page: page));
  }

  @override
  Future<MoviePage> getPopular({int page = 1}) {
    return _moviePage('popular', page, () => _inner.getPopular(page: page));
  }

  @override
  Future<MoviePage> getTopRated({int page = 1}) {
    return _moviePage('top_rated', page, () => _inner.getTopRated(page: page));
  }

  @override
  Future<MoviePage> getUpcoming({int page = 1}) {
    return _moviePage('upcoming', page, () => _inner.getUpcoming(page: page));
  }

  @override
  Future<MoviePage> searchMovies(String query, {int page = 1}) {
    return _moviePage(
      'search:${query.trim().toLowerCase()}',
      page,
      () => _inner.searchMovies(query, page: page),
    );
  }

  @override
  Future<List<Genre>> getGenres() async {
    const key = 'genres';
    try {
      final result = await _inner.getGenres();
      await _cache.put(key, MovieCacheCodec.encodeGenres(result));
      return result;
    } on FetchException {
      final cached = await _readCached('genres', MovieCacheCodec.decodeGenres);
      if (cached == null) rethrow;
      return cached;
    }
  }

  @override
  Future<MoviePage> discoverMovies(GenreFilter filter, {int page = 1}) {
    // La clave de caché distingue cada combinación de género + orden + año.
    final year = filter.releaseYear?.toString() ?? 'any';
    return _moviePage(
      'discover:${filter.genreId}:${filter.sortBy.name}:$year',
      page,
      () => _inner.discoverMovies(filter, page: page),
    );
  }

  @override
  Future<Movie> getRandomMovie({int? genreId, double? minVoteAverage}) {
    // Sin caché: el valor de la sugerencia está en que cada vez cambie.
    return _inner.getRandomMovie(
      genreId: genreId,
      minVoteAverage: minVoteAverage,
    );
  }

  @override
  Future<Person> getPerson(int personId) async {
    final key = 'person:$personId';
    try {
      final result = await _inner.getPerson(personId);
      await _cache.put(key, MovieCacheCodec.encodePerson(result));
      return result;
    } on FetchException {
      final cached = await _readCached(key, MovieCacheCodec.decodePerson);
      if (cached == null) rethrow;
      return cached;
    }
  }

  @override
  Future<PersonFilmography> getPersonMovieCredits(int personId) async {
    final key = 'person_credits:$personId';
    try {
      final result = await _inner.getPersonMovieCredits(personId);
      await _cache.put(key, MovieCacheCodec.encodePersonFilmography(result));
      return result;
    } on FetchException {
      final cached =
          await _readCached(key, MovieCacheCodec.decodePersonFilmography);
      if (cached == null) rethrow;
      return cached;
    }
  }

  @override
  Future<MovieDetails> getMovieDetails(int movieId) async {
    final key = 'details:$movieId';
    try {
      final result = await _inner.getMovieDetails(movieId);
      await _cache.put(key, MovieCacheCodec.encodeMovieDetails(result));
      return result;
    } on FetchException {
      final cached = await _readCached(key, MovieCacheCodec.decodeMovieDetails);
      if (cached == null) rethrow;
      return cached;
    }
  }

  Future<MoviePage> _moviePage(
    String listKey,
    int page,
    Future<MoviePage> Function() fetch,
  ) async {
    final key = '$listKey:$page';
    try {
      final result = await fetch();
      await _cache.put(key, MovieCacheCodec.encodeMoviePage(result));
      return result;
    } on FetchException {
      final cached = await _readCached(key, MovieCacheCodec.decodeMoviePage);
      if (cached == null) rethrow;
      // Contenido guardado: la UI lo marca como "sin conexión".
      return cached;
    }
  }

  /// Lee una entrada de caché; `null` si no hay nada o su formato no se
  /// entiende (p. ej. quedó grabado por una versión anterior de la app).
  Future<T?> _readCached<T>(String key, T Function(String) decode) async {
    final entry = await _cache.read(key);
    return (entry == null)
        ? null
        : MovieCacheCodec.tryDecode(entry.payload, decode);
  }
}
