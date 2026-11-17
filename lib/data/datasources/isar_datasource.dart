import 'package:cinemapedia/data/mappers/movie_local_mapper.dart';
import 'package:cinemapedia/data/models/local/movie_local.dart';
import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_page.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasource extends LocalStorageDataSource {
  IsarDatasource() {
    db = _openIsar();
  }

  late final Future<Isar> db;

  Future<Isar> _openIsar() async {
    final dir = await getApplicationDocumentsDirectory();

    return (Isar.instanceNames.isEmpty)
        ? await Isar.open([MovieLocalSchema],
            inspector: true, directory: dir.path)
        : Future.value(Isar.getInstance());
  }

  @override
  Future<bool> isFavoriteMovie(int movieId) async {
    final isar = await db;
    // Índice único sobre el id de TMDB: búsqueda directa, sin escaneo lineal.
    final movie = await isar.movieLocals.where().idEqualTo(movieId).findFirst();
    return movie != null;
  }

  @override
  Future<bool> toggleFavoriteMovie(Movie movie) async {
    final isar = await db;
    return isar.writeTxn(() async {
      final favoriteMovie =
          await isar.movieLocals.where().idEqualTo(movie.id).findFirst();

      if (favoriteMovie != null) {
        await isar.movieLocals.delete(favoriteMovie.isarId);
        return false;
      }

      await isar.movieLocals.put(MovieLocalMapper.fromEntity(movie));
      return true;
    });
  }

  @override
  Future<MoviePage> getFavoriteMovies({int page = 1, int limit = 20}) async {
    final isar = await db;
    final offset = (page - 1) * limit;
    final total = await isar.movieLocals.count();
    // Orden descendente por clave de inserción: los más recientes primero.
    final favorites = await isar.movieLocals
        .where(sort: Sort.desc)
        .anyIsarId()
        .offset(offset)
        .limit(limit)
        .findAll();

    return MoviePage(
      movies: favorites.map(MovieLocalMapper.toEntity).toList(),
      page: page,
      totalPages: (total / limit).ceil(),
    );
  }
}
