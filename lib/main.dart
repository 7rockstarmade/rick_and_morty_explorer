import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rick_and_morty_exporer/app/app.dart';
import 'package:rick_and_morty_exporer/core/constants/hive_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(HiveConstants.charactersCacheBox);
  await Hive.openBox(HiveConstants.favoritesBox);
  await Hive.openBox(HiveConstants.settingsBox);
  runApp(const RickAndMortyExplorer());
}
