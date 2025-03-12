import 'package:cinemapedia/features/movies/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/features/movies/domain/entities/movie.dart';
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
  Future<List<Movie>> getFavoriteMovies({int page = 1}) {
    // TODO: implement getFavoriteMovies
    throw UnimplementedError();
  }

  @override
  Future<bool> isFavoriteMovie(int movieId) {
    // TODO: implement isFavoriteMovie
    throw UnimplementedError();
  }

  @override
  Future<void> toggleFavoriteMovie(Movie movie) {
    // TODO: implement toggleFavoriteMovie
    throw UnimplementedError();
  }
}
