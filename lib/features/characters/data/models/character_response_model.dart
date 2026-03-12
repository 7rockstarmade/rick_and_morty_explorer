import 'package:rick_and_morty_exporer/features/characters/data/models/character_model.dart';

class CharacterResponseModel {
  final List<CharacterModel> characters;
  final String? next;

  CharacterResponseModel({required this.characters, required this.next});

  factory CharacterResponseModel.fromJson(Map<String, dynamic> json) {
    final results = (json['results'] as List?) ?? const [];
    final info = json['info'];
    final nextValue = info is Map ? info['next'] : null;

    return CharacterResponseModel(
      characters: results
          .whereType<Map>()
          .map((e) => CharacterModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      next: nextValue is String ? nextValue : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'info': {'next': next},
      'results': characters.map((c) => c.toJson()).toList(),
    };
  }
}
