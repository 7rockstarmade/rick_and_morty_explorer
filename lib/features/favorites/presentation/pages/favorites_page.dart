import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_exporer/features/characters/data/datasources/characters_local_datasource.dart';
import 'package:rick_and_morty_exporer/features/characters/data/models/character_model.dart';
import 'package:rick_and_morty_exporer/features/favorites/presentation/bloc/favorites_cubit.dart';
import 'package:rick_and_morty_exporer/shared/widgets/character_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ids = context.watch<FavoritesCubit>().state;

    if (ids.isEmpty) {
      return const Center(child: Text('No favorites yet'));
    }

    return FutureBuilder<List<CharacterModel>>(
      future: Future(() => CharactersLocalDataSource().getCachedCharactersByIds(ids)),
      builder: (context, snapshot) {
        final cached = snapshot.data ?? const <CharacterModel>[];
        final cachedById = {for (final c in cached) c.id: c};
        final orderedIds = ids.toList()..sort();

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: orderedIds.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final id = orderedIds[index];
            final character = cachedById[id];

            return CharacterCard(
              imageUrl: character?.image ?? '',
              name: character?.name ?? 'Character #$id',
              species: character?.species ?? 'Unknown species',
              isFavorite: true,
              onFavoritePressed: () => context.read<FavoritesCubit>().toggle(id),
            );
          },
        );
      },
    );
  }
}
