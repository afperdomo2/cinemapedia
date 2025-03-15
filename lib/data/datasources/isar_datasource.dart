import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasource extends LocalStorageDataSource {
  late Future<Isar> db;

  IsarDatasource() {
    db = openIsar();
  }

  Future<Isar> openIsar() async {
    final dir = await getApplicationDocumentsDirectory();

    return (Isar.instanceNames.isEmpty)
        ? await Isar.open([MovieSchema], inspector: true, directory: dir.path)
        : Future.value(Isar.getInstance());
  }

  @override
  Future<bool> isFavoriteMovie(int movieId) async {
    final isar = await db;
    final movie = await isar.movies.filter().idEqualTo(movieId).findFirst();
    return movie != null;
  }

  @override
  Future<void> toggleFavoriteMovie(Movie movie) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final favoriteMovie = await isar.movies.filter().idEqualTo(movie.id).findFirst();

      (favoriteMovie != null)
          ? await isar.movies.delete(favoriteMovie.isarId)
          : await isar.movies.put(movie);
    });
  }

  @override
  Future<List<Movie>> getFavoriteMovies({int page = 1, int limit = 20}) async {
    final isar = await db;
    final offset = (page - 1) * limit;
    return await isar.movies.where().offset(offset).limit(limit).findAll();
  }
}
