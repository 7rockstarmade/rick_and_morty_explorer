import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_exporer/app/navigation/nav_cubit.dart';
import 'package:rick_and_morty_exporer/features/characters/presentation/pages/characters_page.dart';
import 'package:rick_and_morty_exporer/features/favorites/presentation/pages/favorites_page.dart';
import 'package:rick_and_morty_exporer/shared/widgets/app_bottom_navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _pages = [CharactersPage(), FavoritesPage()];

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.select((NavCubit cubit) => cubit.state);

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _pages),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: currentIndex,
        onDestinationSelected: (index) =>
            context.read<NavCubit>().setIndex(index),
      ),
    );
  }
}
