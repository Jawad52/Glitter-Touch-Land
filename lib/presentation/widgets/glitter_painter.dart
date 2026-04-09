import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/entities/particle.dart';

class GlitterPainter extends CustomPainter {
  final List<Particle> particles;
  final double tiltAmount;

  GlitterPainter({required this.particles, this.tiltAmount = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final chunkyPaint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      // Shimmer Logic: Color fluctuation based on rotation and tilt
      final shimmer = (sin(p.rotation + tiltAmount) * 0.3 + 0.7);
      final displayColor = Color.fromARGB(
        p.color.alpha,
        (p.color.red * shimmer).toInt().clamp(0, 255),
        (p.color.green * shimmer).toInt().clamp(0, 255),
        (p.color.blue * shimmer).toInt().clamp(0, 255),
      );

      if (p.type == ParticleType.fine) {
        // Use drawRect for fine particles to support individual colors easily
        // and maintain performance for 2000-5000 particles.
        final paint = Paint()..color = displayColor;
        canvas.drawRect(
          Rect.fromLTWH(p.position.x, p.position.y, p.radius, p.radius),
          paint,
        );
      } else {
        // Chunky Glitter: Draw Polygons
        chunkyPaint.color = displayColor;
        final path = Path();
        if (p.vertices.isNotEmpty) {
          final first = p.vertices[0];
          path.moveTo(
            p.position.x + first.x * cos(p.rotation) - first.y * sin(p.rotation),
            p.position.y + first.x * sin(p.rotation) + first.y * cos(p.rotation),
          );
          for (int i = 1; i < p.vertices.length; i++) {
            final v = p.vertices[i];
            path.lineTo(
              p.position.x + v.x * cos(p.rotation) - v.y * sin(p.rotation),
              p.position.y + v.x * sin(p.rotation) + v.y * cos(p.rotation),
            );
          }
          path.close();
          canvas.drawPath(path, chunkyPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant GlitterPainter oldDelegate) => true;
}
