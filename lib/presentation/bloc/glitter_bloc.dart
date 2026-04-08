import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vector_math/vector_math_64.dart';
import '../../domain/physics/physics_engine.dart';
import 'glitter_event.dart';
import 'glitter_state.dart';

class GlitterBloc extends Bloc<GlitterEvent, GlitterState> {
  final PhysicsEngine _physicsEngine = PhysicsEngine();

  GlitterBloc() : super(GlitterState.initial()) {
    on<SpawnParticlesEvent>((event, emit) {
      _physicsEngine.spawnParticles(event.position, event.count);
      emit(state.copyWith(
        particles: List.from(_physicsEngine.particles),
        lastUpdate: DateTime.now().millisecondsSinceEpoch,
      ));
    });

    on<ApplyForceEvent>((event, emit) {
      _physicsEngine.applyForce(event.position, event.radius, event.strength);
      emit(state.copyWith(
        particles: List.from(_physicsEngine.particles),
        lastUpdate: DateTime.now().millisecondsSinceEpoch,
      ));
    });

    on<UpdateGravityEvent>((event, emit) {
      emit(state.copyWith(
        gravity: Vector2(event.x, event.y),
      ));
    });

    on<UpdatePhysicsEvent>((event, emit) {
      _physicsEngine.update(event.dt, state.gravity, event.bounds);
      emit(state.copyWith(
        particles: List.from(_physicsEngine.particles),
        lastUpdate: DateTime.now().millisecondsSinceEpoch,
      ));
    });
  }
}
