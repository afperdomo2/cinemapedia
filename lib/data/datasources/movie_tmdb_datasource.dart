import 'dart:math';

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/data/mappers/actor_mapper.dart';
import 'package:cinemapedia/data/mappers/genre_mapper.dart';
import 'package:cinemapedia/data/mappers/movie_mapper.dart';
import 'package:cinemapedia/data/mappers/person_mapper.dart';
import 'package:cinemapedia/data/mappers/video_mapper.dart';
import 'package:cinemapedia/data/models/tmdb/genre_list_tmdb_response.dart';
import 'package:cinemapedia/data/models/tmdb/movie_credits_tmdb_response.dart';
// `hide Genre`: el modelo TMDB choca con la entidad de dominio Genre.
import 'package:cinemapedia/data/models/tmdb/movie_details_tmdb_response.dart'
    hide Genre;
import 'package:cinemapedia/data/models/tmdb/movie_list_tmdb_response.dart';
import 'package:cinemapedia/data/models/tmdb/movie_videos_tmdb_response.dart';
import 'package:cinemapedia/data/models/tmdb/person_tmdb_response.dart';
import 'package:cinemapedia/domain/datasources/movie_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/domain/entities/genre_filter.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_details.dart';
import 'package:cinemapedia/domain/entities/movie_page.dart';
import 'package:cinemapedia/domain/entities/person.dart';
import 'package:cinemapedia/domain/entities/person_filmography.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/domain/exceptions/fetch_exception.dart';
import 'package:dio/dio.dart';

class MovieTMDbDataSource extends MovieDataSource {
  MovieTMDbDataSource({Dio? dioClient, Random? random})
      : dio = dioClient ?? _createDio(),
        _random = random ?? Random();

  final Dio dio;

  /// Fuente de azar para las sugerencias (inyectable para los tests).
  final Random _random;

  static Dio _createDio() {
    return Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbApiKey,
        'language': 'es-MX',
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
  }

  /// Envuelve cada request para traducir errores de red/servidor a un
  /// [FetchException] de dominio, en vez de filtrar `DioException` a la UI.
  Future<T> _request<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (error) {
      throw FetchException(_messageFor(error), cause: error);
    } catch (error) {
      throw FetchException('Ocurrió un error inesperado', cause: error);
    }
  }

  String _messageFor(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'La conexión tardó demasiado. Revisá tu internet e intentá de nuevo.';
      case DioExceptionType.connectionError:
        return 'No se pudo conectar con el servidor. Revisá tu conexión a internet.';
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode;
        if (status == 404) return 'No se encontró lo que buscabas.';
        if (status == 401) return 'La API key de TMDB no es válida.';
        if (status != null && status >= 500) {
          return 'El servidor de TMDB está teniendo problemas. Intentá de nuevo.';
        }
        return 'No se pudo obtener la información.';
      case DioExceptionType.cancel:
        return 'La petición fue cancelada.';
      case DioExceptionType.badCertificate:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.unknown:
        return 'No se pudo conectar con el servidor. Revisá tu conexión a internet.';
    }
  }

  Future<Map<String, dynamic>> _getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(() async {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response.data as Map<String, dynamic>;
    });
  }

  Future<MoviePage> _getMoviePage(
    String path, {
    int page = 1,
    String? query,
    Map<String, dynamic> extraQueryParameters = const {},
  }) async {
    final data = await _getJson(path, queryParameters: {
      'page': page,
      if (query != null) 'query': query,
      ...extraQueryParameters,
    });
    final response = MovieListTMDbResponse.fromJson(data);
    return MoviePage(
      movies:
          response.results.map(MovieMapper.movieTMDbResponseToEntity).toList(),
      page: response.page,
      totalPages: response.totalPages,
    );
  }

  @override
  Future<MoviePage> getNowPlaying({int page = 1}) {
    return _getMoviePage('/movie/now_playing', page: page);
  }

  @override
  Future<MoviePage> getPopular({int page = 1}) {
    return _getMoviePage('/movie/popular', page: page);
  }

  @override
  Future<MoviePage> getTopRated({int page = 1}) {
    return _getMoviePage('/movie/top_rated', page: page);
  }

  @override
  Future<MoviePage> getUpcoming({int page = 1}) {
    return _getMoviePage('/movie/upcoming', page: page);
  }

  @override
  Future<MoviePage> searchMovies(String query, {int page = 1}) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return Future.value(MoviePage.empty);
    return _getMoviePage('/search/movie', page: page, query: trimmed);
  }

  @override
  Future<List<Genre>> getGenres() async {
    final data = await _getJson('/genre/movie/list');
    return GenreListTMDbResponse.fromJson(data)
        .genres
        .map(GenreMapper.genreTMDbResponseToEntity)
        .toList();
  }

  @override
  Future<MoviePage> discoverMovies(GenreFilter filter, {int page = 1}) {
    return _getMoviePage(
      '/discover/movie',
      page: page,
      extraQueryParameters: filter.queryParameters,
    );
  }

  @override
  Future<Movie> getRandomMovie({int? genreId, double? minVoteAverage}) async {
    final filters = {
      'sort_by': 'popularity.desc',
      // Solo películas con cierto respaldo: el azar no debe traer rarezas.
      'vote_count.gte': 500,
      if (genreId != null) 'with_genres': genreId,
      if (minVoteAverage != null) 'vote_average.gte': minVoteAverage,
    };

    // TMDB no tiene "aleatorio": se sortea una página y después una película.
    final firstPage = await _getJson('/discover/movie', queryParameters: {
      ...filters,
      'page': 1,
    });
    final totalPages = (firstPage['total_pages'] as num?)?.toInt() ?? 0;
    if (totalPages == 0) {
      throw const FetchException(
          'No encontramos sugerencias con esos filtros.');
    }

    // TMDB limita la paginación a 500 páginas de resultados.
    final page = _random.nextInt(totalPages.clamp(1, 500)) + 1;
    final data = (page == 1)
        ? firstPage
        : await _getJson('/discover/movie', queryParameters: {
            ...filters,
            'page': page,
          });

    final results = MovieListTMDbResponse.fromJson(data).results;
    if (results.isEmpty) {
      throw const FetchException(
          'No encontramos sugerencias con esos filtros.');
    }
    return MovieMapper.movieTMDbResponseToEntity(
      results[_random.nextInt(results.length)],
    );
  }

  @override
  Future<Person> getPerson(int personId) async {
    final data = await _getJson('/person/$personId');
    return PersonMapper.personTMDbResponseToEntity(
      PersonTMDbResponse.fromJson(data),
    );
  }

  @override
  Future<PersonFilmography> getPersonMovieCredits(int personId) async {
    final data = await _getJson('/person/$personId/movie_credits');
    // Reparto y equipo; el mapper los ordena por popularidad.
    return PersonMapper.movieCreditsTMDbResponseToEntity(
      PersonMovieCreditsTMDbResponse.fromJson(data),
    );
  }

  @override
  Future<MovieDetails> getMovieDetails(int movieId) async {
    final data = await _getJson(
      '/movie/$movieId',
      // Una sola petición en lugar de cuatro.
      queryParameters: {'append_to_response': 'credits,videos,similar'},
    );

    final movie = MovieMapper.movieDetailsTMDbResponseToEntity(
      MovieDetailsTMDbResponse.fromJson(data),
    );

    final creditsJson = data['credits'];
    final List<Actor> actors = (creditsJson is Map<String, dynamic>)
        ? MovieCreditsTMDbResponse.fromJson(creditsJson)
            .cast
            .map(ActorMapper.castToEntity)
            .toList()
        : <Actor>[];

    final videosJson = data['videos'];
    final List<Video> videos = (videosJson is Map<String, dynamic>)
        ? MovieVideosTMDbResponse.fromJson(videosJson)
            .results
            .where((video) => video.site == 'YouTube' && video.key.isNotEmpty)
            .map(VideoMapper.movieVideoTMDbResponseToEntity)
            .toList()
        : <Video>[];

    final similarJson = data['similar'];
    final List<Movie> similarMovies = (similarJson is Map<String, dynamic>)
        ? MovieListTMDbResponse.fromJson(similarJson)
            .results
            .map(MovieMapper.movieTMDbResponseToEntity)
            .toList()
        : <Movie>[];

    return MovieDetails(
      movie: movie,
      actors: actors,
      videos: videos,
      similarMovies: similarMovies,
    );
  }
}
