import 'dart:math';
import 'package:vector_math/vector_math_64.dart';
import '../entities/particle.dart';
import 'package:flutter/material.dart';

class PhysicsEngine {
  List<Particle> particles = [];
  final int maxParticles = 3000;
  final Random _random = Random();

  void update(double dt, Vector2 gravity, Size bounds) {
    final List<Particle> updatedParticles = [];
    
    for (var p in particles) {
      // Apply gravity and update position via Verlet integration
      final velocity = p.position - p.prevPosition;
      // Using a clone to avoid mutating the original Vector2 if it was somehow shared
      final nextPosition = p.position + velocity + (p.acceleration + gravity) * (dt * dt);
      
      var newPosition = nextPosition;
      var newPrevPosition = p.position.clone();
      var newRotation = p.rotation + p.rotationSpeed * dt;

      // Handle bounds collision
      final collisionResult = _handleBoundsCollision(newPosition, newPrevPosition, p.radius, bounds);
      newPosition = collisionResult.position;
      newPrevPosition = collisionResult.prevPosition;

      updatedParticles.add(p.copyWith(
        position: newPosition,
        prevPosition: newPrevPosition,
        acceleration: Vector2.zero(),
        rotation: newRotation,
      ));
    }
    
    particles = updatedParticles;
  }

  ({Vector2 position, Vector2 prevPosition}) _handleBoundsCollision(Vector2 pos, Vector2 prevPos, double radius, Size bounds) {
    const double friction = 0.95;
    const double restitution = 0.3;
    
    var currentPos = pos.clone();
    var currentPrevPos = prevPos.clone();

    // Bottom
    if (currentPos.y > bounds.height - radius) {
      final velocityY = currentPos.y - currentPrevPos.y;
      currentPos.y = bounds.height - radius;
      currentPrevPos.y = currentPos.y + velocityY * restitution;
      currentPrevPos.x += (currentPos.x - currentPrevPos.x) * (1 - friction);
    }
    // Top
    else if (currentPos.y < radius) {
      final velocityY = currentPos.y - currentPrevPos.y;
      currentPos.y = radius;
      currentPrevPos.y = currentPos.y + velocityY * restitution;
    }

    // Left
    if (currentPos.x < radius) {
      final velocityX = currentPos.x - currentPrevPos.x;
      currentPos.x = radius;
      currentPrevPos.x = currentPos.x + velocityX * restitution;
    }
    // Right
    else if (currentPos.x > bounds.width - radius) {
      final velocityX = currentPos.x - currentPrevPos.x;
      currentPos.x = bounds.width - radius;
      currentPrevPos.x = currentPos.x + velocityX * restitution;
    }
    
    return (position: currentPos, prevPosition: currentPrevPos);
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
        acceleration: Vector2.zero(),
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
    final List<Particle> updatedParticles = [];
    
    for (final p in particles) {
      final distSq = p.position.distanceToSquared(forcePos);
      if (distSq < radius * radius) {
        final dist = sqrt(distSq);
        final dir = (p.position - forcePos)..normalize();
        final force = dir * (1.0 - dist / radius) * strength;
        updatedParticles.add(p.copyWith(
          prevPosition: p.prevPosition - force,
        ));
      } else {
        updatedParticles.add(p);
      }
    }
    particles = updatedParticles;
  }
}
