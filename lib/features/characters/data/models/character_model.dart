import 'package:equatable/equatable.dart';

class CharacterModel extends Equatable {
  final int id;
  final String name;
  final String status;
  final String species;
  final String location;
  final String image;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.location,
    required this.image,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      location: json['location']['name'],
      image: json['image'],
    );
  }

  @override
  List<Object?> get props => [id, name, status, species, location, image];
}
