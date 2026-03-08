import 'package:flutter/material.dart';
import 'package:rick_and_morty_exporer/app/theme/app_theme.dart';

class RickAndMortyExplorer extends StatelessWidget {
  const RickAndMortyExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rick & Morty Explorer',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: Scaffold(body: Container()),
    );
  }
}
