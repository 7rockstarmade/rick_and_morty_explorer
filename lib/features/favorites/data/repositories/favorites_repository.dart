import 'package:rick_and_morty_exporer/features/favorites/data/datasources/favorites_local_datasource.dart';

abstract class FavoritesRepository {
  Set<int> loadFavoriteIds();
  Future<Set<int>> toggle(int characterId);
}

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._local);

  final FavoritesLocalDataSource _local;

  @override
  Set<int> loadFavoriteIds() => _local.loadFavoriteIds();

  @override
  Future<Set<int>> toggle(int characterId) async {
    final ids = _local.loadFavoriteIds();
    if (!ids.add(characterId)) {
      ids.remove(characterId);
    }
    await _local.saveFavoriteIds(ids);
    return ids;
  }
}
