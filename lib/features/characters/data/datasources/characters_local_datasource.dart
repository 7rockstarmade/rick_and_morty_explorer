import 'package:hive/hive.dart';
import 'package:rick_and_morty_exporer/core/constants/hive_constants.dart';
import 'package:rick_and_morty_exporer/features/characters/data/models/character_model.dart';
import 'package:rick_and_morty_exporer/features/characters/data/models/character_response_model.dart';

abstract class CharactersLocalDataSource {
  Future<void> cacheCharactersPage(int page, CharacterResponseModel response);
  Future<void> cacheCharacters(List<CharacterModel> characters);
  CharacterResponseModel? getCachedCharactersPage(int page);
  CharacterModel? getCachedCharacterById(int id);
}

class CharactersLocalDataSourceImpl implements CharactersLocalDataSource {
  CharactersLocalDataSourceImpl({Box<dynamic>? box})
    : _box = box ?? Hive.box(HiveConstants.charactersCacheBox);
  final Box<dynamic> _box;

  @override
  Future<void> cacheCharactersPage(int page, CharacterResponseModel response) {
    return _box.put(HiveConstants.charactersPageKey(page), response.toJson());
  }

  @override
  Future<void> cacheCharacters(List<CharacterModel> characters) async {
    final entries = <dynamic, dynamic>{
      for (final c in characters)
        HiveConstants.characterByIdKey(c.id): c.toJson(),
    };
    await _box.putAll(entries);
  }

  @override
  CharacterResponseModel? getCachedCharactersPage(int page) {
    final cached = _box.get(HiveConstants.charactersPageKey(page));
    if (cached is Map) {
      return CharacterResponseModel.fromJson(Map<String, dynamic>.from(cached));
    }
    return null;
  }

  @override
  CharacterModel? getCachedCharacterById(int id) {
    final cached = _box.get(HiveConstants.characterByIdKey(id));
    if (cached is Map) {
      return CharacterModel.fromJson(Map<String, dynamic>.from(cached));
    }
    return null;
  }
}
