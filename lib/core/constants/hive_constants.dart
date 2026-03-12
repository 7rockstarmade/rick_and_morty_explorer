class HiveConstants {
  const HiveConstants._();

  static const String charactersCacheBox = 'characters_cache';
  static const String favoritesBox = 'favorites';
  static const String settingsBox = 'settings';

  static String charactersPageKey(int page) => 'characters_page_$page';
  static const String favoritesIdsKey = 'favorite_ids';
  static const String themeModeKey = 'theme_mode';

  static String characterByIdKey(int id) => 'character_$id';
}
