import 'package:cinemapedia/common/widgets/scaffold_with_bottom_navbar.dart';
import 'package:cinemapedia/features/home/screens/home_screen.dart';
import 'package:cinemapedia/features/categories/screens/categories_screen.dart';
import 'package:cinemapedia/features/favorites/screens/favorites_screen.dart';
import 'package:cinemapedia/features/movie_details/screens/movie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
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
              routes: [
                GoRoute(
                  path: 'movie/:movieId',
                  name: MovieDetailsScreen.name,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final movieId = state.pathParameters['movieId'];
                    return MovieDetailsScreen(movieId.toString());
                  },
                ),
              ],
            ),
          ],
        ),

        // Branch Categories
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/categories',
              name: CategoriesScreen.name,
              builder: (context, state) => const CategoriesScreen(),
            ),
          ],
        ),

        // Branch Favorites
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              name: FavoritesScreen.name,
              builder: (context, state) => const FavoritesScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
