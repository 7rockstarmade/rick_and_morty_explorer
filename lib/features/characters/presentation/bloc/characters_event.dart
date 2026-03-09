import 'package:equatable/equatable.dart';

sealed class CharactersEvent extends Equatable {
  const CharactersEvent();

  @override
  List<Object?> get props => [];
}

class CharactersStarted extends CharactersEvent {
  const CharactersStarted();
}

class CharactersNextPageRequested extends CharactersEvent {
  const CharactersNextPageRequested();
}

class CharactersRefreshed extends CharactersEvent {
  const CharactersRefreshed();
}
