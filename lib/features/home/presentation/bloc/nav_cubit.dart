import 'package:flutter_bloc/flutter_bloc.dart';

enum HomeTab { characters, favorites }

class NavCubit extends Cubit<HomeTab> {
  NavCubit() : super(HomeTab.characters);

  void setTab(HomeTab tab) => emit(tab);
}
