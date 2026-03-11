import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_exporer/core/network/dio_client.dart';
import 'package:rick_and_morty_exporer/features/characters/data/datasources/characters_remote_datasource.dart';
import 'package:rick_and_morty_exporer/features/characters/data/repositories/characters_repository.dart';
import 'package:rick_and_morty_exporer/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:rick_and_morty_exporer/features/characters/presentation/bloc/characters_event.dart';
import 'package:rick_and_morty_exporer/features/characters/presentation/bloc/characters_state.dart';
import 'package:rick_and_morty_exporer/shared/widgets/character_card.dart';

class CharactersPage extends StatelessWidget {
  const CharactersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final remote = CharactersRemoteDataSourceImpl(DioClient.instance);
        final repository = CharactersRepositoryImpl(remote);
        return CharactersBloc(repository)..add(const CharactersStarted());
      },
      child: BlocBuilder<CharactersBloc, CharactersState>(
        builder: (context, state) {
          return state.map(
            initial: (_) => const SizedBox.shrink(),
            loading: (_) => const Center(child: CircularProgressIndicator()),
            error: (e) => Center(child: Text(e.message ?? 'Unknown error')),
            loaded: (state) {
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  final metrics = notification.metrics;
                  if (metrics.maxScrollExtent <= 0) {
                    return false;
                  }
                  final shouldLoadMore =
                      metrics.pixels >= (metrics.maxScrollExtent - 300);
                  if (shouldLoadMore) {
                    context
                        .read<CharactersBloc>()
                        .add(const CharactersNextPageRequested());
                  }
                  return false;
                },
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: state.characters.length,
                          (context, index) {
                            final character = state.characters[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: CharacterCard(
                                imageUrl: character.image,
                                name: character.name,
                                species: character.species,
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
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
