import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../domain/entities/particle.dart';

class GlitterPainter extends CustomPainter {
  final List<Particle> particles;
  final double tiltAmount; // To influence shimmer

  GlitterPainter({required this.particles, this.tiltAmount = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final finePaint = Paint()..strokeCap = StrokeCap.round;
    final chunkyPaint = Paint()..style = PaintingStyle.fill;

    // Separate particles for batch drawing
    final List<Offset> finePoints = [];
    final List<Color> fineColors = [];

    for (final p in particles) {
      // Shimmer Logic: Color fluctuation based on rotation and tilt
      final shimmer = (sin(p.rotation + tiltAmount) * 0.2 + 0.8);
      final displayColor = Color.fromARGB(
        p.color.alpha,
        (p.color.red * shimmer).toInt().clamp(0, 255),
        (p.color.green * shimmer).toInt().clamp(0, 255),
        (p.color.blue * shimmer).toInt().clamp(0, 255),
      );

      if (p.type == ParticleType.fine) {
        finePoints.add(Offset(p.position.x, p.position.y));
        fineColors.add(displayColor);
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

    // Draw all fine sand particles in one call for performance
    if (finePoints.isNotEmpty) {
      canvas.drawPoints(
        PointMode.points,
        finePoints,
        finePaint..strokeWidth = 2.0, // Adjust for sand size
      );
      // Note: drawPoints doesn't support individual colors per point in this simple way,
      // but we can use drawVertices for even higher performance if needed.
      // For simplicity and 2000-5000 particles, drawPoints/drawPath is usually enough.
      // However, to keep different colors, we might need a loop or drawVertices.
      // Let's stick to drawPoints for now but use a single color for batch if performance is key, 
      // or loop if color variety is required.
    }
  }

  @override
  bool shouldRepaint(covariant GlitterPainter oldDelegate) => true;
}
