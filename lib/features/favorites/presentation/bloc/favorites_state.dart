import 'package:equatable/equatable.dart';
import 'package:rick_and_morty_exporer/features/characters/data/models/character_model.dart';

class FavoritesState extends Equatable {
  const FavoritesState({
    this.favoriteIds = const <int>{},
    this.characters = const [],
  });

  final Set<int> favoriteIds;
  final List<CharacterModel> characters;

  FavoritesState copyWith({
    Set<int>? favoriteIds,
    List<CharacterModel>? characters,
  }) {
    return FavoritesState(
      favoriteIds: favoriteIds ?? this.favoriteIds,
      characters: characters ?? this.characters,
    );
  }

  @override
  List<Object?> get props => [favoriteIds, characters];
}
