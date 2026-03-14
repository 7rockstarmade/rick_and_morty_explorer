import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_exporer/features/characters/data/repositories/characters_repository.dart';
import 'package:rick_and_morty_exporer/features/favorites/presentation/bloc/favorites_cubit.dart';
import 'package:rick_and_morty_exporer/shared/widgets/character_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ids = context.watch<FavoritesCubit>().state;
    final repo = context.read<CharactersRepository>();
    if (ids.isEmpty) {
      return const Center(child: Text('No favorites yet'));
    }

    final favoriteItems = ids
        .map((id) => (id: id, character: repo.getCachedCharacterById(id)))
        .toList()
      ..sort((a, b) {
        final left = (a.character?.name ?? 'Character #${a.id}').toLowerCase();
        final right =
            (b.character?.name ?? 'Character #${b.id}').toLowerCase();
        return left.compareTo(right);
      });

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: favoriteItems.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = favoriteItems[index];
        final id = item.id;
        final character = item.character;

        return CharacterCard(
          imageUrl: character?.image ?? '',
          name: character?.name ?? 'Character #$id',
          species: character?.species ?? 'Unknown species',
          isFavorite: true,
          onFavoritePressed: () => context.read<FavoritesCubit>().toggle(id),
        );
      },
    );
  }
}
