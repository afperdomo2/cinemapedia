import 'package:cinemapedia/common/widgets/scaffold_with_bottom_navbar.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/features/favorites/screens/favorites_screen.dart';
import 'package:cinemapedia/features/genres/screens/genres_screen.dart';
import 'package:cinemapedia/features/genres/screens/movies_by_genre_screen.dart';
import 'package:cinemapedia/features/home/screens/home_screen.dart';
import 'package:cinemapedia/features/movie_details/screens/movie_details_screen.dart';
import 'package:cinemapedia/features/movie_details/screens/video_screen.dart';
import 'package:cinemapedia/features/person/screens/person_screen.dart';
import 'package:cinemapedia/features/popular/screens/popular_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  // Sin `initialLocation`: los deep links en frío (y las URLs del navegador en
  // web) llegan por la ruta inicial de la plataforma.
  navigatorKey: _rootNavigatorKey,
  errorBuilder: (context, state) => const RouteErrorScreen(),
  // Los deep links con esquema propio llegan como `cinemapedia://movie/123`
  // (el primer segmento viaja como host): se normalizan a `/movie/123`.
  redirect: (context, state) {
    final uri = state.uri;
    if (uri.scheme == 'cinemapedia' && uri.host.isNotEmpty) {
      return '/${uri.host}/${uri.pathSegments.join('/')}';
    }
    return null;
  },
  routes: [
    // StatefulShellRoute para manejar las pestañas de navegación
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithBottomNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Branch Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              name: HomeScreen.name,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // Branch Populares
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/popular',
              name: PopularScreen.name,
              builder: (context, state) => const PopularScreen(),
            ),
          ],
        ),

        // Branch Favoritos
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              name: FavoritesScreen.name,
              builder: (context, state) => const FavoritesScreen(),
            ),
          ],
        ),

        // Branch Explorar
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/genres',
              name: GenresScreen.name,
              builder: (context, state) => const GenresScreen(),
              routes: [
                GoRoute(
                  path: ':genreId',
                  name: MoviesByGenreScreen.name,
                  builder: (context, state) {
                    final genreId =
                        int.tryParse(state.pathParameters['genreId'] ?? '');
                    if (genreId == null) return const RouteErrorScreen();
                    return MoviesByGenreScreen(
                      genreId: genreId,
                      genreName: state.extra as String?,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // Detalles y videos se muestran fuera del shell (sin barra inferior)
    GoRoute(
      path: '/movie/:movieId',
      name: MovieDetailsScreen.name,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final movieId = int.tryParse(state.pathParameters['movieId'] ?? '');
        if (movieId == null) return const RouteErrorScreen();
        return MovieDetailsScreen(movieId: movieId);
      },
      routes: [
        GoRoute(
          path: 'videos',
          name: VideoScreen.name,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final extra = state.extra;
            if (extra is! Video) {
              return const RouteErrorScreen();
            }
            return VideoScreen(video: extra);
          },
        ),
      ],
    ),

    // Detalle de persona (actor/dirección) fuera del shell, como el de películas
    GoRoute(
      path: '/person/:personId',
      name: PersonScreen.name,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final personId = int.tryParse(state.pathParameters['personId'] ?? '');
        if (personId == null) return const RouteErrorScreen();
        return PersonScreen(personId: personId);
      },
    ),
  ],
);

/// Pantalla de error para rutas inválidas o parámetros mal formados.
class RouteErrorScreen extends StatelessWidget {
  const RouteErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.explore_off_outlined, size: 56),
              const SizedBox(height: 16),
              Text('No encontramos lo que buscabas',
                  style: textStyles.titleMedium),
              const SizedBox(height: 8),
              const Text(
                'La dirección no existe o los datos no son válidos.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: () => context.go('/'),
                child: const Text('Ir al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
