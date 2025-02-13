import 'package:cinemapedia/domain/repositories/movie_repository.dart';
import 'package:cinemapedia/infraestructure/datasources/movie_tmdb_datasource.dart';
import 'package:cinemapedia/infraestructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepositoryImpl(MovieTMDbDataSource());
});
