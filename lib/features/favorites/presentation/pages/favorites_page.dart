import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_exporer/features/favorites/presentation/bloc/favorites_cubit.dart';
import 'package:rick_and_morty_exporer/features/favorites/presentation/widgets/favorites_animated_list.dart';
import 'package:rick_and_morty_exporer/shared/widgets/empty_state_widget.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FavoritesCubit>().state;
    if (state.characters.isEmpty) {
      return const EmptyStateWidget(
        title: 'No favorites yet',
        icon: Icons.star_border,
      );
    }

    return FavoritesAnimatedList(
      characters: state.characters,
    );
  }
}
