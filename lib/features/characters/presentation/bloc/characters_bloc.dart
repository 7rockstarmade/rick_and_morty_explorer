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

  int? _extractPage(String? nextUrl) {
    if (nextUrl == null) {
      return null;
    }
    final uri = Uri.tryParse(nextUrl);
    if (uri == null) {
      return null;
    }
    return int.tryParse(uri.queryParameters['page'] ?? '');
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

    final nextPage = _extractPage(loadedState.next);
    if (nextPage == null) {
      return;
    }

    emit(loadedState.copyWith(isFetchingMore: true));

    try {
      final response = await _repository.getCharacters(nextPage);
      final mergedCharacters = <CharacterModel>[
        ...loadedState.characters,
        ...response.characters,
      ];

      final nextFromApi = response.next;
      final hasMore = _extractPage(nextFromApi) != null;

      emit(
        CharactersState.loaded(
          characters: mergedCharacters,
          currentPage: nextPage,
          hasMore: hasMore,
          next: nextFromApi,
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
      final nextFromApi = response.next;
      final hasMore = _extractPage(nextFromApi) != null;
      emit(
        CharactersState.loaded(
          characters: response.characters,
          currentPage: ApiConstants.firstPage,
          hasMore: hasMore,
          next: nextFromApi,
        ),
      );
    } catch (e) {
      emit(CharactersState.error(e.toString()));
    }
  }
}
