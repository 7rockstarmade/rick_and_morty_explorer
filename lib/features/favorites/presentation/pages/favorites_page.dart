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
    final orderedIds = ids.toList()..sort();
    final repo = context.read<CharactersRepository>();
    if (ids.isEmpty) {
      return const Center(child: Text('No favorites yet'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orderedIds.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final id = orderedIds[index];
        final character = repo.getCachedCharacterById(id);

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
