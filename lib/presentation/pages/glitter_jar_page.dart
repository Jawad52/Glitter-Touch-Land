import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../bloc/glitter_bloc.dart';
import '../bloc/glitter_event.dart';
import '../bloc/glitter_state.dart';
import '../widgets/glitter_painter.dart';

class GlitterJarPage extends StatefulWidget {
  const GlitterJarPage({super.key});

  @override
  State<GlitterJarPage> createState() => _GlitterJarPageState();
}

class _GlitterJarPageState extends State<GlitterJarPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  StreamSubscription? _accelerometerSubscription;
  final double _gravityScale = 9.8;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_onTick);
    _controller.repeat();

    _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      // Map accelerometer to gravity
      // Note: Accelerometer values are inverted relative to screen coordinates
      context.read<GlitterBloc>().add(UpdateGravityEvent(-event.x * _gravityScale, event.y * _gravityScale));
    });
  }

  void _onTick() {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      context.read<GlitterBloc>().add(UpdatePhysicsEvent(0.016, size));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  void _handleTap(TapDownDetails details, Size size) {
    final tapY = details.localPosition.dy;
    final threshold = size.height * 0.7;

    if (tapY < threshold) {
      // Top 70%: Spawn particles
      context.read<GlitterBloc>().add(SpawnParticlesEvent(details.localPosition, 50));
    }
  }

  void _handlePanUpdate(DragUpdateDetails details, Size size) {
    final panY = details.localPosition.dy;
    final threshold = size.height * 0.7;

    if (panY >= threshold) {
      // Bottom 30%: Disturb existing pile
      context.read<GlitterBloc>().add(ApplyForceEvent(details.localPosition, 100.0, 50.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GlitterBloc(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            return GestureDetector(
              onTapDown: (details) => _handleTap(details, size),
              onPanUpdate: (details) => _handlePanUpdate(details, size),
              child: BlocBuilder<GlitterBloc, GlitterState>(
                builder: (context, state) {
                  return RepaintBoundary(
                    child: CustomPaint(
                      size: size,
                      painter: GlitterPainter(
                        particles: state.particles,
                        tiltAmount: state.gravity.x + state.gravity.y,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
