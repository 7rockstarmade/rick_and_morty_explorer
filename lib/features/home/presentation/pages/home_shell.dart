import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_exporer/features/home/presentation/bloc/nav_cubit.dart';
import 'package:rick_and_morty_exporer/features/characters/presentation/pages/characters_page.dart';
import 'package:rick_and_morty_exporer/features/favorites/presentation/pages/favorites_page.dart';
import 'package:rick_and_morty_exporer/features/home/presentation/widgets/app_bottom_navigation_bar.dart';
import 'package:rick_and_morty_exporer/features/home/presentation/widgets/app_top_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _pages = [CharactersPage(), FavoritesPage()];
  static const _titles = ['All Characters', 'Favorites'];

  @override
  Widget build(BuildContext context) {
    final currentTab = context.select((NavCubit cubit) => cubit.state);
    final currentIndex = currentTab.index;

    return Scaffold(
      appBar: AppTopBar(title: _titles[currentIndex]),
      body: IndexedStack(index: currentIndex, children: _pages),
      bottomNavigationBar: AppBottomNavigationBar(
        currentTab: currentTab,
        onTabSelected: (tab) => context.read<NavCubit>().setTab(tab),
      ),
    );
  }
}
