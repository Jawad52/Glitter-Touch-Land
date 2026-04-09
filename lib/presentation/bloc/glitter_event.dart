import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class GlitterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SpawnParticlesEvent extends GlitterEvent {
  final Offset position;
  final int count;

  SpawnParticlesEvent(this.position, this.count);

  @override
  List<Object?> get props => [position, count];
}

class ApplyForceEvent extends GlitterEvent {
  final Offset position;
  final double radius;
  final double strength;

  ApplyForceEvent(this.position, this.radius, this.strength);

  @override
  List<Object?> get props => [position, radius, strength];
}

class UpdateGravityEvent extends GlitterEvent {
  final double x;
  final double y;

  UpdateGravityEvent(this.x, this.y);

  @override
  List<Object?> get props => [x, y];
}

class UpdatePhysicsEvent extends GlitterEvent {
  final double dt;
  final Size bounds;

  UpdatePhysicsEvent(this.dt, this.bounds);

  @override
  List<Object?> get props => [dt, bounds];
}
