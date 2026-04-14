import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:vector_math/vector_math_64.dart';

enum ParticleType { chunky, fine }

class Particle extends Equatable {
  final Vector2 position;
  final Vector2 prevPosition;
  final Vector2 acceleration;
  final double radius;
  final Color color;
  final double rotation;
  final double rotationSpeed;
  final ParticleType type;
  final List<Vector2> vertices;

  const Particle({
    required this.position,
    required this.prevPosition,
    required this.acceleration,
    required this.radius,
    required this.color,
    required this.rotation,
    required this.rotationSpeed,
    required this.type,
    required this.vertices,
  });

  Particle copyWith({
    Vector2? position,
    Vector2? prevPosition,
    Vector2? acceleration,
    double? radius,
    Color? color,
    double? rotation,
    double? rotationSpeed,
    ParticleType? type,
    List<Vector2>? vertices,
  }) {
    return Particle(
      position: position ?? this.position,
      prevPosition: prevPosition ?? this.prevPosition,
      acceleration: acceleration ?? this.acceleration,
      radius: radius ?? this.radius,
      color: color ?? this.color,
      rotation: rotation ?? this.rotation,
      rotationSpeed: rotationSpeed ?? this.rotationSpeed,
      type: type ?? this.type,
      vertices: vertices ?? this.vertices,
    );
  }

  @override
  List<Object?> get props => [
        position,
        prevPosition,
        acceleration,
        radius,
        color,
        rotation,
        rotationSpeed,
        type,
        vertices,
      ];
}
