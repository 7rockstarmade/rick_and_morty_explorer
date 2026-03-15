import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_exporer/core/network/dio_client.dart';
import 'package:rick_and_morty_exporer/features/characters/data/datasources/characters_local_datasource.dart';
import 'package:rick_and_morty_exporer/features/characters/data/datasources/characters_remote_datasource.dart';
import 'package:rick_and_morty_exporer/features/characters/data/repositories/characters_repository.dart';
import 'package:rick_and_morty_exporer/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:rick_and_morty_exporer/features/characters/presentation/bloc/characters_event.dart';
import 'package:rick_and_morty_exporer/features/home/presentation/pages/home_shell.dart';
import 'package:rick_and_morty_exporer/features/home/presentation/bloc/nav_cubit.dart';
import 'package:rick_and_morty_exporer/app/theme/app_theme.dart';
import 'package:rick_and_morty_exporer/app/theme/theme_cubit.dart';
import 'package:rick_and_morty_exporer/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:rick_and_morty_exporer/features/favorites/data/repositories/favorites_repository.dart';
import 'package:rick_and_morty_exporer/features/favorites/presentation/bloc/favorites_cubit.dart';

class RickAndMortyExplorer extends StatelessWidget {
  const RickAndMortyExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CharactersRepository>(
          create: (_) => CharactersRepositoryImpl(
            remoteDataSource: CharactersRemoteDataSourceImpl(
              DioClient.instance,
            ),
            localDataSource: CharactersLocalDataSourceImpl(),
          ),
        ),
        RepositoryProvider<FavoritesRepository>(
          create: (_) => FavoritesRepositoryImpl(FavoritesLocalDataSourceImpl()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => NavCubit()),
          BlocProvider(
            create: (context) =>
                CharactersBloc(context.read<CharactersRepository>())
                  ..add(CharactersStarted()),
          ),
          BlocProvider(
            create: (context) =>
                FavoritesCubit(
                  context.read<FavoritesRepository>(),
                  context.read<CharactersRepository>(),
                )..load(),
          ),
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
      ),
    );
  }
}
