import 'package:rick_and_morty_exporer/features/characters/data/datasources/characters_remote_datasource.dart';
import 'package:rick_and_morty_exporer/features/characters/data/models/character_response_model.dart';

abstract class CharactersRepository {
  Future<CharacterResponseModel> getCharacters(int page);
}

class CharactersRepositoryImpl implements CharactersRepository {
  final CharactersRemoteDataSource remoteDataSource;
  CharactersRepositoryImpl(this.remoteDataSource);

  @override
  Future<CharacterResponseModel> getCharacters(int page) {
    return remoteDataSource.getCharacters(page);
  }
}
