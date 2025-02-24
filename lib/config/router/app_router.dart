import 'package:cinemapedia/features/movies/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'movie/:movieId',
          name: MovieDetailsScreen.name,
          builder: (context, state) {
            final movieId = state.pathParameters['movieId'];
            return MovieDetailsScreen(movieId.toString());
          },
        ),
      ],
    ),
  ],
);
