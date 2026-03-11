import 'package:rick_and_morty_exporer/features/characters/data/datasources/characters_remote_datasource.dart';
import 'package:rick_and_morty_exporer/features/characters/data/datasources/characters_local_datasource.dart';
import 'package:rick_and_morty_exporer/features/characters/data/models/character_response_model.dart';

abstract class CharactersRepository {
  Future<CharacterResponseModel> getCharacters(int page);
}

class CharactersRepositoryImpl implements CharactersRepository {
  final CharactersRemoteDataSource remoteDataSource;
  final CharactersLocalDataSource localDataSource;

  CharactersRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<CharacterResponseModel> getCharacters(int page) async {
    try {
      final response = await remoteDataSource.getCharacters(page);
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
}
