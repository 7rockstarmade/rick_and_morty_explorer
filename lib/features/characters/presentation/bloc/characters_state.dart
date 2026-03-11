import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rick_and_morty_exporer/features/characters/data/models/character_model.dart';

part 'characters_state.freezed.dart';

@freezed
class CharactersState with _$CharactersState {
  const factory CharactersState.initial() = _Initial;
  const factory CharactersState.loading() = _Loading;
  const factory CharactersState.loaded({
    required List<CharacterModel> characters,
    required int currentPage,
    required bool hasMore,
    String? next,
    @Default(false) bool isFetchingMore,
  }) = _Loaded;
  const factory CharactersState.error(String? message) = _Error;
}
