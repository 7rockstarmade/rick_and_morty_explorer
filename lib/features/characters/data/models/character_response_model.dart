import 'package:rick_and_morty_exporer/features/characters/data/models/character_model.dart';

class CharacterResponseModel {
  final List<CharacterModel> characters;
  final String? next;

  CharacterResponseModel({required this.characters, required this.next});

  factory CharacterResponseModel.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as List;

    return CharacterResponseModel(
      characters: results.map((e) => CharacterModel.fromJson(e)).toList(),
      next: json['info']['next'],
    );
  }
}
