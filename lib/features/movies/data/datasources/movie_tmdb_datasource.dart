import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/features/movies/data/mappers/movie_mapper.dart';
import 'package:cinemapedia/features/movies/data/models/tmdb/movie_list_tmdb_response.dart';
import 'package:cinemapedia/features/movies/domain/datasources/movie_datasource.dart';
import 'package:cinemapedia/features/movies/domain/entities/movie.dart';
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
        .where((movie) => movie.posterPath != 'no-poster')
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
}
