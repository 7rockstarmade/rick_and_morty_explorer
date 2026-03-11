import 'package:hive/hive.dart';
import 'package:rick_and_morty_exporer/core/constants/hive_constants.dart';

class FavoritesLocalDataSource {
  FavoritesLocalDataSource({Box<dynamic>? box})
      : _box = box ?? Hive.box(HiveConstants.favoritesBox);

  final Box<dynamic> _box;

  Set<int> loadFavoriteIds() {
    final raw = _box.get(HiveConstants.favoritesIdsKey);
    if (raw is List) {
      return raw.whereType<int>().toSet();
    }
    return <int>{};
  }

  Future<void> saveFavoriteIds(Set<int> ids) {
    return _box.put(HiveConstants.favoritesIdsKey, ids.toList());
  }
}

