import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_exporer/app/theme/theme_cubit.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontWeight: .w600, fontSize: 26),
      ),
      actions: [
        IconButton(
          tooltip: 'Toggle theme',
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          onPressed: () async {
            final cubit = context.read<ThemeCubit>();
            await cubit.setTheme(isDark ? ThemeMode.light : ThemeMode.dark);
          },
        ),
      ],
    );
  }
}
