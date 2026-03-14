import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_exporer/features/favorites/presentation/bloc/favorites_cubit.dart';
import 'package:rick_and_morty_exporer/shared/widgets/character_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FavoritesCubit>().state;
    if (state.characters.isEmpty) {
      return const Center(child: Text('No favorites yet'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.characters.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final character = state.characters[index];

        return CharacterCard(
          imageUrl: character.image,
          name: character.name,
          species: character.species,
          location: character.location,
          isFavorite: true,
          onFavoritePressed: () =>
              context.read<FavoritesCubit>().toggle(character.id),
        );
      },
    );
  }
}
