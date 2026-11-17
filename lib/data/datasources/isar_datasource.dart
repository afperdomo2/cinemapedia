import 'package:cinemapedia/data/datasources/isar_database.dart';
import 'package:cinemapedia/data/mappers/movie_local_mapper.dart';
import 'package:cinemapedia/data/models/local/movie_local.dart';
import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_page.dart';
import 'package:isar/isar.dart';

class IsarDatasource extends LocalStorageDataSource {
  IsarDatasource();

  Future<Isar> get db => IsarDatabase.open();

  @override
  Future<bool> isFavoriteMovie(int movieId) async {
    final isar = await db;
    // Índice único sobre el id de TMDB: búsqueda directa, sin escaneo lineal.
    final movie = await isar.movieLocals.where().idEqualTo(movieId).findFirst();
    return movie != null && movie.isFavorite;
  }

  @override
  Future<bool> isInWatchlistMovie(int movieId) async {
    final isar = await db;
    final movie = await isar.movieLocals.where().idEqualTo(movieId).findFirst();
    return movie != null && movie.inWatchlist;
  }

  @override
  Future<bool> toggleFavoriteMovie(Movie movie) async {
    final isar = await db;
    return isar.writeTxn(() async {
      final stored =
          await isar.movieLocals.where().idEqualTo(movie.id).findFirst();

      if (stored == null) {
        await isar.movieLocals
            .put(MovieLocalMapper.fromEntity(movie, isFavorite: true));
        return true;
      }

      // Se actualiza la fila existente para conservar el orden de inserción.
      stored.isFavorite = !stored.isFavorite;
      await _persistOrDelete(isar, stored);
      return stored.isFavorite;
    });
  }

  @override
  Future<bool> toggleWatchlistMovie(Movie movie) async {
    final isar = await db;
    return isar.writeTxn(() async {
      final stored =
          await isar.movieLocals.where().idEqualTo(movie.id).findFirst();

      if (stored == null) {
        await isar.movieLocals
            .put(MovieLocalMapper.fromEntity(movie, inWatchlist: true));
        return true;
      }

      stored.inWatchlist = !stored.inWatchlist;
      await _persistOrDelete(isar, stored);
      return stored.inWatchlist;
    });
  }

  /// Una fila solo existe si la película está en al menos una lista.
  Future<void> _persistOrDelete(Isar isar, MovieLocal movie) async {
    if (!movie.isFavorite && !movie.inWatchlist) {
      await isar.movieLocals.delete(movie.isarId);
    } else {
      await isar.movieLocals.put(movie);
    }
  }

  @override
  Future<MoviePage> getFavoriteMovies({int page = 1, int limit = 20}) {
    return _getList(page: page, limit: limit, watchlist: false);
  }

  @override
  Future<MoviePage> getWatchlistMovies({int page = 1, int limit = 20}) {
    return _getList(page: page, limit: limit, watchlist: true);
  }

  Future<MoviePage> _getList({
    required int page,
    required int limit,
    required bool watchlist,
  }) async {
    final isar = await db;
    final offset = (page - 1) * limit;

    // Orden descendente por clave de inserción: los más recientes primero.
    final filtered =
        isar.movieLocals.where(sort: Sort.desc).anyIsarId().filter();
    final query = watchlist
        ? filtered.inWatchlistEqualTo(true)
        : filtered.isFavoriteEqualTo(true);

    final total = await query.count();
    final movies = await query.offset(offset).limit(limit).findAll();

    return MoviePage(
      movies: movies.map(MovieLocalMapper.toEntity).toList(),
      page: page,
      totalPages: (total / limit).ceil(),
    );
  }
}
