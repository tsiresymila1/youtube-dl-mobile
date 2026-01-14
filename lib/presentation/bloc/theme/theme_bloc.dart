import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeBloc extends HydratedCubit<ThemeMode> {
  ThemeBloc() : super(ThemeMode.dark);

  void toggleTheme() {
    emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    return ThemeMode.values[json['theme_mode'] as int];
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {'theme_mode': state.index};
  }
}
