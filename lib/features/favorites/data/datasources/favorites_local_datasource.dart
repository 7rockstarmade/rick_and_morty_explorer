import 'package:hive/hive.dart';
import 'package:rick_and_morty_exporer/core/constants/hive_constants.dart';

abstract class FavoritesLocalDataSource {
  Set<int> loadFavoriteIds();
  Future<void> saveFavoriteIds(Set<int> ids);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  FavoritesLocalDataSourceImpl({Box<dynamic>? box})
    : _box = box ?? Hive.box(HiveConstants.favoritesBox);

  final Box<dynamic> _box;

  @override
  Set<int> loadFavoriteIds() {
    final raw = _box.get(HiveConstants.favoritesIdsKey);
    if (raw is List) {
      return raw.whereType<int>().toSet();
    }
    return <int>{};
  }

  @override
  Future<void> saveFavoriteIds(Set<int> ids) {
    return _box.put(HiveConstants.favoritesIdsKey, ids.toList());
  }
}
