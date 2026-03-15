import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_exporer/features/favorites/presentation/bloc/favorites_cubit.dart';
import 'package:rick_and_morty_exporer/features/favorites/presentation/widgets/favorites_animated_list.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FavoritesCubit>().state;
    if (state.characters.isEmpty) {
      return const Center(child: Text('No favorites yet'));
    }

    return FavoritesAnimatedList(
      characters: state.characters,
    );
  }
}
