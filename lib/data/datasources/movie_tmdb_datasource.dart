import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/data/mappers/actor_mapper.dart';
import 'package:cinemapedia/data/mappers/movie_mapper.dart';
import 'package:cinemapedia/data/models/tmdb/movie_credits_tmdb_response.dart';
import 'package:cinemapedia/data/models/tmdb/movie_details_tmdb_response.dart';
import 'package:cinemapedia/data/models/tmdb/movie_list_tmdb_response.dart';
import 'package:cinemapedia/data/models/tmdb/movie_videos_tmdb_response.dart';
import 'package:cinemapedia/domain/datasources/movie_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:dio/dio.dart';

class MovieTMDbDataSource extends MovieDataSource {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Enviroment.theMovieDbApiKey,
      'language': 'es-MX',
    },
  ));

  List<Movie> _mapResponseToMovies(Map<String, dynamic> responseData) {
    final List<Movie> movies = MovieListTMDbResponse.fromJson(responseData)
        .results
        .map((movie) => MovieMapper.movieTMDbResponseToEntity(movie))
        .toList();
    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing', queryParameters: {
      'page': page,
    });
    return _mapResponseToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get('/movie/popular', queryParameters: {
      'page': page,
    });
    return _mapResponseToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get('/movie/top_rated', queryParameters: {
      'page': page,
    });
    return _mapResponseToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get('/movie/upcoming', queryParameters: {
      'page': page,
    });
    return _mapResponseToMovies(response.data);
  }

  @override
  Future<Movie> getMovieDetails(String movieId) async {
    final response = await dio.get('/movie/$movieId');
    if (response.statusCode != 200) {
      throw Exception('Error al obtener los detalles de la película $movieId');
    }
    final movieDetails = MovieDetailsTMDbResponse.fromJson(response.data);
    return MovieMapper.movieDetailsTMDbResponseToEntity(movieDetails);
  }

  @override
  Future<List<Actor>> getMovieActors(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');
    if (response.statusCode != 200) {
      throw Exception('Error al obtener los actores de la película $movieId');
    }
    final castReponse = MovieCreditsTMDbResponse.fromJson(response.data);
    return castReponse.cast.map((cast) => ActorMapper.castToEntity(cast)).toList();
  }

  @override
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    if (query.isEmpty) {
      return [];
    }
    final response = await dio.get('/search/movie', queryParameters: {
      'query': query,
      'page': page,
    });
    print('Cantidad de registros: ${response.data['results'].length}');
    return _mapResponseToMovies(response.data);
  }

  @override
  Future<List<Movie>> getSimilarMovies(String movieId, {int page = 1}) async {
    final response = await dio.get('/movie/$movieId/similar', queryParameters: {
      'page': page,
    });
    return _mapResponseToMovies(response.data);
  }

  @override
  Future<List<String>> getMovieYoutubeVideos(String movieId) async {
    final response = await dio.get('/movie/$movieId/videos');
    final videos = MovieVideosTMDbResponse.fromJson(response.data);
    return videos.results
        .where((video) => video.site == 'YouTube')
        .map((video) => video.key)
        .toList();
  }
}
