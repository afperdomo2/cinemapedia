import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movie_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infraestructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infraestructure/models/tmdb/movie_list_tmdb_response.dart';
import 'package:dio/dio.dart';

class MovieTMDbDataSource extends MovieDataSource {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Enviroment.theMovieDbApiKey,
      'language': 'es-MX',
    },
  ));

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing', queryParameters: {
      'page': page,
    });
    final List<Movie> movies = MovieListTMDbResponse.fromJson(response.data)
        .results
        .where((movie) => movie.posterPath != 'no-poster')
        .map((movie) => MovieMapper.movieTMDbResponseToEntity(movie))
        .toList();
    return movies;
  }
}
