import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_exporer/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:rick_and_morty_exporer/features/characters/presentation/bloc/characters_event.dart';
import 'package:rick_and_morty_exporer/features/characters/presentation/bloc/characters_state.dart';
import 'package:rick_and_morty_exporer/features/characters/presentation/widgets/info_cache_widget.dart';
import 'package:rick_and_morty_exporer/features/favorites/presentation/bloc/favorites_cubit.dart';
import 'package:rick_and_morty_exporer/shared/widgets/character_card.dart';

class CharactersPage extends StatelessWidget {
  const CharactersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharactersBloc, CharactersState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => const SizedBox.shrink(),
          loading: (_) => const Center(child: CircularProgressIndicator()),
          error: (e) => Center(child: Text(e.message ?? 'Unknown error')),
          loaded: (state) {
            final favoriteIds = context.select(
              (FavoritesCubit cubit) => cubit.state.favoriteIds,
            );
            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                final metrics = notification.metrics;
                if (metrics.maxScrollExtent <= 0) {
                  return false;
                }
                final shouldLoadMore =
                    metrics.pixels >= (metrics.maxScrollExtent - 300);
                if (shouldLoadMore) {
                  context.read<CharactersBloc>().add(
                    const CharactersNextPageRequested(),
                  );
                }
                return false;
              },
              child: CustomScrollView(
                slivers: [
                  if (state.isFromCache)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: InfoCacheWidget(),
                      ),
                    ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      state.isFromCache ? 12 : 16,
                      16,
                      16,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: state.characters.length,
                        (context, index) {
                          final character = state.characters[index];
                          final isFavorite = favoriteIds.contains(character.id);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: CharacterCard(
                              imageUrl: character.image,
                              name: character.name,
                              species: character.species,
                              location: character.location,
                              isFavorite: isFavorite,
                              onFavoritePressed: () => context
                                  .read<FavoritesCubit>()
                                  .toggle(character.id),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (state.isFetchingMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 24),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
