import 'package:rick_and_morty_exporer/features/characters/data/datasources/characters_remote_datasource.dart';
import 'package:rick_and_morty_exporer/features/characters/data/datasources/characters_local_datasource.dart';
import 'package:rick_and_morty_exporer/features/characters/data/models/character_model.dart';
import 'package:rick_and_morty_exporer/features/characters/data/models/character_response_model.dart';

abstract class CharactersRepository {
  Future<CharacterResponseModel> getCharacters(int page);
  Future<void> cacheCharactersPage(int page, CharacterResponseModel response);
  Future<void> cacheCharacters(List<CharacterModel> characters);
  CharacterResponseModel? getCachedCharactersPage(int page);
  CharacterModel? getCachedCharacterById(int id);
}

class CharactersRepositoryImpl implements CharactersRepository {
  final CharactersRemoteDatasource remoteDataSource;
  final CharactersLocalDatasource localDataSource;

  CharactersRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<CharacterResponseModel> getCharacters(int page) async {
    try {
      final response = await remoteDataSource.getCharacters(page);
      await localDataSource.cacheCharacters(response.characters);
      await localDataSource.cacheCharactersPage(page, response);
      return response;
    } catch (_) {
      final cached = localDataSource.getCachedCharactersPage(page);
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  @override
  Future<void> cacheCharactersPage(
    int page,
    CharacterResponseModel response,
  ) async {
    await localDataSource.cacheCharactersPage(page, response);
  }

  @override
  Future<void> cacheCharacters(List<CharacterModel> characters) async {
    await localDataSource.cacheCharacters(characters);
  }

  @override
  CharacterResponseModel? getCachedCharactersPage(int page) {
    return localDataSource.getCachedCharactersPage(page);
  }

  @override
  CharacterModel? getCachedCharacterById(int id) {
    return localDataSource.getCachedCharacterById(id);
  }
}
