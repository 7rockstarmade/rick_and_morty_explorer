import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_exporer/features/favorites/data/repositories/favorites_repository.dart';

class FavoritesCubit extends Cubit<Set<int>> {
  FavoritesCubit(this._repository) : super(<int>{});

  final FavoritesRepository _repository;

  void load() {
    emit(_repository.loadFavoriteIds());
  }

  Future<void> toggle(int characterId) async {
    final updated = await _repository.toggle(characterId);
    emit(updated);
  }
}

