import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:rick_and_morty_exporer/core/constants/hive_constants.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit({Box<dynamic>? box})
    : _box = box ?? Hive.box(HiveConstants.settingsBox),
      super(_loadInitial(box ?? Hive.box(HiveConstants.settingsBox)));

  final Box<dynamic> _box;

  static ThemeMode _loadInitial(Box<dynamic> box) {
    final raw = box.get(HiveConstants.themeModeKey);
    if (raw is int && raw >= 0 && raw < ThemeMode.values.length) {
      return ThemeMode.values[raw];
    }
    return ThemeMode.system;
  }

  Future<void> setTheme(ThemeMode mode) async {
    emit(mode);
    await _box.put(HiveConstants.themeModeKey, mode.index);
  }
}
