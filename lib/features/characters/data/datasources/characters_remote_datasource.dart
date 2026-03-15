import 'package:dio/dio.dart';
import 'package:rick_and_morty_exporer/core/constants/api_constants.dart';
import 'package:rick_and_morty_exporer/features/characters/data/models/character_response_model.dart';

abstract class CharactersRemoteDataSource {
  Future<CharacterResponseModel> getCharacters(int page);
}

class CharactersRemoteDataSourceImpl implements CharactersRemoteDataSource {
  final Dio dio;
  const CharactersRemoteDataSourceImpl(this.dio);

  @override
  Future<CharacterResponseModel> getCharacters(int page) async {
    final response = await dio.get(
      ApiConstants.charactersPath,
      queryParameters: {'page': page},
    );
    return CharacterResponseModel.fromJson(response.data);
  }
}
