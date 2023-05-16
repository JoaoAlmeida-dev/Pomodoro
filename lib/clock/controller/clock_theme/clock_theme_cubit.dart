import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'clock_theme_state.dart';

class ClockThemeCubit extends Cubit<ClockThemeState> {
  ClockThemeCubit()
      : super(const ClockThemeState(
            background: Colors.blue, foreground: Colors.blue));

  void changeForeground(MaterialColor? newForeground) => emit(ClockThemeState(
      foreground: newForeground ?? state.foreground,
      background: state.background));

  void changeBackground(MaterialColor? newBackground) => emit(ClockThemeState(
      foreground: state.foreground,
      background: newBackground ?? state.background));
}
