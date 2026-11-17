import 'package:cinemapedia/data/datasources/isar_movie_cache_store.dart';
import 'package:cinemapedia/data/datasources/movie_tmdb_datasource.dart';
import 'package:cinemapedia/data/repositories/cached_movie_repository.dart';
import 'package:cinemapedia/data/repositories/movie_repository_impl.dart';
import 'package:cinemapedia/domain/repositories/movie_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return CachedMovieRepository(
    MovieRepositoryImpl(MovieTMDbDataSource()),
    IsarMovieCacheStore(),
  );
});
