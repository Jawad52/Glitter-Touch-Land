import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final Color backgroundColor;

  const ThemeState({required this.backgroundColor});

  factory ThemeState.initial() {
    return const ThemeState(backgroundColor: Colors.black);
  }

  ThemeState copyWith({Color? backgroundColor}) {
    return ThemeState(
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  List<Object?> get props => [backgroundColor];
}
