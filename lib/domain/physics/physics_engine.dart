import 'dart:math';
import 'package:vector_math/vector_math_64.dart';
import '../entities/particle.dart';
import 'package:flutter/material.dart';

class PhysicsEngine {
  final List<Particle> particles = [];
  final int maxParticles = 3000;
  final Random _random = Random();

  void update(double dt, Vector2 gravity, Size bounds) {
    for (final particle in particles) {
      // Apply gravity and update position via Verlet integration
      final velocity = particle.position - particle.prevPosition;
      final nextPosition = particle.position + velocity + gravity * (dt * dt);
      
      particle.prevPosition = particle.position.clone();
      particle.position = nextPosition;

      // Simple screen bounds collision with friction/restitution
      _handleBoundsCollision(particle, bounds);
    }
    
    // Stacking behavior: particles should ideally collide with each other.
    // Full N^2 collision is too slow for 3000 particles in Dart.
    // We can implement a simple spatial grid or just focus on boundary accumulation for performance.
    // For now, let's ensure they settle at the bottom.
  }

  void _handleBoundsCollision(Particle p, Size bounds) {
    const double friction = 0.95;
    const double restitution = 0.3;

    // Bottom
    if (p.position.y > bounds.height - p.radius) {
      final velocityY = p.position.y - p.prevPosition.y;
      p.position.y = bounds.height - p.radius;
      p.prevPosition.y = p.position.y + velocityY * restitution;
      p.prevPosition.x += (p.position.x - p.prevPosition.x) * (1 - friction);
    }
    // Top
    else if (p.position.y < p.radius) {
      final velocityY = p.position.y - p.prevPosition.y;
      p.position.y = p.radius;
      p.prevPosition.y = p.position.y + velocityY * restitution;
    }

    // Left
    if (p.position.x < p.radius) {
      final velocityX = p.position.x - p.prevPosition.x;
      p.position.x = p.radius;
      p.prevPosition.x = p.position.x + velocityX * restitution;
    }
    // Right
    else if (p.position.x > bounds.width - p.radius) {
      final velocityX = p.position.x - p.prevPosition.x;
      p.position.x = bounds.width - p.radius;
      p.prevPosition.x = p.position.x + velocityX * restitution;
    }
  }

  void spawnParticles(Offset position, int count) {
    for (int i = 0; i < count; i++) {
      if (particles.length >= maxParticles) {
        particles.removeAt(0); // Recycle oldest
      }

      final isChunky = _random.nextDouble() > 0.7;
      final type = isChunky ? ParticleType.chunky : ParticleType.fine;
      
      final angle = _random.nextDouble() * pi * 2;
      final speed = _random.nextDouble() * 2.0 + 1.0;
      final velocity = Vector2(cos(angle) * speed, sin(angle) * speed);

      final color = Color.fromARGB(
        255,
        200 + _random.nextInt(55),
        150 + _random.nextInt(105),
        50 + _random.nextInt(150),
      );

      final p = Particle(
        position: Vector2(position.dx, position.dy),
        prevPosition: Vector2(position.dx - velocity.x, position.dy - velocity.y),
        radius: isChunky ? 4.0 + _random.nextDouble() * 4.0 : 1.0 + _random.nextDouble() * 1.5,
        color: color,
        type: type,
        rotation: _random.nextDouble() * pi * 2,
        rotationSpeed: (_random.nextDouble() - 0.5) * 10,
        vertices: isChunky ? _generateVertices(4.0 + _random.nextDouble() * 4.0) : [],
      );
      
      particles.add(p);
    }
  }

  List<Vector2> _generateVertices(double radius) {
    final vertices = <Vector2>[];
    final sides = 3 + _random.nextInt(4);
    for (int i = 0; i < sides; i++) {
      final angle = (i / sides) * pi * 2;
      final r = radius * (0.6 + _random.nextDouble() * 0.4);
      vertices.add(Vector2(cos(angle) * r, sin(angle) * r));
    }
    return vertices;
  }

  void applyForce(Offset position, double radius, double strength) {
    final forcePos = Vector2(position.dx, position.dy);
    for (final p in particles) {
      final distSq = p.position.distanceToSquared(forcePos);
      if (distSq < radius * radius) {
        final dist = sqrt(distSq);
        final dir = (p.position - forcePos)..normalize();
        final force = dir * (1.0 - dist / radius) * strength;
        p.prevPosition -= force;
      }
    }
  }
}
