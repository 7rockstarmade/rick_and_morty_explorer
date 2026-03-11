import 'package:hive/hive.dart';
import 'package:rick_and_morty_exporer/core/constants/hive_constants.dart';
import 'package:rick_and_morty_exporer/features/characters/data/models/character_model.dart';
import 'package:rick_and_morty_exporer/features/characters/data/models/character_response_model.dart';

class CharactersLocalDataSource {
  CharactersLocalDataSource({Box<dynamic>? box})
      : _box = box ?? Hive.box(HiveConstants.charactersCacheBox);

  final Box<dynamic> _box;

  Future<void> cacheCharactersPage(int page, CharacterResponseModel response) {
    return _box.put(HiveConstants.charactersPageKey(page), response.toJson());
  }

  CharacterResponseModel? getCachedCharactersPage(int page) {
    final cached = _box.get(HiveConstants.charactersPageKey(page));
    if (cached is Map) {
      return CharacterResponseModel.fromJson(Map<String, dynamic>.from(cached));
    }
    return null;
  }

  List<CharacterModel> getCachedCharactersByIds(Iterable<int> ids) {
    final wanted = ids.toSet();
    if (wanted.isEmpty) {
      return const [];
    }

    final Map<int, CharacterModel> found = {};
    for (final value in _box.values) {
      if (found.length == wanted.length) {
        break;
      }
      if (value is! Map) {
        continue;
      }
      final json = Map<String, dynamic>.from(value);
      final response = CharacterResponseModel.fromJson(json);
      for (final character in response.characters) {
        if (wanted.contains(character.id)) {
          found[character.id] = character;
        }
      }
    }

    return wanted
        .map((id) => found[id])
        .whereType<CharacterModel>()
        .toList();
  }
}
