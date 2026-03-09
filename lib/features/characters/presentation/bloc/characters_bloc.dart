import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_exporer/core/constants/api_constants.dart';
import 'package:rick_and_morty_exporer/features/characters/data/models/character_model.dart';
import 'package:rick_and_morty_exporer/features/characters/data/repositories/characters_repository.dart';
import 'package:rick_and_morty_exporer/features/characters/presentation/bloc/characters_event.dart';
import 'package:rick_and_morty_exporer/features/characters/presentation/bloc/characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final CharactersRepository _repository;

  CharactersBloc(this._repository) : super(const CharactersState.initial()) {
    on<CharactersStarted>(_onStarted);
    on<CharactersRefreshed>(_onRefreshed);
    on<CharactersNextPageRequested>(_onNextPageRequested);
  }

  Future<void> _onStarted(
    CharactersStarted event,
    Emitter<CharactersState> emit,
  ) async {
    await _loadFirstPage(emit);
  }

  Future<void> _onRefreshed(
    CharactersRefreshed event,
    Emitter<CharactersState> emit,
  ) async {
    await _loadFirstPage(emit);
  }

  Future<void> _onNextPageRequested(
    CharactersNextPageRequested event,
    Emitter<CharactersState> emit,
  ) async {
    final loadedState = state.maybeMap(
      loaded: (value) => value,
      orElse: () => null,
    );

    if (loadedState == null ||
        !loadedState.hasMore ||
        loadedState.isFetchingMore) {
      return;
    }

    emit(loadedState.copyWith(isFetchingMore: true));

    final nextPage = loadedState.currentPage + 1;

    try {
      final response = await _repository.getCharacters(nextPage);
      final mergedCharacters = <CharacterModel>[
        ...loadedState.characters,
        ...response.characters,
      ];

      emit(
        CharactersState.loaded(
          characters: mergedCharacters,
          currentPage: nextPage,
          hasMore: response.next != null,
          isFetchingMore: false,
        ),
      );
    } catch (_) {
      emit(loadedState.copyWith(isFetchingMore: false));
    }
  }

  Future<void> _loadFirstPage(Emitter<CharactersState> emit) async {
    emit(const CharactersState.loading());
    try {
      final response = await _repository.getCharacters(ApiConstants.firstPage);
      emit(
        CharactersState.loaded(
          characters: response.characters,
          currentPage: ApiConstants.firstPage,
          hasMore: response.next != null,
        ),
      );
    } catch (e) {
      emit(CharactersState.error(e.toString()));
    }
  }
}
