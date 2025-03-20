import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Widget para manejar el scaffold con bottom navigation bar
class ScaffoldWithBottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithBottomNavBar({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(label: 'Inicio', icon: Icon(Icons.home_max)),
          BottomNavigationBarItem(label: 'Populares', icon: Icon(Icons.star_outline)),
          BottomNavigationBarItem(label: 'Favoritos', icon: Icon(Icons.favorite_outline)),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }
}
