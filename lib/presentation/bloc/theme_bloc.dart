import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final Random _random = Random();

  ThemeBloc() : super(ThemeState.initial()) {
    on<ChangeBackgroundColorEvent>((event, emit) {
      final newColor = Color.fromARGB(
        255,
        _random.nextInt(50), // Keep it dark for glitter contrast
        _random.nextInt(50),
        _random.nextInt(50),
      );
      emit(state.copyWith(backgroundColor: newColor));
    });
  }
}
