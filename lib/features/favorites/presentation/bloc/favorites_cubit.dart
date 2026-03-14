import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_exporer/features/characters/data/models/character_model.dart';
import 'package:rick_and_morty_exporer/features/characters/data/repositories/characters_repository.dart';
import 'package:rick_and_morty_exporer/features/favorites/data/repositories/favorites_repository.dart';
import 'package:rick_and_morty_exporer/features/favorites/presentation/bloc/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this._favoritesRepository, this._charactersRepository)
    : super(const FavoritesState());

  final FavoritesRepository _favoritesRepository;
  final CharactersRepository _charactersRepository;

  void load() {
    final favoriteIds = _favoritesRepository.loadFavoriteIds();
    emit(
      FavoritesState(
        favoriteIds: favoriteIds,
        characters: _buildCharacters(favoriteIds),
      ),
    );
  }

  Future<void> toggle(int characterId) async {
    final favoriteIds = await _favoritesRepository.toggle(characterId);
    emit(
      FavoritesState(
        favoriteIds: favoriteIds,
        characters: _buildCharacters(favoriteIds),
      ),
    );
  }

  List<CharacterModel> _buildCharacters(Set<int> favoriteIds) {
    final characters = favoriteIds
        .map((id) => _charactersRepository.getCachedCharacterById(id) ?? _fallback(id))
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return characters;
  }

  CharacterModel _fallback(int id) {
    return CharacterModel(
      id: id,
      name: 'Character #$id',
      status: '',
      species: 'Unknown species',
      location: 'Unknown location',
      image: '',
    );
  }
}
