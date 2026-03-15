import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_exporer/features/characters/data/models/character_model.dart';
import 'package:rick_and_morty_exporer/features/favorites/presentation/bloc/favorites_cubit.dart';
import 'package:rick_and_morty_exporer/features/favorites/presentation/bloc/favorites_state.dart';
import 'package:rick_and_morty_exporer/shared/widgets/character_card.dart';

class FavoritesAnimatedList extends StatefulWidget {
  const FavoritesAnimatedList({
    super.key,
    required this.characters,
  });

  final List<CharacterModel> characters;

  @override
  State<FavoritesAnimatedList> createState() => _FavoritesAnimatedListState();
}

class _FavoritesAnimatedListState extends State<FavoritesAnimatedList> {
  final _listKey = GlobalKey<AnimatedListState>();
  List<CharacterModel> _characters = const [];
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesCubit, FavoritesState>(
      listenWhen: (previous, current) =>
          previous.characters != current.characters,
      listener: (context, state) {
        if (!_initialized) {
          setState(() {
            _characters = List<CharacterModel>.from(state.characters);
            _initialized = true;
          });
          return;
        }

        for (var i = _characters.length - 1; i >= 0; i--) {
          final character = _characters[i];
          final stillExists = state.characters.any(
            (item) => item.id == character.id,
          );
          if (!stillExists) {
            final removed = _characters.removeAt(i);
            _listKey.currentState?.removeItem(
              i,
              (context, animation) => _RemovedFavoriteCard(
                character: removed,
                animation: animation,
              ),
              duration: _AnimatedFavoriteCard.duration,
            );
          }
        }

        final existingIds = _characters.map((e) => e.id).toSet();
        for (final character in state.characters) {
          if (!existingIds.contains(character.id)) {
            final insertIndex = state.characters.indexWhere(
              (item) => item.id == character.id,
            );
            _characters.insert(insertIndex, character);
            _listKey.currentState?.insertItem(
              insertIndex,
              duration: _AnimatedFavoriteCard.duration,
            );
          }
        }

        final stateOrder = {for (final c in state.characters) c.id: c};
        _characters = _characters
            .where((character) => stateOrder.containsKey(character.id))
            .map((character) => stateOrder[character.id]!)
            .toList();
      },
      child: Builder(
        builder: (context) {
          if (!_initialized) {
            _characters = List<CharacterModel>.from(widget.characters);
            _initialized = true;
          }

          return AnimatedList(
            key: _listKey,
            padding: const EdgeInsets.all(16),
            initialItemCount: _characters.length,
            itemBuilder: (context, index, animation) {
              final character = _characters[index];
              final sizeAnimation = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              );
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizeTransition(
                  sizeFactor: sizeAnimation,
                  child: _AnimatedFavoriteCard(
                    key: ValueKey(character.id),
                    character: character,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AnimatedFavoriteCard extends StatefulWidget {
  static const duration = Duration(milliseconds: 240);

  const _AnimatedFavoriteCard({super.key, required this.character});

  final CharacterModel character;

  @override
  State<_AnimatedFavoriteCard> createState() => _AnimatedFavoriteCardState();
}

class _AnimatedFavoriteCardState extends State<_AnimatedFavoriteCard> {
  bool _isRemoving = false;

  Future<void> _handleRemove() async {
    if (_isRemoving) {
      return;
    }

    setState(() {
      _isRemoving = true;
    });

    await Future<void>.delayed(_AnimatedFavoriteCard.duration);
    if (!mounted) {
      return;
    }

    await context.read<FavoritesCubit>().toggle(widget.character.id);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: _isRemoving,
      child: AnimatedOpacity(
        duration: _AnimatedFavoriteCard.duration,
        curve: Curves.easeOut,
        opacity: _isRemoving ? 0 : 1,
        child: AnimatedSlide(
          duration: _AnimatedFavoriteCard.duration,
          curve: Curves.easeInCubic,
          offset: _isRemoving ? const Offset(-1.1, 0) : Offset.zero,
          child: CharacterCard(
            imageUrl: widget.character.image,
            name: widget.character.name,
            species: widget.character.species,
            location: widget.character.location,
            isFavorite: true,
            onFavoritePressed: _handleRemove,
          ),
        ),
      ),
    );
  }
}

class _RemovedFavoriteCard extends StatelessWidget {
  const _RemovedFavoriteCard({
    required this.character,
    required this.animation,
  });

  final CharacterModel character;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final sizeAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizeTransition(
        sizeFactor: sizeAnimation,
        child: IgnorePointer(
          child: Opacity(
            opacity: 0,
            child: CharacterCard(
              imageUrl: character.image,
              name: character.name,
              species: character.species,
              location: character.location,
              isFavorite: true,
            ),
          ),
        ),
      ),
    );
  }
}
