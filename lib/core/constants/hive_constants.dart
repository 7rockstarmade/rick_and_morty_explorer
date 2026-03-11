class HiveConstants {
  const HiveConstants._();

  static const String charactersCacheBox = 'characters_cache';
  static const String favoritesBox = 'favorites';

  static String charactersPageKey(int page) => 'characters_page_$page';
  static const String favoritesIdsKey = 'favorite_ids';
}

