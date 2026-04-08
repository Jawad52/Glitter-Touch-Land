import 'dart:ui';
import 'package:vector_math/vector_math_64.dart';

enum ParticleType { chunky, fine }

class Particle {
  Vector2 position;
  Vector2 prevPosition;
  Vector2 acceleration;
  double radius;
  Color color;
  double rotation;
  double rotationSpeed;
  final ParticleType type;
  final List<Vector2> vertices; // For chunky confetti

  Particle({
    required this.position,
    required this.prevPosition,
    this.acceleration = Vector2.zero,
    required this.radius,
    required this.color,
    this.rotation = 0,
    this.rotationSpeed = 0,
    required this.type,
    this.vertices = const [],
  });

  void update(double dt, Vector2 gravity) {
    // Verlet integration
    final velocity = position - prevPosition;
    prevPosition = position.clone();
    
    // Position = position + velocity + acceleration * dt * dt
    position = position + velocity + (acceleration + gravity) * (dt * dt);
    
    // Reset acceleration
    acceleration = Vector2.zero;
    
    // Update rotation
    rotation += rotationSpeed * dt;
  }
}
