import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_exporer/features/home/presentation/pages/home_shell.dart';
import 'package:rick_and_morty_exporer/features/home/presentation/bloc/nav_cubit.dart';
import 'package:rick_and_morty_exporer/app/theme/app_theme.dart';
import 'package:rick_and_morty_exporer/app/theme/theme_cubit.dart';

class RickAndMortyExplorer extends StatelessWidget {
  const RickAndMortyExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => NavCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Rick & Morty Explorer',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
