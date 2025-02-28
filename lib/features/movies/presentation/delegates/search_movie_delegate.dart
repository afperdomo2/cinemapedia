import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/features/movies/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMovieCallBack = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallBack searchMovies;

  SearchMovieDelegate({required this.searchMovies});

  @override
  String get searchFieldLabel => 'Buscar películas';

  /// Este método se encarga de construir el widget que se muestra en la parte derecha del appbar.
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      FadeIn(
        animate: query.isNotEmpty,
        duration: const Duration(milliseconds: 200),
        child: IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
      ),
    ];
  }

  /// Este método se encarga de construir el widget que se muestra en la parte izquierda del appbar.
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: () => close(context, null), icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  /// Este método se encarga de construir el widget que se muestra cuando no hay sugerencias.
  @override
  Widget buildSuggestions(BuildContext context) {
    // NOTE: Revisar que al abrir o cerrar el teclado, se está ejecutando la búsqueda.
    return FutureBuilder(
      future: searchMovies(query),
      // initialData: const [],
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('-----------> LOADING');
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print('-----------> ERROR: ${snapshot.error}');
          print('-----------> ERROR: ${snapshot.error.runtimeType}');
          return const Center(child: Text('Error'));
        }

        final movies = snapshot.data ?? [];
        print('----> Cantidad de registros: ${movies.length}');

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return ListTile(
              title: Text(movie.title),
              subtitle: Text(movie.originalTitle),
            );
          },
        );
      },
    );
  }
}
