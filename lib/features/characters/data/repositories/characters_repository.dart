import 'package:rick_and_morty_exporer/features/characters/data/datasources/characters_remote_datasource.dart';
import 'package:rick_and_morty_exporer/features/characters/data/datasources/characters_local_datasource.dart';
import 'package:rick_and_morty_exporer/features/characters/data/models/character_model.dart';
import 'package:rick_and_morty_exporer/features/characters/data/models/character_response_model.dart';

class CharactersPageResult {
  const CharactersPageResult({
    required this.response,
    required this.isFromCache,
  });

  final CharacterResponseModel response;
  final bool isFromCache;
}

abstract class CharactersRepository {
  Future<CharactersPageResult> getCharacters(int page);
  CharacterModel? getCachedCharacterById(int id);
}

class CharactersRepositoryImpl implements CharactersRepository {
  final CharactersRemoteDataSource remoteDataSource;
  final CharactersLocalDataSource localDataSource;

  CharactersRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<CharactersPageResult> getCharacters(int page) async {
    try {
      final response = await remoteDataSource.getCharacters(page);
      await localDataSource.cacheCharacters(response.characters);
      await localDataSource.cacheCharactersPage(page, response);
      return CharactersPageResult(response: response, isFromCache: false);
    } catch (_) {
      final cached = localDataSource.getCachedCharactersPage(page);
      if (cached != null) {
        return CharactersPageResult(response: cached, isFromCache: true);
      }
      rethrow;
    }
  }

  @override
  CharacterModel? getCachedCharacterById(int id) {
    return localDataSource.getCachedCharacterById(id);
  }
}
