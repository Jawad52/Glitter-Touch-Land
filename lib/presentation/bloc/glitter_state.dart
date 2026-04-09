import 'package:equatable/equatable.dart';
import '../../domain/entities/particle.dart';
import 'package:vector_math/vector_math_64.dart';

class GlitterState extends Equatable {
  final List<Particle> particles;
  final Vector2 gravity;
  final int lastUpdate;

  const GlitterState({
    required this.particles,
    required this.gravity,
    required this.lastUpdate,
  });

  factory GlitterState.initial() {
    return GlitterState(
      particles: const [],
      gravity: Vector2(0, 9.8), // Standard gravity
      lastUpdate: DateTime.now().millisecondsSinceEpoch,
    );
  }

  GlitterState copyWith({
    List<Particle>? particles,
    Vector2? gravity,
    int? lastUpdate,
  }) {
    return GlitterState(
      particles: particles ?? this.particles,
      gravity: gravity ?? this.gravity,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  @override
  List<Object?> get props => [particles, gravity, lastUpdate];
}
